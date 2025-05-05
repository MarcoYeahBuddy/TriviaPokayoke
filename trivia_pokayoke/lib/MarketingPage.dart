import 'package:flutter/material.dart';

class MarketingPage extends StatelessWidget {
  const MarketingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4A69BD), Color(0xFF1B2F5C)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Título
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF3D4E85),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'MARKETING',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),

              // Contador de fuego
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF5D6FA9),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("🔥", style: TextStyle(fontSize: 20)),
                    SizedBox(width: 8),
                    Text(
                      'x4',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Emoji animado
              const Text(
                '🧠', // Diferente emoji para Marketing
                style: TextStyle(fontSize: 80),
              ),

              const SizedBox(height: 12),

              // Pregunta y opciones
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E3A5F),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      // Pregunta
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3C466D),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '¿Qué es el marketing digital?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      // Opciones
                      ...[
                        'Publicidad en internet',
                        'Contabilidad online',
                        'Gestión de personal',
                        'Análisis financiero'
                      ].map(
                        (text) => Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(14),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFF3C466D),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
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
