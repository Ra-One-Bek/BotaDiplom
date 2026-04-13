class ProfessionModel {
  final int id;
  final String name;
  final String description;
  final String category;
  final List<String> tags;
  final double? score;

  ProfessionModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.tags,
    this.score,
  });

  factory ProfessionModel.fromJson(Map json) {
    return ProfessionModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? [],
      score: json['score'] != null ? (json['score'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'tags': tags,
      'score': score,
    };
  }
}