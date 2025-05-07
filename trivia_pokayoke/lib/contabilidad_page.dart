import 'package:flutter/material.dart';

class ContabilidadPage extends StatelessWidget {
  const ContabilidadPage({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF8D6467); // Marrón rosado exterior
    const contentColor = Color(0xFF2DB73D); // Verde brillante
    const panelColor = Color(0xFF145A1F); // Verde oscuro
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
              colors: [Color(0xFF27AE60), Color(0xFF145A1F)],
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
                  'CONTABILIDAD',
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
              // Icono de calculadora
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey,
                child: Icon(Icons.calculate, color: Colors.black87, size: 40),
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
                          '¿Qué documento muestra los activos, pasivos y patrimonio?',
                          style: TextStyle(
                            fontSize: 18,
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Opciones
                      ...[
                        'Estado de Resultados',
                        'Flujo de Efectivo',
                        'Balance General',
                        'Libro Diario'
                      ].map(
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
