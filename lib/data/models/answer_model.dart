class AnswerModel {
  final int questionId;
  final int answerOptionId;

  AnswerModel({
    required this.questionId,
    required this.answerOptionId,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      questionId: json['questionId'],
      answerOptionId: json['answerOptionId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'answerOptionId': answerOptionId,
    };
  }
}