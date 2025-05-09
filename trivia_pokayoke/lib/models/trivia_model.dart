class TriviaQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  String? explanation;
  int? selectedIndex;

  TriviaQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    this.explanation,
    this.selectedIndex,
  });

  factory TriviaQuestion.fromMap(Map<String, dynamic> data) {
    final options = List<String>.from(data['opciones'] ?? []);
    final correctIndex = options.indexOf(data['respuesta'] ?? '');

    if (data['pregunta'] == null || options.isEmpty || correctIndex == -1) {
      throw ArgumentError('Invalid data for TriviaQuestion'); // Lanzar una excepción si los datos no son válidos
    }

    return TriviaQuestion(
      question: data['pregunta'] ?? '',
      options: options,
      correctIndex: correctIndex,
      explanation: data['explicación'],
    );
  }
}
