import 'package:flutter/material.dart';
import '../../data/models/university_model.dart';
import '../../data/services/university_service.dart';

class UniversitiesScreen extends StatefulWidget {
  const UniversitiesScreen({super.key});

  @override
  State<UniversitiesScreen> createState() => _UniversitiesScreenState();
}

class _UniversitiesScreenState extends State<UniversitiesScreen> {
  final _service = UniversityService();

  String _selectedCity = 'Все города';
  String _searchQuery = '';
  bool _loading = true;
  String? _error;
  List<UniversityModel> _universities = [];

  @override
  void initState() {
    super.initState();
    _loadUniversities();
  }

  Future<void> _loadUniversities() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final universities = await _service.getUniversities();

      if (!mounted) return;

      setState(() {
        _universities = universities;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  List<String> get _cities {
    final cities = _universities.map((e) => e.city).toSet().toList()..sort();
    return ['Все города', ...cities];
  }

  List<UniversityModel> get _filteredUniversities {
    return _universities.where((university) {
      final matchesCity =
          _selectedCity == 'Все города' || university.city == _selectedCity;

      final query = _searchQuery.trim().toLowerCase();

      final matchesSearch = query.isEmpty ||
          university.name.toLowerCase().contains(query) ||
          university.city.toLowerCase().contains(query) ||
          (university.description ?? '').toLowerCase().contains(query);

      return matchesCity && matchesSearch;
    }).toList()
      ..sort((a, b) => b.rating.compareTo(a.rating));
  }

  List<UniversityModel> get _recommendedUniversities {
    final items = [..._universities]..sort((a, b) {
        final reviewsCompare = b.reviewCount.compareTo(a.reviewCount);
        if (reviewsCompare != 0) return reviewsCompare;
        return b.rating.compareTo(a.rating);
      });

    return items.take(5).toList();
  }

  void _openDetails(UniversityModel university) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => _UniversityDetailsSheet(university: university),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = _filteredUniversities;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5FF),
      appBar: AppBar(
        title: const Text('Университеты'),
        centerTitle: false,
        backgroundColor: const Color(0xFFF7F5FF),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _loadUniversities,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Builder(
          builder: (context) {
            if (_loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (_error != null) {
              return _ErrorState(
                message: _error!,
                onRetry: _loadUniversities,
              );
            }

            if (_universities.isEmpty) {
              return _ErrorState(
                message:
                    'Университеты пока не добавлены. Запусти POST /universities/seed в Thunder Client.',
                onRetry: _loadUniversities,
              );
            }

            return RefreshIndicator(
              onRefresh: _loadUniversities,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  _HeroHeader(theme: theme),
                  const SizedBox(height: 18),
                  Text(
                    'Подходят по результату профессий',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 190,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _recommendedUniversities.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final university = _recommendedUniversities[index];

                        return _RecommendedUniversityCard(
                          university: university,
                          onTap: () => _openDetails(university),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 22),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Поиск по университету или городу',
                      prefixIcon: const Icon(Icons.search_rounded),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _selectedCity,
                    items: _cities
                        .map(
                          (city) => DropdownMenuItem(
                            value: city,
                            child: Text(city),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;

                      setState(() {
                        _selectedCity = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Город',
                      prefixIcon: const Icon(Icons.location_city_rounded),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Все университеты',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...filtered.map(
                    (university) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _UniversityCard(
                        university: university,
                        onTap: () => _openDetails(university),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  final ThemeData theme;

  const _HeroHeader({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF6C63FF),
            Color(0xFF8E2DE2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.22),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white24,
            child: Icon(
              Icons.school_rounded,
              color: Colors.white,
              size: 34,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Найди подходящий вуз',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Сравнивай города, рейтинг и отзывы студентов из backend.',
                  style: TextStyle(
                    color: Colors.white70,
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

class _RecommendedUniversityCard extends StatelessWidget {
  final UniversityModel university;
  final VoidCallback onTap;

  const _RecommendedUniversityCard({
    required this.university,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFFEDEBFF),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: Color(0xFF6C63FF),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                university.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 16),
                  const SizedBox(width: 4),
                  Expanded(child: Text(university.city)),
                  const Icon(Icons.reviews_rounded, size: 17),
                  const SizedBox(width: 4),
                  Text('${university.reviewCount}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UniversityCard extends StatelessWidget {
  final UniversityModel university;
  final VoidCallback onTap;

  const _UniversityCard({
    required this.university,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final firstLetter = university.name.isEmpty ? '?' : university.name[0];

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFFEDEBFF),
                child: Text(
                  firstLetter,
                  style: const TextStyle(
                    color: Color(0xFF6C63FF),
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      university.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      university.city,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    if ((university.description ?? '').isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        university.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  const Icon(Icons.star_rounded, color: Colors.amber),
                  Text(
                    university.rating.toStringAsFixed(1),
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${university.reviewCount} отз.',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UniversityDetailsSheet extends StatelessWidget {
  final UniversityModel university;

  const _UniversityDetailsSheet({required this.university});

  @override
  Widget build(BuildContext context) {
    final firstLetter = university.name.isEmpty ? '?' : university.name[0];

    return SafeArea(
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.82,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, controller) {
          return ListView(
            controller: controller,
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: const Color(0xFFEDEBFF),
                child: Text(
                  firstLetter,
                  style: const TextStyle(
                    color: Color(0xFF6C63FF),
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                university.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                university.city,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star_rounded, color: Colors.amber),
                  const SizedBox(width: 6),
                  Text(
                    '${university.rating.toStringAsFixed(1)} · ${university.reviewCount} отзывов',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              if ((university.description ?? '').isNotEmpty)
                Text(
                  university.description!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    height: 1.45,
                  ),
                ),
              const SizedBox(height: 22),
              const Text(
                'Отзывы студентов',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              if (university.reviews.isEmpty)
                _ReviewPlaceholder(university: university)
              else
                ...university.reviews.map(
                  (review) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ReviewCard(review: review),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final UniversityReviewModel review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F5FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE0DAFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 17,
                backgroundColor: Color(0xFFEDEBFF),
                child: Icon(
                  Icons.person_rounded,
                  size: 18,
                  color: Color(0xFF6C63FF),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  review.author ?? 'Анонимный студент',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              if (review.rating != null) ...[
                const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                Text(
                  review.rating!.toStringAsFixed(1),
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Text(
            review.text,
            style: TextStyle(
              color: Colors.grey.shade800,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Источник: ${review.source}',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewPlaceholder extends StatelessWidget {
  final UniversityModel university;

  const _ReviewPlaceholder({required this.university});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F5FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE0DAFF)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.reviews_outlined,
            color: Color(0xFF6C63FF),
            size: 34,
          ),
          const SizedBox(height: 10),
          const Text(
            'Отзывов пока нет',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            'Для ${university.name} отзывы появятся после запуска парсинга.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade700),
          ),
        ],
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
            const Icon(Icons.error_outline_rounded, size: 42),
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