class ModuleAnswerSubmitItem {
  final int questionId;
  final int answerOptionId;

  const ModuleAnswerSubmitItem({
    required this.questionId,
    required this.answerOptionId,
  });

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'answerOptionId': answerOptionId,
    };
  }
}