import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controllers/trivia_controller.dart';
import '../models/trivia_model.dart';
import '../models/score_model.dart';
import '../widgets/question_card.dart';
import 'package:flutter_math_fork/flutter_math.dart';

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
  late Timer _timer;
  int _timeLeft = 10;
  int _currentScore = 0;
  int _questionStartTime = 0;

  String materia = '';
  String docente = '';
  String carrera = '';
  Color panelColor = const Color(0xFF7A441C);
  Color backgroundColor = const Color(0xFF8D6467);

  @override
  void initState() {
    super.initState();
    _loadTrivia();
    startTimer();
  }

  Future<void> _loadTrivia() async {
    try {
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

      if (questions.isEmpty) {
        _showError('No hay preguntas en esta trivia.');
        return;
      }

      setState(() {
        materia = data['materia'] ?? 'General';
        docente = data['docente'] ?? 'Sin docente';
        carrera = data['carrera'] ?? 'General';
        remainingSeconds = questions.length * 15; // 15 segundos por pregunta

        controller = TriviaController(questions);
        isLoading = false;

        _startTimer();
      });
    } catch (e) {
      _showError('Error al cargar la trivia: $e');
    }
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      
      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--;
        } else {
          t.cancel();
          _finishTrivia();
        }
      });
    });
  }

  void startTimer() {
    _timeLeft = 30; // Aumentamos el tiempo por pregunta a 30 segundos
    _questionStartTime = DateTime.now().millisecondsSinceEpoch;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }

      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          t.cancel();
          handleTimeout();
        }
      });
    });
  }

  void pauseTimer() {
    timer?.cancel();
    _timer.cancel();
  }

  void handleTimeout() {
    _timer.cancel();
    handleAnswer(-1); // -1 indicates timeout
  }

  void calculateScore(bool isCorrect) {
    if (!isCorrect) return;

    final endTime = DateTime.now().millisecondsSinceEpoch;
    final timeTaken = endTime - _questionStartTime;
    final maxScore = 1000;
    final score = (maxScore * (1 - (timeTaken / 10000))).round();
    _currentScore += score.clamp(0, maxScore);
  }

  Future<void> saveScore() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      
      final userData = userDoc.data();
      final userName = userData != null 
          ? "${userData['nombre']} ${userData['apellido']}"
          : "Usuario";

      final triviaDoc = await FirebaseFirestore.instance
          .collection('trivias')
          .doc(widget.triviaId)
          .get();

      // Buscar puntaje anterior del usuario en esta trivia
      final previousScores = await FirebaseFirestore.instance
          .collection('scores')
          .where('userId', isEqualTo: user.uid)
          .where('triviaId', isEqualTo: widget.triviaId)
          .get();

      // Si hay puntajes anteriores, verificar si el nuevo es mejor
      if (previousScores.docs.isNotEmpty) {
        final previousHighScore = previousScores.docs
            .map((doc) => doc.data()['score'] as int)
            .reduce((max, score) => score > max ? score : max);

        // Si el puntaje nuevo es mejor, eliminar los anteriores
        if (_currentScore > previousHighScore) {
          // Eliminar puntajes anteriores
          for (var doc in previousScores.docs) {
            await FirebaseFirestore.instance
                .collection('scores')
                .doc(doc.id)
                .delete();
          }

          // Guardar nuevo puntaje
          await _saveNewScore(user.uid, userName, triviaDoc);
        }
      } else {
        // Si no hay puntajes anteriores, guardar el nuevo
        await _saveNewScore(user.uid, userName, triviaDoc);
      }
    } catch (e) {
      debugPrint('Error saving score: $e');
    }
  }

  Future<void> _saveNewScore(String userId, String userName, DocumentSnapshot triviaDoc) async {
    Map<String, dynamic>? triviaData = triviaDoc.data() as Map<String, dynamic>?;
    
    final score = Score(
      userId: userId,
      userName: userName,
      score: _currentScore,
      triviaId: widget.triviaId,
      triviaName: triviaData?['materia'] ?? 'Unknown',
      timestamp: DateTime.now(),
    );

    await FirebaseFirestore.instance
        .collection('scores')
        .add(score.toMap());
  }

  void _finishTrivia() {
    if (!mounted) return;
    
    timer?.cancel();
    _timer.cancel();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: const Text('🎉 ¡Trivia Finalizada!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Puntaje Final: $_currentScore pts'),
              Text('Respuestas Correctas: ${controller!.getScore()}/${controller!.questions.length}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (mounted) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              },
              child: const Text('Volver al inicio'),
            ),
          ],
        ),
      ),
    );
  }

  void handleAnswer(int selectedIndex) {
    pauseTimer(); // Pausamos el tiempo al responder
    final question = controller!.questions[controller!.currentIndex];
    question.selectedIndex = selectedIndex;

    final isCorrect = controller!.isCorrect(selectedIndex);
    calculateScore(isCorrect);
    final isLastQuestion = controller!.isLastQuestion();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isCorrect ? '✅ ¡Correcto!' : '❌ Incorrecto',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              if (question.explanation != null) ...[
                Text(question.explanation!),
                const SizedBox(height: 16),
              ],
              if (question.solutionSteps != null) ...[
                const Text(
                  'Explicación paso a paso:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: SingleChildScrollView(
                    child: Column(
                      children: question.solutionSteps!.map((step) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step['explanation']!,
                            style: const TextStyle(fontSize: 16),
                          ),
                          if (step['latex'] != null) ...[
                            const SizedBox(height: 8),
                            Math.tex(
                              step['latex']!,
                              textStyle: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ],
                      )).toList(),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (isLastQuestion) {
                    saveScore();
                    _finishTrivia();
                  } else {
                    setState(() => controller!.nextQuestion());
                    startTimer(); // Reiniciamos el tiempo al pasar a la siguiente pregunta
                  }
                },
                child: Text(
                  isLastQuestion ? 'Finalizar' : 'Siguiente Pregunta',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
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

  Color _backgroundForMateria(String carrera) {
    switch (carrera.toLowerCase()) {
      case 'economía':
        return const Color(0xFF8D6467);
      case 'contabilidad':
        return const Color(0xFF5D8B72);
      case 'marketing':
        return const Color(0xFF5A7F9C);
      case 'ingeniería de sistemas':
      case 'ingenieria de sistemas':
        return const Color(0xFF4A6C8C);
      case 'medicina':
        return const Color(0xFFB56576);
      case 'derecho':
        return const Color(0xFF937DC2);
      default:
        return Colors.grey.shade400;
    }
  }

  Color _panelForMateria(String carrera) {
    switch (carrera.toLowerCase()) {
      case 'economía':
        return const Color(0xFF7A441C);
      case 'contabilidad':
        return const Color(0xFF3A6B50);
      case 'marketing':
        return const Color(0xFF2F5570);
      case 'ingeniería de sistemas':
      case 'ingenieria de sistemas':
        return const Color(0xFF2E4A62);
      case 'medicina':
        return const Color(0xFF924055);
      case 'derecho':
        return const Color(0xFF6A55A4);
      default:
        return Colors.grey.shade600;
    }
  }

  Color _gradientTopForMateria(String carrera) {
    switch (carrera.toLowerCase()) {
      case 'economía':
        return const Color(0xFFCC8131);
      case 'contabilidad':
        return const Color(0xFF7FC7A1);
      case 'marketing':
        return const Color(0xFF7FB3D5);
      case 'ingeniería de sistemas':
      case 'ingenieria de sistemas':
        return const Color(0xFF6CA0D1);
      case 'medicina':
        return const Color(0xFFF7A1B3);
      case 'derecho':
        return const Color(0xFFD1B3F7);
      default:
        return Colors.grey.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || controller == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final question = controller!.questions[controller!.currentIndex];
    final bgColor = _backgroundForMateria(carrera);
    final pnlColor = _panelForMateria(carrera);
    final gradTop = _gradientTopForMateria(carrera);

    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Container(
          width: 360,
          height: 740,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [gradTop, pnlColor],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: pnlColor,
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
                    color: pnlColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: QuestionCard(
                    question: question,
                    onOptionSelected: handleAnswer,
                    carrera: carrera,
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
