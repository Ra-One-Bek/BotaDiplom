class ModuleQuestionOptionModel {
  final int id;
  final String text;
  final String? textRu;
  final String? textKk;
  final String? textEn;
  final String? value;
  final int order;

  const ModuleQuestionOptionModel({
    required this.id,
    required this.text,
    required this.textRu,
    required this.textKk,
    required this.textEn,
    required this.value,
    required this.order,
  });

  factory ModuleQuestionOptionModel.fromJson(Map<String, dynamic> json) {
    return ModuleQuestionOptionModel(
      id: json['id'] as int,
      text: json['text'] as String? ?? '',
      textRu: json['textRu'] as String?,
      textKk: json['textKk'] as String?,
      textEn: json['textEn'] as String?,
      value: json['value'] as String?,
      order: json['order'] as int,
    );
  }

  String localizedText(String languageCode) {
    if (languageCode == 'kk' && textKk != null && textKk!.trim().isNotEmpty) {
      return textKk!;
    }

    if (languageCode == 'en' && textEn != null && textEn!.trim().isNotEmpty) {
      return textEn!;
    }

    if (languageCode == 'ru' && textRu != null && textRu!.trim().isNotEmpty) {
      return textRu!;
    }

    return text;
  }
}

class ModuleQuestionModel {
  final int id;
  final String text;
  final String? textRu;
  final String? textKk;
  final String? textEn;
  final String? description;
  final String? descriptionRu;
  final String? descriptionKk;
  final String? descriptionEn;
  final int order;
  final String type;
  final List<ModuleQuestionOptionModel> options;

  const ModuleQuestionModel({
    required this.id,
    required this.text,
    required this.textRu,
    required this.textKk,
    required this.textEn,
    required this.description,
    required this.descriptionRu,
    required this.descriptionKk,
    required this.descriptionEn,
    required this.order,
    required this.type,
    required this.options,
  });

  factory ModuleQuestionModel.fromJson(Map<String, dynamic> json) {
    final optionsJson = (json['options'] as List<dynamic>? ?? []);

    return ModuleQuestionModel(
      id: json['id'] as int,
      text: json['text'] as String? ?? '',
      textRu: json['textRu'] as String?,
      textKk: json['textKk'] as String?,
      textEn: json['textEn'] as String?,
      description: json['description'] as String?,
      descriptionRu: json['descriptionRu'] as String?,
      descriptionKk: json['descriptionKk'] as String?,
      descriptionEn: json['descriptionEn'] as String?,
      order: json['order'] as int,
      type: json['type'] as String,
      options: optionsJson
          .map((item) =>
              ModuleQuestionOptionModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  String localizedText(String languageCode) {
    if (languageCode == 'kk' && textKk != null && textKk!.trim().isNotEmpty) {
      return textKk!;
    }

    if (languageCode == 'en' && textEn != null && textEn!.trim().isNotEmpty) {
      return textEn!;
    }

    if (languageCode == 'ru' && textRu != null && textRu!.trim().isNotEmpty) {
      return textRu!;
    }

    return text;
  }

  String? localizedDescription(String languageCode) {
    if (languageCode == 'kk' &&
        descriptionKk != null &&
        descriptionKk!.trim().isNotEmpty) {
      return descriptionKk!;
    }

    if (languageCode == 'en' &&
        descriptionEn != null &&
        descriptionEn!.trim().isNotEmpty) {
      return descriptionEn!;
    }

    if (languageCode == 'ru' &&
        descriptionRu != null &&
        descriptionRu!.trim().isNotEmpty) {
      return descriptionRu!;
    }

    return description;
  }
}

class ModuleQuestionsResponseModel {
  final int moduleId;
  final String moduleCode;
  final String moduleTitle;
  final String? moduleTitleRu;
  final String? moduleTitleKk;
  final String? moduleTitleEn;
  final String moduleDescription;
  final String? moduleDescriptionRu;
  final String? moduleDescriptionKk;
  final String? moduleDescriptionEn;
  final List<ModuleQuestionModel> questions;

  const ModuleQuestionsResponseModel({
    required this.moduleId,
    required this.moduleCode,
    required this.moduleTitle,
    required this.moduleTitleRu,
    required this.moduleTitleKk,
    required this.moduleTitleEn,
    required this.moduleDescription,
    required this.moduleDescriptionRu,
    required this.moduleDescriptionKk,
    required this.moduleDescriptionEn,
    required this.questions,
  });

  factory ModuleQuestionsResponseModel.fromJson(Map<String, dynamic> json) {
    final moduleJson = json['module'] as Map<String, dynamic>;
    final questionsJson = (json['questions'] as List<dynamic>? ?? []);

    return ModuleQuestionsResponseModel(
      moduleId: moduleJson['id'] as int,
      moduleCode: moduleJson['code'] as String,
      moduleTitle: moduleJson['title'] as String? ?? '',
      moduleTitleRu: moduleJson['titleRu'] as String?,
      moduleTitleKk: moduleJson['titleKk'] as String?,
      moduleTitleEn: moduleJson['titleEn'] as String?,
      moduleDescription: moduleJson['description'] as String? ?? '',
      moduleDescriptionRu: moduleJson['descriptionRu'] as String?,
      moduleDescriptionKk: moduleJson['descriptionKk'] as String?,
      moduleDescriptionEn: moduleJson['descriptionEn'] as String?,
      questions: questionsJson
          .map((item) =>
              ModuleQuestionModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  String localizedTitle(String languageCode) {
    if (languageCode == 'kk' &&
        moduleTitleKk != null &&
        moduleTitleKk!.trim().isNotEmpty) {
      return moduleTitleKk!;
    }

    if (languageCode == 'en' &&
        moduleTitleEn != null &&
        moduleTitleEn!.trim().isNotEmpty) {
      return moduleTitleEn!;
    }

    if (languageCode == 'ru' &&
        moduleTitleRu != null &&
        moduleTitleRu!.trim().isNotEmpty) {
      return moduleTitleRu!;
    }

    return moduleTitle;
  }

  String localizedDescription(String languageCode) {
    if (languageCode == 'kk' &&
        moduleDescriptionKk != null &&
        moduleDescriptionKk!.trim().isNotEmpty) {
      return moduleDescriptionKk!;
    }

    if (languageCode == 'en' &&
        moduleDescriptionEn != null &&
        moduleDescriptionEn!.trim().isNotEmpty) {
      return moduleDescriptionEn!;
    }

    if (languageCode == 'ru' &&
        moduleDescriptionRu != null &&
        moduleDescriptionRu!.trim().isNotEmpty) {
      return moduleDescriptionRu!;
    }

    return moduleDescription;
  }
}