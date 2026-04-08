import 'package:flutter/material.dart';
import 'package:career_guidance_app/data/models/module_question_model.dart';
import 'package:career_guidance_app/data/models/module_submit_model.dart';
import 'package:career_guidance_app/data/services/assessment_service.dart';
import 'package:career_guidance_app/features/auth/auth_controller.dart';

class ModuleTestScreen extends StatefulWidget {
  final String moduleCode;

  const ModuleTestScreen({
    super.key,
    required this.moduleCode,
  });

  @override
  State<ModuleTestScreen> createState() => _ModuleTestScreenState();
}

class _ModuleTestScreenState extends State<ModuleTestScreen> {
  final AssessmentService _assessmentService = AssessmentService();
  final AuthController _authController = AuthController();

  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _errorMessage;
  ModuleQuestionsResponseModel? _data;

  final Map<int, int> _selectedAnswers = {};

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final response = await _assessmentService.getModuleQuestions(
        moduleCode: widget.moduleCode,
        accessToken: _authController.accessToken,
      );

      if (!mounted) return;

      setState(() {
        _data = response;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submit() async {
    final userId = _authController.currentUserId;
    final data = _data;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не найден userId')),
      );
      return;
    }

    if (data == null) return;

    if (_selectedAnswers.length != data.questions.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Пожалуйста, ответьте на все вопросы'),
        ),
      );
      return;
    }

    try {
      setState(() {
        _isSubmitting = true;
      });

      await _assessmentService.submitModule(
        moduleCode: widget.moduleCode,
        userId: userId,
        accessToken: _authController.accessToken,
        answers: data.questions.map((question) {
          return ModuleAnswerSubmitItem(
            questionId: question.id,
            answerOptionId: _selectedAnswers[question.id]!,
          );
        }).toList(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Модуль успешно завершён')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _data;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Прохождение модуля'),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? _ModuleErrorState(
                    message: _errorMessage!,
                    onRetry: _loadQuestions,
                  )
                : data == null
                    ? _ModuleErrorState(
                        message: 'Данные модуля не найдены',
                        onRetry: _loadQuestions,
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: ListView(
                              padding: const EdgeInsets.all(16),
                              children: [
                                Text(
                                  data.moduleTitle,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  data.moduleDescription,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                                const SizedBox(height: 20),
                                ...data.questions.map(
                                  (question) => Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${question.order}. ${question.text}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                            if (question.description != null &&
                                                question.description!.isNotEmpty) ...[
                                              const SizedBox(height: 6),
                                              Text(question.description!),
                                            ],
                                            const SizedBox(height: 12),
                                            ...question.options.map(
                                              (option) => RadioListTile<int>(
                                                value: option.id,
                                                groupValue:
                                                    _selectedAnswers[question.id],
                                                contentPadding: EdgeInsets.zero,
                                                title: Text(option.text),
                                                onChanged: (value) {
                                                  if (value == null) return;
                                                  setState(() {
                                                    _selectedAnswers[question.id] =
                                                        value;
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 80),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isSubmitting ? null : _submit,
                                child: _isSubmitting
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text('Завершить модуль'),
                              ),
                            ),
                          ),
                        ],
                      ),
      ),
    );
  }
}

class _ModuleErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ModuleErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 42),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }
}