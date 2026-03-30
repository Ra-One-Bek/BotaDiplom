import 'package:flutter/material.dart';
import 'package:career_guidance_app/features/ai/ai_controller.dart';
import 'package:career_guidance_app/shared/widgets/app_drawer.dart';

class AiScreen extends StatefulWidget {
  const AiScreen({super.key});

  @override
 State<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends State<AiScreen> {
  final AiController _controller = AiController();
  final TextEditingController _questionController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _questionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendQuestion() async {
    final question = _questionController.text.trim();
    if (question.isEmpty) return;

    _questionController.clear();

    await _controller.sendQuestion(question);

    await Future.delayed(const Duration(milliseconds: 100));

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
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
            title: const Text('AI Помощник'),
          ),
          drawer: const AppDrawer(),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: _controller.messages.isEmpty
                      ? const Center(
                          child: Text(
                            'Задайте вопрос по профориентации',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: _controller.messages.length,
                          itemBuilder: (context, index) {
                            final message = _controller.messages[index];
                            final isUser = message.role == 'user';

                            return Align(
                              alignment: isUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                padding: const EdgeInsets.all(12),
                                constraints: const BoxConstraints(maxWidth: 500),
                                decoration: BoxDecoration(
                                  color: isUser
                                      ? Colors.indigo.shade100
                                      : Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(message.text),
                              ),
                            );
                          },
                        ),
                ),
                if (_controller.errorMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _controller.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 12),
                TextField(
                  controller: _questionController,
                  minLines: 1,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Введите вопрос',
                    hintText:
                        'Например: Что выбрать между программистом и дизайнером?',
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _controller.isLoading ? null : _sendQuestion,
                  child: _controller.isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Отправить'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}