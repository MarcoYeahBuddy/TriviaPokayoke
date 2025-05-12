import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void subirTriviaDemo() async {
final List<Map<String, dynamic>> trivias = [

  // Trivia para Contabilidad
  {
    'id': 'contabilidad_trivia_02',
    'data': {
      'anio': 2024,
      'docente': 'Lic. Patricia Rojas',
      'duracion_aprox': 6,
      'imagen_url': 'null',
      'materia': 'Contabilidad General',
      'carrera': 'Contabilidad',
      'nivel': 'básico',
      'semestre': 'I',
      'sigla': 'CON-101',
      'preguntas': {
        'p1': {
          'pregunta': '¿Qué es un activo?',
          'opciones': ['Un gasto', 'Una obligación', 'Un recurso económico', 'Una pérdida'],
          'respuesta': 'Un recurso económico',
          'explicación': 'Los activos son recursos controlados por una entidad con beneficios futuros.'
        },
        'p2': {
          'pregunta': '¿Qué documento muestra la situación financiera?',
          'opciones': ['Estado de resultados', 'Balance general', 'Libro diario', 'Nota explicativa'],
          'respuesta': 'Balance general',
          'explicación': 'El balance general resume activos, pasivos y patrimonio de una entidad.'
        },
        'p3': {
          'pregunta': '¿Qué representa una cuenta por pagar?',
          'opciones': ['Un ingreso', 'Un activo', 'Un pasivo', 'Una utilidad'],
          'respuesta': 'Un pasivo',
          'explicación': 'Una cuenta por pagar es una obligación financiera de la empresa.'
        },
        'p4': {
          'pregunta': '¿Cuál es el principio de devengo?',
          'opciones': [
            'Registrar ingresos cuando se cobra',
            'Registrar gastos cuando se paga',
            'Reconocer ingresos y gastos cuando ocurren, no cuando se cobra o paga',
            'Ignorar ingresos no cobrados'
          ],
          'respuesta': 'Reconocer ingresos y gastos cuando ocurren, no cuando se cobra o paga',
          'explicación': 'El principio de devengo refleja mejor la realidad económica de la empresa.'
        },
        'p5': {
          'pregunta': '¿Qué se registra en el libro diario?',
          'opciones': ['Las ventas', 'Las compras', 'Todas las transacciones contables diarias', 'Los estados financieros'],
          'respuesta': 'Todas las transacciones contables diarias',
          'explicación': 'El libro diario registra cronológicamente todas las operaciones contables.'
        },
      }
    }
  },

  // Trivia para Marketing
  {
    'id': 'marketing_trivia_02',
    'data': {
      'anio': 2024,
      'docente': 'Lic. Rodrigo Morales',
      'duracion_aprox': 6,
      'imagen_url': 'null',
      'materia': 'Fundamentos de Marketing',
      'carrera': 'Marketing',
      'nivel': 'básico',
      'semestre': 'II',
      'sigla': 'MKT-102',
      'preguntas': {
        'p1': {
          'pregunta': '¿Qué es el marketing?',
          'opciones': [
            'La publicidad de productos',
            'La venta directa',
            'El proceso de crear valor para el cliente y construir relaciones',
            'El diseño de logos'
          ],
          'respuesta': 'El proceso de crear valor para el cliente y construir relaciones',
          'explicación': 'El marketing busca satisfacer necesidades mediante propuestas de valor.'
        },
        'p2': {
          'pregunta': '¿Cuál es una de las 4P del marketing?',
          'opciones': ['Precio', 'Proceso', 'Persona', 'Participación'],
          'respuesta': 'Precio',
          'explicación': 'Producto, Precio, Plaza y Promoción son las 4P del marketing tradicional.'
        },
        'p3': {
          'pregunta': '¿Qué es el mercado meta?',
          'opciones': [
            'Todos los consumidores posibles',
            'Clientes fieles',
            'Segmento específico al que se dirige un producto',
            'Competidores'
          ],
          'respuesta': 'Segmento específico al que se dirige un producto',
          'explicación': 'El mercado meta es el público objetivo del esfuerzo de marketing.'
        },
        'p4': {
          'pregunta': '¿Qué herramienta se usa para analizar el entorno?',
          'opciones': ['Análisis FODA', 'Benchmarking', 'Buzón de quejas', 'Publicidad'],
          'respuesta': 'Análisis FODA',
          'explicación': 'FODA permite evaluar fortalezas, oportunidades, debilidades y amenazas.'
        },
        'p5': {
          'pregunta': '¿Qué es una marca?',
          'opciones': ['El nombre del producto', 'Un logotipo', 'Una percepción en la mente del consumidor', 'Un eslogan'],
          'respuesta': 'Una percepción en la mente del consumidor',
          'explicación': 'Una marca es la imagen y significado que el público asocia a un producto o empresa.'
        },
        'p6': {
          'pregunta': '¿Cuál es el objetivo principal del marketing digital?',
          'opciones': [
            'Diseñar páginas web',
            'Viralizar contenidos sin propósito',
            'Alcanzar y conectar con consumidores en medios digitales',
            'Ofrecer descuentos'
          ],
          'respuesta': 'Alcanzar y conectar con consumidores en medios digitales',
          'explicación': 'El marketing digital busca llegar al cliente a través de plataformas online.'
        },
      }
    }
  },

  // Trivia para Economía
  {
    'id': 'economia_trivia_02',
    'data': {
      'anio': 2024,
      'docente': 'M.Sc. Valeria Mendoza',
      'duracion_aprox': 6,
      'imagen_url': 'null',
      'materia': 'Microeconomía',
      'carrera': 'Economía',
      'nivel': 'intermedio',
      'semestre': 'III',
      'sigla': 'ECO-203',
      'preguntas': {
        'p1': {
          'pregunta': '¿Qué estudia la microeconomía?',
          'opciones': ['El comercio internacional', 'El crecimiento económico', 'El comportamiento de consumidores y empresas', 'La política fiscal'],
          'respuesta': 'El comportamiento de consumidores y empresas',
          'explicación': 'La microeconomía analiza decisiones individuales en mercados específicos.'
        },
        'p2': {
          'pregunta': '¿Qué es la ley de la demanda?',
          'opciones': [
            'A mayor precio, mayor demanda',
            'A menor precio, menor demanda',
            'A mayor precio, menor demanda',
            'La demanda no cambia con el precio'
          ],
          'respuesta': 'A mayor precio, menor demanda',
          'explicación': 'Existe una relación inversa entre el precio de un bien y la cantidad demandada.'
        },
        'p3': {
          'pregunta': '¿Qué es un bien sustituto?',
          'opciones': [
            'Un bien de lujo',
            'Un producto idéntico',
            'Un bien que puede reemplazar a otro',
            'Un bien importado'
          ],
          'respuesta': 'Un bien que puede reemplazar a otro',
          'explicación': 'Los bienes sustitutos satisfacen una necesidad similar.'
        },
        'p4': {
          'pregunta': '¿Qué mide la elasticidad precio de la demanda?',
          'opciones': [
            'El ingreso de los consumidores',
            'El impacto de los impuestos',
            'El cambio en la demanda ante variaciones de precio',
            'El costo de producción'
          ],
          'respuesta': 'El cambio en la demanda ante variaciones de precio',
          'explicación': 'Es un indicador de sensibilidad del consumidor al precio.'
        },
        'p5': {
          'pregunta': '¿Qué ocurre en un mercado en equilibrio?',
          'opciones': [
            'La oferta supera a la demanda',
            'La demanda supera a la oferta',
            'No hay compradores',
            'La cantidad ofrecida es igual a la demandada'
          ],
          'respuesta': 'La cantidad ofrecida es igual a la demandada',
          'explicación': 'En equilibrio, no hay presión para cambiar el precio.'
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

