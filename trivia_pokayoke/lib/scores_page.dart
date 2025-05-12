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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mainBlue = const Color(0xFF1B2F5C);
    final lightBlue = const Color(0xFF3A4D7A);

    return Scaffold(
      backgroundColor: isDark ? mainBlue.withOpacity(0.95) : mainBlue.withOpacity(0.07),
      appBar: AppBar(
        backgroundColor: isDark ? mainBlue.withOpacity(0.95) : mainBlue.withOpacity(0.85),
        elevation: 4,
        title: const Text(
          'Tabla de Puntuaciones',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.orangeAccent,
          indicatorWeight: 3,
          labelColor: Colors.orangeAccent,
          unselectedLabelColor: Colors.white,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
          tabs: const [
            Tab(text: 'Global'),
            Tab(text: 'Mis Puntajes'),
          ],
        ),
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
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildScoreList(false, isDark, mainBlue, lightBlue),
            _buildScoreList(true, isDark, mainBlue, lightBlue),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreList(bool onlyUser, bool isDark, Color mainBlue, Color lightBlue) {
    if (onlyUser && userId == null) {
      return const Center(child: Text('Necesitas iniciar sesión para ver tus puntajes'));
    }

    Query query = FirebaseFirestore.instance.collection('scores');
    if (onlyUser) {
      query = query.where('userId', isEqualTo: userId);
    } else {
      query = query.orderBy('score', descending: true).limit(100);
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
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          itemCount: scores.length,
          itemBuilder: (context, index) {
            final data = scores[index].data() as Map<String, dynamic>;
            final isCurrentUser = data['userId'] == userId;

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              color: isCurrentUser
                  ? Colors.orangeAccent.withOpacity(isDark ? 0.18 : 0.12)
                  : (isDark
                      ? mainBlue.withOpacity(0.7)
                      : Colors.white),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isCurrentUser
                      ? Colors.orangeAccent
                      : (isDark ? mainBlue.withOpacity(0.5) : mainBlue.withOpacity(0.12)),
                  width: isCurrentUser ? 2 : 1,
                ),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: isCurrentUser ? Colors.orangeAccent : Colors.amber,
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: isCurrentUser ? Colors.white : mainBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  data['userName'] ?? 'Usuario',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : mainBlue,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['triviaName'] ?? 'Trivia',
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      formatTimestamp(data['timestamp'] ?? ''),
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.grey[300] : mainBlue.withOpacity(0.7),
                      ),
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
                    '${data['score']} pts',
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
