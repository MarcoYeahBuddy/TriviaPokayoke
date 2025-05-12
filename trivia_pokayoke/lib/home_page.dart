import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trivia_pokayoke/scores_page.dart';
import 'login.dart';
import 'perfil_page.dart';
import 'ajustes_page.dart';
import 'trivia_page.dart';
/*import 'subirTriviademo.dart';*/

class HomePage extends StatefulWidget {
  final String nombre;
  final String apellido;

  const HomePage({super.key, required this.nombre, required this.apellido});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _selectedCategoria = 'Todas las carreras';
  final List<Map<String, String>> _categorias = [
    {'sigla': 'TODOS', 'nombre': 'Todas las carreras'},
    {'sigla': 'ECO', 'nombre': 'Economía'},
    {'sigla': 'CON', 'nombre': 'Contabilidad'},
    {'sigla': 'MKT', 'nombre': 'Marketing'},
    {'sigla': 'SIS', 'nombre': 'Ingeniería de Sistemas'},
    {'sigla': 'MED', 'nombre': 'Medicina'},
    {'sigla': 'DER', 'nombre': 'Derecho'},
  ];

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  Widget _getBody() {
    if (_selectedIndex == 0) {
      return _buildPruebasContent();
    } else if (_selectedIndex == 1) {
      return const ScoresPage();
    } else if (_selectedIndex == 2) {
      return const PerfilPage();
    } else {
      return const AjustesPage();
    }
  }

