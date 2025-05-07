import 'package:flutter/material.dart';
import '../../models/trivia_model.dart';

class QuestionCard extends StatelessWidget {
  final TriviaQuestion question;
  final Function(int) onOptionSelected;

  const QuestionCard({
    super.key,
    required this.question,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 16),
          color: const Color(0xFFB36B29),
          child: Text(
            question.question,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...List.generate(question.options.length, (index) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB36B29),
              ),
              onPressed: () => onOptionSelected(index),
              child: Text(
                question.options[index],
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }),
      ],
    );
  }
}
