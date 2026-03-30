class ProfessionModel {
  final int id;
  final String name;
  final String description;
  final String category;

  ProfessionModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
  });

  factory ProfessionModel.fromJson(Map<String, dynamic> json) {
    return ProfessionModel(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
    };
  }
}