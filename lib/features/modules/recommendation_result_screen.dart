import 'package:flutter/material.dart';
import 'package:career_guidance_app/data/services/assessment_service.dart';
import 'package:career_guidance_app/features/auth/auth_controller.dart';

class RecommendationResultScreen extends StatefulWidget {
  const RecommendationResultScreen({super.key});

  @override
  State<RecommendationResultScreen> createState() =>
      _RecommendationResultScreenState();
}

class _RecommendationResultScreenState
    extends State<RecommendationResultScreen> {
  final _service = AssessmentService();
  final _auth = AuthController();

  bool _loading = true;
  Map<String, dynamic>? _data;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final userId = _auth.currentUserId!;
    final data = await _service.getRecommendations(
      userId: userId,
      accessToken: _auth.accessToken,
    );

    setState(() {
      _data = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final top = _data!['topProfession'];
    final alternatives = _data!['alternatives'];
    final profile = _data!['profile'];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _HeroBlock(top),
            _ProfilePreview(profile: profile),
            _AIBlock(),
            _Alternatives(alternatives),
            const SizedBox(height: 20),
            _CourseButton(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _HeroBlock extends StatelessWidget {
  final dynamic profession;

  const _HeroBlock(this.profession);

  @override
  Widget build(BuildContext context) {
    // ✅ защита от null
    if (profession == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
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
        child: const Column(
          children: [
            Text(
              'Твоя профессия',
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 20),
            Text(
              'Профессия пока не определена',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    final score = (profession['score'] ?? 0).toDouble();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
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
                  value: ((score / 20).clamp(0, 1)).toDouble(),
                  strokeWidth: 10,
                  backgroundColor: Colors.white24,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              Text(
                '${(score * 5).clamp(0, 100)}%',
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
            profession['name'] ?? '',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            profession['description'] ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _ProfilePreview extends StatelessWidget {
  final Map<String, dynamic> profile;

  const _ProfilePreview({
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final entries = <MapEntry<String, double>>[];

    void addIfExists(String label, dynamic value) {
      if (value is Map<String, dynamic>) {
        final key = value['key']?.toString();
        final raw = value['value'];
        final score = raw is num ? raw.toDouble() : 0.0;

        if (key != null && key.isNotEmpty) {
          entries.add(MapEntry('$label: $key', score));
        }
      }
    }

    addIfExists('Темперамент', profile['temperament']);
    addIfExists('Стиль мышления', profile['thinkingStyle']);
    addIfExists('Учебный профиль', profile['studyProfile']);
    addIfExists('Ценности', profile['valuesProfile']);

    final directions = profile['directions'];
    if (directions is List) {
      for (final item in directions) {
        if (item is Map<String, dynamic>) {
          final key = item['key']?.toString();
          final raw = item['value'];
          final score = raw is num ? raw.toDouble() : 0.0;

          if (key != null && key.isNotEmpty) {
            entries.add(MapEntry('Направление: $key', score));
          }
        }
      }
    }

    entries.sort((a, b) => b.value.compareTo(a.value));

    if (entries.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Данные профиля пока недоступны',
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Профиль пользователя',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...entries.take(8).map(
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

class _AIBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        color: Colors.deepPurple.shade50,
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Ты подходишь для этой профессии, потому что у тебя сильное аналитическое мышление и креативность.',
          ),
        ),
      ),
    );
  }
}

class _Alternatives extends StatelessWidget {
  final List alternatives;

  const _Alternatives(this.alternatives);

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
            height: 210,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: alternatives.length,
              itemBuilder: (context, index) {
                final p = alternatives[index];
                final score = (p['score'] ?? 0).toDouble();
                final percent = ((score * 5).clamp(0, 100)).toInt();

                return Container(
                  width: 220,
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
                            p['name'] ?? '',
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
                              p['description'] ?? '',
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
                                'Match: ${p['score']}',
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

class _CourseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        onPressed: () {
          // потом откроем экран курсов
        },
        child: const Text('🚀 Найти курсы'),
      ),
    );
  }
}