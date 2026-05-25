class AssessmentModuleModel {
  final int id;
  final String code;
  final String title;
  final String? titleRu;
  final String? titleKk;
  final String? titleEn;
  final String description;
  final String? descriptionRu;
  final String? descriptionKk;
  final String? descriptionEn;
  final int sortOrder;
  final String? status;
  final DateTime? completedAt;

  const AssessmentModuleModel({
    required this.id,
    required this.code,
    required this.title,
    required this.titleRu,
    required this.titleKk,
    required this.titleEn,
    required this.description,
    required this.descriptionRu,
    required this.descriptionKk,
    required this.descriptionEn,
    required this.sortOrder,
    this.status,
    this.completedAt,
  });

  factory AssessmentModuleModel.fromJson(Map<String, dynamic> json) {
    return AssessmentModuleModel(
      id: json['id'] as int,
      code: json['code'] as String,
      title: json['title'] as String? ?? '',
      titleRu: json['titleRu'] as String?,
      titleKk: json['titleKk'] as String?,
      titleEn: json['titleEn'] as String?,
      description: json['description'] as String? ?? '',
      descriptionRu: json['descriptionRu'] as String?,
      descriptionKk: json['descriptionKk'] as String?,
      descriptionEn: json['descriptionEn'] as String?,
      sortOrder: json['sortOrder'] as int,
      status: json['status'] as String?,
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'] as String)
          : null,
    );
  }

  String localizedTitle(String languageCode) {
    if (languageCode == 'kk' && titleKk != null && titleKk!.trim().isNotEmpty) {
      return titleKk!;
    }

    if (languageCode == 'en' && titleEn != null && titleEn!.trim().isNotEmpty) {
      return titleEn!;
    }

    if (languageCode == 'ru' && titleRu != null && titleRu!.trim().isNotEmpty) {
      return titleRu!;
    }

    return title;
  }

  String localizedDescription(String languageCode) {
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

  AssessmentModuleModel copyWith({
    int? id,
    String? code,
    String? title,
    String? titleRu,
    String? titleKk,
    String? titleEn,
    String? description,
    String? descriptionRu,
    String? descriptionKk,
    String? descriptionEn,
    int? sortOrder,
    String? status,
    DateTime? completedAt,
  }) {
    return AssessmentModuleModel(
      id: id ?? this.id,
      code: code ?? this.code,
      title: title ?? this.title,
      titleRu: titleRu ?? this.titleRu,
      titleKk: titleKk ?? this.titleKk,
      titleEn: titleEn ?? this.titleEn,
      description: description ?? this.description,
      descriptionRu: descriptionRu ?? this.descriptionRu,
      descriptionKk: descriptionKk ?? this.descriptionKk,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      sortOrder: sortOrder ?? this.sortOrder,
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  bool get isCompleted => status == 'COMPLETED';
  bool get isInProgress => status == 'IN_PROGRESS';
  bool get isNotStarted => status == null || status == 'NOT_STARTED';
}