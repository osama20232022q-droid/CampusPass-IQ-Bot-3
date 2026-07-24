# CampusPass IQ V9.0.1 LTS — Build Lock Fix

هذه الحزمة صممت لمنع Railway من بناء source_bundle قديم بالخطأ.

## ارفع هذه الملفات السبعة إلى جذر GitHub
- Dockerfile
- railway.json
- requirements.txt
- VERSION.txt
- source_bundle_v9_0_1.zip
- source_bundle_v9_0_1.zip.sha256
- README_UPLOAD_AR.md

لا تفك `source_bundle_v9_0_1.zip`.

بعد النشر ابحث في Build Logs عن:

`BUILD_SOURCE_LOCK_OK version=9.0.1-lts-build-lock`

إذا لم يظهر هذا السطر، فـ Railway لم يبنِ هذا الإصدار.
