import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../models/trivia_model.dart';

class QuestionCard extends StatelessWidget {
  final TriviaQuestion question;
  final Function(int) onOptionSelected;

  const QuestionCard({
    Key? key,
    required this.question,
    required this.onOptionSelected,
  }) : super(key: key);

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

          // Fórmula LaTeX si existe
          if (question.latex != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Math.tex(
                question.latex!,
                textStyle: TextStyle(
                  fontSize: 20,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Opciones
          ...question.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.grey[800] : Colors.white,
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.centerLeft,
                ),
                onPressed: () => onOptionSelected(index),
                child: Math.tex(
                  option,
                  textStyle: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
