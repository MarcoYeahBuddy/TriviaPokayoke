import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/trivia_controller.dart';
import '../models/trivia_model.dart';
import '../widgets/question_card.dart';

class TriviaScreen extends StatefulWidget {
  final String triviaId;

  const TriviaScreen({super.key, required this.triviaId});

  @override
  State<TriviaScreen> createState() => _TriviaScreenState();
}

class _TriviaScreenState extends State<TriviaScreen> {
  TriviaController? controller;
  bool isLoading = true;
  int remainingSeconds = 0;
  Timer? timer;

  String materia = '';
  String docente = '';
  Color panelColor = const Color(0xFF7A441C);
  Color backgroundColor = const Color(0xFF8D6467);

  @override
  void initState() {
    super.initState();
    _loadTrivia();
  }

  Future<void> _loadTrivia() async {
    final doc = await FirebaseFirestore.instance
        .collection('trivias')
        .doc(widget.triviaId)
        .get();

    if (!doc.exists) {
      _showError('Trivia no encontrada.');
      return;
    }

    final data = doc.data()!;
    final rawQuestions = data['preguntas'] as Map<String, dynamic>;

    final questions = rawQuestions.values
        .map((q) => TriviaQuestion.fromMap(q as Map<String, dynamic>))
        .toList();

    setState(() {
      materia = data['materia'] ?? 'General';
      docente = data['docente'] ?? 'Sin docente';
      remainingSeconds = (data['duracion_aprox'] ?? 5) * 60;

      backgroundColor = _backgroundForMateria(materia);
      panelColor = _panelForMateria(materia);

      controller = TriviaController(questions);
      isLoading = false;

      _startTimer();
    });
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remainingSeconds <= 0) {
        t.cancel();
        _finishTrivia();
      } else {
        setState(() {
          remainingSeconds--;
        });
      }
    });
  }

  void _finishTrivia() {
    timer?.cancel();
    final score = controller!.getScore();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 ¡Trivia Finalizada!'),
        content: Text('Puntaje: $score/${controller!.questions.length}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            child: const Text('Salir'),
          ),
        ],
      ),
    );
  }

  void handleAnswer(int selectedIndex) {
    final question = controller!.questions[controller!.currentIndex];
    question.selectedIndex = selectedIndex;

    final isCorrect = controller!.isCorrect(selectedIndex);
    final explanation = question.explanation;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isCorrect ? '✅ ¡Correcto!' : '❌ Incorrecto'),
        content: !isCorrect && explanation != null
            ? Text('Explicación: $explanation')
            : null,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (!controller!.isLastQuestion()) {
                setState(() => controller!.nextQuestion());
              } else {
                _finishTrivia();
              }
            },
            child: const Text('Continuar'),
          )
        ],
      ),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
    Navigator.pop(context);
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Color _backgroundForMateria(String materia) {
    switch (materia.toLowerCase()) {
      case 'economía':
        return const Color(0xFF8D6467);
      case 'contabilidad':
        return const Color(0xFF5D8B72);
      case 'marketing':
        return const Color(0xFF5A7F9C);
      default:
        return Colors.grey.shade400;
    }
  }

  Color _panelForMateria(String materia) {
    switch (materia.toLowerCase()) {
      case 'economía':
        return const Color(0xFF7A441C);
      case 'contabilidad':
        return const Color(0xFF3A6B50);
      case 'marketing':
        return const Color(0xFF2F5570);
      default:
        return Colors.grey.shade600;
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || controller == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final question = controller!.questions[controller!.currentIndex];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Container(
          width: 360,
          height: 740,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [panelColor.withOpacity(0.7), panelColor],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: panelColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  materia.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Docente: $docente',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                '⏳ Tiempo: ${_formatTime(remainingSeconds)}',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.amber,
                child: Icon(Icons.emoji_emotions, color: Colors.black, size: 40),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: panelColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: QuestionCard(
                    question: question,
                    onOptionSelected: handleAnswer,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
