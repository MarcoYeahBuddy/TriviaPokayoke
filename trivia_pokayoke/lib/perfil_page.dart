import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;
  int completedTrivias = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadCompletedTrivias();
  }

  Future<void> _loadUserData() async {
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      
      if (doc.exists) {
        setState(() {
          userData = doc.data();
        });
      }
    }
  }

  Future<void> _loadCompletedTrivias() async {
    if (user != null) {
      final scores = await FirebaseFirestore.instance
          .collection('scores')
          .where('userId', isEqualTo: user!.uid)
          .get();

      setState(() {
        completedTrivias = scores.docs.length;
      });
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (userData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: isDark ? Colors.deepPurple[700] : Colors.deepPurple[100],
                child: Text(
                  (userData?['nombre']?[0] ?? '?').toUpperCase(),
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.deepPurple,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${userData?['nombre'] ?? ''} ${userData?['apellido'] ?? ''}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                userData?['email'] ?? '',
                style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
              ),
              const SizedBox(height: 32),
              Card(
                color: isDark ? Colors.grey[850] : Colors.white,
                child: ListTile(
                  leading: Icon(Icons.emoji_events,
                      color: isDark ? Colors.amber[400] : Colors.amber),
                  title: Text(
                    'Trivias Completadas',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    '$completedTrivias trivias',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _logout,
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
