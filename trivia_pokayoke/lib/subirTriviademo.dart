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

