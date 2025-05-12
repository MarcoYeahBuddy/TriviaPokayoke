import 'package:flutter/foundation.dart';

class TriviaQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String? explanation;
  final String? latex;  // Para mostrar la fórmula matemática
  final List<Map<String, String>>? solutionSteps;
  int? selectedIndex;

  TriviaQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    this.explanation,
    this.latex,
    this.solutionSteps,
    this.selectedIndex,
  });

  factory TriviaQuestion.fromMap(Map<String, dynamic> map) {
    return TriviaQuestion(
      question: map['question'] as String,
      options: List<String>.from(map['options']),
      correctIndex: map['correctIndex'] as int,
      explanation: map['explanation'] as String?,
      latex: map['latex'] as String?,
      solutionSteps: map['solutionSteps'] != null
          ? List<Map<String, String>>.from(
              (map['solutionSteps'] as List).map((step) => Map<String, String>.from(step)))
          : null,
    );
  }
}
