FROM python:3.12-slim AS builder

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

WORKDIR /app
COPY source_bundle.zip source_bundle.zip.sha256 /tmp/

RUN python - <<'PYEXTRACT'
from __future__ import annotations

import hashlib
import stat
from pathlib import Path, PurePosixPath
from zipfile import ZipFile

archive = Path('/tmp/source_bundle.zip')
expected = Path('/tmp/source_bundle.zip.sha256').read_text(encoding='utf-8').split()[0].lower()
actual = hashlib.sha256(archive.read_bytes()).hexdigest()
if actual != expected:
    raise SystemExit(f'checksum mismatch: expected {expected}, got {actual}')

destination = Path('/app').resolve()
with ZipFile(archive) as bundle:
    broken = bundle.testzip()
    if broken is not None:
        raise SystemExit(f'source bundle is corrupted at {broken}')
    for member in bundle.infolist():
        name = PurePosixPath(member.filename)
        if name.is_absolute() or '..' in name.parts:
            raise SystemExit(f'unsafe archive path: {member.filename}')
        mode = member.external_attr >> 16
        if stat.S_ISLNK(mode):
            raise SystemExit(f'symlink is not allowed: {member.filename}')
        target = (destination / Path(*name.parts)).resolve()
        if target != destination and destination not in target.parents:
            raise SystemExit(f'archive path escapes destination: {member.filename}')
    bundle.extractall(destination)
PYEXTRACT

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --upgrade pip \
    && pip install -r requirements.txt \
    && pip install pytest pytest-asyncio

RUN python scripts/verify_runtime_files.py \
    && python scripts/verify_project.py \
    && python scripts/verify_phase3.py \
    && python scripts/verify_phase4.py \
    && python scripts/verify_phase5.py \
    && python scripts/verify_phase6.py \
    && python scripts/verify_phase7b.py \
    && python -m compileall -q app tests scripts ops alembic \
    && pytest -q \
      tests/test_core.py \
      tests/test_migrations.py \
      tests/test_subscriptions.py \
      tests/test_utils.py \
      tests/test_smoke_ui.py \
      tests/test_v6_1_external_database.py \
      tests/test_v6_4_deployment_hardening.py \
      tests/test_v6_5_phase1_hardening.py \
      tests/test_v6_6_phase2_disputes_refunds.py \
      tests/test_v6_7_phase3_privacy_evidence.py \
      tests/test_v6_8_phase4_user_experience.py \
      tests/test_v6_9_phase5_operations_reliability.py \
      tests/test_v7_0_phase6_pilot_quality.py \
      tests/test_v8_0a_enterprise_core.py \
      tests/test_v8_0b_enterprise_scale.py

FROM python:3.12-slim AS runtime
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/opt/venv/bin:$PATH"

WORKDIR /app
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates postgresql-client \
    && rm -rf /var/lib/apt/lists/* \
    && addgroup --system bot \
    && adduser --system --ingroup bot bot
COPY --from=builder /opt/venv /opt/venv
COPY --from=builder /app /app
RUN rm -rf /app/.pytest_cache /app/tests /app/loadtests /app/.github \
    && find /app -type d -name '__pycache__' -prune -exec rm -rf {} + \
    && chown -R bot:bot /app /opt/venv
USER bot
EXPOSE 8080
CMD ["python", "-m", "app.main"]
