import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void subirTriviaDemo() async {
  final List<Map<String, dynamic>> trivias = [
    {
      'id': 'sistemas_trivia_01',
      'data': {
        'anio': 2024,
        'docente': 'Ing. Carlos Rivera',
        'duracion_aprox': 5,
        'imagen_url': 'null',
        'materia': 'Algoritmos',
        'carrera': 'Ingeniería de Sistemas',
        'nivel': 'intermedio',
        'semestre': 'III',
        'sigla': 'INF-203',
        'preguntas': {
          'p1': {
            'pregunta': '¿Qué es un algoritmo?',
            'opciones': [
              'Una fórmula matemática',
              'Un conjunto de instrucciones paso a paso',
              'Un lenguaje de programación',
              'Una base de datos'
            ],
            'respuesta': 'Un conjunto de instrucciones paso a paso',
            'explicación': 'Un algoritmo es una secuencia ordenada de pasos que resuelve un problema.'
          },
          'p2': {
            'pregunta': '¿Qué estructura de control permite repetir instrucciones?',
            'opciones': ['Condicional', 'Función', 'Bucle', 'Clase'],
            'respuesta': 'Bucle',
            'explicación': 'Los bucles permiten repetir bloques de código hasta que se cumpla una condición.'
          },
        }
      }
    },
    {
      'id': 'medicina_trivia_01',
      'data': {
        'anio': 2024,
        'docente': 'Dr. Juan Pérez',
        'duracion_aprox': 5,
        'imagen_url': 'null',
        'materia': 'Anatomía Humana',
        'carrera': 'Medicina',
        'nivel': 'básico',
        'semestre': 'I',
        'sigla': 'MED-101',
        'preguntas': {
          'p1': {
            'pregunta': '¿Cuántos huesos tiene el cuerpo humano adulto?',
            'opciones': ['206', '300', '180', '250'],
            'respuesta': '206',
            'explicación': 'El cuerpo humano adulto tiene 206 huesos.'
          },
          'p2': {
            'pregunta': '¿Qué órgano bombea la sangre en el cuerpo?',
            'opciones': ['Hígado', 'Pulmón', 'Corazón', 'Riñón'],
            'respuesta': 'Corazón',
            'explicación': 'El corazón es el órgano responsable de bombear la sangre.'
          },
        }
      }
    },
    {
      'id': 'derecho_trivia_01',
      'data': {
        'anio': 2024,
        'docente': 'Lic. Ana Gómez',
        'duracion_aprox': 5,
        'imagen_url': 'null',
        'materia': 'Derecho Constitucional',
        'carrera': 'Derecho',
        'nivel': 'intermedio',
        'semestre': 'IV',
        'sigla': 'DER-202',
        'preguntas': {
          'p1': {
            'pregunta': '¿Qué establece una Constitución?',
            'opciones': [
              'Reglas de fútbol',
              'Normas de etiqueta',
              'La organización del Estado y los derechos fundamentales',
              'Precios de mercado'
            ],
            'respuesta': 'La organización del Estado y los derechos fundamentales',
            'explicación': 'La Constitución define la estructura del Estado y garantiza los derechos de los ciudadanos.'
          },
          'p2': {
            'pregunta': '¿Cuál es el poder encargado de interpretar las leyes?',
            'opciones': ['Ejecutivo', 'Legislativo', 'Judicial', 'Militar'],
            'respuesta': 'Judicial',
            'explicación': 'El poder judicial interpreta y aplica las leyes.'
          },
        }
      }
    },
  ];

  for (final trivia in trivias) {
    try {
      await FirebaseFirestore.instance
          .collection('trivias')
          .doc(trivia['id'])
          .set(trivia['data']);
      debugPrint('✅ Trivia subida exitosamente con ID: ${trivia['id']}');
    } catch (e) {
      debugPrint('❌ Error al subir trivia ${trivia['id']}: $e');
    }
  }
}

