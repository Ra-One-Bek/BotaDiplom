import 'package:flutter/material.dart';
import 'package:career_guidance_app/data/services/assessment_service.dart';
import 'package:career_guidance_app/features/auth/auth_controller.dart';
import 'package:career_guidance_app/features/modules/recommendation_refresh_bus.dart';

class RecommendationResultScreen extends StatefulWidget {
  const RecommendationResultScreen({super.key});

  @override
  State<RecommendationResultScreen> createState() =>
      _RecommendationResultScreenState();
}

class _RecommendationResultScreenState extends State<RecommendationResultScreen> {
  final _service = AssessmentService();
  final _auth = AuthController();

  bool _loading = true;
  String? _errorMessage;
  Map<String, dynamic>? _data;

  @override
  void initState() {
    super.initState();
    RecommendationRefreshBus.instance.addListener(_onExternalRefresh);
    _load();
  }

  @override
  void dispose() {
    RecommendationRefreshBus.instance.removeListener(_onExternalRefresh);
    super.dispose();
  }

  void _onExternalRefresh() {
    _load(silent: true);
  }

  Future<void> _load({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _loading = true;
        _errorMessage = null;
      });
    }

    try {
      final userId = _auth.currentUserId;
      if (userId == null) {
        throw Exception('Пользователь не найден. Войдите заново.');
      }

      final data = await _service.getRecommendations(
        userId: userId,
        accessToken: _auth.accessToken,
      );

      if (!mounted) return;
      setState(() {
        _data = data;
        _errorMessage = null;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Итог')),
        body: _ErrorState(
          message: _errorMessage!,
          onRetry: _load,
        ),
      );
    }

    final data = _data ?? <String, dynamic>{};
    final top = data['topProfession'];
    final alternatives = (data['alternatives'] as List?) ?? const [];
    final profile = (data['profile'] as Map?)?.cast<String, dynamic>() ?? {};
    final completion =
        (data['completion'] as Map?)?.cast<String, dynamic>() ?? {};
    final courses = (data['recommendedCourses'] as List?) ?? const [];
    final explanation = data['explanation']?.toString();

    final completedModules = (completion['completedModules'] ?? 0) as int;
    final totalModules = (completion['totalModules'] ?? 0) as int;
    final isPartial = completion['isPartial'] == true;
    final isEmpty = completion['isEmpty'] == true;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Итог'),
        actions: [
          IconButton(
            tooltip: 'Обновить',
            onPressed: _load,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _HeroBlock(
              profession: top,
              completion: completion,
              explanation: explanation,
            ),
            if (isEmpty)
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: _InfoBanner(
                  text:
                      'Пройди модули, чтобы мы подобрали подходящую профессию и показали процент совпадения.',
                ),
              ),
            if (!isEmpty && isPartial)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: _InfoBanner(
                  text:
                      'Сейчас это предварительный результат: пройдено $completedModules из $totalModules модулей. Если завершить все модули, рекомендация станет точнее.',
                ),
              ),
            const SizedBox(height: 16),
            _ProfilePreview(profile: profile),
            const SizedBox(height: 16),
            _WhyThisProfessionBlock(
              profession: top,
              explanation: explanation,
              isEmpty: isEmpty,
            ),
            const SizedBox(height: 16),
            _Alternatives(alternatives: alternatives),
            const SizedBox(height: 16),
            _CoursesBlock(courses: courses),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _HeroBlock extends StatelessWidget {
  final dynamic profession;
  final Map<String, dynamic> completion;
  final String? explanation;

  const _HeroBlock({
    required this.profession,
    required this.completion,
    required this.explanation,
  });

  @override
  Widget build(BuildContext context) {
    final percent = ((profession?['matchPercent'] ?? 0) as num).toInt();
    final professionName =
        profession?['name']?.toString() ?? 'Профессия пока не определена';
    final description = profession?['description']?.toString() ??
        'Чтобы получить точный результат, пройди хотя бы один модуль.';
    final completionPercent = ((completion['percent'] ?? 0) as num).toInt();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF8E2DE2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Твоя профессия',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 140,
                height: 140,
                child: CircularProgressIndicator(
                  value: (percent / 100).clamp(0, 1).toDouble(),
                  strokeWidth: 10,
                  backgroundColor: Colors.white24,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              Text(
                '$percent%',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            professionName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Прогресс модулей: $completionPercent%',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (explanation != null && explanation!.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              explanation!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProfilePreview extends StatefulWidget {
  final Map<String, dynamic> profile;

  const _ProfilePreview({
    required this.profile,
  });

  @override
  State<_ProfilePreview> createState() => _ProfilePreviewState();
}

class _ProfilePreviewState extends State<_ProfilePreview> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entries = <MapEntry<String, double>>[];

    void addIfExists(String label, dynamic value) {
      if (value is Map) {
        final key = value['key']?.toString();
        final raw = value['value'];
        final score = raw is num ? raw.toDouble() : 0.0;
        if (key != null && key.isNotEmpty) {
          entries.add(MapEntry('$label: $key', score));
        }
      }
    }

    addIfExists('Темперамент', widget.profile['temperament']);
    addIfExists('Стиль мышления', widget.profile['thinkingStyle']);
    addIfExists('Учебный профиль', widget.profile['studyProfile']);
    addIfExists('Ценности', widget.profile['valuesProfile']);

    final directions = widget.profile['directions'];
    if (directions is List) {
      for (final item in directions) {
        if (item is Map) {
          final key = item['key']?.toString();
          final raw = item['value'];
          final score = raw is num ? raw.toDouble() : 0.0;
          if (key != null && key.isNotEmpty) {
            entries.add(MapEntry('Направление: $key', score));
          }
        }
      }
    }

    final antiTags = widget.profile['antiTags'];
    if (antiTags is List) {
      for (final item in antiTags) {
        if (item is Map) {
          final key = item['key']?.toString();
          final raw = item['value'];
          final score = raw is num ? raw.toDouble() : 0.0;
          if (key != null && key.isNotEmpty) {
            entries.add(MapEntry('Анти-направление: $key', score));
          }
        }
      }
    }

    entries.sort((a, b) => b.value.compareTo(a.value));

    if (entries.isEmpty) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Данные профиля пока недоступны',
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }

    final visibleEntries = _expanded ? entries : entries.take(8).toList();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Профиль пользователя',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                  child: Text(_expanded ? 'Скрыть' : 'Показать все'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...visibleEntries.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        e.key,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      e.value.toStringAsFixed(1),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WhyThisProfessionBlock extends StatelessWidget {
  final dynamic profession;
  final String? explanation;
  final bool isEmpty;

  const _WhyThisProfessionBlock({
    required this.profession,
    required this.explanation,
    required this.isEmpty,
  });

  @override
  Widget build(BuildContext context) {
    final text = isEmpty
        ? 'После прохождения модулей мы покажем, почему именно эта профессия тебе подходит.'
        : (explanation ??
            'Эта рекомендация собрана на основе твоих ответов, сильных сторон и интересов.');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        color: Colors.deepPurple.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(text),
        ),
      ),
    );
  }
}

