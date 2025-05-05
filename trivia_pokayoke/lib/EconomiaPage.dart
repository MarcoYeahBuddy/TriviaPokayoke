import 'package:flutter/material.dart';

void main() {
  runApp(const EconomiaPage());
}

class EconomiaPage extends StatelessWidget {
  const EconomiaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trivia Economía',
      debugShowCheckedModeBanner: false,
      home: const TriviaPage(),
    );
  }
}

class TriviaPage extends StatelessWidget {
  const TriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF8D6467); // Marrón rosado exterior
    const contentColor = Color(0xFFB36B29); // Naranja-café principal
    const panelColor = Color(0xFF7A441C); // Panel oscuro
    const textColor = Colors.white;

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
              // Título
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: panelColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'ECONOMIA',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Fuego + x4
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.local_fire_department, color: Colors.orange, size: 30),
                  SizedBox(width: 8),
                  Text(
                    'x4',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Carita feliz (placeholder)
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.yellow,
                child: Icon(Icons.emoji_emotions, color: Colors.black, size: 40),
              ),
              const SizedBox(height: 20),
              // Contenedor de pregunta y respuestas
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: panelColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Pregunta
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        color: contentColor,
                        child: const Text(
                          '¿Cuál es el objetivo principal de la economía?',
                          style: TextStyle(
                            fontSize: 18,
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Opciones
                      ...['Aumentar el desempleo', 'Maximizar la producción', 'Reducir el consumo', 'Imprimir dinero sin límite']
                          .map(
                            (option) => Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: contentColor,
                                  padding: const EdgeInsets.all(12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {},
                                child: Text(
                                  option,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: textColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                    ],
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
