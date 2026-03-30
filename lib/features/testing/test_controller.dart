import 'package:flutter/material.dart';
import 'package:career_guidance_app/data/models/answer_model.dart';
import 'package:career_guidance_app/data/models/question_model.dart';
import 'package:career_guidance_app/data/repositories/test_repository.dart';
import 'package:career_guidance_app/features/auth/auth_controller.dart';

class TestController extends ChangeNotifier {
  final TestRepository _testRepository = TestRepository();

  bool isLoading = false;
  String? errorMessage;

  List<QuestionModel> questions = [];
  List<AnswerModel> answers = [];

  dynamic lastResult;

  Future<void> loadQuestions() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      questions = await _testRepository.getQuestions();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void selectAnswer(int questionId, int answerOptionId) {
    answers.removeWhere((item) => item.questionId == questionId);
    answers.add(
      AnswerModel(
        questionId: questionId,
        answerOptionId: answerOptionId,
      ),
    );
    notifyListeners();
  }

  int? getSelectedAnswer(int questionId) {
    try {
      return answers.firstWhere((item) => item.questionId == questionId).answerOptionId;
    } catch (_) {
      return null;
    }
  }

  bool get isTestCompleted => questions.isNotEmpty && answers.length == questions.length;

  Future<bool> submitAnswers() async {
    try {
      final userId = AuthController.instance.currentUserId;

      if (userId == null) {
        throw Exception('Пользователь не авторизован');
      }

      isLoading = true;
      errorMessage = null;
      notifyListeners();

      lastResult = await _testRepository.submitAnswers(
        userId: userId,
        answers: answers,
      );

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}