import 'package:flutter/material.dart';
import 'controllers/trivia_controller.dart';
import 'models/trivia_model.dart';

class EconomiaPage extends StatelessWidget {
  const EconomiaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TriviaScreen();
  }
}

class TriviaScreen extends StatefulWidget {
  const TriviaScreen({super.key});

  @override
  State<TriviaScreen> createState() => _TriviaScreenState();
}

class _TriviaScreenState extends State<TriviaScreen> {
  late TriviaController controller;

  final List<TriviaQuestion> questions = [
    TriviaQuestion(
      question: '¿Cuál es el objetivo principal de la economía?',
      options: ['Aumentar el desempleo', 'Maximizar la producción', 'Reducir el consumo', 'Imprimir dinero sin límite'],
      correctIndex: 1,
    ),
    TriviaQuestion(
      question: '¿Qué mide el PIB?',
      options: ['Inflación', 'Crecimiento demográfico', 'Producción económica', 'Exportaciones'],
      correctIndex: 2,
    ),
  ];

  @override
  void initState() {
    super.initState();
    controller = TriviaController(questions);
  }

  void handleAnswer(int selectedIndex) {
    final isCorrect = controller.isCorrect(selectedIndex);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isCorrect ? '✅ ¡Correcto!' : '❌ Incorrecto'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (!controller.isLastQuestion()) {
                setState(() {
                  controller.nextQuestion();
                });
              } else {
                final score = controller.getScore();
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('🎉 ¡Quiz Finalizado!'),
                    content: Text('Tu puntaje es: $score/${controller.questions.length}'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Aceptar'),
                      ),
                    ],
                  ),
                );
              }
            },
            child: const Text('Continuar'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF8D6467);
    const panelColor = Color(0xFF7A441C);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Container(
          width: 360,
          height: 740,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFCC8131), Color(0xFF7A441C)],
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
                child: const Text(
                  'ECONOMÍA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_fire_department, color: Colors.orange, size: 30),
                  SizedBox(width: 8),
                  Text('x4', style: TextStyle(color: Colors.white, fontSize: 22)),
                ],
              ),
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.yellow,
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
                  /*child: QuestionCard(
                    question: controller.questions[controller.currentIndex],
                    onOptionSelected: handleAnswer,,
                  ),*/
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
