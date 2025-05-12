import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../models/math_exercise_model.dart';

class MathExerciseCard extends StatelessWidget {
  final MathExercise exercise;
  final Function(int) onOptionSelected;

  const MathExerciseCard({
    super.key,
    required this.exercise,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                exercise.question,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Math.tex(
                exercise.latex,
                textStyle: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...exercise.options.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: ElevatedButton(
              onPressed: () => onOptionSelected(entry.key),
              child: Math.tex(
                entry.value,
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          );
        }),
      ],
    );
  }
}
