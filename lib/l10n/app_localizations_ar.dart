// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'تطبيق GDM Firebase';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get confirmPasswordLabel => 'تأكيد كلمة المرور';

  @override
  String get pleaseEnterEmail => 'أدخل البريد الإلكتروني';

  @override
  String get pleaseEnterPassword => 'أدخل كلمة المرور';

  @override
  String get loginSuccess => 'تم تسجيل دخول المستخدم بنجاح!';

  @override
  String get loginfailedTryAgain => 'فشل تسجيل الدخول. يرجى المحاولة مرة أخرى.';

  @override
  String get userNotFound => 'لم يتم العثور على المستخدم في أي مجموعة!';

  @override
  String get wrongPassword => 'كلمة المرور غير صحيحة. حاول مرة أخرى.';

  @override
  String get invalidEmail =>
      'تنسيق البريد الإلكتروني غير صالح. أدخل بريدًا إلكترونيًا صالحًا.';

  @override
  String get userDisabled => 'تم تعطيل هذا الحساب.';

  @override
  String get tooManyRequests =>
      'محاولات تسجيل دخول كثيرة جدًا. حاول مرة أخرى لاحقًا.';

  @override
  String get invalidCredential =>
      'بيانات اعتماد غير صالحة. تحقق من بريدك الإلكتروني وكلمة المرور.';

  @override
  String get operationNotAllowed =>
      'تسجيل الدخول باستخدام البريد الإلكتروني/كلمة المرور غير مفعل.';

  @override
  String get genericError => 'حدث خطأ غير متوقع. حاول مرة أخرى.';

  @override
  String get signUpPrompt => 'ليس لديك حساب؟';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get signUp => 'اشتراك';

  @override
  String get createAccount => 'إنشاء حساب!';

  @override
  String get nameLabel => 'الاسم';

  @override
  String get pleaseEnterName => 'أدخل اسمك';

  @override
  String get pleaseEnterConfirmPassword => 'أدخل تأكيد كلمة المرور';

  @override
  String get passwordsDoNotMatch => 'كلمات المرور غير متطابقة!';

  @override
  String get emailAlreadyInUse =>
      'البريد الإلكتروني مستخدم بالفعل! حاول ببريد إلكتروني آخر.';

  @override
  String get weakPassword => 'كلمة المرور الجديدة ضعيفة جدًا';

  @override
  String get signUpSuccess => 'تم تسجيل المستخدم بنجاح!';

  @override
  String get permissionDenied => 'تم رفض الإذن. تحقق من حقوق الوصول الخاصة بك.';

  @override
  String get firestoreUnavailable =>
      'خدمة Firestore غير متوفرة. حاول مرة أخرى لاحقًا.';

  @override
  String get notFound => 'لم يتم العثور على المستند أو المجموعة المطلوبة.';

  @override
  String get operationCancelled => 'تم إلغاء العملية. حاول مرة أخرى.';

  @override
  String get deadlineExceeded => 'انتهت مهلة العملية. حاول مرة أخرى.';

  @override
  String get firestoreGenericError => 'فشل في حفظ البيانات. حاول مرة أخرى.';

  @override
  String get noUserLoggedIn => 'لا يوجد مستخدم مسجل الدخول حاليًا';

  @override
  String get tellUsAboutYourself => 'أخبرنا عن نفسك';

  @override
  String get personalizationMessage => 'معاييرك الفردية مهمة\nللتخصيص المتعمق.';

  @override
  String get genderLabel => 'الجنس';

  @override
  String get maleOption => 'ذكر';

  @override
  String get femaleOption => 'أنثى';

  @override
  String get maleOrFemale => 'ذكر أو أنثى';

  @override
  String get weightLabel => 'الوزن';

  @override
  String get pleaseEnterWeight => 'أدخل وزنك';

  @override
  String get weightInKg => 'أدخل وزنك بالكيلوغرام';

  @override
  String get weightInLbs => 'أدخل وزنك بالباوند';

  @override
  String get kgUnit => 'كجم';

  @override
  String get lbsUnit => 'باوند';

  @override
  String get ageLabel => 'أدخل عمرك';

  @override
  String get heightLabel => 'أدخل طولك';

  @override
  String get ethnicityLabel => 'أدخل عرقيتك';

  @override
  String get diabetesLabel => 'أدخل بيانات السكري';

  @override
  String get waistLabel => 'أدخل محيط الخصر';

  @override
  String get hypertensionLabel => 'تاريخ ارتفاع ضغط الدم';

  @override
  String get submit => 'إرسال';

  @override
  String get personalInfoSaved => 'تم حفظ المعلومات الشخصية بنجاح!';

  @override
  String get welcomeToGDMCareHub => 'مرحبًا بك في GDMCare+ Hub';

  @override
  String get welcomeToGDMCareHubDescription =>
      'مرحبًا بك في GDMCare+ Hub – منصتك المفضلة لإدارة السكري أثناء الحمل وتمكين الجميع بوعي حول السكري!';

  @override
  String get understandingDiabetes => 'فهم السكري';

  @override
  String get understandingDiabetesDescription =>
      'السكري هو حالة مزمنة يعاني فيها الجسم من صعوبة في التحكم بمستويات السكر في الدم.';

  @override
  String get type2Diabetes => 'السكري من النوع الثاني';

  @override
  String get type2DiabetesDescription =>
      'السكري من النوع الثاني هو الشكل الأكثر شيوعًا، وغالبًا ما يكون مرتبطًا بسوء التغذية وقلة التمارين الرياضية.';

  @override
  String get risksOfGestationalDiabetes => 'مخاطر السكري الحملي';

  @override
  String get risksOfGestationalDiabetesDescription =>
      'يزيد من مخاطر المضاعفات للأم والطفل، وكذلك السكري من النوع الثاني في المستقبل.';

  @override
  String get selectOption => 'اختر خيارًا';

  @override
  String get diabetesTestDate => 'متى تم إجراء اختبار السكري؟';

  @override
  String get phoneLabel => 'رقم الهاتف';

  @override
  String get timeLabel => 'الوقت';

  @override
  String get amLabel => 'صباحًا';

  @override
  String get pmLabel => 'مساءً';

  @override
  String get confirm => 'تأكيد';

  @override
  String get userSelection => 'اختيار المستخدم';

  @override
  String get chooseOption => 'اختر خيارًا للتنقل بسلاسة!';

  @override
  String get iAm => 'أنا';

  @override
  String get pregnant => 'حامل';

  @override
  String get notPregnant => 'غير حامل';

  @override
  String get doctor => 'طبيب';

  @override
  String get pleaseSelectOption => 'يرجى اختيار خيار';

  @override
  String get next => 'التالي';

  @override
  String get pregnancyRegistration => 'تسجيل الحمل';

  @override
  String get lmpLabel => 'آخر دورة شهرية (LMP)';

  @override
  String get dueDateLabel => 'تاريخ الولادة المتوقع (للقراءة فقط)';

  @override
  String get pleaseEnterLMP => 'أدخل آخر دورة شهرية';

  @override
  String get pleaseEnterLMPToCalculate => 'أدخل آخر دورة شهرية لحساب التاريخ';

  @override
  String get diabetesTestLabel => 'هل أجريت اختبار السكري أثناء هذا الحمل؟';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get notSure => 'غير متأكد';

  @override
  String get weightInKgCm => 'أدخل وزنك (كجم)';

  @override
  String get heightInCm => 'أدخل طولك (سم)';

  @override
  String get familyHistoryDiabetes => 'تاريخ عائلي للسكري من النوع الثاني';

  @override
  String get numberOfPregnancies => 'عدد حالات الحمل';

  @override
  String get numberOfDeliveries => 'عدد الولادات السابقة';

  @override
  String get numberOfMiscarriages => 'عدد الإجهاضات';

  @override
  String get numberOfStillbirths => 'عدد الولادات الميتة';

  @override
  String get numberOfChildrenAlive => 'عدد الأطفال الأحياء';

  @override
  String get back => 'رجوع';

  @override
  String get pregnancyDiagnosis => 'تشخيص الحمل';

  @override
  String get q1GdmThisPregnancy =>
      '1. هل تم تشخيصك بمرض السكري الحملي خلال هذا الحمل؟';

  @override
  String get q2HypertensionThisPregnancy =>
      '2. هل تم تشخيصك بارتفاع ضغط الدم خلال هذا الحمل؟';

  @override
  String get q3GdmPreviousPregnancies =>
      '3. هل تم تشخيصك بمرض السكري الحملي خلال حالات الحمل السابقة؟';

  @override
  String get q4HypertensionPreviousPregnancies =>
      '4. هل تم تشخيصك بارتفاع ضغط الدم خلالي حالة الحمل السابقة؟';

  @override
  String get q5Baby4kgOrMore => '5. هل أنجبت طفلاً يزن 4 كجم أو أكثر؟';

  @override
  String get q6CaesareanSection => '6. هل خضعت لعملية قيصرية من قبل؟';

  @override
  String get pregnancyInfoSaved => 'تم حفظ معلومات الحمل بنجاح!';

  @override
  String get measurementUnitsQuestion => 'ما وحدات القياس التي تستخدمها؟';

  @override
  String get mgDlUnit => 'ملغ/ديسيلتر';

  @override
  String get mmolLUnit => 'ممول/لتر';

  @override
  String get pleaseSelectUnit => 'يرجى اختيار وحدة';

  @override
  String get logoutConfirmation => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get attempt => 'محاولة';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get home => 'الرئيسية';

  @override
  String get notification => 'إشعار';

  @override
  String get reminder => 'تذكير';

  @override
  String get meals => 'الوجبات';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get doctorCheckUp => 'فحص الطبيب';

  @override
  String get lastVisit => 'آخر زيارة';

  @override
  String get notAvailable => 'غير متوفر';

  @override
  String get nextVisit => 'الزيارة القادمة';

  @override
  String get notScheduled => 'غير مجدول';

  @override
  String get nextVisitUpdated => 'تم تحديث الزيارة القادمة بنجاح!';

  @override
  String get failedToUpdateNextVisit => 'فشل في تحديث الزيارة القادمة';

  @override
  String get sunday => 'الأحد';

  @override
  String get monday => 'الإثنين';

  @override
  String get tuesday => 'الثلاثاء';

  @override
  String get wednesday => 'الأربعاء';

  @override
  String get thursday => 'الخميس';

  @override
  String get friday => 'الجمعة';

  @override
  String get saturday => 'السبت';

  @override
  String get hiLoading => 'مرحبًا، جارٍ التحميل...';

  @override
  String get glucose => 'الجلوكوز';

  @override
  String get glucoseWeeklyAvg => 'الجلوكوز، المتوسط الأسبوعي';

  @override
  String get gdm => 'سكري الحمل (GDM)';

  @override
  String get whatYouNeedToKnow => 'ما تحتاج إلى معرفته';

  @override
  String get dueDateUpdated => 'تم تحديث تاريخ الولادة بنجاح!';

  @override
  String get failedToUpdateDueDate => 'فشل في تحديث تاريخ الولادة';

  @override
  String get setDueDate => 'تحديد تاريخ الولادة';

  @override
  String get noDueDateSet => 'لم يتم تحديد تاريخ الولادة';

  @override
  String get dueDatePassed => 'تجاوز تاريخ الولادة';

  @override
  String get gdmTestDone => 'تم تسجيل اختبار السكري الحملي كمنتهي!';

  @override
  String get failedToMarkGdmTest => 'فشل في تسجيل اختبار السكري الحملي كمنتهي';

  @override
  String get markGdmTestDone => 'تسجيل اختبار السكري الحملي كمنتهي';

  @override
  String get errorLoadingNotifications => 'خطأ في تحميل الإشعارات:';

  @override
  String get noNotificationsAvailable => 'لا توجد إشعارات متوفرة';

  @override
  String get deleteAll => 'حذف الكل';

  @override
  String get allNotificationsDeleted => 'تم حذف جميع الإشعارات';

  @override
  String get errorDeletingNotifications => 'خطأ في حذف الإشعارات:';

  @override
  String get newNotification => 'جديد';

  @override
  String get steps => 'خطوات';

  @override
  String get to => 'إلى';

  @override
  String get notWalking => 'لا يمشي. التباين:';

  @override
  String get stepDetected => 'تم اكتشاف خطوة! التباين:';

  @override
  String get initializing => 'جارٍ التهيئة...';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get confirmNewPassword => 'تأكيد كلمة المرور الجديدة';

  @override
  String get passwordMinLength => 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';

  @override
  String get pleaseConfirmPassword => 'يرجى تأكيد كلمة المرور';

  @override
  String get passwordUpdated => 'تم تحديث كلمة المرور بنجاح';

  @override
  String get failedToUpdatePassword => 'فشل في تحديث كلمة المرور:';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get updateProfile => 'تحديث الملف الشخصي';

  @override
  String get profileUpdated => 'تم تحديث الملف الشخصي بنجاح';

  @override
  String get failedToUpdateProfile => 'فشل في تحديث الملف الشخصي:';

  @override
  String get feedbackSurvey => 'استبيان التغذية الراجعة';

  @override
  String get impact => 'التأثير';

  @override
  String get feedback => 'تعليقات';

  @override
  String get invalidDate => 'تاريخ غير صالح';

  @override
  String get left => 'بقي';

  @override
  String get dueThisWeek => 'مستحق هذا الأسبوع';

  @override
  String get expectedDueDate => 'تاريخ الاستحقاق المتوقع';

  @override
  String get perceivedUsefulness => 'الفائدة المدركة';

  @override
  String get perceivedEaseOfUse => 'سهولة الاستخدام المدركة';

  @override
  String get userControl => 'التحكم بالمستخدم';

  @override
  String get feedbackQ1 =>
      'أعتقد أن التطبيق سيكون إضافة إيجابية لسكان الإمارات/ النساء الحوامل/ الأطباء.';

  @override
  String get feedbackQ2 =>
      'أعتقد أن هذا التطبيق سيحسن جودة حياة مرضى السكري الحملي.';

  @override
  String get feedbackQ3 =>
      'هذا التطبيق جزء مهم في تلبية احتياجاتي المعلوماتية المتعلقة بالسكري الحملي.';

  @override
  String get feedbackQ4 =>
      'استخدام هذا التطبيق يجعل الحصول على معلومات حول السكري الحملي أسهل.';

  @override
  String get feedbackQ5 =>
      'استخدام هذا التطبيق يمكنني من تقييم مخاطر السكري الحملي بنفسي.';

  @override
  String get feedbackQ6 =>
      'استخدام هذا التطبيق يزيد من احتمالية فحص السكري الحملي في الوقت المناسب.';

  @override
  String get feedbackQ7 =>
      'أنا راضٍ عن هذا التطبيق لاكتساب معرفة حول السكري الحملي.';

  @override
  String get feedbackQ8 =>
      'أنا راضٍ عن هذا التطبيق للإدارة الذاتية للسكري الحملي أو عوامل المخاطر.';

  @override
  String get feedbackQ9 =>
      'استخدام هذا التطبيق يزيد من قدرتي على مراقبة تناولي الغذائي.';

  @override
  String get feedbackQ10 =>
      'استخدام هذا التطبيق يزيد من قدرتي على الحفاظ على النشاط البدني.';

  @override
  String get feedbackQ11 =>
      'أستطيع مراقبة سكر الدم ذاتيًا باستخدام هذا التطبيق.';

  @override
  String get feedbackQ12 =>
      'كطبيب، أجد معلومات التطبيق حول فحص وتشخيص السكري الحملي مفيدة.';

  @override
  String get feedbackQ13 => 'أنا مرتاح لقدرتي على استخدام هذا التطبيق.';

  @override
  String get feedbackQ14 => 'تعلم تشغيل هذا التطبيق سهل بالنسبة لي.';

  @override
  String get feedbackQ15 =>
      'من السهل بالنسبة لي أن أصبح ماهرًا في استخدام هذا التطبيق.';

  @override
  String get feedbackQ16 => 'أجد هذا التطبيق سهل الاستخدام.';

  @override
  String get feedbackQ17 =>
      'أستطيع دائمًا تذكر كيفية تسجيل الدخول واستخدام هذا التطبيق.';

  @override
  String get feedbackQ18 => 'التطبيق نادرًا ما يتعطل أو يسبب مشاكل على هاتفي.';

  @override
  String get feedbackQ19 =>
      'عندما أرتكب خطأ أثناء استخدام التطبيق، أستعيد بسهولة وسرعة.';

  @override
  String get feedbackQ20 =>
      'المعلومات (مثل المساعدة عبر الإنترنت، الرسائل على الشاشة، والوثائق الأخرى) المقدمة مع التطبيق واضحة.';

  @override
  String get submitFeedback => 'إرسال التغذية الراجعة';

  @override
  String get logoutSuccess => 'تم تسجيل خروج المستخدم بنجاح!';

  @override
  String get failedToLogout => 'فشل في تسجيل الخروج:';

  @override
  String get reminders => 'التذكيرات';

  @override
  String get weightManagement => 'إدارة الوزن';

  @override
  String get mealPlan => 'خطة الوجبات';

  @override
  String get myMeals => 'وجباتي';

  @override
  String get loading => 'جارٍ التحميل';

  @override
  String get gdmAssistantChat => 'دردشة مساعد السكري الحملي';

  @override
  String get you => 'أنت';

  @override
  String get pregnancies => 'الحمل';

  @override
  String get previousDeliveries => 'الولادات السابقة';

  @override
  String get familyHistory => 'التاريخ العائلي';

  @override
  String get miscarriages => 'الإجهاض';

  @override
  String get stillBirths => 'الولادات الميتة';

  @override
  String get childrenAlive => 'الأطفال الأحياء';

  @override
  String get gdmAI => 'ذكاء السكري الحملي';

  @override
  String get typing => 'يكتب...';

  @override
  String get typeMessage => 'اكتب رسالة...';

  @override
  String get pleaseEnterQuestion => 'أدخل سؤالاً';

  @override
  String get failedToGetResponse => 'فشل في الحصول على رد:';

  @override
  String get updateDoctorVisits => 'تحديث زيارات الطبيب';

  @override
  String get nextVisitDate => 'تاريخ الزيارة القادمة';

  @override
  String get pleaseEnterDate => 'أدخل التاريخ';

  @override
  String get update => 'تحديث';

  @override
  String get giveFeedback => 'قدم تغذيتك الراجعة';

  @override
  String get question => 'سؤال';

  @override
  String get agree => 'موافق';

  @override
  String get disagree => 'غير موافق';

  @override
  String get success => 'نجاح!!';

  @override
  String get feedbackAdded => 'تم إضافة تغذيتك الراجعة بنجاح!';

  @override
  String get continueButton => 'متابعة';

  @override
  String get weightHistory => 'سجل الوزن';

  @override
  String get score => 'النتيجة';

  @override
  String get questionAboutGDM => 'سؤال حول السكري الحملي';

  @override
  String get glucoseTitle => 'الجلوكوز';

  @override
  String get selectTimeHint => 'اختر الوقت (ساعة:دقيقة)';

  @override
  String get selectDateHint => 'اختر التاريخ (سنة-شهر-يوم)';

  @override
  String get valueHint => 'القيمة';

  @override
  String get pleaseSelectTime => 'يرجى اختيار الوقت';

  @override
  String get pleaseSelectDate => 'يرجى اختيار التاريخ';

  @override
  String get glucoseLevel => 'مستوى الجلوكوز';

  @override
  String get beforeBreakfast => 'قبل الإفطار';

  @override
  String get afterBreakfast => 'بعد الإفطار';

  @override
  String get beforeLunch => 'قبل الغداء';

  @override
  String get afterLunch => 'بعد الغداء';

  @override
  String get beforeDinner => 'قبل العشاء';

  @override
  String get afterDinner => 'بعد العشاء';

  @override
  String get before => 'قبل';

  @override
  String get after => 'بعد';

  @override
  String get breakfast => 'الإفطار';

  @override
  String get lunch => 'الغداء';

  @override
  String get dinner => 'العشاء';

  @override
  String get save => 'حفظ';

  @override
  String get invalidGlucoseValue => 'أدخل قيمة جلوكوز صالحة!';

  @override
  String get glucoseDataAdded => 'تم إضافة بيانات الجلوكوز';

  @override
  String get glucoseSummaryReport => 'تقرير ملخص الجلوكوز';

  @override
  String get generatedOn => 'تم إنشاؤه في:';

  @override
  String get date => 'التاريخ';

  @override
  String get time => 'الوقت';

  @override
  String get reading => 'القراءة';

  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get skip => 'تخطي';

  @override
  String get mealContext => 'سياق الوجبة';

  @override
  String get pdfGenerated => 'تم إنشاء ومشاركة ملف PDF بنجاح!';

  @override
  String get errorGeneratingPdf => 'خطأ في إنشاء ملف PDF:';

  @override
  String get glucoseSummary => 'ملخص الجلوكوز';

  @override
  String get errorFetchingGlucose => 'خطأ في جلب بيانات الجلوكوز:';

  @override
  String get downloadPdf => 'تحميل ملف PDF';

  @override
  String get daily => 'يومي';

  @override
  String get weekly => 'أسبوعي';

  @override
  String get monthly => 'شهري';

  @override
  String get monthlyAvgBloodGlucose => 'متوسط الجلوكوز في الدم الشهري';

  @override
  String get monthGlucoseLevels => 'مستويات الجلوكوز الشهرية';

  @override
  String get yourGlucose => 'جلوكوزك';

  @override
  String get retrying => 'جارٍ إعادة المحاولة...';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get todayAvgBloodGlucose => 'متوسط جلوكوز الدم اليوم';

  @override
  String get todayGlucoseLevels => 'مستويات الجلوكوز اليوم';

  @override
  String get glucoseButton => 'الجلوكوز';

  @override
  String get summaryButton => 'الملخص';

  @override
  String get addGlucoseTooltip => 'إضافة جلوكوز';

  @override
  String get noGlucoseData => 'لا توجد بيانات جلوكوز متاحة';

  @override
  String get viewGlucoseSummaryTooltip => 'عرض ملخص الجلوكوز';

  @override
  String get dataLoadedSuccess => 'تم تحميل البيانات بنجاح';

  @override
  String get failedToLoadData => 'فشل في تحميل البيانات بعد';

  @override
  String get weeklyAvgBloodGlucose => 'متوسط جلوكوز الدم الأسبوعي';

  @override
  String get glucoseWeekAvg => 'الجلوكوز، متوسط الأسبوع';

  @override
  String get helpCenter => 'مركز المساعدة';

  @override
  String get searchByTopics => 'ابحث حسب الموضوعات';

  @override
  String get gdmAssistanceHub => 'مساعدة السكري الحملي + المركز';

  @override
  String get whatIsGDM => 'ما هو السكري الحملي؟';

  @override
  String get whatIsGDMDescription =>
      'السكري الحملي (GDM) هو حالة تتطور فيها مستويات السكر في الدم لدى المرأة الحامل. يحدث عادة خلال الثلث الثاني أو الثالث من الحمل ويزول بعد الولادة. يتطلب مراقبة دقيقة لضمان صحة الأم والطفل.';

  @override
  String get whoIsAtRisk => 'من هم المعرضون للخطر؟';

  @override
  String get whoIsAtRiskDescription =>
      'أنتِ أكثر عرضة للخطر إذا:\n1. كان لديكِ تاريخ عائلي للسكري\n2. كنتِ تعانين من زيادة الوزن/السمنة أو أسلوب حياة خامل\n3. كنتِ أكبر من 35 عامًا\n4. كنتِ مصابة بالسكري الحملي في حمل سابق\n5. كنتِ تعانين من متلازمة تكيس المبايض (PCOS)\n6. تنتمين إلى مجموعة عرقية ذات مخاطر عالية للسكري (بما في ذلك السكان الشرق أوسطيين)';

  @override
  String get signsAndSymptoms => 'العلامات والأعراض';

  @override
  String get signsAndSymptomsDescription =>
      'لا تعاني معظم النساء من أعراض، لذا الفحص ضروري. قد تعاني بعضهن من:\n● زيادة العطش والتبول المتكرر\n● الإرهاق\n● ضبابية الرؤية';

  @override
  String get screeningAndDiagnosis => 'الفحص والتشخيص';

  @override
  String get screeningAndDiagnosisDescription =>
      'في الإمارات:\n1. يُوصى بفحص السكري الحملي بين 24-28 أسبوعًا من الحمل.\n2. يُستخدم اختبار تحمل الجلوكوز (OGTT) للتشخيص.';

  @override
  String get complicationsOfGDM => 'مضاعفات السكري الحملي';

  @override
  String get complicationsOfGDMDescription =>
      '⚠️ إذا لم يُتحكم به، يمكن أن يؤدي السكري الحملي إلى:\n1. زيادة وزن المواليد (التضخم)\n2. الولادة المبكرة أو الولادة القيصرية\n3. تسمم الحمل (ارتفاع ضغط الدم أثناء الحمل)\n4. زيادة مخاطر الإصابة بالسكري من النوع الثاني للأم والطفل لاحقًا';

  @override
  String get managingGDM => 'إدارة السكري الحملي';

  @override
  String get managingGDMDescription =>
      '1. الأكل الصحي\n. اتبعي خطة وجبات متوازنة تحتوي على الحبوب الكاملة، البروتين الخالي من الدهون، والألياف\n2. النشاط البدني المنتظم\n. اهدفي إلى 30 دقيقة من التمارين المعتدلة (مثل المشي)\n3. مراقبة سكر الدم\n. تحققي من مستويات الجلوكوز حسب نصيحة الطبيب\n4. الأدوية\n. إذا لزم الأمر، قد يُوصف الأنسولين أو علاجات أخرى';

  @override
  String get postpartumCare => 'رعاية ما بعد الولادة';

  @override
  String get postpartumCareDescription =>
      '1. عادةً ما يزول السكري الحملي بعد الولادة، لكن النساء المصابات به لديهن مخاطر بنسبة 50% للإصابة بالسكري من النوع الثاني في المستقبل\n2. الرضاعة الطبيعية تساعد في تنظيم سكر الدم وتقلل من مخاطر السكري المستقبلية\n3. يُوصى بإجراء اختبار السكري بعد 6-12 أسبوعًا من الولادة وكل 1-3 سنوات بعد ذلك';

  @override
  String get preventionOfGDM =>
      'الوقاية من السكري الحملي – نصائح خاصة بالإمارات';

  @override
  String get preventionOfGDMDescription =>
      '1. الأكل الصحي للوقاية من السكري الحملي\n● اختيار الأطعمة الغنية بالعناصر الغذائية المناسبة للإمارات\n. اختاري خبز الحبوب الكاملة العربي، الأرز البني، الكينوا، والشوفان بدلاً من الخبز الأبيض أو الحبوب المكررة\n. أدرجي الأسماك المشوية (مثل الهامور أو السلمون)، الدجاج، لحم الضأن الخالي من الدهون، والبروتينات النباتية مثل العدس، الحمص، والفول\n. استخدمي زيت الزيتون والمكسرات (اللوز، الجوز، الفستق) بدلاً من الزبدة أو السمن الزائد\n. استمتعي بالخيارات المحلية الغنية بالألياف مثل التمر (باعتدال)، الخيار، الطماطم، البامية، والكوسا\n. اختاري لبن قليل الدسم، زبادي يوناني، أو عيران بدلاً من الألبان كاملة الدسم\n● الأطعمة التي يجب الحد منها\n. قللي من الأطباق الإماراتية عالية الكربوهيدرات (مثل الأرز الأبيض الزائد في البرياني أو الهريس – اختاري النسخ الكاملة الحبوب)\n. تجنبي المشروبات السكرية (مثل شاي الكرك بالسكر، المشروبات الغازية، عصائر الفواكه – استبدليها بالشاي غير المحلى أو الماء المنكه)\n. قللي من الحلويات (مثل اللقيمات، البقلاوة – استمتعي بها باعتدال واختاري بدائل صحية مثل التمر مع المكسرات)\n2. البقاء نشطًا في مناخ الإمارات\n● نصائح للتمارين رغم الحرارة\n. امشي داخل المولات (مثل مول الإمارات، ياس مول) أو صالات الجيم الداخلية\n. جربي السباحة، خيار رائع منخفض التأثير للياقة المناسبة للحمل\n. قومي بالمشي في الهواء الطلق في المساء في حدائق مثل حديقة البرشاء، حديقة الصفا، أو الكورنيش عندما يكون الجو أبرد\n. انضمي إلى دروس يوغا أو بيلاتس للحوامل، التي تُقدم في العديد من الصالات الرياضية ومراكز الأمومة مع خيارات للنساء فقط\n3. إدارة العادات الغذائية الثقافية والاجتماعية\n● اختيارات ذكية في التجمعات\n. مارسي التحكم في الحصص: استمتعي بكميات صغيرة من الأرز والخبز، واملئي طبقك باللحوم المشوية والخضروات\n. قومي بتبديلات صحية: استبدلي السمبوسة المقلية بالمخبوزة أو اللحوم المشوية\n. اختاري وجبات إفطار متوازنة: تجنبي الحلويات الزائدة بعد الإفطار؛ اختاري الفواكه، اللبن، أو المكسرات بدلاً من ذلك\n. حافظي على الترطيب: اشربي الكثير من الماء بدلاً من العصائر المحلاة';

  @override
  String get understandingGDM => 'فهم السكري الحملي';

  @override
  String get understandingGDMDescription =>
      'نظرة شاملة على السكري الحملي، أسبابه، عوامل الخطر، وكيفية تأثيره على الحمل.';

  @override
  String get gdmAndPregnancy => 'السكري الحملي والحمل';

  @override
  String get gdmAndPregnancyDescription =>
      'حقائق رئيسية حول السكري الحملي، عمليات الفحص، والآثار الصحية طويلة الأمد.';

  @override
  String get addReminder => 'إضافة تذكير';

  @override
  String get selectLabel => 'اختر التسمية';

  @override
  String get selectReminderLabel => 'اختر تسمية التذكير';

  @override
  String get glucoseReading => 'قراءة الجلوكوز';

  @override
  String get logCalories => 'تسجيل السعرات';

  @override
  String get weightCheck => 'فحص الوزن';

  @override
  String get stepCount => 'عدد الخطوات';

  @override
  String get gdmFacts => 'حقائق السكري الحملي';

  @override
  String get pleaseFillAllFields => 'يرجى ملء جميع الحقول';

  @override
  String get ringOnce => 'رنة واحدة';

  @override
  String get customFrequency => 'مخصص';

  @override
  String get everyday => 'كل يوم';

  @override
  String get weekdays => 'أيام الأسبوع';

  @override
  String get monToFri => 'من الإثنين إلى الجمعة';

  @override
  String get repeat => 'تكرار';

  @override
  String get daySun => 'ح';

  @override
  String get dayMon => 'ن';

  @override
  String get dayTue => 'ث';

  @override
  String get dayWed => 'أ';

  @override
  String get dayThu => 'خ';

  @override
  String get dayFri => 'ج';

  @override
  String get daySat => 'س';

  @override
  String get repeatPrefix => 'التكرار:';

  @override
  String get reminderAddedSuccess => 'تم إضافة التذكير بنجاح!';

  @override
  String get failedToAddReminder => 'فشل في إضافة التذكير:';

  @override
  String get allReminders => 'جميع التذكيرات';

  @override
  String get noRemindersYet => 'لا توجد تذكيرات بعد';

  @override
  String get addReminderToStart => 'أضف تذكيرًا للبدء';

  @override
  String get reminderDeletedSuccess => 'تم حذف التذكير بنجاح';

  @override
  String get failedToDeleteReminder => 'فشل في حذف التذكير:';

  @override
  String get reminderActivated => 'تم تفعيل التذكير';

  @override
  String get reminderDeactivated => 'تم إلغاء تفعيل التذكير';

  @override
  String get failedToUpdateReminder => 'فشل في تحديث التذكير:';

  @override
  String get deleteReminder => 'حذف التذكير';

  @override
  String get confirmDeleteReminder => 'هل أنت متأكد من رغبتك في الحذف؟';

  @override
  String get delete => 'حذف';

  @override
  String get gdmTestReminder => 'تذكير اختبار السكري الحملي';

  @override
  String get gdmTestReminderMessage =>
      'تذكير بالذهاب لإجراء اختبار السكري في المستشفى (بين 24 إلى 28 أسبوعًا)؟';

  @override
  String get thanksForReminder => 'شكرًا على التذكير';

  @override
  String get iHaveDoneIt => 'لقد أكملته';

  @override
  String get snoozeReminder => 'تأجيل التذكير';

  @override
  String get snoozeFor3Days => 'تأجيل لمدة 3 أيام';

  @override
  String get snoozeFor1Week => 'تأجيل لمدة أسبوع';

  @override
  String get addWeight => 'إضافة الوزن';

  @override
  String get pickDate => 'اختر التاريخ';

  @override
  String get pleaseEnterDateAndWeight => 'يرجى إدخال التاريخ والوزن';

  @override
  String get weightDataAddedSuccess => 'تم إضافة بيانات الوزن بنجاح!';

  @override
  String get weightDataUpdatedSuccess => 'تم تحديث بيانات الوزن بنجاح!';

  @override
  String get errorAddingWeight => 'خطأ في إضافة الوزن:';

  @override
  String get pdfButton => 'ملف PDF';

  @override
  String get weightButton => 'الوزن';

  @override
  String get downloadPdfTooltip => 'تنزيل ملف PDF';

  @override
  String get errorFetchingWeightData => 'خطأ في جلب بيانات الوزن:';

  @override
  String get weightTrackingReport => 'تقرير تتبع الوزن';

  @override
  String get dateHeader => 'التاريخ';

  @override
  String get weightHeader => 'الوزن';

  @override
  String get unitHeader => 'الوحدة';

  @override
  String get pdfGeneratedSuccess => 'تم إنشاء ومشاركة ملف PDF بنجاح!';

  @override
  String get noWeightData => 'لا توجد بيانات وزن متوفرة';

  @override
  String get currentWeight => 'الوزن الحالي:';

  @override
  String get noWeightDataPastWeek => 'لا توجد بيانات وزن متاحة للأسبوع الماضي';

  @override
  String get notApplicable => 'غير متاح';

  @override
  String get oldPassword => 'كلمة المرور القديمة';

  @override
  String get pleaseEnterOldPassword => 'يرجى إدخال كلمة المرور القديمة';

  @override
  String get pleaseEnterNewPassword => 'يرجى إدخال كلمة المرور الجديدة';

  @override
  String get pleaseConfirmNewPassword => 'يرجى تأكيد كلمة المرور الجديدة';

  @override
  String get newPasswordsDoNotMatch => 'كلمات المرور الجديدة غير متطابقة';

  @override
  String get updateFailed => 'فشل تحديث كلمة المرور';

  @override
  String get oldPasswordIncorrect => 'كلمة المرور القديمة غير صحيحة';

  @override
  String get loginRequired => 'يرجى تسجيل الدخول مرة أخرى لتحديث كلمة المرور';

  @override
  String get set_calories => 'ضبط السعرات الحرارية';

  @override
  String get set_daily_cal => 'ضبط السعرات اليومية';

  @override
  String get add_cal => 'إضافة السعرات';

  @override
  String get user_not_logged_in => 'المستخدم غير مسجل الدخول!';

  @override
  String get please_enter_valid_calorie_value =>
      'الرجاء إدخال قيمة سعرات حرارية صحيحة!';

  @override
  String get successfully_added_daily_calories =>
      'تمت إضافة بيانات السعرات اليومية بنجاح!';

  @override
  String get user_not_found_in_collection => 'المستخدم غير موجود في أي مجموعة!';

  @override
  String get error_adding_calories => 'خطأ في إضافة السعرات:';

  @override
  String get create_food => 'إنشاء طعام';

  @override
  String get enter_food_name => 'أدخل اسم الطعام';

  @override
  String get food_name_label => 'اسم الطعام';

  @override
  String get enter_calories => 'أدخل السعرات الحرارية';

  @override
  String get calories_label => 'السعرات الحرارية';

  @override
  String get enter_quantity => 'أدخل الكمية';

  @override
  String get quantity_label => 'الكمية';

  @override
  String get save_food => 'حفظ الطعام';

  @override
  String get please_enter_food_name => 'الرجاء إدخال اسم الطعام';

  @override
  String get please_enter_calories => 'الرجاء إدخال السعرات الحرارية';

  @override
  String get please_enter_quantity => 'الرجاء إدخال الكمية';

  @override
  String get successfully_added_food => 'تمت إضافة الطعام بنجاح!';

  @override
  String get error_adding_food => 'خطأ في إضافة الطعام:';

  @override
  String get eaten => 'تم تناوله';

  @override
  String get error_deleting_food => 'خطأ في حذف الطعام:';

  @override
  String get meals_plan => 'خطة الوجبات';

  @override
  String get snacks => 'الوجبات الخفيفة';

  @override
  String get eaten_label => 'تم تناوله';

  @override
  String get remaining => 'المتبقي';

  @override
  String get total_cal => 'إجمالي السعرات';

  @override
  String get food => 'طعام';

  @override
  String get no_foods_available => 'لا توجد أطعمة متاحة';

  @override
  String get added_to => 'تمت الإضافة إلى';

  @override
  String get no_recent_items => 'لا توجد عناصر حديثة';

  @override
  String get no_user_logged_in_error => 'لا يوجد مستخدم مسجل الدخول';

  @override
  String get user_not_found_in_users_collection =>
      'المستخدم غير موجود في مجموعة المستخدمين';

  @override
  String get error_fetching_meals_data => 'خطأ في جلب بيانات الوجبات:';

  @override
  String get error_adding_meal_item => 'خطأ في إضافة عنصر الوجبة:';

  @override
  String get error_removing_meal_item => 'خطأ في إزالة عنصر الوجبة:';

  @override
  String get item_not_found_in_firestore => 'العنصر غير موجود في Firestore';

  @override
  String get food_added_successfully => 'تمت إضافة الطعام بنجاح';

  @override
  String get food_deleted_successfully => 'تم حذف الطعام بنجاح';

  @override
  String get item_not_found => 'العنصر غير موجود';

  @override
  String get search_for_a_food => 'ابحث عن طعام';

  @override
  String get recent => 'حديث';

  @override
  String get my_food => 'طعامي';

  @override
  String get deleteAccount => 'حذف حسابي';

  @override
  String get deleteAccountConfirmation =>
      'هل أنت متأكد أنك تريد حذف حسابك؟ هذا الإجراء لا يمكن التراجع عنه.';

  @override
  String get deleteAccountSuccess => 'تم حذف الحساب بنجاح.';

  @override
  String get noUserSignedIn => 'لا يوجد مستخدم مسجل الدخول حاليًا.';

  @override
  String get reauthenticate => 'إعادة التوثيق';

  @override
  String get reauthenticatePrompt =>
      'يرجى إدخال كلمة المرور الخاصة بك لتأكيد حذف الحساب.';

  @override
  String get reauthenticationFailed => 'فشل إعادة التوثيق';

  @override
  String get invalidCredentials => 'يرجى إدخال بيانات اعتماد صالحة.';

  @override
  String get failedToDeleteAccount => 'فشل في حذف الحساب';

  @override
  String get dailyCalories => 'السعرات الحرارية اليومية';

  @override
  String get calories => 'سعرات حرارية';

  @override
  String get outsidePregnancyDiagnosis => 'خارج الحمل، تم تشخيصي بـ';

  @override
  String get diagnosisType2Diabetes => 'السكري (النوع الثاني)';

  @override
  String get diagnosisType1Diabetes => 'السكري (النوع الأول)';

  @override
  String get diagnosisPrediabetes => 'ما قبل السكري';

  @override
  String get diagnosisHypertension => 'ارتفاع ضغط الدم';

  @override
  String get diagnosisHeartDisease => 'أمراض القلب';

  @override
  String get diagnosisObesity => 'السمنة';

  @override
  String get diagnosisLipidDisorders => 'اضطرابات الدهون/الكوليسترول';

  @override
  String get diagnosisOther => 'أخرى';

  @override
  String get pleaseSpecify => 'يرجى التوضيح';

  @override
  String get pleaseEnterDiagnosis => 'يرجى إدخال التشخيص';

  @override
  String get pleaseSelectAtLeastOneOption => 'يرجى تحديد خيار واحد على الأقل';

  @override
  String get pleaseSpecifyOtherDiagnosis => 'يرجى توضيح التشخيص \'أخرى\'';
}
