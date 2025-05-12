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
  final String? carrera;

  const QuestionCard({
    Key? key,
    required this.question,
    required this.onOptionSelected,
    required this.carrera,
  }) : super(key: key);

  bool _isLatex(String text) {
    return text.trim().startsWith(r'\') ||
        (text.trim().startsWith(r'$') && text.trim().endsWith(r'$'));
  }

  @override
  Widget build(BuildContext context) {
    final carreraKey = (carrera ?? 'default').toLowerCase();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = CarreraColors.background(carreraKey, isDark);
    final panelColor = CarreraColors.panel(carreraKey, isDark);

    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: panelColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(color: backgroundColor, width: 3),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Pregunta
                AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    question.question,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 2,
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Fórmula LaTeX si existe
                if (question.latex != null) ...[
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: backgroundColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Math.tex(
                      question.latex!,
                      textStyle: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Opciones (ahora con wrap de texto y sin scroll horizontal)
                ...question.options.asMap().entries.map((entry) {
                  final index = entry.key;
                  final option = entry.value;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: backgroundColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: Colors.white.withOpacity(0.7),
                              width: 1.5,
                            ),
                          ),
                          shadowColor: Colors.black.withOpacity(0.18),
                        ),
                        onPressed: () => onOptionSelected(index),
                        child: _isLatex(option)
                            ? Math.tex(
                                option,
                                textStyle: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                option,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                                textAlign: TextAlign.center,
                              ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
