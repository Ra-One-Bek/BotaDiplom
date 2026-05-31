class UniversityReviewModel {
  final int id;
  final String? author;
  final double? rating;
  final String text;
  final String source;
  final String? sourceUrl;
  final DateTime? publishedAt;

  const UniversityReviewModel({
    required this.id,
    required this.author,
    required this.rating,
    required this.text,
    required this.source,
    required this.sourceUrl,
    required this.publishedAt,
  });

  factory UniversityReviewModel.fromJson(Map<String, dynamic> json) {
    return UniversityReviewModel(
      id: json['id'] as int,
      author: json['author'] as String?,
      rating: json['rating'] == null
          ? null
          : (json['rating'] as num).toDouble(),
      text: json['text'] as String? ?? '',
      source: json['source'] as String? ?? '',
      sourceUrl: json['sourceUrl'] as String?,
      publishedAt: json['publishedAt'] != null
          ? DateTime.tryParse(json['publishedAt'] as String)
          : null,
    );
  }
}

class UniversityModel {
  final int id;
  final String name;
  final String city;
  final String? description;
  final String? website;
  final double rating;
  final List<UniversityReviewModel> reviews;

  const UniversityModel({
    required this.id,
    required this.name,
    required this.city,
    required this.description,
    required this.website,
    required this.rating,
    required this.reviews,
  });

  factory UniversityModel.fromJson(Map<String, dynamic> json) {
    final reviewsJson = json['reviews'] as List<dynamic>? ?? [];

    return UniversityModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      city: json['city'] as String? ?? '',
      description: json['description'] as String?,
      website: json['website'] as String?,
      rating: json['rating'] == null
          ? 0
          : (json['rating'] as num).toDouble(),
      reviews: reviewsJson
          .map((item) =>
              UniversityReviewModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  int get reviewCount => reviews.length;
}