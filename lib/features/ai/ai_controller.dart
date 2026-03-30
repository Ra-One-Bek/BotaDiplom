import 'package:flutter/material.dart';
import 'package:career_guidance_app/data/models/ai_message_model.dart';
import 'package:career_guidance_app/data/repositories/ai_repository.dart';

class AiController extends ChangeNotifier {
  final AiRepository _repository = AiRepository();

  bool isLoading = false;
  String? errorMessage;

  final List<AiMessageModel> messages = [];

  Future<void> sendQuestion(String question) async {
    if (question.trim().isEmpty) return;

    // сообщение пользователя
    messages.add(
      AiMessageModel(
        role: 'user',
        text: question,
      ),
    );

    errorMessage = null;
    isLoading = true;
    notifyListeners();

    try {
      final answer = await _repository.sendQuestion(question);

      // ответ от backend (ВАЖНО)
      messages.add(
        AiMessageModel(
          role: 'assistant',
          text: answer,
        ),
      );
    } catch (e) {
      errorMessage = e.toString();

      messages.add(
        AiMessageModel(
          role: 'assistant',
          text: 'Ошибка подключения к серверу',
        ),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}