class AiMessageModel {
  final String role;
  final String text;

  AiMessageModel({
    required this.role,
    required this.text,
  });

  factory AiMessageModel.fromJson(Map<String, dynamic> json) {
    return AiMessageModel(
      role: json['role'] ?? '',
      text: json['text'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'text': text,
    };
  }
}