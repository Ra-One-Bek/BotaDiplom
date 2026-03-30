import 'answer_option_model.dart';

class QuestionModel {
  final int id;
  final String text;
  final String category;
  final List<AnswerOptionModel> options;

  QuestionModel({
    required this.id,
    required this.text,
    required this.category,
    required this.options,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      text: json['text'] ?? '',
      category: json['category'] ?? '',
      options: (json['options'] as List<dynamic>? ?? [])
          .map((e) => AnswerOptionModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'category': category,
      'options': options.map((e) => e.toJson()).toList(),
    };
  }
}