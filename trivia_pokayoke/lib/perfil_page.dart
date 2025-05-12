import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart'; // Make sure this path matches your project structure

class PerfilPage extends StatefulWidget {
  const PerfilPage({Key? key}) : super(key: key);

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  String nombre = '';
  String correo = '';
  String carrera = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final data = doc.data();
    setState(() {
      nombre = data?['nombre'] ?? 'Usuario';
      correo = data?['email'] ?? user.email ?? '';
      carrera = data?['carrera'] ?? 'Sin carrera';
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mainBlue = const Color(0xFF1B2F5C);

    if (isLoading) {
      return Scaffold(
        backgroundColor: isDark ? mainBlue.withOpacity(0.95) : mainBlue.withOpacity(0.07),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? mainBlue.withOpacity(0.95) : mainBlue.withOpacity(0.07),
      appBar: AppBar(
        backgroundColor: isDark ? mainBlue.withOpacity(0.95) : mainBlue.withOpacity(0.85),
        title: const Text('Perfil', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              final mainBlue = const Color(0xFF1B2F5C);
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  backgroundColor: isDark ? mainBlue.withOpacity(0.98) : mainBlue.withOpacity(0.92),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "images/cerebro_sad.png",
                          height: 54,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 18),
                        Text(
                          '¿Deseas cerrar sesión?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.18),
                                blurRadius: 2,
                                offset: const Offset(1, 1),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancelar', style: TextStyle(fontSize: 16, color: Colors.white70)),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await FirebaseAuth.instance.signOut();
                                if (mounted) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (_) => const LoginPage()),
                                    (route) => false,
                                  );
                                }
                              },
                              child: const Text('Cerrar sesión', style: TextStyle(fontSize: 16)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [mainBlue.withOpacity(0.95), Colors.grey[900]!]
                : [mainBlue.withOpacity(0.12), Colors.grey[100]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.10),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: CircleAvatar(
                      radius: 54,
                      backgroundColor: Colors.amber,
                      child: Icon(Icons.person, size: 60, color: mainBlue),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    nombre,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : mainBlue,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    correo,
                    style: TextStyle(
                      fontSize: 15,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Chip(
                    label: Text(
                      carrera,
                      style: TextStyle(
                        color: isDark ? Colors.white : mainBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: isDark ? mainBlue.withOpacity(0.7) : Colors.white,
                    avatar: Icon(Icons.school, color: isDark ? Colors.white : mainBlue, size: 20),
                  ),
                  const SizedBox(height: 18),
                  const SizedBox(height: 32),
                  // Progreso dinámico
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseAuth.instance.currentUser == null
                        ? null
                        : FirebaseFirestore.instance
                            .collection('scores')
                            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                    builder: (context, snapshot) {
                      int totalTrivias = 0;
                      int totalScore = 0;
                      if (snapshot.hasData) {
                        totalTrivias = snapshot.data!.docs.length;
                        totalScore = snapshot.data!.docs.fold<int>(
                          0,
                          (sum, doc) => sum + (((doc.data() as Map<String, dynamic>)['score'] ?? 0) as int),
                        );
                      }
                      return Card(
                        color: isDark ? mainBlue.withOpacity(0.7) : Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Progreso",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: isDark ? Colors.white : mainBlue,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "$totalTrivias",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.orangeAccent),
                                      ),
                                      const SizedBox(height: 4),
                                      Text("Trivias", style: TextStyle(color: isDark ? Colors.white70 : mainBlue)),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "8", // Puedes reemplazar por logros reales si los tienes
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.orangeAccent),
                                      ),
                                      const SizedBox(height: 4),
                                      Text("Logros", style: TextStyle(color: isDark ? Colors.white70 : mainBlue)),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "$totalScore",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.orangeAccent),
                                      ),
                                      const SizedBox(height: 4),
                                      Text("Puntaje", style: TextStyle(color: isDark ? Colors.white70 : mainBlue)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