class _Alternatives extends StatelessWidget {
  final List alternatives;

  const _Alternatives({
    required this.alternatives,
  });

  @override
  Widget build(BuildContext context) {
    if (alternatives.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Альтернативные профессии',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 225,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: alternatives.length,
              itemBuilder: (context, index) {
                final p = alternatives[index];
                final percent = ((p['matchPercent'] ?? 0) as num).toInt();

                return Container(
                  width: 230,
                  margin: const EdgeInsets.only(right: 12),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              '$percent%',
                              style: const TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            p['name']?.toString() ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Text(
                              p['description']?.toString() ?? '',
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                height: 1.35,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(
                                Icons.auto_awesome,
                                size: 16,
                                color: Colors.deepPurple,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Схожесть: $percent%',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CoursesBlock extends StatelessWidget {
  final List courses;

  const _CoursesBlock({
    required this.courses,
  });

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Курсы по результатам',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ...courses.map((item) {
            final map = (item as Map).cast<String, dynamic>();

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    showDragHandle: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    builder: (_) => _CourseDetailsSheet(course: map),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        child: Icon(Icons.school_outlined),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              map['title']?.toString() ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              map['provider']?.toString() ?? '',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              map['description']?.toString() ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                if (map['level'] != null)
                                  _CourseChip(
                                    icon: Icons.bar_chart_rounded,
                                    label: map['level'].toString(),
                                  ),
                                if (map['duration'] != null)
                                  _CourseChip(
                                    icon: Icons.schedule_rounded,
                                    label: map['duration'].toString(),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right_rounded),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _CourseDetailsSheet extends StatelessWidget {
  final Map<String, dynamic> course;

  const _CourseDetailsSheet({
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    final title = course['title']?.toString() ?? 'Курс';
    final provider = course['provider']?.toString() ?? 'Proffy Academy';
    final description = course['description']?.toString() ?? '';
    final level = course['level']?.toString() ?? 'Начальный';
    final duration = course['duration']?.toString() ?? '4 недели';

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              const CircleAvatar(
                radius: 28,
                child: Icon(Icons.menu_book_rounded),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                provider,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _CourseChip(
                    icon: Icons.bar_chart_rounded,
                    label: level,
                  ),
                  _CourseChip(
                    icon: Icons.schedule_rounded,
                    label: duration,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'О курсе',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey.shade800,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Что ты получишь',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              const _CourseBullet(text: 'Поймёшь основы этого направления'),
              const _CourseBullet(text: 'Сможешь попробовать себя в профессии'),
              const _CourseBullet(text: 'Соберёшь первые практические навыки'),
              const _CourseBullet(text: 'Поймёшь, подходит ли тебе эта сфера'),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Понятно'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CourseChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _CourseChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: Colors.deepPurple),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.deepPurple,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseBullet extends StatelessWidget {
  final String text;

  const _CourseBullet({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 3),
            child: Icon(
              Icons.check_circle,
              size: 18,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  final String text;

  const _InfoBanner({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.amber.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.info_outline),
            const SizedBox(width: 12),
            Expanded(child: Text(text)),
          ],
        ),
      ),
    );
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
              child: const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }
}