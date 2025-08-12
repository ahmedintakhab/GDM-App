import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'GDM Firebase'**
  String get appTitle;

  /// Text for login title and button
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Label for email input field
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// Label for password and confirm password input fields
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// Validation message for empty email field
  ///
  /// In en, this message translates to:
  /// **'Enter the email'**
  String get pleaseEnterEmail;

  /// Validation message for empty password field
  ///
  /// In en, this message translates to:
  /// **'Please enter a password'**
  String get pleaseEnterPassword;

  /// Toast message for successful login
  ///
  /// In en, this message translates to:
  /// **'User Login Successfully!'**
  String get loginSuccess;

  /// No description provided for @loginfailedTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please try again.'**
  String get loginfailedTryAgain;

  /// Toast message for user not found
  ///
  /// In en, this message translates to:
  /// **'User not found in any collection!'**
  String get userNotFound;

  /// Error message for incorrect password
  ///
  /// In en, this message translates to:
  /// **'Incorrect password. Please try again.'**
  String get wrongPassword;

  /// Error message for invalid email format
  ///
  /// In en, this message translates to:
  /// **'Invalid email format. Please enter a valid email.'**
  String get invalidEmail;

  /// Error message for disabled account
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled.'**
  String get userDisabled;

  /// Error message for too many login attempts
  ///
  /// In en, this message translates to:
  /// **'Too many login attempts. Please try again later.'**
  String get tooManyRequests;

  /// Error message for invalid credentials
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials. Please check your email and password.'**
  String get invalidCredential;

  /// Error message for disabled email/password login
  ///
  /// In en, this message translates to:
  /// **'Email/password login is not enabled.'**
  String get operationNotAllowed;

  /// Generic error message for unexpected errors
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get genericError;

  /// Prompt to navigate to sign-up screen
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get signUpPrompt;

  /// Text for forgot password link
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// Text for sign-up title, button, and link
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Text encouraging account creation
  ///
  /// In en, this message translates to:
  /// **'Create an Account!'**
  String get createAccount;

  /// Label for name input field
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// Validation message for empty name field
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterName;

  /// Validation message for empty confirm password field
  ///
  /// In en, this message translates to:
  /// **'Enter the confirm password'**
  String get pleaseEnterConfirmPassword;

  /// Validation message for mismatched passwords
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match!'**
  String get passwordsDoNotMatch;

  /// Error message for email already in use
  ///
  /// In en, this message translates to:
  /// **'Email already exists! Please try another email.'**
  String get emailAlreadyInUse;

  /// Error message for weak password
  ///
  /// In en, this message translates to:
  /// **'New password is too weak'**
  String get weakPassword;

  /// Toast message for successful sign-up
  ///
  /// In en, this message translates to:
  /// **'User successfully registered!'**
  String get signUpSuccess;

  /// Error message for Firestore permission denied
  ///
  /// In en, this message translates to:
  /// **'Permission denied. Please check your access rights.'**
  String get permissionDenied;

  /// Error message for Firestore unavailable
  ///
  /// In en, this message translates to:
  /// **'Firestore service is unavailable. Please try again later.'**
  String get firestoreUnavailable;

  /// Error message for Firestore document not found
  ///
  /// In en, this message translates to:
  /// **'Requested document or collection not found.'**
  String get notFound;

  /// Error message for cancelled Firestore operation
  ///
  /// In en, this message translates to:
  /// **'Operation was cancelled. Please try again.'**
  String get operationCancelled;

  /// Error message for Firestore operation timeout
  ///
  /// In en, this message translates to:
  /// **'Operation timed out. Please try again.'**
  String get deadlineExceeded;

  /// Generic error message for Firestore errors
  ///
  /// In en, this message translates to:
  /// **'Failed to save data. Please try again.'**
  String get firestoreGenericError;

  /// Error message for no logged-in user
  ///
  /// In en, this message translates to:
  /// **'No user is currently logged in'**
  String get noUserLoggedIn;

  /// Title for personal information input screen
  ///
  /// In en, this message translates to:
  /// **'Tell us about yourself'**
  String get tellUsAboutYourself;

  /// Description for importance of personal information
  ///
  /// In en, this message translates to:
  /// **'Your individual parameters are important for\nthe in-depth personalization.'**
  String get personalizationMessage;

  /// Label for gender selection field
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get genderLabel;

  /// Option for male gender
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get maleOption;

  /// Option for female gender
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get femaleOption;

  /// No description provided for @maleOrFemale.
  ///
  /// In en, this message translates to:
  /// **'Male or Female'**
  String get maleOrFemale;

  /// Label for weight input field
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weightLabel;

  /// Validation message for empty weight field
  ///
  /// In en, this message translates to:
  /// **'Please enter your weight'**
  String get pleaseEnterWeight;

  /// Hint text for weight in kilograms
  ///
  /// In en, this message translates to:
  /// **'Enter your weight in kg'**
  String get weightInKg;

  /// Hint text for weight in pounds
  ///
  /// In en, this message translates to:
  /// **'Enter your weight in lbs'**
  String get weightInLbs;

  /// Unit label for kilograms
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get kgUnit;

  /// Unit label for pounds
  ///
  /// In en, this message translates to:
  /// **'lbs'**
  String get lbsUnit;

  /// Label and validation message for age input field
  ///
  /// In en, this message translates to:
  /// **'Enter your age'**
  String get ageLabel;

  /// Label and validation message for height input field
  ///
  /// In en, this message translates to:
  /// **'Enter your height'**
  String get heightLabel;

  /// Label and validation message for ethnicity input field
  ///
  /// In en, this message translates to:
  /// **'Enter your Ethnicity'**
  String get ethnicityLabel;

  /// Label and validation message for diabetes input field
  ///
  /// In en, this message translates to:
  /// **'Enter your Diabetes'**
  String get diabetesLabel;

  /// Label and validation message for waist measurement input field
  ///
  /// In en, this message translates to:
  /// **'Enter your waist'**
  String get waistLabel;

  /// Label and validation message for hypertension history input field
  ///
  /// In en, this message translates to:
  /// **'History of hypertension'**
  String get hypertensionLabel;

  /// Label for submit button
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// Toast message for successful personal information save
  ///
  /// In en, this message translates to:
  /// **'Personal information saved successfully!'**
  String get personalInfoSaved;

  /// Title for onboarding welcome slide
  ///
  /// In en, this message translates to:
  /// **'Welcome to GDMCare+ Hub'**
  String get welcomeToGDMCareHub;

  /// Description for onboarding welcome slide
  ///
  /// In en, this message translates to:
  /// **'Welcome to GDMCare+ Hub – your go-to platform for managing diabetes in pregnancy and empowering everyone with diabetes awareness!'**
  String get welcomeToGDMCareHubDescription;

  /// Title for onboarding diabetes explanation slide
  ///
  /// In en, this message translates to:
  /// **'Understanding Diabetes'**
  String get understandingDiabetes;

  /// Description for onboarding diabetes explanation slide
  ///
  /// In en, this message translates to:
  /// **'Diabetes is a chronic condition where the body struggles to control blood sugar levels.'**
  String get understandingDiabetesDescription;

  /// Title for onboarding Type 2 diabetes slide
  ///
  /// In en, this message translates to:
  /// **'Type 2 Diabetes'**
  String get type2Diabetes;

  /// Description for onboarding Type 2 diabetes slide
  ///
  /// In en, this message translates to:
  /// **'Type 2 diabetes is the most common form, often linked to poor diet and lack of exercise.'**
  String get type2DiabetesDescription;

  /// Title for onboarding gestational diabetes risks slide
  ///
  /// In en, this message translates to:
  /// **'Risks of Gestational Diabetes'**
  String get risksOfGestationalDiabetes;

  /// Description for onboarding gestational diabetes risks slide
  ///
  /// In en, this message translates to:
  /// **'It increases the risk of complications for both mother and baby, and future Type 2 diabetes.'**
  String get risksOfGestationalDiabetesDescription;

  /// Hint text for dropdown or selection field
  ///
  /// In en, this message translates to:
  /// **'Select Option'**
  String get selectOption;

  /// Label for diabetes test date input
  ///
  /// In en, this message translates to:
  /// **'When was the diabetes test done?'**
  String get diabetesTestDate;

  /// Label for phone number input field
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneLabel;

  /// Label for time input field
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeLabel;

  /// Label for AM time period
  ///
  /// In en, this message translates to:
  /// **'am'**
  String get amLabel;

  /// Label for PM time period
  ///
  /// In en, this message translates to:
  /// **'pm'**
  String get pmLabel;

  /// Label for confirm button
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Title for user selection screen
  ///
  /// In en, this message translates to:
  /// **'User Selection'**
  String get userSelection;

  /// Instruction to choose an option
  ///
  /// In en, this message translates to:
  /// **'Choose an option to navigate smoothly!'**
  String get chooseOption;

  /// Label for user type selection
  ///
  /// In en, this message translates to:
  /// **'I am'**
  String get iAm;

  /// Option for pregnant user
  ///
  /// In en, this message translates to:
  /// **'Pregnant'**
  String get pregnant;

  /// Option for not pregnant user
  ///
  /// In en, this message translates to:
  /// **'Not Pregnant'**
  String get notPregnant;

  /// Option for doctor user
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get doctor;

  /// Validation message for no option selected
  ///
  /// In en, this message translates to:
  /// **'Please select an option'**
  String get pleaseSelectOption;

  /// Label for next button
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Title for pregnancy registration screen
  ///
  /// In en, this message translates to:
  /// **'Pregnancy Registration'**
  String get pregnancyRegistration;

  /// Label for last menstrual period input
  ///
  /// In en, this message translates to:
  /// **'Last Menstrual Period (LMP)'**
  String get lmpLabel;

  /// Label for expected due date input
  ///
  /// In en, this message translates to:
  /// **'Expected Due Date (Read only)'**
  String get dueDateLabel;

  /// Validation message for empty LMP field
  ///
  /// In en, this message translates to:
  /// **'Please enter LMP'**
  String get pleaseEnterLMP;

  /// Validation message for due date calculation
  ///
  /// In en, this message translates to:
  /// **'Please enter LMP to calculate'**
  String get pleaseEnterLMPToCalculate;

  /// Label for diabetes test question
  ///
  /// In en, this message translates to:
  /// **'Did you have a test for diabetes during this pregnancy?'**
  String get diabetesTestLabel;

  /// Dropdown option for yes
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// Dropdown option for no
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Dropdown option for not sure
  ///
  /// In en, this message translates to:
  /// **'Not Sure'**
  String get notSure;

  /// Hint text for weight in kilograms (specific to pregnancy screen)
  ///
  /// In en, this message translates to:
  /// **'Enter your weight (kg)'**
  String get weightInKgCm;

  /// Hint text for height in centimeters
  ///
  /// In en, this message translates to:
  /// **'Enter your height (cm)'**
  String get heightInCm;

  /// Label for family history of type 2 diabetes
  ///
  /// In en, this message translates to:
  /// **'Family History of Type 2 Diabetes'**
  String get familyHistoryDiabetes;

  /// Label for number of pregnancies
  ///
  /// In en, this message translates to:
  /// **'Number of Pregnancies'**
  String get numberOfPregnancies;

  /// Label for number of previous deliveries
  ///
  /// In en, this message translates to:
  /// **'Number of Previous Deliveries'**
  String get numberOfDeliveries;

  /// Label for number of miscarriages
  ///
  /// In en, this message translates to:
  /// **'Number of Miscarriages'**
  String get numberOfMiscarriages;

  /// Label for number of stillbirths
  ///
  /// In en, this message translates to:
  /// **'Number of Stillbirths'**
  String get numberOfStillbirths;

  /// Label for number of children alive
  ///
  /// In en, this message translates to:
  /// **'Number of Children Alive'**
  String get numberOfChildrenAlive;

  /// Label for back button
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Title for pregnancy diagnosis screen
  ///
  /// In en, this message translates to:
  /// **'Pregnancy Diagnosis'**
  String get pregnancyDiagnosis;

  /// Question about GDM diagnosis in current pregnancy
  ///
  /// In en, this message translates to:
  /// **'1. Have you been diagnosed with GDM during this pregnancy?'**
  String get q1GdmThisPregnancy;

  /// Question about hypertension diagnosis in current pregnancy
  ///
  /// In en, this message translates to:
  /// **'2. Have you been diagnosed with hypertension during this pregnancy?'**
  String get q2HypertensionThisPregnancy;

  /// Question about GDM diagnosis in previous pregnancies
  ///
  /// In en, this message translates to:
  /// **'3. Have you been diagnosed with GDM during previous pregnancies?'**
  String get q3GdmPreviousPregnancies;

  /// Question about hypertension diagnosis in previous pregnancies
  ///
  /// In en, this message translates to:
  /// **'4. Have you been diagnosed with hypertension during previous pregnancies?'**
  String get q4HypertensionPreviousPregnancies;

  /// Question about baby weighing 4kg or more
  ///
  /// In en, this message translates to:
  /// **'5. Have you had a baby that weighed 4kg or more?'**
  String get q5Baby4kgOrMore;

  /// Question about previous Caesarean section
  ///
  /// In en, this message translates to:
  /// **'6. Have you had Caesarean Section (CS) before?'**
  String get q6CaesareanSection;

  /// Toast message for successful pregnancy information save
  ///
  /// In en, this message translates to:
  /// **'Pregnancy information saved successfully!'**
  String get pregnancyInfoSaved;

  /// Question about preferred measurement units
  ///
  /// In en, this message translates to:
  /// **'What measurement units do you use?'**
  String get measurementUnitsQuestion;

  /// Unit option for mg/dl
  ///
  /// In en, this message translates to:
  /// **'mg/dl'**
  String get mgDlUnit;

  /// Unit option for mmol/L
  ///
  /// In en, this message translates to:
  /// **'mmol/L'**
  String get mmolLUnit;

  /// Validation message for no unit selected
  ///
  /// In en, this message translates to:
  /// **'Please select a unit'**
  String get pleaseSelectUnit;

  /// Confirmation message for logout
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmation;

  /// Label for cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @attempt.
  ///
  /// In en, this message translates to:
  /// **'Attempt'**
  String get attempt;

  /// Label for logout button
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Label for home navigation item
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Label for notification navigation item
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// Label for reminder navigation item
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get reminder;

  /// Label for meals navigation item
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get meals;

  /// Label for profile navigation item
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Title for doctor check-up section
  ///
  /// In en, this message translates to:
  /// **'Doctor Check up'**
  String get doctorCheckUp;

  /// Label for last doctor visit
  ///
  /// In en, this message translates to:
  /// **'Last Visit'**
  String get lastVisit;

  /// Message when last visit is not available
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get notAvailable;

  /// Label for next doctor visit
  ///
  /// In en, this message translates to:
  /// **'Next Visit'**
  String get nextVisit;

  /// Message when next visit is not scheduled
  ///
  /// In en, this message translates to:
  /// **'Not scheduled'**
  String get notScheduled;

  /// Toast message for successful next visit update
  ///
  /// In en, this message translates to:
  /// **'Next Visit updated successfully!'**
  String get nextVisitUpdated;

  /// Toast message for failed next visit update
  ///
  /// In en, this message translates to:
  /// **'Failed to update Next Visit'**
  String get failedToUpdateNextVisit;

  /// Abbreviation for Sunday
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sunday;

  /// Abbreviation for Monday
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get monday;

  /// Abbreviation for Tuesday
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tuesday;

  /// Abbreviation for Wednesday
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wednesday;

  /// Abbreviation for Thursday
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thursday;

  /// Abbreviation for Friday
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get friday;

  /// Abbreviation for Saturday
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get saturday;

  /// Greeting while user data is loading
  ///
  /// In en, this message translates to:
  /// **'Hi, Loading...'**
  String get hiLoading;

  /// Title for glucose data
  ///
  /// In en, this message translates to:
  /// **'Glucose'**
  String get glucose;

  /// Title for weekly average glucose data
  ///
  /// In en, this message translates to:
  /// **'Glucose, Weekly Avg'**
  String get glucoseWeeklyAvg;

  /// Title for Gestational Diabetes Mellitus
  ///
  /// In en, this message translates to:
  /// **'Gestational Diabetes Mellitus (GDM)'**
  String get gdm;

  /// Title for GDM information section
  ///
  /// In en, this message translates to:
  /// **'What You Need to Know'**
  String get whatYouNeedToKnow;

  /// Toast message for successful due date update
  ///
  /// In en, this message translates to:
  /// **'Due date updated successfully!'**
  String get dueDateUpdated;

  /// Toast message for failed due date update
  ///
  /// In en, this message translates to:
  /// **'Failed to update due date'**
  String get failedToUpdateDueDate;

  /// Title for setting due date
  ///
  /// In en, this message translates to:
  /// **'Set Due Date'**
  String get setDueDate;

  /// Message when no due date is set
  ///
  /// In en, this message translates to:
  /// **'No due date set'**
  String get noDueDateSet;

  /// Message when due date has passed
  ///
  /// In en, this message translates to:
  /// **'Due date passed'**
  String get dueDatePassed;

  /// Toast message for marking GDM test as done
  ///
  /// In en, this message translates to:
  /// **'GDM test marked as done!'**
  String get gdmTestDone;

  /// Toast message for failed GDM test marking
  ///
  /// In en, this message translates to:
  /// **'Failed to mark GDM test as done'**
  String get failedToMarkGdmTest;

  /// Label for marking GDM test as done
  ///
  /// In en, this message translates to:
  /// **'Mark GDM Test as Done'**
  String get markGdmTestDone;

  /// Error message prefix for loading notifications
  ///
  /// In en, this message translates to:
  /// **'Error loading notifications:'**
  String get errorLoadingNotifications;

  /// Message when no notifications are available
  ///
  /// In en, this message translates to:
  /// **'No notifications available'**
  String get noNotificationsAvailable;

  /// Label for deleting all notifications
  ///
  /// In en, this message translates to:
  /// **'Delete all'**
  String get deleteAll;

  /// SnackBar message for all notifications deleted
  ///
  /// In en, this message translates to:
  /// **'All notifications deleted'**
  String get allNotificationsDeleted;

  /// Error message prefix for deleting notifications
  ///
  /// In en, this message translates to:
  /// **'Error deleting notifications:'**
  String get errorDeletingNotifications;

  /// Label for new notification
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newNotification;

  /// Label for step count
  ///
  /// In en, this message translates to:
  /// **'steps'**
  String get steps;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get to;

  /// Debug message for no walking detected
  ///
  /// In en, this message translates to:
  /// **'Not walking. Variance:'**
  String get notWalking;

  /// Debug message for step detected
  ///
  /// In en, this message translates to:
  /// **'Step detected! Variance:'**
  String get stepDetected;

  /// Debug message for initialization
  ///
  /// In en, this message translates to:
  /// **'Initializing...'**
  String get initializing;

  /// Title for change password screen
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// Label for new password input
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// Label for confirm new password input
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// Validation message for password length
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// Validation message for empty confirm password field
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get pleaseConfirmPassword;

  /// SnackBar message for successful password update
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully'**
  String get passwordUpdated;

  /// SnackBar message prefix for failed password update
  ///
  /// In en, this message translates to:
  /// **'Failed to update password:'**
  String get failedToUpdatePassword;

  /// Title for edit profile screen
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// Button label for updating profile
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get updateProfile;

  /// SnackBar message for successful profile update
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdated;

  /// SnackBar message prefix for failed profile update
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile:'**
  String get failedToUpdateProfile;

  /// Title for feedback survey screen
  ///
  /// In en, this message translates to:
  /// **'Feedback Survey'**
  String get feedbackSurvey;

  /// Heading for impact section in feedback survey
  ///
  /// In en, this message translates to:
  /// **'Impact'**
  String get impact;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'FeedBack'**
  String get feedback;

  /// No description provided for @invalidDate.
  ///
  /// In en, this message translates to:
  /// **'Invalid Date'**
  String get invalidDate;

  /// No description provided for @left.
  ///
  /// In en, this message translates to:
  /// **'left'**
  String get left;

  /// No description provided for @dueThisWeek.
  ///
  /// In en, this message translates to:
  /// **'Due this week'**
  String get dueThisWeek;

  /// No description provided for @expectedDueDate.
  ///
  /// In en, this message translates to:
  /// **'Expected due date'**
  String get expectedDueDate;

  /// Heading for perceived usefulness section in feedback survey
  ///
  /// In en, this message translates to:
  /// **'Perceived Usefulness'**
  String get perceivedUsefulness;

  /// Heading for perceived ease of use section in feedback survey
  ///
  /// In en, this message translates to:
  /// **'Perceived Ease of Use'**
  String get perceivedEaseOfUse;

  /// Heading for user control section in feedback survey
  ///
  /// In en, this message translates to:
  /// **'User Control'**
  String get userControl;

  /// Feedback question about app's positive addition
  ///
  /// In en, this message translates to:
  /// **'I think the App would be a positive addition for UAE population/ pregnant women/ Physicians.'**
  String get feedbackQ1;

  /// Feedback question about improving quality of life
  ///
  /// In en, this message translates to:
  /// **'I think this App would improve the Quality of Life of GDM patients.'**
  String get feedbackQ2;

  /// Feedback question about meeting GDM information needs
  ///
  /// In en, this message translates to:
  /// **'This App is an important part of meeting my information needs related to GDM.'**
  String get feedbackQ3;

  /// Feedback question about ease of getting GDM info
  ///
  /// In en, this message translates to:
  /// **'Using this App makes it easier to get info on GDM.'**
  String get feedbackQ4;

  /// Feedback question about self-assessing GDM risk
  ///
  /// In en, this message translates to:
  /// **'Using this App enables me to self-assess my GDM risk.'**
  String get feedbackQ5;

  /// Feedback question about timely GDM screening
  ///
  /// In en, this message translates to:
  /// **'Using this App makes it more likely that I get screened for GDM on time.'**
  String get feedbackQ6;

  /// Feedback question about satisfaction with GDM knowledge
  ///
  /// In en, this message translates to:
  /// **'I am satisfied with this App for gaining GDM knowledge.'**
  String get feedbackQ7;

  /// Feedback question about satisfaction with GDM self-management
  ///
  /// In en, this message translates to:
  /// **'I am satisfied with this App for self-management of GDM or GDM risk factors.'**
  String get feedbackQ8;

  /// Feedback question about monitoring dietary intake
  ///
  /// In en, this message translates to:
  /// **'Using this App increases my ability to monitor my dietary intake.'**
  String get feedbackQ9;

  /// Feedback question about maintaining physical activity
  ///
  /// In en, this message translates to:
  /// **'Using this App increases my ability to maintain physical activity.'**
  String get feedbackQ10;

  /// Feedback question about self-monitoring blood sugar
  ///
  /// In en, this message translates to:
  /// **'I am able to do self-monitoring of blood sugar using this App.'**
  String get feedbackQ11;

  /// Feedback question about GDM screening info for physicians
  ///
  /// In en, this message translates to:
  /// **'As a physician I find the App’s info on GDM Screening and Diagnosis useful.'**
  String get feedbackQ12;

  /// Feedback question about comfort with app usage
  ///
  /// In en, this message translates to:
  /// **'I am comfortable with my ability to use this App.'**
  String get feedbackQ13;

  /// Feedback question about ease of learning app
  ///
  /// In en, this message translates to:
  /// **'Learning to operate this App is easy for me.'**
  String get feedbackQ14;

  /// Feedback question about becoming skillful with app
  ///
  /// In en, this message translates to:
  /// **'It is easy for me to become skillful at using this App.'**
  String get feedbackQ15;

  /// Feedback question about app ease of use
  ///
  /// In en, this message translates to:
  /// **'I find this App easy to use.'**
  String get feedbackQ16;

  /// Feedback question about remembering app usage
  ///
  /// In en, this message translates to:
  /// **'I can always remember how to log on to and use this App.'**
  String get feedbackQ17;

  /// Feedback question about app stability
  ///
  /// In en, this message translates to:
  /// **'The app rarely crashes or causes problems on my phone.'**
  String get feedbackQ18;

  /// Feedback question about error recovery
  ///
  /// In en, this message translates to:
  /// **'Whenever I make a mistake using this App, I recover easily and quickly.'**
  String get feedbackQ19;

  /// Feedback question about clarity of app information
  ///
  /// In en, this message translates to:
  /// **'The information (such as on-line help, on-screen messages and other documentation) provided with this App is clear.'**
  String get feedbackQ20;

  /// Button label for submitting feedback
  ///
  /// In en, this message translates to:
  /// **'Submit Feedback'**
  String get submitFeedback;

  /// Toast message for successful logout
  ///
  /// In en, this message translates to:
  /// **'User successfully Logout!'**
  String get logoutSuccess;

  /// Toast message prefix for failed logout
  ///
  /// In en, this message translates to:
  /// **'Failed to logout:'**
  String get failedToLogout;

  /// Label for reminders menu item
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get reminders;

  /// Title for weight management screen
  ///
  /// In en, this message translates to:
  /// **'Weight Management'**
  String get weightManagement;

  /// Label for meal plan sub-menu item
  ///
  /// In en, this message translates to:
  /// **'Meal plan'**
  String get mealPlan;

  /// Label for my meals sub-menu item
  ///
  /// In en, this message translates to:
  /// **'My meals'**
  String get myMeals;

  /// Message indicating loading state
  ///
  /// In en, this message translates to:
  /// **'loading'**
  String get loading;

  /// No description provided for @gdmAssistantChat.
  ///
  /// In en, this message translates to:
  /// **'GDM Assistant Chat'**
  String get gdmAssistantChat;

  /// Label for user in chat
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// No description provided for @pregnancies.
  ///
  /// In en, this message translates to:
  /// **'Pregnancies'**
  String get pregnancies;

  /// No description provided for @previousDeliveries.
  ///
  /// In en, this message translates to:
  /// **'Previous Deliveries'**
  String get previousDeliveries;

  /// No description provided for @familyHistory.
  ///
  /// In en, this message translates to:
  /// **'Family History'**
  String get familyHistory;

  /// No description provided for @miscarriages.
  ///
  /// In en, this message translates to:
  /// **'Miscarriages'**
  String get miscarriages;

  /// No description provided for @stillBirths.
  ///
  /// In en, this message translates to:
  /// **'Still Births'**
  String get stillBirths;

  /// No description provided for @childrenAlive.
  ///
  /// In en, this message translates to:
  /// **'Children Alive'**
  String get childrenAlive;

  /// Label for GDM AI in chat
  ///
  /// In en, this message translates to:
  /// **'GDM AI'**
  String get gdmAI;

  /// Message indicating typing state
  ///
  /// In en, this message translates to:
  /// **'Typing...'**
  String get typing;

  /// Hint text for chat input
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeMessage;

  /// Validation message for empty chat input
  ///
  /// In en, this message translates to:
  /// **'Please enter a question'**
  String get pleaseEnterQuestion;

  /// SnackBar message prefix for failed chat response
  ///
  /// In en, this message translates to:
  /// **'Failed to get response:'**
  String get failedToGetResponse;

  /// Title for updating doctor visits
  ///
  /// In en, this message translates to:
  /// **'Update Doctor Visits'**
  String get updateDoctorVisits;

  /// Hint text for next visit date input
  ///
  /// In en, this message translates to:
  /// **'Next Visit Date'**
  String get nextVisitDate;

  /// Validation message for empty date field
  ///
  /// In en, this message translates to:
  /// **'Please enter date'**
  String get pleaseEnterDate;

  /// Button label for update action
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// Prompt to give feedback
  ///
  /// In en, this message translates to:
  /// **'Give feedback'**
  String get giveFeedback;

  /// Prefix for feedback question number
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get question;

  /// Option for agreeing with feedback question
  ///
  /// In en, this message translates to:
  /// **'Agree'**
  String get agree;

  /// Option for disagreeing with feedback question
  ///
  /// In en, this message translates to:
  /// **'Disagree'**
  String get disagree;

  /// Title for success dialog
  ///
  /// In en, this message translates to:
  /// **'Success!!'**
  String get success;

  /// Message for successful feedback submission
  ///
  /// In en, this message translates to:
  /// **'Your feedback added Successfully!'**
  String get feedbackAdded;

  /// Button label for continue action
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// Label for Weight History menu item
  ///
  /// In en, this message translates to:
  /// **'Weight History'**
  String get weightHistory;

  /// Label for Score menu item
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// Label for Question about GDM
  ///
  /// In en, this message translates to:
  /// **'Question about GDM'**
  String get questionAboutGDM;

  /// Title for glucose input screen
  ///
  /// In en, this message translates to:
  /// **'GLUCOSE'**
  String get glucoseTitle;

  /// Hint text for time selection
  ///
  /// In en, this message translates to:
  /// **'Select time (HH:mm)'**
  String get selectTimeHint;

  /// Hint text for date selection
  ///
  /// In en, this message translates to:
  /// **'Select date (yyyy-MM-dd)'**
  String get selectDateHint;

  /// Hint text for glucose value input
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get valueHint;

  /// Validation message for empty time field
  ///
  /// In en, this message translates to:
  /// **'Please select time'**
  String get pleaseSelectTime;

  /// Validation message for empty date field
  ///
  /// In en, this message translates to:
  /// **'Please select date'**
  String get pleaseSelectDate;

  /// Label for glucose level input section
  ///
  /// In en, this message translates to:
  /// **'Glucose level'**
  String get glucoseLevel;

  /// Label for before breakfast meal option
  ///
  /// In en, this message translates to:
  /// **'Before Breakfast'**
  String get beforeBreakfast;

  /// Label for after breakfast meal option
  ///
  /// In en, this message translates to:
  /// **'After Breakfast'**
  String get afterBreakfast;

  /// Label for before lunch meal option
  ///
  /// In en, this message translates to:
  /// **'Before Lunch'**
  String get beforeLunch;

  /// Label for after lunch meal option
  ///
  /// In en, this message translates to:
  /// **'After Lunch'**
  String get afterLunch;

  /// Label for before dinner meal option
  ///
  /// In en, this message translates to:
  /// **'Before Dinner'**
  String get beforeDinner;

  /// Label for after dinner meal option
  ///
  /// In en, this message translates to:
  /// **'After Dinner'**
  String get afterDinner;

  /// No description provided for @before.
  ///
  /// In en, this message translates to:
  /// **'Before'**
  String get before;

  /// No description provided for @after.
  ///
  /// In en, this message translates to:
  /// **'After'**
  String get after;

  /// No description provided for @breakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get breakfast;

  /// No description provided for @lunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get lunch;

  /// No description provided for @dinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get dinner;

  /// Button label for saving glucose data
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Toast message for invalid glucose value
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid glucose value!'**
  String get invalidGlucoseValue;

  /// Toast message for successful glucose data addition
  ///
  /// In en, this message translates to:
  /// **'Glucose data added'**
  String get glucoseDataAdded;

  /// Title for glucose summary PDF report
  ///
  /// In en, this message translates to:
  /// **'Glucose Summary Report'**
  String get glucoseSummaryReport;

  /// Subtitle prefix for PDF generation date
  ///
  /// In en, this message translates to:
  /// **'Generated on:'**
  String get generatedOn;

  /// Table header for date in PDF and UI
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// Table header for time in PDF and UI
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// Table header for glucose reading in PDF and UI
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get reading;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Table header for meal context in PDF and UI
  ///
  /// In en, this message translates to:
  /// **'Meal Context'**
  String get mealContext;

  /// Toast message for successful PDF generation
  ///
  /// In en, this message translates to:
  /// **'PDF generated and shared successfully!'**
  String get pdfGenerated;

  /// Toast message prefix for failed PDF generation
  ///
  /// In en, this message translates to:
  /// **'Error generating PDF:'**
  String get errorGeneratingPdf;

  /// Title for glucose summary screen
  ///
  /// In en, this message translates to:
  /// **'Glucose Summary'**
  String get glucoseSummary;

  /// Toast message prefix for glucose data fetch error
  ///
  /// In en, this message translates to:
  /// **'Error fetching glucose data:'**
  String get errorFetchingGlucose;

  /// Button label for downloading PDF
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get downloadPdf;

  /// Tab label for daily glucose view
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// Tab label for weekly glucose view
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// Tab label for monthly glucose view
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// Title for monthly average blood glucose
  ///
  /// In en, this message translates to:
  /// **'Monthly Avg Blood Glucose'**
  String get monthlyAvgBloodGlucose;

  /// Title for month glucose levels
  ///
  /// In en, this message translates to:
  /// **'MONTH GLUCOSE LEVELS'**
  String get monthGlucoseLevels;

  /// Title for user’s glucose data
  ///
  /// In en, this message translates to:
  /// **'Your glucose'**
  String get yourGlucose;

  /// Message indicating retry attempt in progress
  ///
  /// In en, this message translates to:
  /// **'Retrying...'**
  String get retrying;

  /// Button label for retry action
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Title for today's average blood glucose card
  ///
  /// In en, this message translates to:
  /// **'Today\'s Avg Blood Glucose'**
  String get todayAvgBloodGlucose;

  /// Title for today's glucose levels chart
  ///
  /// In en, this message translates to:
  /// **'TODAY\'S GLUCOSE LEVELS'**
  String get todayGlucoseLevels;

  /// Label for glucose floating action button
  ///
  /// In en, this message translates to:
  /// **'Glucose'**
  String get glucoseButton;

  /// Label for summary floating action button
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summaryButton;

  /// Tooltip for add glucose button
  ///
  /// In en, this message translates to:
  /// **'Add Glucose'**
  String get addGlucoseTooltip;

  /// No description provided for @noGlucoseData.
  ///
  /// In en, this message translates to:
  /// **'No glucose data available'**
  String get noGlucoseData;

  /// Tooltip for view glucose summary button
  ///
  /// In en, this message translates to:
  /// **'View Glucose Summary'**
  String get viewGlucoseSummaryTooltip;

  /// Toast message for successful data loading
  ///
  /// In en, this message translates to:
  /// **'Data loaded successfully'**
  String get dataLoadedSuccess;

  /// Toast message prefix for failed data loading
  ///
  /// In en, this message translates to:
  /// **'Failed to load data after'**
  String get failedToLoadData;

  /// Title for weekly average blood glucose card
  ///
  /// In en, this message translates to:
  /// **'Weekly Avg Blood Glucose'**
  String get weeklyAvgBloodGlucose;

  /// Title for weekly glucose average chart
  ///
  /// In en, this message translates to:
  /// **'Glucose, week avg'**
  String get glucoseWeekAvg;

  /// Title for help center screen
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenter;

  /// Hint text for search field
  ///
  /// In en, this message translates to:
  /// **'Search by topics'**
  String get searchByTopics;

  /// Title for GDM assistance hub container
  ///
  /// In en, this message translates to:
  /// **'GDM Assistance + HUB'**
  String get gdmAssistanceHub;

  /// Title for GDM information card
  ///
  /// In en, this message translates to:
  /// **'What is GDM?'**
  String get whatIsGDM;

  /// Description for what is GDM card
  ///
  /// In en, this message translates to:
  /// **'Gestational Diabetes Mellitus (GDM) is a condition where a pregnant woman develops high blood sugar levels. It usually occurs during the second or third trimester and resolves after delivery. It requires careful monitoring to ensure the health of both mother and baby.'**
  String get whatIsGDMDescription;

  /// Title for who is at risk card
  ///
  /// In en, this message translates to:
  /// **'Who is at Risk?'**
  String get whoIsAtRisk;

  /// Description for who is at risk card
  ///
  /// In en, this message translates to:
  /// **'You are at higher risk if you:\n1. Have a family history of diabetes\n2. Are overweight/obese or have a sedentary lifestyle\n3. Are older than 35 years\n4. Have had GDM in a previous pregnancy\n5. Have polycystic ovary syndrome (PCOS)\n6. Belong to an ethnic group with a high diabetes risk (including Middle Eastern populations)'**
  String get whoIsAtRiskDescription;

  /// Title for signs and symptoms card
  ///
  /// In en, this message translates to:
  /// **'Signs & Symptoms'**
  String get signsAndSymptoms;

  /// Description for signs and symptoms card
  ///
  /// In en, this message translates to:
  /// **'Most women do not have symptoms, so screening is essential. Some may experience:\n● Increased thirst and frequent urination\n● Fatigue\n● Blurred vision'**
  String get signsAndSymptomsDescription;

  /// Title for screening and diagnosis card
  ///
  /// In en, this message translates to:
  /// **'Screening & Diagnosis'**
  String get screeningAndDiagnosis;

  /// Description for screening and diagnosis card
  ///
  /// In en, this message translates to:
  /// **'In the UAE:\n1. Screening for GDM is recommended between 24-28 weeks of pregnancy.\n2. A glucose tolerance test (OGTT) is used for diagnosis.'**
  String get screeningAndDiagnosisDescription;

  /// Title for complications of GDM card
  ///
  /// In en, this message translates to:
  /// **'Complications of GDM'**
  String get complicationsOfGDM;

  /// Description for complications of GDM card
  ///
  /// In en, this message translates to:
  /// **'⚠️ If left uncontrolled, GDM can lead to:\n1. High birth weight in babies (macrosomia)\n2. Preterm birth or C-section delivery\n3. Preeclampsia (high blood pressure during pregnancy)\n4. Increased risk of Type 2 Diabetes for both mother & child later in life'**
  String get complicationsOfGDMDescription;

  /// Title for managing GDM card
  ///
  /// In en, this message translates to:
  /// **'Managing GDM'**
  String get managingGDM;

  /// Description for managing GDM card
  ///
  /// In en, this message translates to:
  /// **'1 Healthy eating\n. Follow a balanced meal plan with whole grains, lean protein, and fiber\n2 Regular physical activity\n. Aim for 30 minutes of moderate exercise (e.g., walking)\n3 Blood sugar monitoring\n. Check your glucose levels as advised by your doctor\n4 Medications\n. If needed, insulin or other treatments may be prescribed'**
  String get managingGDMDescription;

  /// Title for postpartum care card
  ///
  /// In en, this message translates to:
  /// **'Postpartum Care'**
  String get postpartumCare;

  /// Description for postpartum care card
  ///
  /// In en, this message translates to:
  /// **'1. GDM usually resolves after birth, but women with GDM have a 50% risk of developing Type 2 Diabetes in the future\n2. Breastfeeding helps regulate blood sugar and lowers future diabetes risk\n3. A follow-up diabetes test is recommended 6-12 weeks postpartum and every 1-3 years thereafter'**
  String get postpartumCareDescription;

  /// Title for prevention of GDM card
  ///
  /// In en, this message translates to:
  /// **'Prevention of GDM – UAE-Specific Tips'**
  String get preventionOfGDM;

  /// Description for prevention of GDM card
  ///
  /// In en, this message translates to:
  /// **'1. Healthy Eating for GDM Prevention\n● Choose Nutrient-Rich UAE-Friendly Foods\n. Opt for whole-wheat Arabic bread, brown rice, quinoa, and oats instead of white bread or refined grains\n. Include grilled fish (like hammour or salmon), chicken, lean lamb, and plant-based proteins like lentils, chickpeas, and fava beans (foul)\n. Use olive oil and nuts (almonds, walnuts, pistachios) instead of excessive butter or ghee\n. Enjoy local fiber-rich options like dates (in moderation), cucumbers, tomatoes, okra, and zucchini\n. Choose low-fat Laban, Greek yogurt, or Ayran instead of full-fat dairy\n● Foods to Limit\n. Limit high-carb Emirati dishes (e.g., excess white rice in biryani or Harees – opt for whole-grain versions)\n. Avoid sugary beverages (e.g., Karak tea with sugar, soft drinks, fruit juices – replace with unsweetened tea or infused water)\n. Reduce desserts and sweets (e.g., Luqaimat, Baklava – enjoy in moderation and opt for healthier alternatives like dates with nuts)\n2. Staying Active in the UAE Climate\n● Exercise Tips Despite the Heat\n. Walk indoors in malls (e.g., Mall of the Emirates, Yas Mall) or indoor gyms\n. Try swimming, a great low-impact option for pregnancy-friendly fitness\n. Take evening outdoor walks at parks like Al Barsha Pond Park, Safa Park, or Corniche when it’s cooler\n. Join prenatal yoga or Pilates classes, offered at many gyms and maternity centers with women-only options\n3. Managing Cultural & Social Eating Habits\n● Smart Choices at Gatherings\n. Practice portion control: enjoy small portions of rice and bread, filling up on grilled meats and vegetables\n. Make healthy swaps: replace fried samosas with baked versions or grilled meats\n. Choose balanced Iftar meals: avoid excessive sweets after Iftar; opt for fruit, Laban, or nuts instead\n. Stay hydrated: drink plenty of water instead of sweetened juices'**
  String get preventionOfGDMDescription;

  /// Title for understanding GDM container
  ///
  /// In en, this message translates to:
  /// **'Understanding Gestational Diabetes (GDM)'**
  String get understandingGDM;

  /// Description for understanding GDM container
  ///
  /// In en, this message translates to:
  /// **'A comprehensive overview of GDM, its causes, risk factors, and how it affects pregnancy.'**
  String get understandingGDMDescription;

  /// Title for GDM and pregnancy container
  ///
  /// In en, this message translates to:
  /// **'GDM and Pregnancy'**
  String get gdmAndPregnancy;

  /// Description for GDM and pregnancy container
  ///
  /// In en, this message translates to:
  /// **'Key facts about GDM, screening processes, and long-term health implications.'**
  String get gdmAndPregnancyDescription;

  /// Title for add reminder screen and button
  ///
  /// In en, this message translates to:
  /// **'Add Reminder'**
  String get addReminder;

  /// Hint text for reminder label dropdown
  ///
  /// In en, this message translates to:
  /// **'Select label'**
  String get selectLabel;

  /// Label for reminder label dropdown
  ///
  /// In en, this message translates to:
  /// **'Select Reminder label'**
  String get selectReminderLabel;

  /// Dropdown option for glucose reading reminder
  ///
  /// In en, this message translates to:
  /// **'Glucose Reading'**
  String get glucoseReading;

  /// Dropdown option for log calories reminder
  ///
  /// In en, this message translates to:
  /// **'Log Calories'**
  String get logCalories;

  /// Dropdown option for weight check reminder
  ///
  /// In en, this message translates to:
  /// **'Weight Check'**
  String get weightCheck;

  /// Dropdown option for step count reminder
  ///
  /// In en, this message translates to:
  /// **'Step Count'**
  String get stepCount;

  /// Dropdown option for GDM facts reminder
  ///
  /// In en, this message translates to:
  /// **'GDM Facts'**
  String get gdmFacts;

  /// Validation message for incomplete reminder form
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get pleaseFillAllFields;

  /// Frequency option for one-time reminder
  ///
  /// In en, this message translates to:
  /// **'Ring Once'**
  String get ringOnce;

  /// Frequency option for custom reminder schedule
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get customFrequency;

  /// Frequency option for daily reminders
  ///
  /// In en, this message translates to:
  /// **'Everyday'**
  String get everyday;

  /// Frequency option for weekday reminders
  ///
  /// In en, this message translates to:
  /// **'Weekdays'**
  String get weekdays;

  /// Frequency option for Monday to Friday reminders
  ///
  /// In en, this message translates to:
  /// **'Mon to Fri'**
  String get monToFri;

  /// Section title for repeat frequency
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get repeat;

  /// Abbreviation for Sunday
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get daySun;

  /// Abbreviation for Monday
  ///
  /// In en, this message translates to:
  /// **'M'**
  String get dayMon;

  /// Abbreviation for Tuesday
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get dayTue;

  /// Abbreviation for Wednesday
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get dayWed;

  /// Abbreviation for Thursday
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get dayThu;

  /// Abbreviation for Friday
  ///
  /// In en, this message translates to:
  /// **'F'**
  String get dayFri;

  /// Abbreviation for Saturday
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get daySat;

  /// Prefix for displaying selected frequency
  ///
  /// In en, this message translates to:
  /// **'Repeat:'**
  String get repeatPrefix;

  /// Toast message for successful reminder addition
  ///
  /// In en, this message translates to:
  /// **'Reminder added successfully!'**
  String get reminderAddedSuccess;

  /// Toast message prefix for failed reminder addition
  ///
  /// In en, this message translates to:
  /// **'Failed to add reminder:'**
  String get failedToAddReminder;

  /// Title for all reminders screen
  ///
  /// In en, this message translates to:
  /// **'All Reminders'**
  String get allReminders;

  /// Message for empty reminders list
  ///
  /// In en, this message translates to:
  /// **'No reminders yet'**
  String get noRemindersYet;

  /// Prompt to add a reminder
  ///
  /// In en, this message translates to:
  /// **'Add a reminder to get started'**
  String get addReminderToStart;

  /// Toast message for successful reminder deletion
  ///
  /// In en, this message translates to:
  /// **'Reminder deleted successfully'**
  String get reminderDeletedSuccess;

  /// Toast message prefix for failed reminder deletion
  ///
  /// In en, this message translates to:
  /// **'Failed to delete reminder:'**
  String get failedToDeleteReminder;

  /// Toast message for reminder activation
  ///
  /// In en, this message translates to:
  /// **'Reminder activated'**
  String get reminderActivated;

  /// Toast message for reminder deactivation
  ///
  /// In en, this message translates to:
  /// **'Reminder deactivated'**
  String get reminderDeactivated;

  /// Toast message prefix for failed reminder update
  ///
  /// In en, this message translates to:
  /// **'Failed to update reminder:'**
  String get failedToUpdateReminder;

  /// Title for delete reminder dialog
  ///
  /// In en, this message translates to:
  /// **'Delete Reminder'**
  String get deleteReminder;

  /// Confirmation message for deleting a reminder
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete?'**
  String get confirmDeleteReminder;

  /// Button label for delete action
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Title for GDM test reminder dialog
  ///
  /// In en, this message translates to:
  /// **'GDM Test Reminder'**
  String get gdmTestReminder;

  /// Message for GDM test reminder
  ///
  /// In en, this message translates to:
  /// **'Reminder to go and test for diabetes at the hospital (between 24 to 28 weeks)?'**
  String get gdmTestReminderMessage;

  /// Button label for acknowledging reminder
  ///
  /// In en, this message translates to:
  /// **'Thanks for the reminder'**
  String get thanksForReminder;

  /// Button label for confirming task completion
  ///
  /// In en, this message translates to:
  /// **'I have done it'**
  String get iHaveDoneIt;

  /// Title for snooze reminder dialog
  ///
  /// In en, this message translates to:
  /// **'Snooze Reminder'**
  String get snoozeReminder;

  /// Option to snooze reminder for 3 days
  ///
  /// In en, this message translates to:
  /// **'Snooze for 3 days'**
  String get snoozeFor3Days;

  /// Option to snooze reminder for 1 week
  ///
  /// In en, this message translates to:
  /// **'Snooze for 1 week'**
  String get snoozeFor1Week;

  /// Title for add weight dialog and button tooltip
  ///
  /// In en, this message translates to:
  /// **'Add Weight'**
  String get addWeight;

  /// No description provided for @pickDate.
  ///
  /// In en, this message translates to:
  /// **'Pick Date'**
  String get pickDate;

  /// Validation message for missing date or weight
  ///
  /// In en, this message translates to:
  /// **'Please enter both date and weight'**
  String get pleaseEnterDateAndWeight;

  /// Toast message for successful weight data addition
  ///
  /// In en, this message translates to:
  /// **'Weight data successfully added!'**
  String get weightDataAddedSuccess;

  /// Toast message for successful weight data update
  ///
  /// In en, this message translates to:
  /// **'Weight data successfully updated!'**
  String get weightDataUpdatedSuccess;

  /// Toast message prefix for failed weight data addition
  ///
  /// In en, this message translates to:
  /// **'Error adding weight:'**
  String get errorAddingWeight;

  /// Label for PDF generation button
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get pdfButton;

  /// Label for weight addition button
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weightButton;

  /// Tooltip for PDF download button
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get downloadPdfTooltip;

  /// Toast message prefix for failed weight data fetch
  ///
  /// In en, this message translates to:
  /// **'Error fetching weight data:'**
  String get errorFetchingWeightData;

  /// Title for weight tracking PDF report
  ///
  /// In en, this message translates to:
  /// **'Weight Tracking Report'**
  String get weightTrackingReport;

  /// Table header for date in PDF
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateHeader;

  /// Table header for weight in PDF
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weightHeader;

  /// Table header for unit in PDF
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unitHeader;

  /// Toast message for successful PDF generation and sharing
  ///
  /// In en, this message translates to:
  /// **'PDF generated and shared successfully!'**
  String get pdfGeneratedSuccess;

  /// Message for empty weight data list
  ///
  /// In en, this message translates to:
  /// **'No weight data available'**
  String get noWeightData;

  /// Label for current weight display
  ///
  /// In en, this message translates to:
  /// **'Current Weight:'**
  String get currentWeight;

  /// Message for no weight data in the past week
  ///
  /// In en, this message translates to:
  /// **'No weight data available for the past week'**
  String get noWeightDataPastWeek;

  /// Fallback value for missing weight data
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notApplicable;

  /// No description provided for @oldPassword.
  ///
  /// In en, this message translates to:
  /// **'Old Password'**
  String get oldPassword;

  /// No description provided for @pleaseEnterOldPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your old password'**
  String get pleaseEnterOldPassword;

  /// No description provided for @pleaseEnterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter a new password'**
  String get pleaseEnterNewPassword;

  /// No description provided for @pleaseConfirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your new password'**
  String get pleaseConfirmNewPassword;

  /// No description provided for @newPasswordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'New passwords do not match'**
  String get newPasswordsDoNotMatch;

  /// No description provided for @updateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update password'**
  String get updateFailed;

  /// No description provided for @oldPasswordIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Old password is incorrect'**
  String get oldPasswordIncorrect;

  /// No description provided for @loginRequired.
  ///
  /// In en, this message translates to:
  /// **'Please log in again to update your password'**
  String get loginRequired;

  /// No description provided for @set_calories.
  ///
  /// In en, this message translates to:
  /// **'Set Calories'**
  String get set_calories;

  /// No description provided for @set_daily_cal.
  ///
  /// In en, this message translates to:
  /// **'Set daily Cal'**
  String get set_daily_cal;

  /// No description provided for @add_cal.
  ///
  /// In en, this message translates to:
  /// **'Add Cal'**
  String get add_cal;

  /// No description provided for @user_not_logged_in.
  ///
  /// In en, this message translates to:
  /// **'User not logged in!'**
  String get user_not_logged_in;

  /// No description provided for @please_enter_valid_calorie_value.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid calorie value!'**
  String get please_enter_valid_calorie_value;

  /// No description provided for @successfully_added_daily_calories.
  ///
  /// In en, this message translates to:
  /// **'Successfully added Daily Calories data!'**
  String get successfully_added_daily_calories;

  /// No description provided for @user_not_found_in_collection.
  ///
  /// In en, this message translates to:
  /// **'User not found in any collection!'**
  String get user_not_found_in_collection;

  /// No description provided for @error_adding_calories.
  ///
  /// In en, this message translates to:
  /// **'Error adding calories:'**
  String get error_adding_calories;

  /// No description provided for @create_food.
  ///
  /// In en, this message translates to:
  /// **'Create Food'**
  String get create_food;

  /// No description provided for @enter_food_name.
  ///
  /// In en, this message translates to:
  /// **'Enter food name'**
  String get enter_food_name;

  /// No description provided for @food_name_label.
  ///
  /// In en, this message translates to:
  /// **'Food Name'**
  String get food_name_label;

  /// No description provided for @enter_calories.
  ///
  /// In en, this message translates to:
  /// **'Enter calories'**
  String get enter_calories;

  /// No description provided for @calories_label.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get calories_label;

  /// No description provided for @enter_quantity.
  ///
  /// In en, this message translates to:
  /// **'Enter quantity'**
  String get enter_quantity;

  /// No description provided for @quantity_label.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity_label;

  /// No description provided for @save_food.
  ///
  /// In en, this message translates to:
  /// **'Save Food'**
  String get save_food;

  /// No description provided for @please_enter_food_name.
  ///
  /// In en, this message translates to:
  /// **'Please enter a food name'**
  String get please_enter_food_name;

  /// No description provided for @please_enter_calories.
  ///
  /// In en, this message translates to:
  /// **'Please enter calories'**
  String get please_enter_calories;

  /// No description provided for @please_enter_quantity.
  ///
  /// In en, this message translates to:
  /// **'Please enter a quantity'**
  String get please_enter_quantity;

  /// No description provided for @successfully_added_food.
  ///
  /// In en, this message translates to:
  /// **'Successfully added food!'**
  String get successfully_added_food;

  /// No description provided for @error_adding_food.
  ///
  /// In en, this message translates to:
  /// **'Error adding food:'**
  String get error_adding_food;

  /// No description provided for @eaten.
  ///
  /// In en, this message translates to:
  /// **'eaten'**
  String get eaten;

  /// No description provided for @error_deleting_food.
  ///
  /// In en, this message translates to:
  /// **'Error deleting food:'**
  String get error_deleting_food;

  /// No description provided for @meals_plan.
  ///
  /// In en, this message translates to:
  /// **'Meals Plan'**
  String get meals_plan;

  /// No description provided for @snacks.
  ///
  /// In en, this message translates to:
  /// **'Snacks'**
  String get snacks;

  /// No description provided for @eaten_label.
  ///
  /// In en, this message translates to:
  /// **'Eaten'**
  String get eaten_label;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @total_cal.
  ///
  /// In en, this message translates to:
  /// **'Total Cal'**
  String get total_cal;

  /// No description provided for @food.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get food;

  /// No description provided for @no_foods_available.
  ///
  /// In en, this message translates to:
  /// **'No foods available'**
  String get no_foods_available;

  /// No description provided for @added_to.
  ///
  /// In en, this message translates to:
  /// **'added to'**
  String get added_to;

  /// No description provided for @no_recent_items.
  ///
  /// In en, this message translates to:
  /// **'No recent items'**
  String get no_recent_items;

  /// No description provided for @no_user_logged_in_error.
  ///
  /// In en, this message translates to:
  /// **'No user logged in'**
  String get no_user_logged_in_error;

  /// No description provided for @user_not_found_in_users_collection.
  ///
  /// In en, this message translates to:
  /// **'User not found in Users collection'**
  String get user_not_found_in_users_collection;

  /// No description provided for @error_fetching_meals_data.
  ///
  /// In en, this message translates to:
  /// **'Error fetching meals data:'**
  String get error_fetching_meals_data;

  /// No description provided for @error_adding_meal_item.
  ///
  /// In en, this message translates to:
  /// **'Error adding meal item:'**
  String get error_adding_meal_item;

  /// No description provided for @error_removing_meal_item.
  ///
  /// In en, this message translates to:
  /// **'Error removing meal item:'**
  String get error_removing_meal_item;

  /// No description provided for @item_not_found_in_firestore.
  ///
  /// In en, this message translates to:
  /// **'Item not found in Firestore'**
  String get item_not_found_in_firestore;

  /// No description provided for @food_added_successfully.
  ///
  /// In en, this message translates to:
  /// **'Food added successfully'**
  String get food_added_successfully;

  /// No description provided for @food_deleted_successfully.
  ///
  /// In en, this message translates to:
  /// **'Food deleted successfully'**
  String get food_deleted_successfully;

  /// No description provided for @item_not_found.
  ///
  /// In en, this message translates to:
  /// **'Item not found'**
  String get item_not_found;

  /// No description provided for @search_for_a_food.
  ///
  /// In en, this message translates to:
  /// **'Search for a food'**
  String get search_for_a_food;

  /// No description provided for @recent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recent;

  /// No description provided for @my_food.
  ///
  /// In en, this message translates to:
  /// **'My food'**
  String get my_food;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete My Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone.'**
  String get deleteAccountConfirmation;

  /// No description provided for @deleteAccountSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully.'**
  String get deleteAccountSuccess;

  /// No description provided for @noUserSignedIn.
  ///
  /// In en, this message translates to:
  /// **'No user is currently signed in.'**
  String get noUserSignedIn;

  /// No description provided for @reauthenticate.
  ///
  /// In en, this message translates to:
  /// **'Re-authenticate'**
  String get reauthenticate;

  /// No description provided for @reauthenticatePrompt.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password to confirm account deletion.'**
  String get reauthenticatePrompt;

  /// No description provided for @reauthenticationFailed.
  ///
  /// In en, this message translates to:
  /// **'Re-authentication failed'**
  String get reauthenticationFailed;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid credentials.'**
  String get invalidCredentials;

  /// No description provided for @failedToDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account'**
  String get failedToDeleteAccount;

  /// No description provided for @dailyCalories.
  ///
  /// In en, this message translates to:
  /// **'Daily Calories'**
  String get dailyCalories;

  /// No description provided for @calories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get calories;

  /// Title for the DiabetesTypeScreen asking about diagnoses outside pregnancy
  ///
  /// In en, this message translates to:
  /// **'Outside pregnancy, I have been diagnosed with'**
  String get outsidePregnancyDiagnosis;

  /// Diagnosis option for Type 2 Diabetes
  ///
  /// In en, this message translates to:
  /// **'Diabetes (Type 2)'**
  String get diagnosisType2Diabetes;

  /// Diagnosis option for Type 1 Diabetes
  ///
  /// In en, this message translates to:
  /// **'Diabetes (Type 1)'**
  String get diagnosisType1Diabetes;

  /// Diagnosis option for Prediabetes
  ///
  /// In en, this message translates to:
  /// **'Prediabetes'**
  String get diagnosisPrediabetes;

  /// Diagnosis option for Hypertension
  ///
  /// In en, this message translates to:
  /// **'Hypertension'**
  String get diagnosisHypertension;

  /// Diagnosis option for Heart disease
  ///
  /// In en, this message translates to:
  /// **'Heart disease'**
  String get diagnosisHeartDisease;

  /// Diagnosis option for Obesity
  ///
  /// In en, this message translates to:
  /// **'Obesity'**
  String get diagnosisObesity;

  /// Diagnosis option for Lipid/Cholesterol disorders
  ///
  /// In en, this message translates to:
  /// **'Lipid/Cholesterol disorders'**
  String get diagnosisLipidDisorders;

  /// Diagnosis option for Other unspecified conditions
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get diagnosisOther;

  /// Hint text for the 'Other' diagnosis text field
  ///
  /// In en, this message translates to:
  /// **'Please specify'**
  String get pleaseSpecify;

  /// Validation message for empty 'Other' diagnosis text field
  ///
  /// In en, this message translates to:
  /// **'Please enter diagnosis'**
  String get pleaseEnterDiagnosis;

  /// Validation message when no diagnosis options are selected
  ///
  /// In en, this message translates to:
  /// **'Please select at least one option'**
  String get pleaseSelectAtLeastOneOption;

  /// Validation message when 'Other' is selected but not specified
  ///
  /// In en, this message translates to:
  /// **'Please specify the \'Other\' diagnosis'**
  String get pleaseSpecifyOtherDiagnosis;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
