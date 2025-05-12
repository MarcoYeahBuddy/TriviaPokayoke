import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../models/math_exercise_model.dart';

class ExerciseSolutionPage extends StatelessWidget {
  final List<MathExercise> exercises;
  final List<bool> results;

  const ExerciseSolutionPage({
    super.key,
    required this.exercises,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Soluciones'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ExpansionTile(
              title: Text('Ejercicio ${index + 1}'),
              subtitle: Text(
                results[index] ? '✅ Correcto' : '❌ Incorrecto',
                style: TextStyle(
                  color: results[index] ? Colors.green : Colors.red,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Math.tex(exercise.latex),
                      const Divider(),
                      ...exercise.solutionSteps.map((step) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(step.explanation),
                            const SizedBox(height: 8),
                            Math.tex(step.latex),
                            if (step.imageUrl != null)
                              Image.network(step.imageUrl!),
                            const SizedBox(height: 16),
                          ],
                        );
                      }),
                      const Divider(),
                      Text(
                        'Explicación final:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(exercise.finalExplanation),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
