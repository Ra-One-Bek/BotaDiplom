import 'package:flutter/material.dart';
import 'package:career_guidance_app/data/models/profession_model.dart';
import 'package:career_guidance_app/features/recommendations/recommendations_controller.dart';

class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  final RecommendationsController _controller = RecommendationsController();

  @override
  void initState() {
    super.initState();
    _controller.loadRecommendations();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'it':
        return Icons.code_rounded;
      case 'design':
      case 'creative':
        return Icons.palette_rounded;
      case 'medicine':
        return Icons.local_hospital_rounded;
      case 'business':
      case 'management':
        return Icons.business_center_rounded;
      case 'education':
        return Icons.school_rounded;
      case 'engineering':
        return Icons.engineering_rounded;
      default:
        return Icons.auto_awesome_rounded;
    }
  }

  String _getPrettyCategory(String category) {
    switch (category.toLowerCase()) {
      case 'it':
        return 'IT';
      case 'design':
        return 'Design';
      case 'creative':
        return 'Creative';
      case 'medicine':
        return 'Medicine';
      case 'business':
        return 'Business';
      case 'management':
        return 'Management';
      case 'education':
        return 'Education';
      case 'engineering':
        return 'Engineering';
      default:
        return category;
    }
  }

  String _formatDirection(String value) {
    if (value.trim().isEmpty) return '—';

    switch (value.toLowerCase()) {
      case 'it':
        return 'IT';
      case 'business':
        return 'Business';
      case 'medicine':
        return 'Medicine';
      case 'creative':
        return 'Creative';
      case 'education':
        return 'Education';
      case 'engineering':
        return 'Engineering';
      default:
        return value;
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
            title: const Text('Рекомендации'),
          ),
          body: _buildBody(theme),
        );
      },
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_controller.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_controller.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            _controller.errorMessage!,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge,
          ),
        ),
      );
    }

    if (_controller.recommendationData == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Сначала пройди тест, чтобы получить рекомендации',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge,
          ),
        ),
      );
    }

    final topProfession = _controller.topProfession;
    final alternatives = _controller.alternatives;
    final summary = _controller.summary;
    final finalDirection = _controller.finalDirection;
    final ruleDirection = _controller.ruleBasedDirection;
    final mlDirection = _controller.mlPredictedDirection;
    final mlConfidence = _controller.mlConfidence;
    final source = _controller.source;
    final modelVersion = _controller.modelVersion;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.secondary,
                  theme.colorScheme.secondaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  _getCategoryIcon(finalDirection),
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(height: 14),
                Text(
                  'Твое направление',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.95),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDirection(finalDirection),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  summary,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withOpacity(0.96),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Гибридный анализ',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(
                    label: 'Итог',
                    value: _formatDirection(finalDirection),
                  ),
                  _InfoRow(
                    label: 'Rule-based',
                    value: _formatDirection(ruleDirection),
                  ),
                  _InfoRow(
                    label: 'ML prediction',
                    value: _formatDirection(mlDirection),
                  ),
                  _InfoRow(
                    label: 'ML confidence',
                    value: '${(mlConfidence * 100).toStringAsFixed(1)}%',
                  ),
                  _InfoRow(
                    label: 'Источник',
                    value: source,
                  ),
                  _InfoRow(
                    label: 'Модель',
                    value: modelVersion,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'Основная профессия',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),

          if (topProfession == null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Основная профессия пока не найдена',
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            )
          else
            _ProfessionCard(
              profession: topProfession,
              icon: _getCategoryIcon(topProfession.category),
              categoryLabel: _getPrettyCategory(topProfession.category),
            ),

          const SizedBox(height: 20),

          Text(
            'Альтернативные профессии',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Дополнительные варианты, подходящие твоему профилю.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          if (alternatives.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Альтернативные профессии пока отсутствуют',
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            )
          else
            ...alternatives.map(
              (profession) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ProfessionCard(
                  profession: profession,
                  icon: _getCategoryIcon(profession.category),
                  categoryLabel: _getPrettyCategory(profession.category),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfessionCard extends StatelessWidget {
  final ProfessionModel profession;
  final IconData icon;
  final String categoryLabel;

  const _ProfessionCard({
    required this.profession,
    required this.icon,
    required this.categoryLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profession.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      categoryLabel,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    profession.description,
                    style: theme.textTheme.bodyMedium,
                  ),
                  if (profession.score != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      'Match score: ${profession.score!.toStringAsFixed(1)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  if (profession.tags.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: profession.tags
                          .map(
                            (tag) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                tag,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}