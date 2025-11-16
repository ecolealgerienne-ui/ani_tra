// lib/i18n/strings_ar.dart
// ملاحظة: العربية الفصحى المعيارية (MSA) مع الحفاظ على المتغيّرات {name} و {count} إلخ.

const Map<String, String> stringsAr = {
  // FARM MANAGEMENT
  'userName': 'اسم المستخدم',
  'farmManagement': 'إدارة المزرعة',
  'currentFarm': 'المزرعة الحالية',
  'farmName': 'اسم المزرعة',
  'switchFarm': 'تبديل المزرعة',
  'availableFarms': 'المزارع المتاحة',
  'farmPhase4Note': 'المرحلة 4: اختيار المزرعة من هنا',
  'noFarmAvailable': 'لا توجد مزارع متاحة',
  'pleaseCreateFarm': 'يرجى إنشاء مزرعة للمتابعة',

  // ==================== عام ====================
  'ok': 'حسناً',
  'cancel': 'إلغاء',
  'delete': 'حذف',
  'rename': 'إعادة تسمية',
  'duplicate': 'نسخ مكرر',
  'keep': 'إبقاء',
  'date': 'التاريخ',
  'error': 'خطأ',
  'search': 'بحث',
  'optional': 'اختياري',
  'save': 'حفظ',
  'nothingSelected': 'لا يوجد اختيار',

  // ============ شاشة المزامنة ============
  'sync': 'مزامنة',
  'offlineMode': 'وضع عدم الاتصال',
  'pendingData': 'بيانات معلّقة',
  'syncSuccess': 'تمت المزامنة بنجاح',
  'syncNow': 'مزامنة الآن',

  // ============ تسجيل الوزن ============
  'newWeight': 'وزن جديد',
  'scanAnimal': 'مسح الحيوان',
  'weight': 'الوزن',
  'noAnimalsAvailable': 'لا توجد حيوانات متاحة',
  'noAnimalsAvailableForWeight': 'لا توجد حيوانات متاحة للوزن',
  'weightRecorded': 'تم تسجيل الوزن',
  'selectDate': 'اختر التاريخ',
  'selectAnimal': 'اختر الحيوان',
  'weightSource': 'مصدر القياس',
  'notes': 'ملاحظات',
  'noWeightsRecorded': 'لم يتم تسجيل أي وزن',
  'previousWeight': 'الوزن السابق',
  'currentWeight': 'الوزن الحالي',

  // ============ الإعدادات ============
  'deleteCache': 'مسح الذاكرة المؤقتة',
  'settings': 'الإعدادات',
  'account': 'الحساب',
  'userProfile': 'الملف الشخصي',
  'changePassword': 'تغيير كلمة المرور',
  'changeVeterinarian': 'تغيير الطبيب البيطري',
  'farmPreferences': 'تفضيلات المزرعة',
  'defaultVeterinarian': 'الطبيب البيطري الافتراضي',
  'noVeterinarianDefined': 'لا يوجد طبيب بيطري محدد',
  'scanQr': 'مسح QR',
  'appearance': 'المظهر',
  'language': 'اللغة',
  'darkMode': 'الوضع الداكن',
  'notifications': 'الإشعارات',
  'treatmentReminders': 'تذكيرات العلاج',
  'withdrawalAlerts': 'تنبيهات فترات السحب',
  'campaignNotifications': 'إشعارات الحملات',
  'sound': 'صوت',
  'vibration': 'اهتزاز',
  'security': 'الأمان',
  'biometric': 'القياسات الحيوية',
  'autoLock': 'قفل تلقائي',
  'storage': 'التخزين',
  'cache': 'ذاكرة مؤقتة',
  'autoBackup': 'نسخ احتياطي تلقائي',
  'help': 'مساعدة',
  'about': 'حول التطبيق',
  'contactSupport': 'الاتصال بالدعم',
  'hours': 'الساعات',
  'sendEmail': 'إرسال بريد',
  'resetPreferences': 'إعادة تعيين التفضيلات',
  'veterinarianPrescriber': 'الطبيب البيطري الموصي',
  'receiveAllNotifications': 'تلقي جميع الإشعارات',
  'waitingPeriodsDeadlines': 'فترات الانتظار والمواعيد النهائية',
  'animalsWithActiveWaitingPeriod': 'حيوانات بفترة انتظار نشطة',
  'newCampaignsReminders': 'حملات جديدة وتذكيرات',
  'enableDarkTheme': 'تفعيل السمة الداكنة',
  'restartAppToApplyTheme': 'أعد تشغيل التطبيق لتطبيق السمة',
  'textSize': 'حجم النص',
  'themeColor': 'لون السمة',
  'biometricAuthentication': 'مصادقة حيوية',
  'useFingerprintFaceId': 'استخدام البصمة/‏Face ID',
  'biometryEnabled': 'القياسات الحيوية مفعّلة',
  'biometryDisabled': 'القياسات الحيوية معطّلة',
  'afterMinutesInactivity': 'بعد {minutes} دقيقة من عدم النشاط',
  'lockDelay': 'مهلة القفل',
  'minute': 'دقيقة',
  'minutes': 'دقائق',
  'activeSessions': 'جلسات نشطة',
  'manageConnectedDevices': 'إدارة الأجهزة المتصلة',
  'synchronization': 'المزامنة',
  'onlineMode': 'وضع الاتصال',
  'serverConnectionActive': 'الاتصال بالخادم نشط',
  'localDataOnly': 'وضع عدم الاتصال (بيانات محلية)',
  'autoSync': 'مزامنة تلقائية',
  'syncEvery15Minutes': 'مزامنة كل 15 دقيقة',
  'viewSyncDetails': 'عرض تفاصيل المزامنة',
  'historyConflicts': 'السجلّ والتعارضات',
  'storageData': 'التخزين والبيانات',
  'usedStorage': 'التخزين المستخدم',
  'calculating': 'جارٍ الحساب...',
  'clearCache': 'مسح الذاكرة المؤقتة',
  'freeSpace': 'تحرير مساحة',
  'dailyDataBackup': 'نسخ احتياطي يومي للبيانات',
  'exportData': 'تصدير البيانات',
  'importData': 'استيراد البيانات',
  'fromCsvExcel': 'من ملف CSV أو Excel',
  'clearLocalData': 'مسح البيانات المحلية',
  'deleteAllUnsyncedData': 'حذف جميع البيانات غير المتزامنة',
  'version': 'الإصدار',
  'openSourceLicenses': 'تراخيص مفتوحة المصدر',
  'privacyPolicy': 'سياسة الخصوصية',
  'termsOfService': 'شروط الاستخدام',
  'helpSupport': 'مساعدة ودعم',
  'debug': 'تصحيح',
  'simulateSyncError': 'محاكاة خطأ مزامنة',
  'offlineModeActivated': 'تم تفعيل وضع عدم الاتصال لاختبار الأخطاء',
  'remove': 'إزالة',
  'notSpecified': 'غير محدد',
  'searchVeterinarian': 'ابحث عن طبيب بيطري',
  'currentDevice': 'هذا الجهاز',
  'csvExcelXml': 'CSV, XML, Excel',
  'fromCsvOrExcel': 'من ملف CSV أو Excel',
  'rfidTroupeau': 'RFID Troupeau',
  'sheepManagementSystem': 'نظام إدارة قطيع الأغنام',

  // ============ شاشة العلاج ============
  'treatment': 'العلاج',
  'addTreatment': 'إضافة رعاية',
  'selectProduct': 'يرجى اختيار منتج',
  'dose': 'الجرعة',
  'veterinarian': 'الطبيب البيطري الموصي',
  'added': 'مضافة',
  'treatmentDetail': 'تفاصيل العلاج',
  'treatmentInformation': 'معلومات العلاج',
  'recordedOn': 'مسجل في',
  'withdrawalPeriod': 'فترة الانسحاب',
  'withdrawalActiveUntil': 'فترة الانسحاب نشطة حتى {date} ({days} أيام متبقية)',
  'withdrawalCompleted': 'انتهت فترة الانسحاب',
  'deleteTreatment': 'حذف العلاج',
  'deleteTreatmentConfirm': 'هل أنت متأكد من حذف هذا العلاج؟',
  'treatmentDeleted': 'تم حذف العلاج بنجاح',
  'editNotes': 'تعديل الملاحظات',
  'noNotes': 'لا توجد ملاحظات',
  'notesSaved': 'تم حفظ الملاحظات بنجاح',
  'notesPlaceholder': 'إضافة ملاحظات...',
  'notesMaxLength': 'الحد الأقصى 1000 حرف',

  // ============ التطعيم ============
  'vaccinationDetail': 'تفاصيل التطعيم',
  'information': 'معلومات',
  'animal': 'الحيوان',
  'reminder': 'تذكير',
  'protocol': 'البروتوكول',
  'confirm': 'تأكيد',

  // ============ تاريخ/تغيير EID ============
  'noEidChanges': 'لا تغييرات في EID',
  'eidHistory': 'سجلّ التغييرات',
  'oldEid': 'EID القديم',
  'newEid': 'EID الجديد',
  'changeEidTitle': 'تغيير EID',
  'currentEid': 'EID الحالي',
  'newEidLabel': 'EID جديد *',
  'changeReason': 'سبب التغيير *',
  'optionalNotes': 'ملاحظات (اختياري)',
  'eidChangedSuccess': '✅ تم تغيير EID بنجاح',
  'eidChangedError': '❌ خطأ أثناء تغيير EID',
  'eidRequired': 'EID مطلوب',
  'eidMustBeDifferent': 'يجب أن يختلف EID الجديد',
  'eidTooShort': 'EID قصير جداً',

  // ============ تفضيلات المزرعة ============
  'farmPreferencesTitle': 'تفضيلات التربية',
  'farmPreferencesSubtitle': 'قيم مبدئية عند إضافة حيوان',
  'defaultAnimalType': 'نوع الحيوان الافتراضي',
  'defaultBreed': 'السلالة الافتراضية',
  'noBreedSelected': 'لا شيء',
  'farmPreferencesInfo':
      'سيتم تعبئة هذه القيم تلقائياً عند إضافة حيوان جديد، ويمكنك تعديلها لاحقاً.',
  'noBreedAvailable': 'لا توجد سلالة لهذا النوع',
  'noneChooseEachTime': 'لا شيء (اختيار كل مرة)',

  // ============ التنبيهات ============
  'alerts': 'التنبيهات',
  'noAlertsTitle': 'لا توجد تنبيهات! 🎉',
  'noAlertsSubtitle': 'كل شيء على ما يرام في قطيعك',
  'alertsRecalculated': 'تمت إعادة حساب التنبيهات',
  'recalculateAlerts': 'إعادة حساب التنبيهات',
  'debugInfo': 'معلومات تصحيح:',
  'urgentAlertsCount': 'تنبيهات عاجلة',
  'importantAlertsCount': 'تنبيهات مهمة',
  'routineAlertsCount': 'تنبيهات روتينية',
  'totalCount': 'الإجمالي',
  'urgentAlerts': 'عاجلة',
  'importantAlerts': 'مهمة',
  'routineAlerts': 'روتينية',
  'overview': 'نظرة عامة',
  'urgentLabel': 'عاجلة',
  'importantLabel': 'مهمة',
  'routineLabel': 'روتينية',
  'animalNotFound': 'الحيوان غير موجود',
  'animalsToWeigh': 'حيوانات للوزن',
  'incompleteEvent': 'حدث غير مكتمل',
  'complete': 'إكمال',
  'batchAnimals': 'حيوانات الدفعة',
  'animalNotFoundAlert': 'الحيوان غير موجود: {name}',

  // رسائل التنبيه
  'withdrawalDeadlineExceeded': 'انتهت مهلة الذبح/البيع',
  'withdrawalInProgress': 'فترة السحب قيد التنفيذ',
  'seeAnimal': 'عرض الحيوان',
  'eidMissing': 'EID مفقود',
  'mandatoryIdentification': 'تعريف إلزامي',
  'addEid': 'إضافة EID',
  'eventToFinalize': 'حدث بحاجة للإتمام',
  'criticalSync': 'مزامنة حرجة',
  'syncRequired': 'مطلوب مزامنة',
  'synchronize': 'مزامنة',
  'recommendedWeighing': 'وزن مُوصى به',
  'seeAnimals': 'عرض الحيوانات',
  'treatmentToRenew': 'علاج للتجديد',
  'renew': 'تجديد',
  'lotToFinalize': 'دفعة بحاجة للإتمام',
  'finalize': 'إتمام',
  'motherNotDeclared': 'الأم غير مصرّح بها',
  'declareMother': 'تسجيل الأم',
  'invalidMother': 'أم غير صالحة',
  'correct': 'تصحيح',
  'noAlert': 'لا توجد تنبيهات 🎉',

  // فئات التنبيهات
  'categoryWithdrawal': 'فترة السحب',
  'categoryIdentification': 'التعريف',
  'categoryRegistry': 'السجلّ',
  'categorySynchronization': 'المزامنة',
  'categoryWeighing': 'الوزن',
  'categoryTreatment': 'العلاج',
  'categoryBatch': 'دفعة',
  'categoryBirth': 'الولادة',
  'categoryMortality': 'النفوق',
  'categoryOther': 'أخرى',
  'delayBeforeSlaughter': 'مهلة قبل الذبح/البيع',
  'eidAndTraceability': 'EID والتتبّع',
  'registryUpdate': 'تحديث السجلّ',
  'dataSave': 'نسخ احتياطي للبيانات',
  'weightTracking': 'تتبّع الوزن',
  'veterinaryCare': 'رعاية بيطرية',
  'batchManagement': 'إدارة الدُفعات',
  'birthDeclaration': 'تصريح الولادة',
  'mortalityManagement': 'إدارة النفوق',
  'otherAlerts': 'تنبيهات أخرى',

  // شاشات الحيوان
  'animals': 'الحيوانات',
  'addAnimal': 'إضافة حيوان',
  'animalDetail': 'تفاصيل الحيوان',
  'searchHint': 'ابحث عن EID أو رقم...',
  'noAnimals': 'لا توجد حيوانات',
  'filter': 'تصفية',
  'eid': 'EID',
  'eidCurrent': 'EID الحالي',
  'eidMother': 'EID للأم',
  'officialNumber': 'الرقم الرسمي',
  'visualId': 'المعرّف المرئي',
  'mother': 'الأم',
  'motherOptional': 'الأم (اختياري)',
  'motherUnknown': 'الأم غير معروفة',
  'birthDate': 'تاريخ الميلاد',
  'birthDateRequired': 'تاريخ الميلاد *',
  'sex': 'الجنس',
  'sexRequired': 'الجنس *',
  'male': 'ذكر',
  'female': 'أنثى',
  'breed': 'السلالة',
  'breedOptional': 'السلالة (اختياري)',
  'status': 'الحالة',
  'observations': 'ملاحظات',

  // تحقق الحيوان
  'animalNotFemale': 'الحيوان ليس أنثى',
  'animalNotAlive': 'الحيوان لم يعد حياً',
  'animalTooYoung': 'الحيوان صغير جداً (الحد الأدنى {months} أشهر)',
  'noId': 'بدون معرّف',
  'noIdentification': 'بدون تعريف',
  'idPrefix': 'معرّف: ',
  'eidPrefix': 'EID: ',
  'numberPrefix': 'رقم: ',
  'notAvailable': 'غير متاح',

  // تاريخ الأوزان
  'weightHistory': 'سجلّ الأوزان',
  'noWeights': 'لا توجد أوزان',
  'noWeightsMessage': 'لم يتم وزن هذا الحيوان بعد',
  'addWeight': 'إضافة وزن',
  'noNumber': 'بدون رقم',
  'statistics': 'إحصاءات',
  'lastWeight': 'آخر وزن',
  'weightCount': 'عدد الأوزان',
  'averageWeight': 'متوسط الوزن',
  'totalGain': 'إجمالي الزيادة',
  'gmq': 'الزيادة اليومية المتوسطة',
  'weightEvolution': 'تطور الوزن',
  'evolutionOverWeights': 'التطور عبر {count} وزن',
  'completeHistory': 'السجلّ الكامل',
  'current': 'الحالي',

  // تاريخ الأم
  'reproductionHistory': 'سجلّ التكاثر',
  'descendants': 'الذرية',
  'noDescendants': 'لا توجد ذرية مسجلة',
  'age': 'العمر',
  'reproductionStats': 'إحصاءات التكاثر',
  'totalBirths': 'إجمالي الولادات',
  'aliveFemales': 'أحياء',
  'survivalRate': 'معدل البقاء',
  'avgInterval': 'الفاصل المتوسط',
  'lastBirth': 'آخر ولادة',
  'bornOn': 'وُلد في',
  'months': 'أشهر',
  'alive': 'حيّ',
  'sold': 'مباع',
  'dead': 'ميت',
  'slaughtered': 'مذبوح',

  // الماسح
  'scanner': 'الماسح',
  'scannedTheAnimals': 'مسح الحيوانات',
  'scanHint': 'امسح باركود أو EID أو معرّفاً مرئياً',
  'scanError': 'خطأ في المسح',
  'processing': 'جارٍ المعالجة...',
  'manualEntry': 'إدخال يدوي',

  // الرئيسية
  'dashboard': 'لوحة التحكم',

  // الدُفعات
  'batches': 'الدُفعات',
  'noBatches': 'لا توجد دُفعات',
  'prepareBatch': 'تحضير دفعة',
  'batchDescription':
      'أنشئ دفعة لتجميع الحيوانات وتسهيل الإجراءات الجماعية (بيع، ذبح، علاج).',
  'batchName': 'اسم الدفعة *',
  'batchNameHint': 'مثال: ذبح نوفمبر 2025',
  'batchPurpose': 'الهدف *',
  'batchNameRequired': 'اسم الدفعة مطلوب',
  'minCharacters': 'يجب أن يحتوي الاسم على 3 أحرف على الأقل',
  'sale': 'بيع',
  'slaughter': 'ذبح',
  'treatmentBatch': 'علاج',
  'other': 'أخرى',
  'startScan': 'بدء المسح',
  'noAnimalsAvailableBatch': '⚠️ لا توجد حيوانات في القطيع',
  'animalDuplicate': '⚠️ {name} تم مسحه مسبقاً',
  'animalRemoved': 'تمت إزالة الحيوان من الدفعة',
  'batchEmpty': '⚠️ الدفعة فارغة. امسح حيواناً واحداً على الأقل.',
  'scannedAnimals': 'الحيوانات الممسوحة',
  'newBatch': 'دفعة جديدة',
  'noBatchesCreated': 'لم يتم إنشاء دفعات',
  'deleteBatchTitle': 'حذف الدفعة؟',
  'deleteBatchMessage': 'هل تريد حقاً حذف الدفعة "{name}" ({count} حيوان)؟',
  'batchDeleted': 'تم حذف الدفعة "{name}"',
  'saleOfBatch': 'بيع الدفعة "{name}"',
  'slaughterOfBatch': 'ذبح الدفعة "{name}"',
  'toImplement': 'قيد التنفيذ',
  'featureComingSoon': 'الميزة قادمة قريباً',
  'export': 'تصدير',
  'exportComingSoon': 'التصدير قريباً',
  'completedOn': 'تم في',
  'useForSale': 'استخدام للبيع',
  'useForSlaughter': 'استخدام للذبح',
  'applyTreatment': 'تطبيق العلاج',
  'use': 'استخدام',
  'animalAdded': '✅ تم إضافة {name}',
  'batchSaved': '✅ تم حفظ الدفعة "{name}" ({count} حيوان)',
  'cancelBatchTitle': 'إلغاء الدفعة؟',
  'cancelBatchMessage': 'تضم الدفعة {count} حيوان(اً). هل تريد الإلغاء فعلاً؟',
  'cancelBatchEmpty': 'هل تريد إلغاء إنشاء الدفعة؟',
  'no': 'لا',
  'yes': 'نعم',
  'yesCancel': 'نعم، إلغاء',
  'noAnimalScanned': 'لم يتم مسح أي حيوان',
  'animalsScannedCount': '{count} حيوان{plural} ممسوح{pluralScanned}',
  'scanOneAnimal': 'مسح حيوان واحد',
  'scanAnimalsOneByOne': 'امسح الحيوانات واحداً تلو الآخر',

  // الشحنات/اللوت (Lots)
  'lots': 'اللوطات',
  'noLots': 'لا توجد لوطات',
  'lotDetail': 'تفاصيل اللوت',
  'finalizeLot': 'إتمام اللوت',
  'chooseLotType': 'اختر نوع اللوت',
  'treatmentLot': 'علاج',
  'saleLot': 'بيع',
  'slaughterLot': 'ذبح',
  'createLot': 'إنشاء لوت',
  'lotName': 'اسم اللوت',
  'duplicateLot': 'نسخ اللوت',
  'newLotName': 'اسم جديد للوت',
  'keepAnimals': 'الإبقاء على الحيوانات',
  'keepType': 'الإبقاء على النوع',
  'deleteLot': 'حذف اللوت',
  'myLots': 'لوطاتي',
  'openLots': 'لوطات مفتوحة',
  'closedLots': 'لوطات مغلقة',
  'noOpenLot': 'لا يوجد لوت مفتوح',
  'noClosedLot': 'لا يوجد لوت مغلق',
  'invalidPrice': 'سعر غير صالح',
  'lotNotFound': 'اللوت غير موجود',
  'groupedHealthTreatment': 'علاج صحي جماعي',
  'slaughterPrep': 'تحضير للمسلخ',
  'animalSale': 'بيع حيوانات',
  'treatmentWillApply': 'سيطبَّق العلاج على حيوانات الدفعة',
  'buyerName': 'اسم المشتري *',
  'farmNumber': 'رقم المزرعة (اختياري)',
  'pricePerAnimal': 'السعر لكل حيوان (€) *',
  'fieldRequired': 'حقل مطلوب',
  'deleteLotConfirm': 'حذف "{name}"؟',
  'vetValidated': '✅ {name} تم اعتماده',
  'ewesMonthHint': 'مثال: نعاج مايو 2025',
  'addCopieToName': '(نسخة)',
  'noVeterinarianFound': 'لا يوجد طبيب بيطري',
  'product': 'المنتج',
  'treatmentDate': 'تاريخ العلاج',
  'buyer': 'المشتري',
  'totalPrice': 'السعر الإجمالي',
  'slaughterhouse': 'المسلخ',
  'males': 'ذكور',
  'females': 'إناث',
  'close': 'إغلاق',
  'newName': 'اسم جديد',
  'lotRenamed': 'تم تغيير اسم اللوت',
  'lotDuplicated': 'تم نسخ اللوت',
  'lotClosed': 'تم إغلاق اللوت',
  'lotOpened': 'تم فتح اللوت',
  'onThe': 'في',
  'type': 'النوع',
  'animalRemovedFromLot': 'تمت إزالة الحيوان',
  'animalsAdded': 'حيوانات مضافة',
  'scanAnimals': 'مسح الحيوانات',
  'lotFinalized': 'تم إتمام اللوت',
  'saleAnimals': 'بيع الحيوانات',
  'slaughterPreparation': 'التحضير للمسلخ',
  'notesOptional': 'ملاحظات (اختياري)',
  'treatmentWillApplyToAnimals': 'سيتم تطبيق العلاج على الحيوانات',
  'typeNotDefined': 'النوع غير محدد',
  'allGoodWithHerd': 'كل شيء على ما يرام مع قطيعك',
  'animalNotFoundSearch': '❌ الحيوان "{query}" غير موجود',
  'quickActions': 'إجراءات سريعة',
  'manageHerd': 'إدارة قطيعي',
  'campaignsGroups': 'حملات ومجموعات',
  'exportRegistry': 'تصدير السجلّ',
  'pdfControl': 'PDF للتفتيش',
  'identifyAnimal': 'تحديد حيوان',
  'aliveStatus': 'أحياء',
  'activeStatus': 'نشطة',
  'urgentStatus': 'عاجلة',

  // الطبي/الأحداث
  'recordSale': 'تسجيل بيع',
  'confirmSale': 'تأكيد البيع',
  'saleRecorded': 'تم تسجيل البيع',
  'slaughterRecorded': 'تم تسجيل الذبح',
  'recordDeath': 'تسجيل نفوق',
  'confirmDeath': 'تأكيد النفوق',
  'deathRecorded': 'تم تسجيل النفوق',
  'irreversibleWarning': 'إجراء غير قابل للتراجع. سيُعلَّم الحيوان كمتوفّى.',
  'deathCause': 'سبب الوفاة',
  'buyerIdOptional': 'معرّف مزرعة المشتري (اختياري)',
  'priceEur': 'السعر (€) *',
  'step1ScanAnimal': 'الخطوة 1: مسح الحيوان',
  'step2BuyerInfo': 'الخطوة 2: معلومات المشتري',
  'step3SalePrice': 'الخطوة 3: سعر البيع',
  'withdrawalPeriodActive': '⚠️ غير ممكن: فترة السحب نشطة',
  'pleaseEnterBuyerName': 'يرجى إدخال اسم المشتري',
  'scanVeterinarian': 'البحث عن طبيب بيطري',
  'noVeterinarianSelected': 'لا يوجد طبيب مختار',
  'scanQrCode': 'مسح QR',
  'exportDocuments': 'تصدير المستندات',
  'pdfDownloaded': '✅ تم تنزيل PDF',

  // إضافات
  'causeNotSpecified': 'سبب غير محدد',
  'deathCauseHint': 'مثال: مرض، حادث، مفترس...',
  'buyerNameHint': 'مثال: أحمد علي',
  'buyerIdHint': 'مثال: FR123456789',
  'priceHint': '120.00',
  'actType': 'نوع الإجراء',
  'standardCure': 'خطة علاج قياسية',
  'days': 'أيام',
  'administration': 'الإعطاء',
  'single': 'جرعة واحدة',
  'dosage': 'الجرعة',
  'calculatedAccording': 'محسوبة وفقاً لـ',
  'formula': 'معادلة',
  'weightNotAvailable': 'الوزن غير متاح',
  'enterDosage': 'أدخل الجرعة',
  'addWeightToCalculate': 'أضف وزناً لحساب الجرعة تلقائياً',
  'productDosage': 'جرعة المنتج',
  'indicativeCalculation': 'حساب إرشادي',
  'doseIndividually': 'جرعة فردية حسب الوزن',
  'route': 'طريق الإعطاء',
  'oral': 'فموي',
  'topical': 'موضعي',
  'site': 'الموضع',
  'neck': 'العنق',
  'thigh': 'الفخذ',
  'flank': 'الخاصرة',
  'hindQuarter': 'الربع الخلفي',
  'jugularVein': 'الوريد الوداجي',
  'reminders': 'تذكيرات',
  'sendMeReminders': 'إرسال تذكيرات لي',
  'reminderTime': 'وقت التذكير',
  'configureReminders': 'اضبط التذكيرات',
  'to': 'إلى',
  'configureCustomReminders': 'ضبط تذكيرات مخصّصة',
  'reminderS': 'تذكير/تذكيرات',
  'configureVaccinationReminders': 'ضبط تذكيرات التطعيم',
  'withdrawalPeriods': 'فترات السحب',
  'meat': 'لحم',
  'milk': 'حليب',
  'additionalNotesOptional': 'ملاحظات إضافية (اختياري)',
  'prescribingVeterinarian': 'الطبيب البيطري الموصي',
  'validated': 'مؤكّد',
  'pleaseSelectProduct': 'يرجى اختيار منتج',
  'pleaseEnterValidDosage': 'يرجى إدخال جرعة صالحة',
  'treatmentRecordedSuccess': 'تم تسجيل العلاج بنجاح',
  'vaccinationRecordedSuccess': 'تم تسجيل التطعيم بنجاح',
  'treat': 'علاج',
  'treatBatch': 'علاج الدفعة',
  'vaccination': 'تطعيم',
  'batch': 'دفعة',
  'species': 'النوع',

  // موجز المزرعة
  'myFarm': 'مزرعتي',
  'animalInventory': 'جرد الحيوانات',
  'total': 'الإجمالي',
  'animalsCount': 'حيوانات',
  'eidLabel': 'EID',
  'maleShort': 'ذ',
  'femaleShort': 'أ',
  'cannotAccessDownloads': 'تعذّر الوصول إلى التنزيلات',
  'completeRegistry': 'السجلّ الكامل',
  'herdInventory': 'جرد القطيع',
  'completeHerdList': 'قائمة القطيع الكاملة',

  // اتصال/عدم اتصال
  'onlineModeActivated': 'تم تفعيل وضع الاتصال',
  'toggleOnlineOffline': 'تبديل اتصال/عدم اتصال',
  'connectedToServer': 'متصل بالخادم',
  'syncAvailable': 'المزامنة متاحة',
  'dataWillSyncLater': 'ستتزامن البيانات لاحقاً',
  'lastSync': 'آخر مزامنة',
  'never': 'أبداً',
  'syncFailed': 'فشلت المزامنة',
  'syncInProgress': 'جاري المزامنة...',
  'requiresConnection': '(يتطلب اتصالاً)',
  'allDataSynchronized': 'جميع البيانات متزامنة',
  'syncError': 'خطأ في المزامنة',
  'localDataSummary': 'ملخص البيانات المحلية',
  'treatments': 'العلاجات',
  'campaigns': 'الحملات',
  'justNow': 'الآن',
  'minutesAgo': 'قبل {minutes} دقيقة',
  'hoursAgo': 'قبل {hours} ساعة',

  // لوحة العلاج
  'treatmentDash': 'العلاج - {batchName}',
  'addCare': 'إضافة رعاية',
  'treatmentForAnimals': 'علاج لـ {count} حيوان',
  'careAdded': 'تمت إضافة الرعاية',
  'individualTreatment': 'علاج فردي',
  'groupTreatment': 'علاج جماعي',
  'oneAnimalConcerned': 'حيوان واحد معني',
  'animalsConcerned': '{count} حيواناً معنياً',
  'medicalProduct': 'منتج طبي *',
  'withdrawalDelay': 'المهلة',
  'meatDays': '{days}ي لحم',
  'doseExample': 'مثال: 2.5',
  'unitMl': 'مل',
  'pleaseEnterDose': 'يرجى إدخال الجرعة',
  'invalidDose': 'جرعة غير صالحة',
  'treatmentDateLabel': 'تاريخ العلاج',
  'notesHintTreatment': 'ملاحظات، أعراض، جرعات...',

  // التطعيم
  'animalsLowercase': 'حيوانات',
  'vaccinationDate': 'تاريخ التطعيم',
  'doseLabel': 'الجرعة',
  'administrationRoute': 'طريق الإعطاء',
  'lotNumber': 'رقم الدفعة',
  'expirationDate': 'تاريخ الانتهاء',
  'veterinarianLabel': 'الطبيب البيطري',
  'withdrawalPeriodLabel': 'فترة السحب',
  'daysRemaining': 'متبقي {days} يوم',
  'groupVaccination': 'تطعيم جماعي - {count} حيوان',
  'animalPrefix': 'حيوان: {id}',
  'unknownAnimal': 'حيوان غير معروف',
  'lateByDays': 'متأخر بـ {days} يوم',
  'today': 'اليوم',
  'inDays': 'بعد {days} يوم',
  'nextReminder': 'التذكير التالي: {date}',
  'notesLabel': 'ملاحظات',
  'protocolLabel': 'البروتوكول',
  'name': 'الاسم',
  'description': 'الوصف',
  'reminderFrequency': 'تكرار التذكير',
  'recommendedPeriod': 'الفترة الموصى بها',
  'protocolNotes': 'ملاحظات البروتوكول',
  'deleteVaccination': 'حذف التطعيم',
  'deleteVaccinationConfirm':
      'هل أنت متأكد من حذف هذا التطعيم؟ هذا الإجراء غير قابل للاسترجاع.',
  'vaccinationDeleted': 'تم حذف التطعيم',

  // خطوات الوزن
  'animalScanned': 'تم مسح الحيوان: {name}',
  'stepOneAnimal': '1. الحيوان',
  'stepTwoWeight': '2. {weight}',
  'stepThreeSource': '3. مصدر القياس',
  'stepFourDate': '4. {date}',
  'stepFiveNotes': '5. {notes} ({optional})',
  'weightRequired': '{weight} مطلوب',
  'invalidWeight': '{weight} غير صالح',
  'weightRangeError': 'يجب أن يكون الوزن بين 0 و {max} كغ',
  'measurementSource': 'مصدر القياس',
  'reliability': 'الموثوقية: {percent}%',
  'weightHintExample': '45.5',
  'unitKg': 'كغ',
  'notesHintWeight': 'مثال: حيوان بصحة جيدة، وزن بعد الجز...',

  // تغيير/تاريخ EID
  'newEidHint': 'مثال: 250001234567890',
  'notesHintEid': 'مثال: تبيّن كسر الشريحة أثناء المسح',

  // إدارة المزرعة
  'notDefined': 'غير معرّف',
  'farmEmojiSheep': '🐑',

  // ========== الإعدادات ==========
  'adminEmail': 'admin@rfid-troupeau.com',
  'languageSection': 'اللغة / Language / Langue',
  'french': 'Français',
  'arabic': 'العربية',
  'english': 'English',
  'colorBlue': 'أزرق',
  'colorGreen': 'أخضر',
  'colorPurple': 'بنفسجي',
  'colorOrange': 'برتقالي',
  'appVersion': '1.0.0+1 (MVP)',
  'mvpOnly': '(MVP)',
  'openSyncScreen': 'فتح sync_detail_screen.dart',
  'fullName': 'الاسم الكامل',
  'profileEditComingSoon': 'تعديل الملف الشخصي - قريباً',
  'modify': 'تعديل',
  'currentPassword': 'كلمة المرور الحالية',
  'newPassword': 'كلمة المرور الجديدة',
  'confirmPassword': 'تأكيد كلمة المرور',
  'passwordChangedSuccess': 'تم تغيير كلمة المرور بنجاح',
  'chooseColor': 'اختر لوناً',
  'restartAppForColor': 'أعد تشغيل التطبيق لتطبيق اللون',
  'oneMinute': 'دقيقة واحدة',
  'fiveMinutes': '5 دقائق',
  'fifteenMinutes': '15 دقيقة',
  'thirtyMinutes': '30 دقيقة',
  'thisDevice': 'هذا الجهاز',
  'activeNow': 'نشط الآن',
  'tabletSamsung': 'جهاز لوحي سامسونج',
  'twoHoursAgo': 'قبل ساعتين',
  'sessionDisconnected': 'تم قطع الجلسة',
  'clearCacheDescription':
      'سيؤدي ذلك إلى حذف الملفات المؤقتة وتحرير مساحة. ستبقى بياناتك محفوظة.',
  'cacheCleared': 'تم مسح الذاكرة المؤقتة بنجاح',
  'clear': 'مسح',
  'csvFile': 'ملف CSV',
  'importFromCsv': 'استيراد من CSV',
  'importCsvComingSoon': 'استيراد CSV - قريباً',
  'excelFile': 'ملف Excel',
  'importFromExcel': 'استيراد من Excel',
  'importExcelComingSoon': 'استيراد Excel - قريباً',
  'exportCsvComingSoon': 'تصدير CSV - قريباً',
  'exportXmlComingSoon': 'تصدير XML - قريباً',
  'exportExcelComingSoon': 'تصدير Excel - قريباً',
  'clearDataConfirmTitle': 'مسح البيانات؟',
  'clearDataConfirmMessage':
      'سيتم حذف جميع البيانات المحلية غير المتزامنة. هذا الإجراء لا يمكن التراجع عنه.',
  'featureDisabledMvp': 'الميزة معطّلة في نسخة MVP',
  'veterinarianSetDefault': 'تم تعيين {name} كافتراضي',
  'veterinarianValidated': '✅ تم اعتماد {name}',
  'selectDefaultVeterinarian': 'اختر طبيباً بيطرياً افتراضياً',
  'privacyPolicyContent':
      'تقدّر RFID Troupeau خصوصيتك.\n\n• تُخزَّن جميع البيانات محلياً على جهازك\n• تتم المزامنة عبر HTTPS/TLS بشكل آمن\n• لا نشارك البيانات مع أطراف ثالثة\n• لك السيطرة الكاملة على بياناتك\n• لا نجمع أي بيانات شخصية دون موافقتك\n\nللمزيد: support@rfid-troupeau.com',
  'termsOfServiceContent':
      'شروط الاستخدام\n\n1. قبول الشروط\nباستخدام RFID Troupeau فإنك توافق على هذه الشروط.\n\n2. استخدام الخدمة\nتُقدَّم الخدمة "كما هي" لإدارة القطعان.\n\n3. المسؤوليات\nأنت مسؤول عن دقة البيانات المُدخلة.\n\n4. الملكية الفكرية\nجميع الحقوق محفوظة.\n\n5. تحديد المسؤولية\nلسنا مسؤولين عن فقدان البيانات.\n\nالإصدار: 1.0.0\nآخر تحديث: أكتوبر 2025',
  'needHelp': 'هل تحتاج مساعدة؟',
  'supportEmail': 'support@rfid-troupeau.com',
  'supportPhone': '+33 1 23 45 67 89',
  'supportWebsite': 'www.rfid-troupeau.com',
  'businessHours': 'الساعات: الإثنين–الجمعة 9–18',
  'sendEmailComingSoon': 'إرسال بريد - قريباً',
  'contactUs': 'اتصل بنا',
  'resetPreferencesMessage':
      'سيؤدي ذلك إلى إعادة جميع الإعدادات إلى القيم الافتراضية. لن تتأثر بياناتك.',
  'preferencesReset': 'تمت إعادة التفضيلات',
  'reset': 'إعادة تعيين',
  'email': 'البريد الإلكتروني',
  'phone': 'الهاتف',
  'website': 'الموقع الإلكتروني',

  // شاشات اللوت
  'treatLot': 'علاج اللوت',
  'saleDate': 'تاريخ البيع',
  'buyerNameRequired': 'اسم المشتري مطلوب',
  'dateSlaughter': 'تاريخ الذبح',
  'nameOrEstablishment': 'الاسم أو المنشأة',
  'lotCreated': 'تم إنشاء اللوت',
  'source': 'المصدر: {name}',
  'deleteLotQuestion': 'حذف "{name}"؟',
  'lotDeleted': 'تم حذف اللوت',
  'back': 'رجوع',
  'copySuffix': '(نسخة)',
  'buyerFarmId': 'معرّف مزرعة المشتري',
  'slaughterhouseName': 'اسم المسلخ',
  'slaughterhouseId': 'معرّف المسلخ',

  // محدد الحيوانات
  'identifyAnimals': 'تحديد الحيوانات',
  'animalAlreadyScanned': '⚠️ {name} ممسوح مسبقاً',
  'noAnimalAvailable': '⚠️ لا يوجد حيوانات متاحة',
  'searchEidOfficialVisual': 'ابحث عن EID أو الرقم الرسمي أو المعرّف المرئي...',
  'stop': 'إيقاف',
  'scanRfid': 'مسح RFID',
  'camera': 'الكاميرا',
  'done': 'تم',
  'scanOrSearchAnimals': 'امسح أو ابحث\nعن الحيوانات',
  'selected': 'المحدَّد',
  'noAnimalFound': 'لم يتم العثور على حيوان',
  'tryAnotherIdentifier': 'جرّب معرّفاً آخر',
  'numberShort': 'رقم',
  'idLabel': 'معرّف',
  'selectedAnimals': 'الحيوانات المحددة',
  'scanMother': 'مسح الأم',

  // إضافة حيوان
  'identification': '📋 التعريف',
  'eidElectronic': 'EID (رقم إلكتروني)',
  'atLeastOneIdRequired':
      'مطلوب معرّف واحد على الأقل (EID أو الرقم الرسمي أو المعرّف المرئي)',
  'officialNumberOptional': 'الرقم الرسمي (اختياري)',
  'visualIdOptional': 'معرّف مرئي (اختياري)',
  'toIdentifyEasily': 'لتعريف الحيوان بسهولة',
  'typeAndBreed': '🐑 النوع والسلالة',
  'animalType': 'نوع الحيوان *',
  'animalTypeRequired': 'نوع الحيوان مطلوب',
  'noBreed': '-- بدون سلالة --',
  'selectTypeFirst': 'اختر النوع أولاً',
  'characteristics': '🐄 الخصائص',
  'origin': 'المنشأ *',
  'originRequired': 'المنشأ *',
  'birth': 'ولادة',
  'purchase': 'شراء',
  'provenance': 'المصدر',
  'farmOrBreederName': 'اسم المزرعة أو المربّي',
  'purchasePrice': 'سعر الشراء',
  'observationsRemarks': 'ملاحظات، تعليقات...',
  'saving': 'جارٍ الحفظ...',
  'idScanned': '✅ تم مسح المعرّف: {name}',
  'motherMustBeFemale': '⚠️ يجب أن تكون الأم أنثى',
  'motherSelected': '✅ تم اختيار الأم: {name}',
  'atLeastOneIdRequiredError':
      '⚠️ مطلوب معرّف واحد على الأقل (EID أو الرقم الرسمي أو المعرّف المرئي)',
  'selectSexError': '⚠️ يرجى اختيار الجنس',
  'selectBirthDateError': '⚠️ يرجى اختيار تاريخ الميلاد',
  'motherNotFound': '⚠️ لم يتم العثور على الأم',
  'animalSavedSuccess': '✅ تم حفظ الحيوان بنجاح',
  'errorOccurred': '❌ خطأ: {error}',
  'eidOfMother': 'EID للأم',
  'scanningInProgress': 'جارٍ المسح...',
  'noFemaleAvailable': 'لا توجد إناث في القطيع',
  'add': 'إضافة',
  'motherAdded': '✅ تم إضافة الأم: {name}',
  'eidDetected': 'تم اكتشاف EID',
  'placeRfidNear': 'ضع قارئ RFID قرب الحيوان لمسح EID الإلكتروني.',
  'eidDetectedSuccess': 'تم اكتشاف EID بنجاح',
  'eidScanned': '✅ تم مسح EID: {eid}',
  'validate': 'تحقق',

  // تفاصيل الحيوان
  'infos': 'معلومات',
  'care': 'رعاية',
  'genealogy': 'شجرة النسب',
  'years': 'سنوات',
  'statusAlive': '🟢 حيّ',
  'statusSold': '🟠 مباع',
  'statusDead': '🔴 ميت',
  'statusSlaughtered': '🔴 مذبوح',
  'weightInKg': 'الوزن (كغ)',
  'addWeightButton': 'إضافة',
  'weightAddedSuccess': '✅ تم إضافة الوزن بنجاح',
  'identifiers': 'المعرّفات',
  'changeEid': 'تغيير EID',
  'visualIdAnimal': 'المعرّف المرئي',
  'show': 'عرض',
  'noEidHistory': 'لا يوجد سجلّ لـ EID',
  'generalInfo': 'معلومات عامة',
  'statusAnimal': 'الحالة',
  'noWeightRecorded': 'لا يوجد وزن مسجّل',
  'seeAll': 'عرض الكل',
  'kg': 'كغ',
  'gain': 'زيادة',
  'loss': 'نقص',
  'actions': 'إجراءات',
  'recordWeight': 'وزن',
  'declareDeath': 'تسجيل نفوق',
  'death': 'نفوق',
  'noActiveAlert': 'لا توجد تنبيهات نشطة',
  'vaccinations': 'التطعيمات',
  'noVaccination': 'لا يوجد تطعيم مسجّل',
  'reminderLate': 'تذكير متأخر',
  'reminderInDays': 'تذكير خلال {days}ي',
  'noMotherDeclared': 'لا توجد أم مسجّلة',
  'seeDetails': 'عرض التفاصيل',
  'offspring': 'الذرية',
  'noOffspring': 'لا توجد ذرية مسجّلة',

  // قائمة الحيوانات
  'allAnimals': 'جميع الحيوانات',
  'animalList': 'قائمة الحيوانات',
  'urgent': '🚨 عاجل',
  'toMonitor': '⚠️ متابعة',
  'routine': '📋 روتين',
  'withdrawal': 'فترة السحب',
  'apply': 'تطبيق',
  'all': 'الكل',
  'active': 'نشطة',
  'inactive': 'غير نشطة',
  'motherEid': 'EID للأم',
  'noAnimal': 'لا يوجد حيوان',
  'searchEidOfficial': 'ابحث عن EID أو الرقم الرسمي...',
  'filters': 'مرشِّحات',
  'groupBy': 'تجميع حسب',
  'none': 'لا شيء',
  'withAlertsOnly': 'مع التنبيهات فقط',
  'byAlert': 'حسب التنبيه',
  'bySex': 'حسب الجنس',
  'byAge': 'حسب العمر',
  'byStatus': 'حسب الحالة',
  'byWithdrawal': 'حسب فترة السحب',
  'byMother': 'حسب الأم',
  'byType': 'حسب النوع',
  'byBreed': 'حسب السلالة',

  // تاريخ الوزن
  'fullHistory': 'السجلّ الكامل',

  'scanQrEidVisual': 'امسح باركود أو EID أو معرّف مرئي',
  'manualInput': 'إدخال يدوي',

  // الدُفعة
  'animalCount': '{count} حيوان{plural}',
  'continueScanning': 'متابعة',
  'cancelBatch': 'إلغاء الدفعة',

  // عام/تنقل
  'scan': 'مسح',
  'home': 'الرئيسية',

  // ============ إعدادات المزرعة وإحصائيات التنبيهات ============
  'enabled': 'مُفعّلة',
  'disabled': 'مُعطّلة',
  'draftUrgentAlert': '🚨 عاجل: مسودة منذ {days} يوم',
  'draftWarningAlert': '⚠️ مسودة منذ {hours} ساعة',
  'initializingAlerts': 'جاري تهيئة التنبيهات...',
  'creatingDefaultConfigs': 'جاري إنشاء الإعدادات الافتراضية',
  'alertEnabled': 'التنبيه مُفعّل: {title}',
  'alertDisabled': 'التنبيه مُعطّل: {title}',
};
