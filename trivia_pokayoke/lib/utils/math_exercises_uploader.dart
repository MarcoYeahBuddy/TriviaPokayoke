import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> uploadCalculusExercises() async {
  final firestore = FirebaseFirestore.instance;
  
  final triviaData = {
    'materia': 'Cálculo I',
    'carrera': 'Ingeniería de Sistemas',
    'docente': 'Dr. Matemáticas',
    'duracion_aprox': 30,
    'sigla': 'MAT-101',
    'preguntas': {
      'q1': {
        'question': 'Encuentra la derivada de la función:',
        'latex': 'f(x) = x^2 \\sin(x)',
        'options': [
          '2x\\sin(x) + x^2\\cos(x)',
          'x^2\\sin(x) + 2x\\cos(x)',
          '2x\\sin(x) - x^2\\cos(x)',
          '2x\\sin(x)'
        ],
        'correctIndex': 0,
        'explanation': 'Se aplica la regla del producto.',
        'solutionSteps': [
          {
            'explanation': 'Aplicamos la regla del producto:',
            'latex': '\\frac{d}{dx}[u\\cdot v] = u\'v + uv\''
          },
          {
            'explanation': 'Identificamos u = x² y v = sin(x)',
            'latex': '\\frac{d}{dx}[x^2] \\cdot \\sin(x) + x^2 \\cdot \\frac{d}{dx}[\\sin(x)]'
          },
          {
            'explanation': 'Derivamos cada parte:',
            'latex': '(2x)\\sin(x) + x^2(\\cos(x))'
          }
        ]
      },
      'q2': {
        'question': 'Calcula el límite:',
        'latex': '\\lim_{x \\to 0} \\frac{\\sin(x)}{x}',
        'options': ['0', '1', '\\infty', 'No existe'],
        'correctIndex': 1,
        'explanation': 'Este es un límite fundamental.',
        'solutionSteps': [
          {
            'explanation': 'Este es un límite especial conocido como límite fundamental:',
            'latex': '\\lim_{x \\to 0} \\frac{\\sin(x)}{x} = 1'
          },
          {
            'explanation': 'Podemos verificarlo usando la serie de Taylor de sin(x):',
            'latex': '\\sin(x) = x - \\frac{x^3}{3!} + \\frac{x^5}{5!} - ...'
          }
        ]
      },
      'q3': {
        'question': 'Encuentra la integral indefinida:',
        'latex': '\\int x^2e^x dx',
        'options': [
          'x^2e^x - 2xe^x + 2e^x + C',
          'x^2e^x + 2xe^x + 2e^x + C',
          'x^2e^x - 2xe^x - 2e^x + C',
          'x^2e^x + C'
        ],
        'correctIndex': 0,
        'explanation': 'Se resuelve usando integración por partes dos veces.',
        'solutionSteps': [
          {
            'explanation': 'Primera integración por partes: u = x², dv = e^x dx',
            'latex': 'x^2e^x - \\int 2xe^x dx'
          },
          {
            'explanation': 'Segunda integración por partes: u = x, dv = e^x dx',
            'latex': 'x^2e^x - (2xe^x - 2\\int e^x dx)'
          },
          {
            'explanation': 'Resultado final:',
            'latex': 'x^2e^x - 2xe^x + 2e^x + C'
          }
        ]
      }
    }
  };

  try {
    await firestore.collection('trivias').add(triviaData);
    print('Ejercicios de cálculo subidos exitosamente');
  } catch (e) {
    print('Error al subir ejercicios: $e');
    rethrow;
  }
}

// Puedes agregar más funciones para diferentes temas
Future<void> uploadLimitsExercises() async {
  // Similar estructura pero con ejercicios de límites
}

Future<void> uploadIntegrationExercises() async {
  // Similar estructura pero con ejercicios de integración
}
