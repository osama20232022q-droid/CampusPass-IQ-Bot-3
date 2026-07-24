# رفع CampusPass IQ V8.0-B إلى GitHub وRailway

1. فك ضغط الحزمة الخارجية فقط.
2. ارفع الملفات الثمانية إلى جذر مستودع GitHub.
3. لا تفك `source_bundle.zip`.
4. حافظ على `DATABASE_URL` و`ENCRYPTION_KEY` و`BOT_TOKEN` السابقة.
5. خذ Backup قبل النشر.
6. اترك `PILOT_STRICT_STARTUP=false` في أول نشر، ثم فعّله بعد نجاح الفحص.

## متغيرات التوسع الجديدة الاختيارية

```env
ENTERPRISE_JOB_LEASE_SECONDS=180
ENTERPRISE_JOB_BASE_BACKOFF_SECONDS=15
ENTERPRISE_JOB_MAX_BACKOFF_SECONDS=3600
ENTERPRISE_WORKER_STALE_SECONDS=120
ENTERPRISE_WEBHOOK_TIMEOUT_SECONDS=10
ENTERPRISE_WEBHOOK_MAX_ATTEMPTS=8
ENTERPRISE_WEBHOOK_BASE_BACKOFF_SECONDS=30
ENTERPRISE_WEBHOOK_MAX_BACKOFF_SECONDS=21600
ENTERPRISE_GRACE_DAYS=7
```

Docker يتحقق من SHA-256 للحزمة الداخلية قبل فكها، ثم يثبت المتطلبات ويشغّل فحوص المشروع قبل إنشاء صورة التشغيل.
