import 'package:flutter/material.dart';
import 'package:career_guidance_app/app/router.dart';
import 'package:career_guidance_app/features/testing/test_controller.dart';
import 'package:career_guidance_app/shared/widgets/app_drawer.dart';

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

  Future<void> _submitTest() async {
    final success = await _controller.submitAnswers();

    if (!mounted) return;

    if (success) {
      Navigator.pushNamed(context, AppRouter.recommendations);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_controller.errorMessage ?? 'Ошибка отправки теста'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Тестирование'),
          ),
          drawer: const AppDrawer(),
          body: _controller.isLoading && _controller.questions.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : _controller.errorMessage != null && _controller.questions.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          _controller.errorMessage!,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: _controller.questions.length,
                              itemBuilder: (context, index) {
                                final question = _controller.questions[index];
                                final selectedAnswer =
                                    _controller.getSelectedAnswer(question.id);

                                return Card(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          question.text,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'Категория: ${question.category}',
                                          style: TextStyle(
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        ...question.options.map(
                                          (option) => RadioListTile<int>(
                                            value: option.id,
                                            groupValue: selectedAnswer,
                                            title: Text(option.text),
                                            onChanged: (value) {
                                              if (value != null) {
                                                _controller.selectAnswer(
                                                  question.id,
                                                  value,
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _controller.isTestCompleted &&
                                    !_controller.isLoading
                                ? _submitTest
                                : null,
                            child: _controller.isLoading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Завершить тест'),
                          ),
                        ],
                      ),
                    ),
        );
      },
    );
  }
}