  Widget _buildPruebasContent() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mainBlue = const Color(0xFF1B2F5C);
    final lightBlue = const Color(0xFF3A4D7A);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [mainBlue.withOpacity(0.95), Colors.grey[900]!]
              : [mainBlue.withOpacity(0.12), Colors.grey[100]!],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? mainBlue.withOpacity(0.85) : mainBlue.withOpacity(0.85),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withOpacity(0.18)
                        : mainBlue.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hola\n${widget.nombre} ${widget.apellido}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.red),
                    onPressed: _logout,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Buscar cursos',
                hintStyle: TextStyle(
                  color: isDark ? Colors.grey[300] : mainBlue.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
                prefixIcon: Icon(Icons.search, color: isDark ? Colors.grey[300] : mainBlue.withOpacity(0.7)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: isDark ? Colors.grey[700]! : mainBlue.withOpacity(0.2)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: isDark ? Colors.grey[700]! : mainBlue.withOpacity(0.2)),
                ),
                filled: true,
                fillColor: isDark ? mainBlue.withOpacity(0.3) : Colors.white,
              ),
              style: TextStyle(
                color: isDark ? Colors.white : mainBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Categoría:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : mainBlue,
                  fontSize: 16,
                ),
              ),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 0, // <-- Mantén esto para evitar espacio vertical extra
              children: _categorias.map((categoria) {
                final isSelected = _selectedCategoria == categoria['nombre'];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0), // <-- Elimina padding vertical
                  child: ChoiceChip(
                    label: Text(
                      categoria['sigla']!,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : (isDark ? Colors.white70 : mainBlue),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: mainBlue,
                    backgroundColor: isDark ? mainBlue.withOpacity(0.25) : lightBlue.withOpacity(0.10),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: const VisualDensity(horizontal: -2, vertical: -4), // <-- Más compacto aún
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0), // <-- Sin padding vertical
                    onSelected: (_) {
                      setState(() => _selectedCategoria = categoria['nombre']!);
                    },
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 700
                      ? 3
                      : constraints.maxWidth > 500
                          ? 2
                          : 1;
                  return StreamBuilder<QuerySnapshot>(
                    stream: _selectedCategoria == 'Todas las carreras'
                        ? FirebaseFirestore.instance.collection('trivias').snapshots()
                        : FirebaseFirestore.instance
                            .collection('trivias')
                            .where('carrera', isEqualTo: _selectedCategoria)
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(child: Text('Error al cargar cursos'));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final docs = snapshot.data!.docs;
                      if (docs.isEmpty) {
                        return const Center(child: Text('No hay cursos disponibles aún.'));
                      }
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 18,
                          mainAxisSpacing: 18,
                          childAspectRatio: 1.15, // <-- Aumenta el aspect ratio para reducir la altura
                        ),
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final doc = docs[index];
                          final data = doc.data() as Map<String, dynamic>;
                          final docId = doc.id;
                          final materia = data['materia'] ?? 'Materia';
                          final carrera = data['carrera'] ?? 'Carrera';
                          final duracion = '${data['duracion_aprox'] ?? 0} min';
                          final docente = data['docente'] ?? 'Sin docente';
                          final sigla = data['sigla'] ?? '';
                          final color = isDark
                              ? _colorForMateriaDark(carrera)
                              : _colorForMateria(carrera);

                          return GestureDetector(
                            onTap: () {
                              debugPrint('Selected trivia ID: $docId');
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text(materia),
                                  content: Text('Docente: $docente\nSigla: $sigla\nDuración: $duracion\n\n¿Listo para comenzar la trivia?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancelar'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => TriviaScreen(triviaId: docId),
                                          ),
                                        );
                                      },
                                      child: const Text('¡Empezar!'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Card(
                              margin: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              color: isDark
                                  ? mainBlue.withOpacity(0.7)
                                  : Colors.white,
                              elevation: 4,
                              child: Column(
                                children: [
                                  Container(
                                    height: 80, // <-- Reduce la altura del header de la card
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.school, size: 40, color: Colors.white70), // Icono más pequeño
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12), // Menos padding
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          materia,
                                          style: TextStyle(
                                            fontSize: 16, // Más pequeño
                                            fontWeight: FontWeight.bold,
                                            color: isDark ? Colors.white : mainBlue,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Docente: $docente',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: isDark ? Colors.white70 : Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              duracion,
                                              style: TextStyle(
                                                color: isDark ? Colors.grey[400] : mainBlue.withOpacity(0.7),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                              ),
                                            ),
                                            Text(
                                              sigla,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: isDark ? Colors.white54 : mainBlue,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _colorForMateria(String carrera) {
    switch (carrera.toLowerCase()) {
      case 'economía':
        return Colors.orangeAccent.shade100;
      case 'contabilidad':
        return Colors.greenAccent.shade100;
      case 'marketing':
        return Colors.lightBlueAccent.shade100;
      case 'ingeniería de sistemas':
        return Colors.blueGrey.shade100;
      case 'medicina':
        return Colors.redAccent.shade100;
      case 'derecho':
        return Colors.purpleAccent.shade100;
      default:
        return Colors.grey.shade300;
    }
  }

  Color _colorForMateriaDark(String carrera) {
    switch (carrera.toLowerCase()) {
      case 'economía':
        return Colors.orange[900]!;
      case 'contabilidad':
        return Colors.green[900]!;
      case 'marketing':
        return Colors.blue[900]!;
      case 'ingeniería de sistemas':
        return Colors.blueGrey[900]!;
      case 'medicina':
        return Colors.red[900]!;
      case 'derecho':
        return Colors.purple[900]!;
      default:
        return Colors.grey[800]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mainBlue = const Color(0xFF1B2F5C);
    final lightBlue = const Color(0xFF3A4D7A);

    return Scaffold(
      backgroundColor: isDark ? mainBlue.withOpacity(0.95) : mainBlue.withOpacity(0.07),
      body: SafeArea(child: _getBody()),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: mainBlue, // TabBar siempre azul marino
          primaryColor: Colors.white,
          textTheme: Theme.of(context).textTheme.copyWith(
                bodySmall: const TextStyle(
                  color: Colors.white,
                ),
              ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (value) => setState(() => _selectedIndex = value),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.quiz, color: Colors.white),
              label: 'Pruebas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard, color: Colors.white),
              label: 'Puntajes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Colors.white),
              label: 'Perfil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings, color: Colors.white),
              label: 'Ajustes',
            ),
          ],
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.orangeAccent,
          unselectedItemColor: Colors.white,
          backgroundColor: mainBlue,
          elevation: 8,
          selectedLabelStyle: const TextStyle(
            color: Colors.orangeAccent,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
