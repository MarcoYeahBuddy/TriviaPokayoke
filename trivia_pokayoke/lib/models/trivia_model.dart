import 'package:flutter/foundation.dart';

class TriviaQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String? explanation;
  final String? latex;
  final List<Map<String, String>>? pasos;  // Cambiado de solutionSteps a pasos
  int? selectedIndex;

  TriviaQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    this.explanation,
    this.latex,
    this.pasos,  // Actualizado aquí también
    this.selectedIndex,
  });

  factory TriviaQuestion.fromMap(Map<String, dynamic> map) {
    try {
      final options = List<String>.from(map['opciones'] ?? []);
      final respuesta = map['respuesta'] as String?;
      
      return TriviaQuestion(
        question: map['pregunta']?.toString() ?? 'Pregunta no disponible',
        options: options,
        correctIndex: respuesta != null ? options.indexOf(respuesta) : 0,
        explanation: map['explicación']?.toString(),
        latex: map['latex']?.toString(),
        pasos: map['pasos'] != null  // Cambiado aquí también
            ? (map['pasos'] as List).map((paso) {
                return {
                  'texto': paso['texto']?.toString() ?? '',
                  'latex': paso['latex']?.toString() ?? '',
                };
              }).toList()
            : null,
      );
    } catch (e) {
      print('Error parsing question: $e');
      return TriviaQuestion(
        question: 'Error al cargar la pregunta',
        options: ['Error - Contacta al administrador'],
        correctIndex: 0,
      );
    }
  }
}
