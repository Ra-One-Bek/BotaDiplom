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
            _ProfilePreview(profile),
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

          // 🔥 КРУГ С ПРОЦЕНТОМ
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
            profession['name'],
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            profession['description'],
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _ProfilePreview extends StatelessWidget {
  final Map profile;

  const _ProfilePreview(this.profile);

  @override
  Widget build(BuildContext context) {
    final entries = profile.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final top3 = entries.take(3).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Row(
                children: [
                  Text('Твой профиль',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 10),

              ...top3.map(
                (e) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(e.key),
                    Text('${e.value}'),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              TextButton(
                onPressed: () {
                  showDialog(
                  context: context,
                  builder: (_) {
                    final entries = profile.entries.toList()
                      ..sort((a, b) => (b.value as num).compareTo(a.value as num));

                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 420,
                          maxHeight: 520,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Полный профиль',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 18),
                              Expanded(
                                child: ListView.separated(
                                  itemCount: entries.length,
                                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                                  itemBuilder: (_, index) {
                                    final entry = entries[index];
                                    final title = _formatProfileKey(entry.key.toString());
                                    final value = (entry.value as num).toInt();

                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF5F2FF),
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              title,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.deepPurple.withOpacity(0.12),
                                              borderRadius: BorderRadius.circular(999),
                                            ),
                                            child: Text(
                                              '$value',
                                              style: const TextStyle(
                                                color: Colors.deepPurple,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 14),
                              SizedBox(
                                width: double.infinity,
                                child: TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Закрыть'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
                },
                child: const Text('Смотреть полностью'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  String _formatProfileKey(String key) {
    switch (key) {
      case 'analytical':
        return 'Аналитика';
      case 'creative':
        return 'Креативность';
      case 'social':
        return 'Коммуникация';
      case 'technical':
        return 'Техническое мышление';
      case 'structure':
        return 'Структурность';
      case 'business':
        return 'Бизнес-мышление';
      case 'direction.business':
        return 'Склонность к бизнесу';
      case 'values.leader':
        return 'Лидерские ценности';
      case 'temperament.choleric':
        return 'Темперамент: холерик';
      case 'temperament.melancholic':
        return 'Темперамент: меланхолик';
      case 'temperament.phlegmatic':
        return 'Темперамент: флегматик';
      case 'temperament.sanguine':
        return 'Темперамент: сангвиник';
      default:
        return key.replaceAll('.', ' • ');
    }
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