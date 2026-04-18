import 'package:flutter/material.dart';
import 'package:career_guidance_app/features/ai/ai_controller.dart';
import 'package:career_guidance_app/features/auth/auth_controller.dart';

class AiScreen extends StatefulWidget {
  const AiScreen({super.key});

  @override
  State<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends State<AiScreen> {
  final AiController _controller = AiController();
  final AuthController _auth = AuthController();

  final TextEditingController _questionController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _questionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String get _userName {
    final value = _auth.userData?['name'];
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
    return 'друг';
  }

  List<String> get _quickQuestions {
    final user = _auth.userData ?? {};
    final profession = (user['topProfession'] ?? user['profession'] ?? '')
        .toString()
        .toLowerCase();

    if (profession.contains('ui/ux') || profession.contains('дизайн')) {
      return const [
        'С чего начать путь в UI/UX дизайне?',
        'Какие навыки нужны UI/UX дизайнеру?',
        'Какие 3 проекта добавить в портфолио дизайнера?',
        'Что изучать сначала: UI или UX?',
      ];
    }

    if (profession.contains('frontend') || profession.contains('разработ')) {
      return const [
        'Что учить сначала для frontend?',
        'Нужно ли мне учить React сразу?',
        'Какие проекты сделать для первого портфолио?',
        'Как стать frontend разработчиком с нуля?',
      ];
    }

    if (profession.contains('менедж')) {
      return const [
        'Что делает менеджер проектов каждый день?',
        'Какие навыки важнее всего менеджеру?',
        'Чем project manager отличается от product manager?',
        'Подходит ли мне менеджмент без программирования?',
      ];
    }

    return const [
      'Какая профессия может мне подойти?',
      'С чего начать выбор будущей профессии?',
      'Какие навыки сейчас самые полезные?',
      'Как понять, что профессия действительно мне подходит?',
    ];
  }

  Future<void> _sendQuestion([String? quickText]) async {
    final text = (quickText ?? _questionController.text).trim();
    if (text.isEmpty) return;

    _questionController.clear();

    await _controller.sendQuestion(text);

    await Future.delayed(const Duration(milliseconds: 120));
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 140,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOut,
    );
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
            actions: [
              IconButton(
                tooltip: 'Очистить чат',
                onPressed: _controller.messages.isEmpty
                    ? null
                    : () {
                        setState(() {
                          _controller.messages.clear();
                          _controller.errorMessage = null;
                        });
                      },
                icon: const Icon(Icons.delete_outline_rounded),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: _controller.messages.isEmpty
                    ? ListView(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                        children: [
                          _AiHeroCard(userName: _userName),
                          const SizedBox(height: 18),
                          Text(
                            'Подходящие быстрые вопросы',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: _quickQuestions
                                .map(
                                  (item) => _QuickQuestionChip(
                                    text: item,
                                    onTap: () => _sendQuestion(item),
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: 20),
                          const _AiInfoCard(
                            icon: Icons.auto_awesome_rounded,
                            title: 'Что умеет AI помощник',
                            subtitle:
                                'Он может объяснить профессии, навыки, направления обучения и помочь понять, что тебе попробовать дальше.',
                          ),
                          const SizedBox(height: 12),
                          const _AiInfoCard(
                            icon: Icons.school_outlined,
                            title: 'О чём лучше спрашивать',
                            subtitle:
                                'Например: что учить для frontend, как стать дизайнером, чем отличаются профессии, какие навыки мне развивать.',
                          ),
                        ],
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                        itemCount: _controller.messages.length +
                            (_controller.isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (_controller.isLoading &&
                              index == _controller.messages.length) {
                            return const _TypingBubble();
                          }

                          final message = _controller.messages[index];
                          final isUser = message.role == 'user';

                          if (isUser) {
                            return _UserBubble(text: message.text);
                          }

                          return _AiBubble(
                            text: message.text,
                            onQuickTap: (value) => _sendQuestion(value),
                          );
                        },
                      ),
              ),
              if (_controller.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _controller.errorMessage!,
                      style: TextStyle(
                        color: theme.colorScheme.onErrorContainer,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: theme.colorScheme.outlineVariant,
                            ),
                          ),
                          child: TextField(
                            controller: _questionController,
                            minLines: 1,
                            maxLines: 5,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) {
                              if (!_controller.isLoading) {
                                _sendQuestion();
                              }
                            },
                            decoration: const InputDecoration(
                              hintText:
                                  'Например: что мне изучать для UI/UX?',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 56,
                        height: 56,
                        child: FilledButton(
                          onPressed:
                              _controller.isLoading ? null : _sendQuestion,
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: const Icon(Icons.arrow_upward_rounded),
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

class _AiHeroCard extends StatelessWidget {
  final String userName;

  const _AiHeroCard({
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
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
          const CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white24,
            child: Icon(
              Icons.smart_toy_rounded,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Привет, $userName',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Я помогу тебе разобраться в профессиях, навыках, обучении и первых шагах в подходящем направлении.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withOpacity(0.95),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickQuestionChip extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _QuickQuestionChip({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      onPressed: onTap,
      avatar: const Icon(Icons.flash_on_rounded, size: 18),
      label: Text(text),
      side: BorderSide(
        color: Theme.of(context).colorScheme.outlineVariant,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}

class _AiInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _AiInfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.deepPurple.withOpacity(0.10),
              child: Icon(icon, color: Colors.deepPurple),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserBubble extends StatelessWidget {
  final String text;

  const _UserBubble({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: theme.textTheme.bodyLarge?.copyWith(
            height: 1.4,
          ),
        ),
      ),
    );
  }
}

class _AiBubble extends StatelessWidget {
  final String text;
  final ValueChanged<String> onQuickTap;

  const _AiBubble({
    required this.text,
    required this.onQuickTap,
  });

  List<String> _extractParagraphs(String input) {
    return input
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  bool _isBullet(String line) {
    return line.startsWith('- ') ||
        line.startsWith('• ') ||
        line.startsWith('* ');
  }

  String _clearBullet(String line) {
    return line
        .replaceFirst('- ', '')
        .replaceFirst('• ', '')
        .replaceFirst('* ', '')
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final parts = _extractParagraphs(text);

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.86,
        ),
        margin: const EdgeInsets.only(bottom: 14),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: BorderSide(
              color: theme.colorScheme.outlineVariant,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Color(0xFFEDE7F6),
                      child: Icon(
                        Icons.auto_awesome_rounded,
                        size: 18,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'AI помощник',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ...parts.map((line) {
                  if (_isBullet(line)) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Icon(
                              Icons.check_circle_rounded,
                              size: 18,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _clearBullet(line),
                              style: theme.textTheme.bodyLarge?.copyWith(
                                height: 1.45,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      line,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.45,
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _MiniActionChip(
                      label: 'Сделай короче',
                      onTap: () => onQuickTap('Сделай ответ короче и проще'),
                    ),
                    _MiniActionChip(
                      label: 'Что делать дальше',
                      onTap: () => onQuickTap('Какие мои следующие шаги?'),
                    ),
                    _MiniActionChip(
                      label: 'Какие навыки',
                      onTap: () => onQuickTap(
                        'Какие ключевые навыки нужно развивать?',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniActionChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _MiniActionChip({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.deepPurple.withOpacity(0.08),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 10),
            Text(
              'AI думает...',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}