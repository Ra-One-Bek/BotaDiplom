import 'package:flutter/material.dart';
import 'package:career_guidance_app/features/ai/ai_controller.dart';

class AiScreen extends StatefulWidget {
  const AiScreen({super.key});

  @override
  State<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends State<AiScreen> {
  final AiController _controller = AiController();
  final TextEditingController _questionController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<String> _quickQuestions = const [
    'Какие профессии подходят тем, кто любит математику?',
    'Чем отличается программист от дизайнера?',
    'Какие навыки нужны для врача?',
  ];

  @override
  void dispose() {
    _controller.dispose();
    _questionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendQuestion([String? quickText]) async {
    final text = (quickText ?? _questionController.text).trim();

    if (text.isEmpty) return;

    _questionController.clear();

    await _controller.sendQuestion(text);

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
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('AI помощник'),
          ),
          body: Column(
            children: [
              Expanded(
                child: _controller.messages.isEmpty
                    ? ListView(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                        children: [
                          Container(
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28),
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
                                  Icons.smart_toy_rounded,
                                  color: Colors.white,
                                  size: 32,
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  'Задай вопрос AI-консультанту',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Спроси о профессиях, направлениях, навыках и выборе будущей специальности.',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: Colors.white.withOpacity(0.95),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Быстрые вопросы',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ..._quickQuestions.map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: OutlinedButton(
                                onPressed: () => _sendQuestion(item),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(item),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                        itemCount: _controller.messages.length,
                        itemBuilder: (context, index) {
                          final message = _controller.messages[index];
                          final isUser = message.role == 'user';

                          return Align(
                            alignment: isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.78,
                              ),
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: isUser
                                    ? theme.colorScheme.primaryContainer
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: theme.colorScheme.outlineVariant,
                                ),
                              ),
                              child: Text(
                                message.text,
                                style: theme.textTheme.bodyLarge,
                              ),
                            ),
                          );
                        },
                      ),
              ),
              if (_controller.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Text(
                    _controller.errorMessage!,
                    style: TextStyle(
                      color: theme.colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _questionController,
                          minLines: 1,
                          maxLines: 4,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) {
                            if (!_controller.isLoading) {
                              _sendQuestion();
                            }
                          },
                          decoration: const InputDecoration(
                            hintText: 'Например: какая профессия подойдет мне?',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 56,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _controller.isLoading ? null : _sendQuestion,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: _controller.isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.arrow_upward_rounded),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}