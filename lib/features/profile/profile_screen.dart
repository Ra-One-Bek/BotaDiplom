import 'package:flutter/material.dart';
import 'package:career_guidance_app/app/router.dart';
import 'package:career_guidance_app/features/auth/auth_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthController _auth = AuthController();

  String get _userName {
    final value = _auth.userData?['name'];
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
    return 'Пользователь';
  }

  String get _userEmail {
    final value = _auth.userData?['email'];
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
    return 'email не указан';
  }

  String get _firstLetter {
    final name = _userName.trim();
    if (name.isEmpty) return 'P';
    return name.characters.first.toUpperCase();
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Выйти из аккаунта?'),
        content: const Text('Ты действительно хочешь выйти из аккаунта?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await _auth.logout();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRouter.auth,
      (route) => false,
    );
  }

  void _goToModules() {
    Navigator.pushReplacementNamed(context, AppRouter.main);
  }

  void _goToRecommendations() {
    Navigator.pushReplacementNamed(context, AppRouter.main);
  }

  void _goToAi() {
    Navigator.pushReplacementNamed(context, AppRouter.main);
  }

  Future<void> _refreshProfile() async {
    await _auth.loadSession();
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        actions: [
          IconButton(
            tooltip: 'Обновить',
            onPressed: _refreshProfile,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProfile,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _ProfileHeaderCard(
              name: _userName,
              email: _userEmail,
              firstLetter: _firstLetter,
            ),
            const SizedBox(height: 16),
            const _SectionCard(
              title: 'О приложении',
              children: [
                _InfoTile(
                  icon: Icons.school_outlined,
                  title: 'Назначение',
                  subtitle: 'Профориентация школьников',
                ),
                _InfoTile(
                  icon: Icons.quiz_outlined,
                  title: 'Функция',
                  subtitle: 'Тестирование интересов и направлений',
                ),
                _InfoTile(
                  icon: Icons.auto_awesome_outlined,
                  title: 'Результат',
                  subtitle: 'Подбор профессий по результатам теста',
                ),
                _InfoTile(
                  icon: Icons.smart_toy_outlined,
                  title: 'AI помощник',
                  subtitle: 'Ответы на вопросы по профориентации',
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Мой аккаунт',
              children: [
                _AccountRow(
                  icon: Icons.person_outline,
                  title: 'Имя пользователя',
                  value: _userName,
                ),
                _AccountRow(
                  icon: Icons.alternate_email,
                  title: 'Почта',
                  value: _userEmail,
                ),
                _AccountRow(
                  icon: Icons.verified_user_outlined,
                  title: 'Статус',
                  value: 'Аккаунт активен',
                ),
              ],
            ),
            const SizedBox(height: 16),
            const _SectionCard(
              title: 'Мой прогресс',
              children: [
                _ProgressTipCard(
                  title: 'Модули профориентации',
                  subtitle:
                      'Проходи модули последовательно, чтобы получить более точную рекомендацию.',
                  icon: Icons.dashboard_customize_outlined,
                ),
                _ProgressTipCard(
                  title: 'Итоговые рекомендации',
                  subtitle:
                      'После прохождения модулей смотри подходящие профессии и курсы.',
                  icon: Icons.workspace_premium_outlined,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Быстрые действия',
              children: [
                _ActionTile(
                  icon: Icons.grid_view_rounded,
                  title: 'Перейти к модулям',
                  subtitle: 'Открыть модули профориентации',
                  onTap: _goToModules,
                ),
                _ActionTile(
                  icon: Icons.auto_awesome_rounded,
                  title: 'Посмотреть рекомендации',
                  subtitle: 'Открыть экран итоговых результатов',
                  onTap: _goToRecommendations,
                ),
                _ActionTile(
                  icon: Icons.smart_toy_rounded,
                  title: 'Открыть AI помощника',
                  subtitle: 'Задать вопросы по профессиям',
                  onTap: _goToAi,
                ),
                _ActionTile(
                  icon: Icons.logout_rounded,
                  title: 'Выйти из аккаунта',
                  subtitle: 'Завершить текущую сессию',
                  onTap: _logout,
                  isDestructive: true,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Полезные советы',
              children: [
                _AdviceCard(
                  color: Colors.deepPurple.shade50,
                  icon: Icons.lightbulb_outline,
                  title: 'Проходи все модули',
                  subtitle:
                      'Так система сможет подобрать более точную профессию именно под тебя.',
                ),
                _AdviceCard(
                  color: Colors.blue.shade50,
                  icon: Icons.update_outlined,
                  title: 'Обновляй результат',
                  subtitle:
                      'Если меняешь ответы в модулях, итоговые рекомендации тоже обновляются.',
                ),
                _AdviceCard(
                  color: Colors.green.shade50,
                  icon: Icons.menu_book_outlined,
                  title: 'Изучай курсы',
                  subtitle:
                      'После результата смотри курсы по своему направлению и пробуй себя в профессии.',
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Proffy · профориентация и рекомендации',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  final String name;
  final String email;
  final String firstLetter;

  const _ProfileHeaderCard({
    required this.name,
    required this.email,
    required this.firstLetter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF6C63FF),
            Color(0xFF8E2DE2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.18),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 38,
            backgroundColor: Colors.white.withOpacity(0.22),
            child: Text(
              firstLetter,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            email,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'Твой личный кабинет в Proffy',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 14),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
            ),
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
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
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
    );
  }
}

class _AccountRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _AccountRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.deepPurple),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = isDestructive ? Colors.red : Colors.deepPurple;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: baseColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: baseColor.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: baseColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: isDestructive ? Colors.red.shade700 : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: baseColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressTipCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _ProgressTipCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.07),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
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
    );
  }
}

class _AdviceCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;

  const _AdviceCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}