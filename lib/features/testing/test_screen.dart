import 'package:flutter/material.dart';
import 'package:career_guidance_app/features/testing/test_controller.dart';
import 'package:career_guidance_app/shared/widgets/screen_padding.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final TestController _controller = TestController();

  @override
  void initState() {
    super.initState();
    _controller.loadQuestions();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submitAnswers() async {
    final success = await _controller.submitAnswers();

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Тест успешно завершен. Перейди во вкладку "Профессии"'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_controller.errorMessage ?? 'Ошибка отправки ответов'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Профориентационный тест'),
          ),
          body: _buildBody(theme),
        );
      },
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_controller.isLoading && _controller.questions.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_controller.errorMessage != null && _controller.questions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            _controller.errorMessage ?? 'Произошла ошибка',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge,
          ),
        ),
      );
    }

    if (_controller.questions.isEmpty) {
      return Center(
        child: Text(
          'Вопросы пока недоступны',
          style: theme.textTheme.bodyLarge,
        ),
      );
    }

    final answeredCount = _controller.answers.length;
    final totalCount = _controller.questions.length;
    final progress = totalCount == 0 ? 0.0 : answeredCount / totalCount;

    return SafeArea(
      child: ScreenPadding(
        child: ListView(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primaryContainer,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.quiz_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Пройди тест и узнай свое направление',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ответь на вопросы, чтобы получить персональные рекомендации по профессиям.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.95),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      backgroundColor: Colors.white.withOpacity(0.25),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Отвечено: $answeredCount из $totalCount',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.95),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            ..._controller.questions.asMap().entries.map((entry) {
              final index = entry.key;
              final question = entry.value;
              final selectedAnswerId = _controller.getSelectedAnswer(question.id);

              final questionText = (question.text).trim().isEmpty
                  ? 'Текст вопроса отсутствует'
                  : question.text;

              final questionCategory =
                  ((question.category).trim().isEmpty) ? 'Без категории' : question.category;

              final options = question.options;

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'Вопрос ${index + 1}',
                            style: TextStyle(
                              color: theme.colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          questionText,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          questionCategory,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 14),

                        if (options.isEmpty)
                          Text(
                            'Варианты ответа отсутствуют',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          )
                        else
                          ...options.map<Widget>((option) {
                            final optionText = (option.text).trim().isEmpty
                                ? 'Пустой вариант'
                                : option.text;
                            final isSelected = selectedAnswerId == option.id;

                            return Padding(
                              key: ValueKey('${question.id}_${option.id}'),
                              padding: const EdgeInsets.only(bottom: 10),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  _controller.selectAnswer(
                                    question.id,
                                    option.id,
                                  );
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? theme.colorScheme.primaryContainer
                                        : theme.colorScheme.surface,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected
                                          ? theme.colorScheme.primary
                                          : theme.colorScheme.outlineVariant,
                                      width: isSelected ? 1.4 : 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          optionText,
                                          style: theme.textTheme.bodyLarge?.copyWith(
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Icon(
                                        isSelected
                                            ? Icons.check_circle
                                            : Icons.radio_button_unchecked,
                                        color: isSelected
                                            ? theme.colorScheme.primary
                                            : theme.colorScheme.outline,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),

            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: _controller.isLoading ? null : _submitAnswers,
              child: _controller.isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Завершить тест'),
            ),
          ],
        ),
      ),
    );
  }
}