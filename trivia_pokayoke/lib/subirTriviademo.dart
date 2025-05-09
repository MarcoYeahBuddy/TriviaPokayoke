import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void subirTriviaDemo() async {
  final triviaId = 'eco_trivia_01'; // ID personalizado, o usa .add() para autogen

  final triviaData = {
    'anio': 2024,
    'docente': 'Dra. María López',
    'duracion_aprox': 5,
    'imagen_url': 'null',
    'materia': 'Economía',
    'nivel': 'básico',
    'semestre': 'II',
    'sigla': 'ECO-101',
    'preguntas': {
      'p1': {
        'pregunta': '¿Cuál es el objetivo principal de la economía?',
        'opciones': [
          'Aumentar el desempleo',
          'Maximizar la producción',
          'Reducir el consumo',
          'Imprimir dinero sin límite'
        ],
        'respuesta': 'Maximizar la producción',
        'explicación': 'La economía busca asignar eficientemente los recursos escasos para maximizar la producción y el bienestar.'
      },
      'p2': {
        'pregunta': '¿Qué mide el PIB?',
        'opciones': [
          'Inflación',
          'Crecimiento demográfico',
          'Producción económica',
          'Exportaciones'
        ],
        'respuesta': 'Producción económica',
        'explicación': 'El PIB mide el valor total de los bienes y servicios producidos en un país.'
      },
      'p3': {
        'pregunta': '¿Qué es la inflación?',
        'opciones': [
          'La caída de precios',
          'El aumento generalizado de precios',
          'El ahorro excesivo',
          'La reducción de exportaciones'
        ],
        'respuesta': 'El aumento generalizado de precios',
        'explicación': 'La inflación representa el aumento sostenido del nivel general de precios de bienes y servicios.'
      }
    }
  };

  try {
    await FirebaseFirestore.instance
        .collection('trivias')
        .doc(triviaId)
        .set(triviaData);

    debugPrint('✅ Trivia subida exitosamente con ID: $triviaId');
  } catch (e) {
    debugPrint('❌ Error al subir trivia: $e');
  }
}
