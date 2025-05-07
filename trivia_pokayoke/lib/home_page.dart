import 'package:flutter/material.dart';
import 'login.dart';
import 'contabilidad_page.dart';
import 'economia_page.dart';
import 'marketing_page.dart'; // marketing
import 'perfil_page.dart';
import 'ajustes_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  // Página de contenido dinámico según BottomNavigationBar
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
    final subjects = [
      {
        'title': 'Economía',
        'duration': '2 h 45 min',
        'widget': const EconomiaPage(),
        'color': Colors.orangeAccent.shade100
      },
      {
        'title': 'Contabilidad',
        'duration': '3 h 30 min',
        'widget': const ContabilidadPage(),
        'color': Colors.greenAccent.shade100
      },
      {
        'title': 'Marketing',
        'duration': '2 h 10 min',
        'widget': const MarketingPage(),
        'color': Colors.lightBlueAccent.shade100
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Hola\nSergio Villegas',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.red),
                onPressed: _logout,
              )
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

          // Categorías
          const Text(
            'Categoría:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: const [
              Chip(label: Text('#CPA')),
              Chip(label: Text('#ADM')),
              Chip(label: Text('#MAT')),
              Chip(label: Text('#ECO')),
            ],
          ),
          const SizedBox(height: 16),

          // Lista
          Expanded(
            child: ListView.builder(
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final subject = subjects[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => subject['widget'] as Widget),
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
                            color: subject['color'] as Color,
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
                                subject['title'] as String,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                subject['duration'] as String,
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
            ),
          )
        ],
      ),
    );
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
