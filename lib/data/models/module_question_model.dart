class ModuleQuestionOptionModel {
  final int id;
  final String text;
  final String? value;
  final int order;

  const ModuleQuestionOptionModel({
    required this.id,
    required this.text,
    required this.value,
    required this.order,
  });

  factory ModuleQuestionOptionModel.fromJson(Map<String, dynamic> json) {
    return ModuleQuestionOptionModel(
      id: json['id'] as int,
      text: json['text'] as String,
      value: json['value'] as String?,
      order: json['order'] as int,
    );
  }
}

class ModuleQuestionModel {
  final int id;
  final String text;
  final String? description;
  final int order;
  final String type;
  final List<ModuleQuestionOptionModel> options;

  const ModuleQuestionModel({
    required this.id,
    required this.text,
    required this.description,
    required this.order,
    required this.type,
    required this.options,
  });

  factory ModuleQuestionModel.fromJson(Map<String, dynamic> json) {
    final optionsJson = (json['options'] as List<dynamic>? ?? []);

    return ModuleQuestionModel(
      id: json['id'] as int,
      text: json['text'] as String,
      description: json['description'] as String?,
      order: json['order'] as int,
      type: json['type'] as String,
      options: optionsJson
          .map((item) =>
              ModuleQuestionOptionModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ModuleQuestionsResponseModel {
  final int moduleId;
  final String moduleCode;
  final String moduleTitle;
  final String moduleDescription;
  final List<ModuleQuestionModel> questions;

  const ModuleQuestionsResponseModel({
    required this.moduleId,
    required this.moduleCode,
    required this.moduleTitle,
    required this.moduleDescription,
    required this.questions,
  });

  factory ModuleQuestionsResponseModel.fromJson(Map<String, dynamic> json) {
    final moduleJson = json['module'] as Map<String, dynamic>;
    final questionsJson = (json['questions'] as List<dynamic>? ?? []);

    return ModuleQuestionsResponseModel(
      moduleId: moduleJson['id'] as int,
      moduleCode: moduleJson['code'] as String,
      moduleTitle: moduleJson['title'] as String,
      moduleDescription: moduleJson['description'] as String? ?? '',
      questions: questionsJson
          .map((item) =>
              ModuleQuestionModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}