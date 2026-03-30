import 'package:flutter/material.dart';
import 'package:career_guidance_app/features/recommendations/recommendations_controller.dart';
import 'package:career_guidance_app/shared/widgets/app_drawer.dart';

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

  String _fieldTitle(String field) {
    switch (field) {
      case 'IT':
        return 'Информационные технологии';
      case 'Design':
        return 'Дизайн';
      case 'Medicine':
        return 'Медицина';
      case 'Business':
        return 'Бизнес и управление';
      default:
        return field;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Рекомендации'),
          ),
          drawer: const AppDrawer(),
          body: _controller.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : _controller.errorMessage != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          _controller.errorMessage!,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Результат тестирования',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Доминирующее направление: ${_fieldTitle(_controller.dominantField)}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    _controller.summary,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Рекомендуемые профессии',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: _controller.professions.isEmpty
                                ? const Center(
                                    child: Text('Рекомендации не найдены'),
                                  )
                                : ListView.builder(
                                    itemCount: _controller.professions.length,
                                    itemBuilder: (context, index) {
                                      final profession =
                                          _controller.professions[index];

                                      return Card(
                                        margin:
                                            const EdgeInsets.only(bottom: 12),
                                        child: ListTile(
                                          title: Text(profession.name),
                                          subtitle:
                                              Text(profession.description),
                                          trailing: Text(profession.category),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
        );
      },
    );
  }
}