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
      'p1': {
        'pregunta': 'Encuentra la derivada de la función:',
        'latex': 'f(x) = x^2 \\sin(x)',
        'opciones': [
          '2x\\sin(x) + x^2\\cos(x)',
          'x^2\\sin(x) + 2x\\cos(x)',
          '2x\\sin(x) - x^2\\cos(x)',
          '2x\\sin(x)'
        ],
        'respuesta': '2x\\sin(x) + x^2\\cos(x)',
        'explicación': 'Veamos paso a paso cómo resolver esta derivada usando la regla del producto.',
        'pasos': [
          {
            'texto': 'Aplicamos la regla del producto: d/dx[u·v] = u\'v + uv\'',
            'latex': '\\frac{d}{dx}[x^2 \\sin(x)] = \\frac{d}{dx}[x^2]\\sin(x) + x^2\\frac{d}{dx}[\\sin(x)]'
          },
          {
            'texto': 'Derivamos x² → 2x',
            'latex': '= (2x)\\sin(x) + x^2\\frac{d}{dx}[\\sin(x)]'
          },
          {
            'texto': 'Derivamos sin(x) → cos(x)',
            'latex': '= (2x)\\sin(x) + x^2\\cos(x)'
          },
          {
            'texto': 'Esta es nuestra respuesta final',
            'latex': '= 2x\\sin(x) + x^2\\cos(x)'
          }
        ]
      },
      'p2': {
        'pregunta': 'Calcula el límite:',
        'latex': '\\lim_{x \\to 0} \\frac{\\sin(x)}{x}',
        'opciones': ['0', '1', '\\infty', 'No existe'],
        'respuesta': '1',
        'explicación': 'Este es uno de los límites fundamentales más importantes del cálculo.',
        'pasos': [
          {
            'texto': 'Este es un límite especial conocido como límite fundamental.',
            'latex': '\\lim_{x \\to 0} \\frac{\\sin(x)}{x} = 1'
          },
          {
            'texto': 'Podemos verificarlo usando la serie de Taylor de sin(x)',
            'latex': '\\sin(x) = x - \\frac{x^3}{3!} + \\frac{x^5}{5!} - ...'
          },
          {
            'texto': 'Al sustituir en el límite y simplificar',
            'latex': '\\lim_{x \\to 0} \\frac{x - \\frac{x^3}{6} + ...}{x} = \\lim_{x \\to 0} (1 - \\frac{x^2}{6} + ...) = 1'
          }
        ]
      },
      'p3': {
        'pregunta': 'Encuentra la integral indefinida:',
        'latex': '\\int x^2e^x dx',
        'opciones': [
          'x^2e^x - 2xe^x + 2e^x + C',
          'x^2e^x + 2xe^x + 2e^x + C',
          'x^2e^x - 2xe^x - 2e^x + C',
          'x^2e^x + C'
        ],
        'respuesta': 'x^2e^x - 2xe^x + 2e^x + C',
        'explicación': 'Resolveremos esta integral usando integración por partes dos veces.',
        'pasos': [
          {
            'texto': 'Primera integración por partes con u = x² y dv = e^x dx',
            'latex': '\\int x^2e^x dx = x^2e^x - \\int (2x)e^x dx'
          },
          {
            'texto': 'Segunda integración por partes con u = 2x y dv = e^x dx',
            'latex': '= x^2e^x - (2xe^x - \\int 2e^x dx)'
          },
          {
            'texto': 'Resolvemos la última integral',
            'latex': '= x^2e^x - (2xe^x - 2e^x)'
          },
          {
            'texto': 'Simplificamos y agregamos la constante de integración',
            'latex': '= x^2e^x - 2xe^x + 2e^x + C'
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
