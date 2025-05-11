import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ScoresPage extends StatefulWidget {
  const ScoresPage({super.key});

  @override
  State<ScoresPage> createState() => _ScoresPageState();
}

class _ScoresPageState extends State<ScoresPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  String formatTimestamp(String timestamp) {
    try {
      final DateTime date = DateTime.parse(timestamp);
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    } catch (e) {
      return 'Fecha no disponible';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Tabla de Puntuaciones'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Global'),
            Tab(text: 'Mis Puntajes'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildScoreList(false),
          _buildScoreList(true),
        ],
      ),
    );
  }

  Widget _buildScoreList(bool onlyUser) {
    if (onlyUser && userId == null) {
      return const Center(child: Text('Necesitas iniciar sesión para ver tus puntajes'));
    }

    Query query = FirebaseFirestore.instance.collection('scores');
    
    if (onlyUser) {
      // Solo filtrar por userId sin ordenar
      query = query.where('userId', isEqualTo: userId);
    } else {
      // Solo ordenar por puntaje para la vista global
      query = query.orderBy('score', descending: true).limit(100); // Limitamos a 100 resultados
    }

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          debugPrint('Error en Firestore: ${snapshot.error}');
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final scores = snapshot.data!.docs;

        if (scores.isEmpty) {
          return const Center(
            child: Text('No hay puntajes registrados'),
          );
        }

        return ListView.builder(
          itemCount: scores.length,
          itemBuilder: (context, index) {
            final data = scores[index].data() as Map<String, dynamic>;
            final isCurrentUser = data['userId'] == userId;

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: isCurrentUser ? Colors.blue.withOpacity(0.1) : null,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.amber,
                  child: Text('${index + 1}'),
                ),
                title: Text(
                  data['userName'] ?? 'Usuario',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data['triviaName'] ?? 'Trivia'),
                    Text(
                      formatTimestamp(data['timestamp'] ?? ''),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${data['score']}pts',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
