// This file defines the MathExercise and Step classes, which are used to represent a math exercise and its solution steps.

class TriviaQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String? explanation;
  final List<Map<String, String>>? solutionSteps;
  final String? latex; // Add this field
  int? selectedIndex;
    final String? materia;
      final String? carrera;

  TriviaQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    this.explanation,
    this.solutionSteps,
    this.latex, // Add this paramete
    this.materia,
    this.carrera
  });

  factory TriviaQuestion.fromMap(Map<String, dynamic> map) {
    // Detecta si es formato normal (Derecho) o cálculo
    if (map.containsKey('pregunta')) {
      // Formato normal
      final opciones = List<String>.from(map['opciones'] ?? []);
      final respuesta = map['respuesta'];
      final correctIdx = opciones.indexOf(respuesta);
      return TriviaQuestion(
        question: map['pregunta'] ?? '',
        options: opciones,
        correctIndex: correctIdx,
        explanation: map['explicación'] ?? '',
        solutionSteps: null,
      );
    } else {
      // Formato cálculo
      return TriviaQuestion(
        question: map['question'] ?? '',
        options: List<String>.from(map['options'] ?? []),
        correctIndex: map['correctIndex'] ?? 0,
        explanation: map['explanation'] ?? '',
        solutionSteps: (map['solutionSteps'] as List<dynamic>?)
            ?.map((e) => Map<String, String>.from(e))
            .toList(),
      );
    }
  }
}
