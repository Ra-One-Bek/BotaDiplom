import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_kk.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('en'),
    Locale('kk'),
    Locale('ru')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Bota'**
  String get appName;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'User profile'**
  String get profileTitle;

  /// No description provided for @logoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get logoutTitle;

  /// No description provided for @logoutDescription.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to log out?'**
  String get logoutDescription;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About app'**
  String get aboutApp;

  /// No description provided for @purpose.
  ///
  /// In en, this message translates to:
  /// **'Purpose'**
  String get purpose;

  /// No description provided for @purposeDescription.
  ///
  /// In en, this message translates to:
  /// **'Career guidance for school students'**
  String get purposeDescription;

  /// No description provided for @function.
  ///
  /// In en, this message translates to:
  /// **'Function'**
  String get function;

  /// No description provided for @functionDescription.
  ///
  /// In en, this message translates to:
  /// **'Interest and direction testing'**
  String get functionDescription;

  /// No description provided for @result.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get result;

  /// No description provided for @resultDescription.
  ///
  /// In en, this message translates to:
  /// **'Career recommendations based on test results'**
  String get resultDescription;

  /// No description provided for @aiAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get aiAssistant;

  /// No description provided for @aiAssistantDescription.
  ///
  /// In en, this message translates to:
  /// **'Answers to career guidance questions'**
  String get aiAssistantDescription;

  /// No description provided for @myAccount.
  ///
  /// In en, this message translates to:
  /// **'My account'**
  String get myAccount;

  /// No description provided for @userName.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get userName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @accountActive.
  ///
  /// In en, this message translates to:
  /// **'Account active'**
  String get accountActive;

  /// No description provided for @myProgress.
  ///
  /// In en, this message translates to:
  /// **'My progress'**
  String get myProgress;

  /// No description provided for @modulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Career modules'**
  String get modulesTitle;

  /// No description provided for @modulesDescription.
  ///
  /// In en, this message translates to:
  /// **'Complete modules sequentially for more accurate recommendations.'**
  String get modulesDescription;

  /// No description provided for @recommendationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Final recommendations'**
  String get recommendationsTitle;

  /// No description provided for @recommendationsDescription.
  ///
  /// In en, this message translates to:
  /// **'After completing modules, view suitable careers and courses.'**
  String get recommendationsDescription;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get quickActions;

  /// No description provided for @goToModules.
  ///
  /// In en, this message translates to:
  /// **'Go to modules'**
  String get goToModules;

  /// No description provided for @goToModulesDescription.
  ///
  /// In en, this message translates to:
  /// **'Open career modules'**
  String get goToModulesDescription;

  /// No description provided for @openRecommendations.
  ///
  /// In en, this message translates to:
  /// **'View recommendations'**
  String get openRecommendations;

  /// No description provided for @openRecommendationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Open final results screen'**
  String get openRecommendationsDescription;

  /// No description provided for @openAi.
  ///
  /// In en, this message translates to:
  /// **'Open AI assistant'**
  String get openAi;

  /// No description provided for @openAiDescription.
  ///
  /// In en, this message translates to:
  /// **'Ask questions about professions'**
  String get openAiDescription;

  /// No description provided for @logoutAction.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logoutAction;

  /// No description provided for @logoutActionDescription.
  ///
  /// In en, this message translates to:
  /// **'End current session'**
  String get logoutActionDescription;

  /// No description provided for @helpfulTips.
  ///
  /// In en, this message translates to:
  /// **'Helpful tips'**
  String get helpfulTips;

  /// No description provided for @tipModules.
  ///
  /// In en, this message translates to:
  /// **'Complete all modules'**
  String get tipModules;

  /// No description provided for @tipModulesDescription.
  ///
  /// In en, this message translates to:
  /// **'This helps the system choose a more accurate profession for you.'**
  String get tipModulesDescription;

  /// No description provided for @tipUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update results'**
  String get tipUpdate;

  /// No description provided for @tipUpdateDescription.
  ///
  /// In en, this message translates to:
  /// **'If answers change, recommendations also change.'**
  String get tipUpdateDescription;

  /// No description provided for @tipCourses.
  ///
  /// In en, this message translates to:
  /// **'Explore courses'**
  String get tipCourses;

  /// No description provided for @tipCoursesDescription.
  ///
  /// In en, this message translates to:
  /// **'After results, explore courses and try professions.'**
  String get tipCoursesDescription;

  /// No description provided for @profileFooter.
  ///
  /// In en, this message translates to:
  /// **'Proffy · career guidance and recommendations'**
  String get profileFooter;

  /// No description provided for @profileCabinet.
  ///
  /// In en, this message translates to:
  /// **'Your personal Proffy account'**
  String get profileCabinet;

  /// No description provided for @navModules.
  ///
  /// In en, this message translates to:
  /// **'Modules'**
  String get navModules;

  /// No description provided for @navResult.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get navResult;

  /// No description provided for @navAi.
  ///
  /// In en, this message translates to:
  /// **'AI'**
  String get navAi;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @modulesAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Career guidance modules'**
  String get modulesAppBarTitle;

  /// No description provided for @modulesIntro.
  ///
  /// In en, this message translates to:
  /// **'Complete all modules to unlock final recommendations'**
  String get modulesIntro;

  /// No description provided for @modulesNoData.
  ///
  /// In en, this message translates to:
  /// **'No module data'**
  String get modulesNoData;

  /// No description provided for @viewRecommendations.
  ///
  /// In en, this message translates to:
  /// **'View recommendations'**
  String get viewRecommendations;

  /// No description provided for @yourProgress.
  ///
  /// In en, this message translates to:
  /// **'Your progress'**
  String get yourProgress;

  /// No description provided for @modulesCompleted.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} modules completed'**
  String modulesCompleted(Object completed, Object total);

  /// No description provided for @moduleCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get moduleCompleted;

  /// No description provided for @moduleInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get moduleInProgress;

  /// No description provided for @moduleNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Not started'**
  String get moduleNotStarted;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @moduleTestTitle.
  ///
  /// In en, this message translates to:
  /// **'Module test'**
  String get moduleTestTitle;

  /// No description provided for @userIdNotFound.
  ///
  /// In en, this message translates to:
  /// **'User ID not found'**
  String get userIdNotFound;

  /// No description provided for @answerAllQuestions.
  ///
  /// In en, this message translates to:
  /// **'Please answer all questions'**
  String get answerAllQuestions;

  /// No description provided for @moduleCompletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Module completed successfully'**
  String get moduleCompletedSuccess;

  /// No description provided for @moduleDataNotFound.
  ///
  /// In en, this message translates to:
  /// **'Module data not found'**
  String get moduleDataNotFound;

  /// No description provided for @finishModule.
  ///
  /// In en, this message translates to:
  /// **'Finish module'**
  String get finishModule;

  /// No description provided for @resultTitle.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get resultTitle;

  /// No description provided for @yourProfession.
  ///
  /// In en, this message translates to:
  /// **'Your profession'**
  String get yourProfession;

  /// No description provided for @professionNotDefined.
  ///
  /// In en, this message translates to:
  /// **'Profession is not defined yet'**
  String get professionNotDefined;

  /// No description provided for @finishModulesForResult.
  ///
  /// In en, this message translates to:
  /// **'Complete at least one module for accurate results'**
  String get finishModulesForResult;

  /// No description provided for @modulesProgress.
  ///
  /// In en, this message translates to:
  /// **'Modules progress'**
  String get modulesProgress;

  /// No description provided for @hide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get hide;

  /// No description provided for @showAll.
  ///
  /// In en, this message translates to:
  /// **'Show all'**
  String get showAll;

  /// No description provided for @profileUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Profile data unavailable'**
  String get profileUnavailable;

  /// No description provided for @temperament.
  ///
  /// In en, this message translates to:
  /// **'Temperament'**
  String get temperament;

  /// No description provided for @thinkingStyle.
  ///
  /// In en, this message translates to:
  /// **'Thinking style'**
  String get thinkingStyle;

  /// No description provided for @studyProfile.
  ///
  /// In en, this message translates to:
  /// **'Study profile'**
  String get studyProfile;

  /// No description provided for @values.
  ///
  /// In en, this message translates to:
  /// **'Values'**
  String get values;

  /// No description provided for @direction.
  ///
  /// In en, this message translates to:
  /// **'Direction'**
  String get direction;

  /// No description provided for @antiDirection.
  ///
  /// In en, this message translates to:
  /// **'Anti direction'**
  String get antiDirection;

  /// No description provided for @alternatives.
  ///
  /// In en, this message translates to:
  /// **'Alternative professions'**
  String get alternatives;

  /// No description provided for @similarity.
  ///
  /// In en, this message translates to:
  /// **'Similarity'**
  String get similarity;

  /// No description provided for @coursesTitle.
  ///
  /// In en, this message translates to:
  /// **'Recommended courses'**
  String get coursesTitle;

  /// No description provided for @courseTitle.
  ///
  /// In en, this message translates to:
  /// **'Course'**
  String get courseTitle;

  /// No description provided for @aboutCourse.
  ///
  /// In en, this message translates to:
  /// **'About course'**
  String get aboutCourse;

  /// No description provided for @whatYouGet.
  ///
  /// In en, this message translates to:
  /// **'What you get'**
  String get whatYouGet;

  /// No description provided for @understandBasics.
  ///
  /// In en, this message translates to:
  /// **'Understand the basics'**
  String get understandBasics;

  /// No description provided for @tryProfession.
  ///
  /// In en, this message translates to:
  /// **'Try yourself in profession'**
  String get tryProfession;

  /// No description provided for @practiceSkills.
  ///
  /// In en, this message translates to:
  /// **'Gain practical skills'**
  String get practiceSkills;

  /// No description provided for @understandSphere.
  ///
  /// In en, this message translates to:
  /// **'Understand if this field suits you'**
  String get understandSphere;

  /// No description provided for @understood.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get understood;

  /// No description provided for @recommendationEmptyBanner.
  ///
  /// In en, this message translates to:
  /// **'Complete the modules so we can suggest a suitable profession and show the match percentage.'**
  String get recommendationEmptyBanner;

  /// No description provided for @recommendationPartialBanner.
  ///
  /// In en, this message translates to:
  /// **'This is a preliminary result: {completed} of {total} modules completed. Complete all modules to make the recommendation more accurate.'**
  String recommendationPartialBanner(Object completed, Object total);

  /// No description provided for @whyProfessionEmpty.
  ///
  /// In en, this message translates to:
  /// **'After completing the modules, we will show why this profession suits you.'**
  String get whyProfessionEmpty;

  /// No description provided for @whyProfessionDefault.
  ///
  /// In en, this message translates to:
  /// **'This recommendation is based on your answers, strengths, and interests.'**
  String get whyProfessionDefault;

  /// No description provided for @defaultCourseLevel.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get defaultCourseLevel;

  /// No description provided for @defaultCourseDuration.
  ///
  /// In en, this message translates to:
  /// **'4 weeks'**
  String get defaultCourseDuration;

  /// No description provided for @userNotFoundLoginAgain.
  ///
  /// In en, this message translates to:
  /// **'User not found. Please log in again.'**
  String get userNotFoundLoginAgain;
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
      <String>['en', 'kk', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'kk':
      return AppLocalizationsKk();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
