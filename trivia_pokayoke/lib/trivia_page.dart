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
      debugPrint('Raw trivia data: $data'); // Debug log

      final rawQuestions = data['preguntas'] as Map<String, dynamic>;
      debugPrint('Raw questions: $rawQuestions'); // Debug log

      final questions = rawQuestions.entries.map((entry) {
        final questionData = Map<String, dynamic>.from(entry.value);
        debugPrint('Processing question: $questionData'); // Debug log
        return TriviaQuestion.fromMap(questionData);
      }).toList();

      if (questions.isEmpty) {
        _showError('No hay preguntas en esta trivia.');
        return;
      }

      setState(() {
        materia = data['materia'] ?? 'General';
        docente = data['docente'] ?? 'Sin docente';
        carrera = data['carrera'] ?? 'General';
        remainingSeconds = questions.length * 30; // 30 segundos por pregunta

        controller = TriviaController(questions);
        isLoading = false;
      });
    } catch (e, stackTrace) {
      debugPrint('Error loading trivia: $e');
      debugPrint('Stack trace: $stackTrace');
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

  void _finishTrivia() async {
    if (!mounted) return;

    timer?.cancel();
    _timer.cancel();

    final Color carreraColor = _panelForMateria(carrera);
    final Color bgColor = _backgroundForMateria(carrera);

    // Frases motivadoras
    final frases = [
      "¡Cada intento te hace mejor!",
      "¡Sigue adelante, el aprendizaje es progreso!",
      "¡No te rindas, cada error es una oportunidad!",
      "¡Lo importante es participar y aprender!",
      "¡Hoy es un gran día para superarte!",
      "¡Tu esfuerzo vale más que el resultado!",
      "¡La práctica te llevará lejos!",
      "¡Sigue jugando, tu mejor versión está en camino!",
      "¡Eres capaz de lograr grandes cosas!",
      "¡El conocimiento es tu mejor recompensa!",
    ];

    // Selecciona una frase aleatoria
    final fraseMotivadora = (frases..shuffle()).first;

    // Determina si el puntaje es bajo (puedes ajustar el umbral)
    final bool puntajeBajo = _currentScore < 300;

    // Determina si el puntaje fue actualizado
    bool puntajeActualizado = false;
    int? puntajeAnterior;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final previousScores = await FirebaseFirestore.instance
          .collection('scores')
          .where('userId', isEqualTo: user.uid)
          .where('triviaId', isEqualTo: widget.triviaId)
          .get();

      if (previousScores.docs.isNotEmpty) {
        puntajeAnterior = previousScores.docs
            .map((doc) => doc.data()['score'] as int)
            .reduce((max, score) => score > max ? score : max);

        if (_currentScore > puntajeAnterior) {
          puntajeActualizado = true;
        }
      } else {
        puntajeActualizado = true; // Primer intento siempre es actualización
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          backgroundColor: carreraColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            decoration: BoxDecoration(
              color: carreraColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: bgColor.withOpacity(0.18),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(color: bgColor, width: 3),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(18),
                  child: Image.asset(
                    puntajeBajo ? 'images/cerebro_sad.png' : 'images/cerebro_bien.png',
                    height: 70,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  '🎉 ¡Trivia Finalizada!',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 2,
                        offset: const Offset(1, 1),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                  decoration: BoxDecoration(
                    color: bgColor.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Puntaje Final: $_currentScore pts',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.orangeAccent,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Respuestas Correctas: ${controller!.getScore()}/${controller!.questions.length}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.95),
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (puntajeActualizado)
                        Text(
                          puntajeAnterior != null
                              ? "¡Felicidades! Mejoraste tu puntaje anterior (${puntajeAnterior} pts)."
                              : "¡Tu puntaje ha sido registrado!",
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        )
                      else if (puntajeAnterior != null)
                        Text(
                          "No superaste tu mejor puntaje (${puntajeAnterior} pts), ¡pero puedes intentarlo de nuevo!",
                          style: const TextStyle(
                            color: Colors.yellowAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  fraseMotivadora,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    if (mounted) {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }
                  },
                  icon: const Icon(Icons.home, color: Colors.white),
                  label: const Text('Volver al inicio', style: TextStyle(fontSize: 16, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bgColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
              // Logo neutral personalizado
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: Image.asset(
                  'images/cerebro_question.png',
                  height: 60,
                  fit: BoxFit.contain,
                ),
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
                    carrera: materia, // Cambiado de carrera a materia
                  ),
                ),
              ),
            ],
          ),
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
        backgroundColor: _panelForMateria(carrera),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Limita el ancho máximo del diálogo para evitar overflow
            final double maxWidth = constraints.maxWidth < 420 ? constraints.maxWidth : 420;
            return Container(
              width: maxWidth,
              constraints: BoxConstraints(
                maxWidth: maxWidth,
                minWidth: 220,
                maxHeight: MediaQuery.of(context).size.height * 0.90,
              ),
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Imagen decorativa
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Image.asset(
                        isCorrect ? 'images/cerebro_bien.png' : 'images/cerebro_sad.png',
                        height: 50,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isCorrect ? '✅ ¡Correcto!' : '❌ Incorrecto',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (question.latex != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: 0,
                              maxWidth: maxWidth - 40,
                            ),
                            child: Math.tex(
                              question.latex!,
                              textStyle: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (question.explanation != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          question.explanation!,
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    if (question.pasos?.isNotEmpty ?? false) ...[
                      const SizedBox(height: 20),
                      const Text(
                        'Paso a paso:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...question.pasos!.asMap().entries.map((entry) {
                        final index = entry.key;
                        final step = entry.value;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Paso ${index + 1}:',
                                style: const TextStyle(
                                  color: Colors.orangeAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                step['texto'] ?? '',
                                style: const TextStyle(color: Colors.white),
                              ),
                              if (step['latex'] != null) ...[
                                const SizedBox(height: 8),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth: 0,
                                      maxWidth: maxWidth - 40,
                                    ),
                                    child: Math.tex(
                                      step['latex']!,
                                      textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      }).toList(),
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
                          startTimer();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _backgroundForMateria(carrera),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isLastQuestion ? 'Finalizar' : 'Siguiente Pregunta',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
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
}
