import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'perfil_page.dart';
import 'ajustes_page.dart';
import 'trivia_page.dart';
import 'subirTriviademo.dart';

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
      return const PerfilPage();
    } else {
      return const AjustesPage();
    }
  }

  Widget _buildPruebasContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado dinámico
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hola\n${widget.nombre} ${widget.apellido}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.red),
                onPressed: _logout,
              ),
              /*ElevatedButton(
                onPressed: subirTriviaDemo,
                child: const Text('Subir Economía'),
              ),
              ElevatedButton(
                onPressed: subirTriviaMarketing,
                child: const Text('Subir Marketing'),
              ),
              ElevatedButton(
                onPressed: subirTriviaContabilidad,
                child: const Text('Subir Contabilidad'),
              ),*/
            ],
          ),
          const SizedBox(height: 16),

          // Buscar
          TextField(
            decoration: InputDecoration(
              hintText: 'Buscar cursos',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          const Text('Categoría:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _categorias.map((categoria) {
              final isSelected = _selectedCategoria == categoria['nombre'];
              return ChoiceChip(
                label: Text(categoria['sigla']!),
                selected: isSelected,
                onSelected: (_) {
                  setState(() {
                    _selectedCategoria = categoria['nombre']!;
                  });
                },
              );
            }).toList(),
          ),


          const SizedBox(height: 16),

          // Cargar cursos desde Firestore
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
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

                return ListView.builder(
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
                    final color = _colorForMateria(carrera); // función opcional para color

                    return GestureDetector(
                      onTap: () {
                        debugPrint('Selected trivia ID: $docId'); // Debug log
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
                                  Navigator.pop(context); // Cierra el diálogo
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => TriviaScreen(triviaId: docId), // Pass correct ID
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
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 150,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                              ),
                              child: const Center(child: Icon(Icons.school, size: 50)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    materia,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    duracion,
                                    style: const TextStyle(color: Colors.grey),
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
            ),
          ),
        ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(child: _getBody()),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (value) => setState(() => _selectedIndex = value),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Pruebas'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ajustes'),
        ],
      ),
    );
  }
}
