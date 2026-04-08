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
  final AssessmentService _service = AssessmentService();
  final AuthController _auth = AuthController();

  bool _isLoading = true;
  String? _error;
  Map<String, dynamic>? _data;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final userId = _auth.currentUserId;
      if (userId == null) throw Exception('Нет userId');

      final data = await _service.getRecommendations(
        userId: userId,
        accessToken: _auth.accessToken,
      );

      setState(() {
        _data = data;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(child: Text(_error!)),
      );
    }

    final profession = _data?['topProfession'];

    return Scaffold(
      appBar: AppBar(title: const Text('Твоя профессия')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.workspace_premium, size: 80),
            const SizedBox(height: 20),
            Text(
              profession?['name'] ?? 'Не найдено',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              profession?['description'] ?? '',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}