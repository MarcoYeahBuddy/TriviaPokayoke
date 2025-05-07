import 'package:flutter/material.dart';
import 'login.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 50,
                child: Text("🧑", style: TextStyle(fontSize: 40)),
              ),
              const SizedBox(height: 16),
              const Text(
                'Sergio Villegas',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'sergio@universidad.edu',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),
              ListTile(
                leading: const Icon(Icons.school),
                title: const Text('Carrera'),
                subtitle: const Text('Ingeniería de Sistemas'),
              ),
              ListTile(
                leading: const Icon(Icons.bar_chart),
                title: const Text('Progreso'),
                subtitle: const Text('7 materias completadas'),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _logout(context),
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar sesión'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
