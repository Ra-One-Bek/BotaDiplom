import 'package:flutter/material.dart';
import 'package:career_guidance_app/app/router.dart';
import 'package:career_guidance_app/features/auth/auth_controller.dart';
import '../../core/services/localization_extension.dart';

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
        title: Text(context.loc.logoutTitle),
        content: Text(context.loc.logoutDescription),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.loc.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.loc.logout),
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
        title: Text(context.loc.profileTitle),
        actions: [
          IconButton(
          tooltip: context.loc.refresh,
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
            _SectionCard(
              title: context.loc.aboutApp,
              children: [
                _InfoTile(
                  icon: Icons.school_outlined,
                  title: context.loc.purpose,
                  subtitle: context.loc.purposeDescription,
                ),
                _InfoTile(
                  icon: Icons.quiz_outlined,
                  title: context.loc.function,
                  subtitle: context.loc.functionDescription,
                ),
                _InfoTile(
                  icon: Icons.auto_awesome_outlined,
                  title: context.loc.result,
                  subtitle: context.loc.resultDescription,
                ),
                _InfoTile(
                  icon: Icons.smart_toy_outlined,
                  title: context.loc.aiAssistant,
                  subtitle: context.loc.aiAssistantDescription,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: context.loc.myAccount,
              children: [
                _AccountRow(
                  icon: Icons.person_outline,
                  title: context.loc.userName,
                  value: _userName,
                ),
                _AccountRow(
                  icon: Icons.alternate_email,
                  title: context.loc.email,
                  value: _userEmail,
                ),
                _AccountRow(
                  icon: Icons.verified_user_outlined,
                  title: context.loc.status,
                  value: context.loc.accountActive,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: context.loc.myProgress,
              children: [
                _ProgressTipCard(
                  title: context.loc.modulesTitle,
                  subtitle: context.loc.modulesDescription,
                  icon: Icons.dashboard_customize_outlined,
                ),
                _ProgressTipCard(
                  title: context.loc.recommendationsTitle,
                  subtitle: context.loc.recommendationsDescription,
                  icon: Icons.workspace_premium_outlined,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: context.loc.quickActions,
              children: [
                _ActionTile(
                  icon: Icons.grid_view_rounded,
                  title: context.loc.goToModules,
                  subtitle: context.loc.goToModulesDescription,
                  onTap: _goToModules,
                ),
                _ActionTile(
                  icon: Icons.auto_awesome_rounded,
                  title: context.loc.openRecommendations,
                  subtitle: context.loc.openRecommendationsDescription,
                  onTap: _goToRecommendations,
                ),
                _ActionTile(
                  icon: Icons.smart_toy_rounded,
                  title: context.loc.openAi,
                  subtitle: context.loc.openAiDescription,
                  onTap: _goToAi,
                ),
                _ActionTile(
                  icon: Icons.language_rounded,
                  title: context.loc.language,
                  subtitle: 'en/ru/kz',
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRouter.language,
                    );
                  },
                ),
                _ActionTile(
                  icon: Icons.logout_rounded,
                  title: context.loc.logoutAction,
                  subtitle: context.loc.logoutActionDescription,
                  onTap: _logout,
                  isDestructive: true,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: context.loc.helpfulTips,
              children: [
                _AdviceCard(
                  color: Colors.deepPurple.shade50,
                  icon: Icons.lightbulb_outline,
                  title: context.loc.tipModules,
                  subtitle: context.loc.tipModulesDescription,
                ),
                _AdviceCard(
                  color: Colors.blue.shade50,
                  icon: Icons.update_outlined,
                  title: context.loc.tipUpdate,
                  subtitle: context.loc.tipUpdateDescription,
                ),
                _AdviceCard(
                  color: Colors.green.shade50,
                  icon: Icons.menu_book_outlined,
                  title: context.loc.tipCourses,
                  subtitle: context.loc.tipCoursesDescription,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              context.loc.profileFooter,
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
            child: Text(
              context.loc.profileCabinet,
              style: const TextStyle(
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