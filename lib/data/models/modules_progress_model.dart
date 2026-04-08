import 'assessment_module_model.dart';

class ModulesProgressModel {
  final int totalModules;
  final int completedModules;
  final int percent;
  final List<AssessmentModuleModel> items;

  const ModulesProgressModel({
    required this.totalModules,
    required this.completedModules,
    required this.percent,
    required this.items,
  });

  factory ModulesProgressModel.fromJson(Map<String, dynamic> json) {
    final itemsJson = (json['items'] as List<dynamic>? ?? []);

    return ModulesProgressModel(
      totalModules: json['totalModules'] as int? ?? 0,
      completedModules: json['completedModules'] as int? ?? 0,
      percent: json['percent'] as int? ?? 0,
      items: itemsJson
          .map((item) => AssessmentModuleModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}