import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../models/trivia_model.dart';

class CarreraColors {
  static Color background(String carrera, bool isDark) {
    switch (carrera.toLowerCase()) {
      case 'economía':
      case 'economia':
        return isDark ? const Color(0xFF7A441C) : const Color(0xFF8D6467);
      case 'contabilidad':
        return isDark ? const Color(0xFF3A6B50) : const Color(0xFF5D8B72);
      case 'marketing':
        return isDark ? const Color(0xFF2F5570) : const Color(0xFF5A7F9C);
      case 'ingeniería de sistemas':
      case 'ingenieria de sistemas':
        return isDark ? const Color(0xFF2E4A62) : const Color(0xFF4A6C8C);
      case 'medicina':
        return isDark ? const Color(0xFF924055) : const Color(0xFFB56576);
      case 'derecho':
        return isDark ? const Color(0xFF6A55A4) : const Color(0xFF937DC2);
      default:
        return isDark ? Colors.grey.shade700 : Colors.grey.shade400;
    }
  }

  static Color panel(String carrera, bool isDark) {
    // Panel es más oscuro en ambos modos, pero en dark aún más
    switch (carrera.toLowerCase()) {
      case 'economía':
      case 'economia':
        return isDark ? const Color(0xFF4E2A13) : const Color(0xFF7A441C);
      case 'contabilidad':
        return isDark ? const Color(0xFF23412E) : const Color(0xFF3A6B50);
      case 'marketing':
        return isDark ? const Color(0xFF1B3142) : const Color(0xFF2F5570);
      case 'ingeniería de sistemas':
      case 'ingenieria de sistemas':
        return isDark ? const Color(0xFF1A2B39) : const Color(0xFF2E4A62);
      case 'medicina':
        return isDark ? const Color(0xFF5B2633) : const Color(0xFF924055);
      case 'derecho':
        return isDark ? const Color(0xFF3D2C5C) : const Color(0xFF6A55A4);
      default:
        return isDark ? Colors.grey.shade800 : Colors.grey.shade600;
    }
  }
}

class QuestionCard extends StatelessWidget {
  final TriviaQuestion question;
  final Function(int) onOptionSelected;
  final String carrera;

  const QuestionCard({
    Key? key,
    required this.question,
    required this.onOptionSelected,
    required this.carrera,
  }) : super(key: key);

  bool get _isMatematicas {
    try {
      return carrera.toLowerCase().contains('cálculo') || 
             carrera.toLowerCase().contains('calculo') ||
             (question.latex?.isNotEmpty ?? false);
    } catch (e) {
      return false;
    }
  }

  Widget _buildOptionWidget(String option, bool isDark) {
    try {
      if (_isMatematicas && option.contains(RegExp(r'[\\${}^_]'))) {
        return Math.tex(
          option,
          textStyle: TextStyle(
            fontSize: 16,
            color: isDark ? Colors.white : Colors.black87,
          ),
          onErrorFallback: (error) => Text(
            option,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        );
      }
    } catch (e) {
      print('Error rendering math: $e');
    }

    return Text(
      option,
      style: TextStyle(
        fontSize: 16,
        color: isDark ? Colors.white : Colors.black87,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Pregunta
          Text(
            question.question,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // Fórmula LaTeX si existe o si es trivia de cálculo
          if (_isMatematicas && question.latex != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: isDark ? Colors.black26 : Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Colors.white24 : Colors.grey.shade300,
                ),
              ),
              child: Center(
                child: Math.tex(
                  question.latex!,
                  textStyle: TextStyle(
                    fontSize: 20,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
          ],

          // Opciones
          ...question.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.grey[800] : Colors.white,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => onOptionSelected(index),
                child: _buildOptionWidget(option, isDark),
              ),
            );
          }),
        ],
      ),
    );
  }
}