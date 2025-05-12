// This file defines the MathExercise and Step classes, which are used to represent a math exercise and its solution steps.
class MathExercise {
  final String question;
  final String latex; // Para mostrar la fórmula matemática
  final List<String> options;
  final int correctIndex;
  final List<Step> solutionSteps;
  final String finalExplanation;

  MathExercise({
    required this.question,
    required this.latex,
    required this.options,
    required this.correctIndex,
    required this.solutionSteps,
    required this.finalExplanation,
  });

  factory MathExercise.fromMap(Map<String, dynamic> map) {
    return MathExercise(
      question: map['question'],
      latex: map['latex'],
      options: List<String>.from(map['options']),
      correctIndex: map['correctIndex'],
      solutionSteps: (map['solutionSteps'] as List)
          .map((step) => Step.fromMap(step))
          .toList(),
      finalExplanation: map['finalExplanation'],
    );
  }
}

class Step {
  final String explanation;
  final String latex;
  final String? imageUrl;

  Step({
    required this.explanation,
    required this.latex,
    this.imageUrl,
  });

  factory Step.fromMap(Map<String, dynamic> map) {
    return Step(
      explanation: map['explanation'],
      latex: map['latex'],
      imageUrl: map['imageUrl'],
    );
  }
}
