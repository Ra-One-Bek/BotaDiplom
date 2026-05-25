import 'package:career_guidance_app/features/modules/module_test_screen.dart';
import 'package:career_guidance_app/features/modules/recommendation_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:career_guidance_app/app/router.dart';
import 'package:career_guidance_app/data/models/assessment_module_model.dart';
import 'package:career_guidance_app/data/models/modules_progress_model.dart';
import 'package:career_guidance_app/data/services/assessment_service.dart';
import 'package:career_guidance_app/features/auth/auth_controller.dart';
import '../../core/services/localization_extension.dart';

class ModulesScreen extends StatefulWidget {
  const ModulesScreen({super.key});

  @override
  State<ModulesScreen> createState() => _ModulesScreenState();
}

class _ModulesScreenState extends State<ModulesScreen> {
  final AuthController _authController = AuthController();
  final AssessmentService _assessmentService = AssessmentService();

  bool _isLoading = true;
  String? _errorMessage;
  ModulesProgressModel? _progress;

  @override
  void initState() {
    super.initState();
    _loadModules();
  }

  Future<void> _loadModules() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final userId = _authController.currentUserId;
      if (userId == null) {
        throw Exception('Пользователь не найден. Войдите заново.');
      }

      final progress = await _assessmentService.getModulesProgress(
        userId: userId,
        accessToken: _authController.accessToken,
      );

      if (!mounted) return;

      setState(() {
        _progress = progress;
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

  Future<void> _openModule(AssessmentModuleModel module) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ModuleTestScreen(moduleCode: module.code),
      ),
    );

    if (result == true) {
      await _loadModules();
    }
  }

  void _openRecommendations() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RecommendationResultScreen(),
      ),
    );
  }
  Future<void> _logout() async {
    await _authController.logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRouter.auth,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.modulesAppBarTitle),
        actions: [
          IconButton(
            tooltip: context.loc.refresh,
            onPressed: _loadModules,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: context.loc.logout,
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? _ErrorState(
                    message: _errorMessage!,
                    onRetry: _loadModules,
                  )
                : _progress == null
                    ? _ErrorState(
                        message: context.loc.modulesNoData,
                        onRetry: _loadModules,
                      )
                    : RefreshIndicator(
                        onRefresh: _loadModules,
                        child: ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            _ProgressCard(progress: _progress!),
                            const SizedBox(height: 16),
                            Text(
                              context.loc.modulesIntro,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ..._progress!.items.map(
                              (module) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _ModuleCard(
                                  module: module,
                                  onTap: () => _openModule(module),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: _progress!.completedModules ==
                                      _progress!.totalModules
                                  ? _openRecommendations
                                  : null,
                              icon: const Icon(Icons.workspace_premium_outlined),
                              label: Text(context.loc.viewRecommendations),
                            ),
                          ],
                        ),
                      ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final ModulesProgressModel progress;

  const _ProgressCard({required this.progress});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final value = progress.totalModules == 0
        ? 0.0
        : progress.completedModules / progress.totalModules;

    return Container(
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
            Icons.psychology_alt_outlined,
            color: Colors.white,
            size: 30,
          ),
          const SizedBox(height: 14),
          Text(
            context.loc.yourProgress,
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.loc.modulesCompleted(
              progress.completedModules,
              progress.totalModules,
            ),
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withOpacity(0.95),
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 12,
              backgroundColor: Colors.white.withOpacity(0.28),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${progress.percent}%',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  final AssessmentModuleModel module;
  final VoidCallback onTap;

  const _ModuleCard({
    required this.module,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;


    return Card(
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: _statusColor(context).withOpacity(0.14),
                child: Icon(
                  _statusIcon(),
                  color: _statusColor(context),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      module.localizedTitle(languageCode),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      module.localizedDescription(languageCode),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _statusColor(context).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        _statusText(context),
                        style: TextStyle(
                          color: _statusColor(context),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  IconData _statusIcon() {
    if (module.isCompleted) {
      return Icons.check_circle;
    }
    if (module.isInProgress) {
      return Icons.timelapse;
    }
    return Icons.radio_button_unchecked;
  }

  String _statusText(BuildContext context) {
    if (module.isCompleted) {
      return context.loc.moduleCompleted;
    }
    if (module.isInProgress) {
      return context.loc.moduleInProgress;
    }
    return context.loc.moduleNotStarted;
  }

  Color _statusColor(BuildContext context) {
    final theme = Theme.of(context);

    if (module.isCompleted) {
      return Colors.green;
    }
    if (module.isInProgress) {
      return theme.colorScheme.primary;
    }
    return theme.colorScheme.outline;
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorState({
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
              child: Text(context.loc.retry),
            ),
          ],
        ),
      ),
    );
  }
}