// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Bota';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get profile => 'Profile';

  @override
  String get language => 'Language';

  @override
  String get refresh => 'Refresh';

  @override
  String get profileTitle => 'User profile';

  @override
  String get logoutTitle => 'Log out?';

  @override
  String get logoutDescription => 'Do you really want to log out?';

  @override
  String get cancel => 'Cancel';

  @override
  String get logout => 'Log out';

  @override
  String get aboutApp => 'About app';

  @override
  String get purpose => 'Purpose';

  @override
  String get purposeDescription => 'Career guidance for school students';

  @override
  String get function => 'Function';

  @override
  String get functionDescription => 'Interest and direction testing';

  @override
  String get result => 'Result';

  @override
  String get resultDescription =>
      'Career recommendations based on test results';

  @override
  String get aiAssistant => 'AI Assistant';

  @override
  String get aiAssistantDescription => 'Answers to career guidance questions';

  @override
  String get myAccount => 'My account';

  @override
  String get userName => 'Username';

  @override
  String get email => 'Email';

  @override
  String get status => 'Status';

  @override
  String get accountActive => 'Account active';

  @override
  String get myProgress => 'My progress';

  @override
  String get modulesTitle => 'Career modules';

  @override
  String get modulesDescription =>
      'Complete modules sequentially for more accurate recommendations.';

  @override
  String get recommendationsTitle => 'Final recommendations';

  @override
  String get recommendationsDescription =>
      'After completing modules, view suitable careers and courses.';

  @override
  String get quickActions => 'Quick actions';

  @override
  String get goToModules => 'Go to modules';

  @override
  String get goToModulesDescription => 'Open career modules';

  @override
  String get openRecommendations => 'View recommendations';

  @override
  String get openRecommendationsDescription => 'Open final results screen';

  @override
  String get openAi => 'Open AI assistant';

  @override
  String get openAiDescription => 'Ask questions about professions';

  @override
  String get logoutAction => 'Log out';

  @override
  String get logoutActionDescription => 'End current session';

  @override
  String get helpfulTips => 'Helpful tips';

  @override
  String get tipModules => 'Complete all modules';

  @override
  String get tipModulesDescription =>
      'This helps the system choose a more accurate profession for you.';

  @override
  String get tipUpdate => 'Update results';

  @override
  String get tipUpdateDescription =>
      'If answers change, recommendations also change.';

  @override
  String get tipCourses => 'Explore courses';

  @override
  String get tipCoursesDescription =>
      'After results, explore courses and try professions.';

  @override
  String get profileFooter => 'Proffy · career guidance and recommendations';

  @override
  String get profileCabinet => 'Your personal Proffy account';

  @override
  String get navModules => 'Modules';

  @override
  String get navResult => 'Result';

  @override
  String get navAi => 'AI';

  @override
  String get navProfile => 'Profile';

  @override
  String get modulesAppBarTitle => 'Career guidance modules';

  @override
  String get modulesIntro =>
      'Complete all modules to unlock final recommendations';

  @override
  String get modulesNoData => 'No module data';

  @override
  String get viewRecommendations => 'View recommendations';

  @override
  String get yourProgress => 'Your progress';

  @override
  String modulesCompleted(Object completed, Object total) {
    return '$completed of $total modules completed';
  }

  @override
  String get moduleCompleted => 'Completed';

  @override
  String get moduleInProgress => 'In progress';

  @override
  String get moduleNotStarted => 'Not started';

  @override
  String get retry => 'Retry';

  @override
  String get moduleTestTitle => 'Module test';

  @override
  String get userIdNotFound => 'User ID not found';

  @override
  String get answerAllQuestions => 'Please answer all questions';

  @override
  String get moduleCompletedSuccess => 'Module completed successfully';

  @override
  String get moduleDataNotFound => 'Module data not found';

  @override
  String get finishModule => 'Finish module';

  @override
  String get resultTitle => 'Result';

  @override
  String get yourProfession => 'Your profession';

  @override
  String get professionNotDefined => 'Profession is not defined yet';

  @override
  String get finishModulesForResult =>
      'Complete at least one module for accurate results';

  @override
  String get modulesProgress => 'Modules progress';

  @override
  String get hide => 'Hide';

  @override
  String get showAll => 'Show all';

  @override
  String get profileUnavailable => 'Profile data unavailable';

  @override
  String get temperament => 'Temperament';

  @override
  String get thinkingStyle => 'Thinking style';

  @override
  String get studyProfile => 'Study profile';

  @override
  String get values => 'Values';

  @override
  String get direction => 'Direction';

  @override
  String get antiDirection => 'Anti direction';

  @override
  String get alternatives => 'Alternative professions';

  @override
  String get similarity => 'Similarity';

  @override
  String get coursesTitle => 'Recommended courses';

  @override
  String get courseTitle => 'Course';

  @override
  String get aboutCourse => 'About course';

  @override
  String get whatYouGet => 'What you get';

  @override
  String get understandBasics => 'Understand the basics';

  @override
  String get tryProfession => 'Try yourself in profession';

  @override
  String get practiceSkills => 'Gain practical skills';

  @override
  String get understandSphere => 'Understand if this field suits you';

  @override
  String get understood => 'Got it';

  @override
  String get recommendationEmptyBanner =>
      'Complete the modules so we can suggest a suitable profession and show the match percentage.';

  @override
  String recommendationPartialBanner(Object completed, Object total) {
    return 'This is a preliminary result: $completed of $total modules completed. Complete all modules to make the recommendation more accurate.';
  }

  @override
  String get whyProfessionEmpty =>
      'After completing the modules, we will show why this profession suits you.';

  @override
  String get whyProfessionDefault =>
      'This recommendation is based on your answers, strengths, and interests.';

  @override
  String get defaultCourseLevel => 'Beginner';

  @override
  String get defaultCourseDuration => '4 weeks';

  @override
  String get userNotFoundLoginAgain => 'User not found. Please log in again.';
}