void subirTriviaMarketing() async {
  final triviaId = 'marketing_trivia_01';

  final triviaData = {
    'anio': 2024,
    'docente': 'Lic. Ana Torres',
    'duracion_aprox': 5,
    'imagen_url': 'null',
    'materia': 'Marketing',
    'nivel': 'intermedio',
    'semestre': 'I',
    'sigla': 'MKT-201',
    'preguntas': {
      'p1': {
        'pregunta': '¿Qué es el marketing?',
        'opciones': [
          'La producción en masa',
          'La venta al por mayor',
          'La identificación y satisfacción de necesidades',
          'El diseño de productos sin estudio'
        ],
        'respuesta': 'La identificación y satisfacción de necesidades',
        'explicación': 'El marketing se centra en comprender y satisfacer las necesidades del consumidor.'
      },
      'p2': {
        'pregunta': '¿Qué representa el análisis FODA?',
        'opciones': [
          'Fuerzas, Oportunidades, Debilidades y Amenazas',
          'Factores, Operaciones, Desarrollo y Administración',
          'Finanzas, Oferta, Demanda y Administración',
          'Formación, Objetivos, Diagnóstico y Ajuste'
        ],
        'respuesta': 'Fuerzas, Oportunidades, Debilidades y Amenazas',
        'explicación': 'FODA es una herramienta estratégica para analizar el entorno interno y externo.'
      },
      'p3': {
        'pregunta': '¿Qué es el segmento de mercado?',
        'opciones': [
          'El grupo total de consumidores',
          'Un grupo homogéneo dentro del mercado',
          'La estrategia de distribución',
          'El presupuesto de publicidad'
        ],
        'respuesta': 'Un grupo homogéneo dentro del mercado',
        'explicación': 'Segmentar el mercado permite dirigir esfuerzos hacia grupos específicos.'
      }
    }
  };

  try {
    await FirebaseFirestore.instance
        .collection('trivias')
        .doc(triviaId)
        .set(triviaData);

    debugPrint('✅ Trivia de Marketing subida correctamente.');
  } catch (e) {
    debugPrint('❌ Error al subir trivia de Marketing: $e');
  }
}
void subirTriviaContabilidad() async {
  final triviaId = 'contabilidad_trivia_01';

  final triviaData = {
    'anio': 2024,
    'docente': 'Lic. Juan Pérez',
    'duracion_aprox': 5,
    'imagen_url': 'null',
    'materia': 'Contabilidad',
    'nivel': 'básico',
    'semestre': 'II',
    'sigla': 'CONT-101',
    'preguntas': {
      'p1': {
        'pregunta': '¿Qué es la contabilidad?',
        'opciones': [
          'El arte de vender productos',
          'Un sistema para gestionar redes',
          'El proceso de registrar, clasificar y resumir transacciones',
          'Una estrategia de marketing'
        ],
        'respuesta': 'El proceso de registrar, clasificar y resumir transacciones',
        'explicación': 'La contabilidad organiza la información financiera de manera sistemática.'
      },
      'p2': {
        'pregunta': '¿Cuál es el objetivo principal de la contabilidad financiera?',
        'opciones': [
          'Diseñar campañas de ventas',
          'Producir informes internos',
          'Proporcionar información útil a externos',
          'Registrar únicamente gastos'
        ],
        'respuesta': 'Proporcionar información útil a externos',
        'explicación': 'Está orientada a usuarios externos como inversionistas, acreedores y entes reguladores.'
      },
      'p3': {
        'pregunta': '¿Qué representa el balance general?',
        'opciones': [
          'El flujo de caja',
          'El rendimiento de ventas',
          'La situación financiera en un momento específico',
          'El presupuesto anual'
        ],
        'respuesta': 'La situación financiera en un momento específico',
        'explicación': 'El balance general muestra activos, pasivos y patrimonio en una fecha determinada.'
      }
    }
  };

  try {
    await FirebaseFirestore.instance
        .collection('trivias')
        .doc(triviaId)
        .set(triviaData);

    debugPrint('✅ Trivia de Contabilidad subida correctamente.');
  } catch (e) {
    debugPrint('❌ Error al subir trivia de Contabilidad: $e');
  }
}

