class AssessmentModuleModel {
  final int id;
  final String code;
  final String title;
  final String description;
  final int sortOrder;
  final String? status;
  final DateTime? completedAt;

  const AssessmentModuleModel({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.sortOrder,
    this.status,
    this.completedAt,
  });

  factory AssessmentModuleModel.fromJson(Map<String, dynamic> json) {
    return AssessmentModuleModel(
      id: json['id'] as int,
      code: json['code'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      sortOrder: json['sortOrder'] as int,
      status: json['status'] as String?,
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'] as String)
          : null,
    );
  }

  AssessmentModuleModel copyWith({
    int? id,
    String? code,
    String? title,
    String? description,
    int? sortOrder,
    String? status,
    DateTime? completedAt,
  }) {
    return AssessmentModuleModel(
      id: id ?? this.id,
      code: code ?? this.code,
      title: title ?? this.title,
      description: description ?? this.description,
      sortOrder: sortOrder ?? this.sortOrder,
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  bool get isCompleted => status == 'COMPLETED';
  bool get isInProgress => status == 'IN_PROGRESS';
  bool get isNotStarted => status == null || status == 'NOT_STARTED';
}