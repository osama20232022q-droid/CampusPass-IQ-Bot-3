# CampusPass IQ V9 LTS — Final Stability/Performance Pass

## الأداء
- تفعيل `uvloop` تلقائياً على Railway/Linux عند توفره، مع fallback آمن إلى asyncio.
- رفع cache القوائم إلى 5 دقائق، مع invalidation فوري عند أي تعديل من Menu Builder.
- رفع cache الـfeature flags إلى دقيقة، مع invalidation فوري عند التعديل.
- role cache قصير 5 ثوانٍ فقط لتقليل round-trips دون إبقاء صلاحيات مزود قديمة لمدة طويلة.
- استعلام الحظر صار يجلب boolean فقط بدل تحميل User row كامل.
- القوائم تُعمل لها warm-up عند بدء الخدمة كما في الإصدار السابق.
- العمليات التي تتجاوز زمن الاستجابة الطبيعي تعرض رسالة المعالجة؛ العمليات السريعة لا تعرضها.

## UX
- زر الخصوصية مخفي من واجهة حسابي، لكن منطق الخصوصية والأمان والتصدير لم يُحذف من الكود.
- إضافة زر `💰 محفظتي` مباشرة داخل حسابي.
- Home/Back داخل الأقسام حسب نظام القائمة الحالي.

## التقارير
- `REPORT_SNAPSHOT_RETENTION_DAYS=30` افتراضياً.
- تنظيف snapshots الثقيلة يومياً ضمن maintenance scheduler.
- metadata يبقى محفوظاً للمحاسبة وحدود الخطط والتدقيق.
- البيانات الأصلية للطلبات والمبيعات والمحفظة والتسويات لا تُمسح.
- التقارير السنوية يعاد توليدها من البيانات الأصلية.

## التحقق المحلي
- Runtime repository verification: PASS
- Project verification: PASS
- Phase 3: PASS
- Phase 4: PASS
- Phase 5: PASS
- Phase 6: PASS
- Phase 7B: PASS
- V8.1 regression test subset: 3 passed

ملاحظة: Dockerfile ما زال يشغّل مجموعة الاختبارات الكاملة أثناء Railway Build؛ أي regression يمنع النشر بدلاً من تمرير نسخة مكسورة.
