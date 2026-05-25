// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'Bota';

  @override
  String get login => 'Вход';

  @override
  String get register => 'Регистрация';

  @override
  String get profile => 'Профиль';

  @override
  String get language => 'Язык';

  @override
  String get refresh => 'Обновить';

  @override
  String get profileTitle => 'Профиль пользователя';

  @override
  String get logoutTitle => 'Выйти из аккаунта?';

  @override
  String get logoutDescription => 'Ты действительно хочешь выйти из аккаунта?';

  @override
  String get cancel => 'Отмена';

  @override
  String get logout => 'Выйти';

  @override
  String get aboutApp => 'О приложении';

  @override
  String get purpose => 'Назначение';

  @override
  String get purposeDescription => 'Профориентация школьников';

  @override
  String get function => 'Функция';

  @override
  String get functionDescription => 'Тестирование интересов и направлений';

  @override
  String get result => 'Результат';

  @override
  String get resultDescription => 'Подбор профессий по результатам теста';

  @override
  String get aiAssistant => 'AI помощник';

  @override
  String get aiAssistantDescription => 'Ответы на вопросы по профориентации';

  @override
  String get myAccount => 'Мой аккаунт';

  @override
  String get userName => 'Имя пользователя';

  @override
  String get email => 'Почта';

  @override
  String get status => 'Статус';

  @override
  String get accountActive => 'Аккаунт активен';

  @override
  String get myProgress => 'Мой прогресс';

  @override
  String get modulesTitle => 'Модули профориентации';

  @override
  String get modulesDescription =>
      'Проходи модули последовательно, чтобы получить более точную рекомендацию.';

  @override
  String get recommendationsTitle => 'Итоговые рекомендации';

  @override
  String get recommendationsDescription =>
      'После прохождения модулей смотри подходящие профессии и курсы.';

  @override
  String get quickActions => 'Быстрые действия';

  @override
  String get goToModules => 'Перейти к модулям';

  @override
  String get goToModulesDescription => 'Открыть модули профориентации';

  @override
  String get openRecommendations => 'Посмотреть рекомендации';

  @override
  String get openRecommendationsDescription =>
      'Открыть экран итоговых результатов';

  @override
  String get openAi => 'Открыть AI помощника';

  @override
  String get openAiDescription => 'Задать вопросы по профессиям';

  @override
  String get logoutAction => 'Выйти из аккаунта';

  @override
  String get logoutActionDescription => 'Завершить текущую сессию';

  @override
  String get helpfulTips => 'Полезные советы';

  @override
  String get tipModules => 'Проходи все модули';

  @override
  String get tipModulesDescription =>
      'Так система сможет подобрать более точную профессию именно под тебя.';

  @override
  String get tipUpdate => 'Обновляй результат';

  @override
  String get tipUpdateDescription =>
      'Если меняешь ответы в модулях, итоговые рекомендации тоже обновляются.';

  @override
  String get tipCourses => 'Изучай курсы';

  @override
  String get tipCoursesDescription =>
      'После результата смотри курсы по своему направлению и пробуй себя в профессии.';

  @override
  String get profileFooter => 'Proffy · профориентация и рекомендации';

  @override
  String get profileCabinet => 'Твой личный кабинет в Proffy';

  @override
  String get navModules => 'Модули';

  @override
  String get navResult => 'Итог';

  @override
  String get navAi => 'AI';

  @override
  String get navProfile => 'Профиль';

  @override
  String get modulesAppBarTitle => 'Модули профориентации';

  @override
  String get modulesIntro =>
      'Пройди все модули, чтобы открыть итоговые рекомендации';

  @override
  String get modulesNoData => 'Нет данных по модулям';

  @override
  String get viewRecommendations => 'Посмотреть рекомендации';

  @override
  String get yourProgress => 'Твой прогресс';

  @override
  String modulesCompleted(Object completed, Object total) {
    return '$completed из $total модулей завершено';
  }

  @override
  String get moduleCompleted => 'Пройден';

  @override
  String get moduleInProgress => 'В процессе';

  @override
  String get moduleNotStarted => 'Не начат';

  @override
  String get retry => 'Повторить';

  @override
  String get moduleTestTitle => 'Прохождение модуля';

  @override
  String get userIdNotFound => 'Не найден userId';

  @override
  String get answerAllQuestions => 'Пожалуйста, ответьте на все вопросы';

  @override
  String get moduleCompletedSuccess => 'Модуль успешно завершён';

  @override
  String get moduleDataNotFound => 'Данные модуля не найдены';

  @override
  String get finishModule => 'Завершить модуль';

  @override
  String get resultTitle => 'Итог';

  @override
  String get yourProfession => 'Твоя профессия';

  @override
  String get professionNotDefined => 'Профессия пока не определена';

  @override
  String get finishModulesForResult =>
      'Чтобы получить точный результат, пройди хотя бы один модуль';

  @override
  String get modulesProgress => 'Прогресс модулей';

  @override
  String get hide => 'Скрыть';

  @override
  String get showAll => 'Показать все';

  @override
  String get profileUnavailable => 'Данные профиля пока недоступны';

  @override
  String get temperament => 'Темперамент';

  @override
  String get thinkingStyle => 'Стиль мышления';

  @override
  String get studyProfile => 'Учебный профиль';

  @override
  String get values => 'Ценности';

  @override
  String get direction => 'Направление';

  @override
  String get antiDirection => 'Анти-направление';

  @override
  String get alternatives => 'Альтернативные профессии';

  @override
  String get similarity => 'Схожесть';

  @override
  String get coursesTitle => 'Курсы по результатам';

  @override
  String get courseTitle => 'Курс';

  @override
  String get aboutCourse => 'О курсе';

  @override
  String get whatYouGet => 'Что ты получишь';

  @override
  String get understandBasics => 'Поймёшь основы этого направления';

  @override
  String get tryProfession => 'Сможешь попробовать себя в профессии';

  @override
  String get practiceSkills => 'Соберёшь первые практические навыки';

  @override
  String get understandSphere => 'Поймёшь подходит ли тебе эта сфера';

  @override
  String get understood => 'Понятно';

  @override
  String get recommendationEmptyBanner =>
      'Пройди модули, чтобы мы подобрали подходящую профессию и показали процент совпадения.';

  @override
  String recommendationPartialBanner(Object completed, Object total) {
    return 'Сейчас это предварительный результат: пройдено $completed из $total модулей. Если завершить все модули, рекомендация станет точнее.';
  }

  @override
  String get whyProfessionEmpty =>
      'После прохождения модулей мы покажем, почему именно эта профессия тебе подходит.';

  @override
  String get whyProfessionDefault =>
      'Эта рекомендация собрана на основе твоих ответов, сильных сторон и интересов.';

  @override
  String get defaultCourseLevel => 'Начальный';

  @override
  String get defaultCourseDuration => '4 недели';

  @override
  String get userNotFoundLoginAgain =>
      'Пользователь не найден. Войдите заново.';
}
