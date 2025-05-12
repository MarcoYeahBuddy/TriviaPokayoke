import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'utils/math_exercises_uploader.dart';

class AjustesPage extends StatelessWidget {
  const AjustesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mainBlue = const Color(0xFF1B2F5C);

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: isDark ? mainBlue.withOpacity(0.95) : mainBlue.withOpacity(0.07),
          appBar: AppBar(
            backgroundColor: isDark ? mainBlue.withOpacity(0.95) : mainBlue.withOpacity(0.85),
            title: const Text('Ajustes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            centerTitle: true,
            elevation: 4,
            iconTheme: const IconThemeData(color: Colors.white),
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
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Card(
                  color: isDark ? mainBlue.withOpacity(0.7) : Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.color_lens, color: Colors.orangeAccent),
                            const SizedBox(width: 10),
                            const Text(
                              'Apariencia',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SwitchListTile(
                          title: const Text('Modo oscuro'),
                          subtitle: Text(themeProvider.isDarkMode ? 'Activado' : 'Desactivado'),
                          value: themeProvider.isDarkMode,
                          onChanged: (_) => themeProvider.toggleTheme(),
                          activeColor: Colors.orangeAccent,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  color: isDark ? mainBlue.withOpacity(0.7) : Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    title: const Text(
                      'Cerrar sesión',
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    leading: const Icon(Icons.logout, color: Colors.red),
                    onTap: () async {
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
                                        if (context.mounted) {
                                          Navigator.pushAndRemoveUntil(
                                            context,
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
                ),
                const SizedBox(height: 16),
                if (FirebaseAuth.instance.currentUser?.email == "admin@example.com")
                  Card(
                    color: isDark ? mainBlue.withOpacity(0.7) : Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: ListTile(
                      title: const Text('Cargar Ejercicios de Cálculo'),
                      leading: const Icon(Icons.upload),
                      onTap: () async {
                        try {
                          await uploadCalculusExercises();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Ejercicios cargados con éxito')),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        }
                      },
                    ),
                  ),
                const SizedBox(height: 24),
                Card(
                  color: isDark ? mainBlue.withOpacity(0.7) : Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.blueAccent),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Versión 1.0.0\nDesarrollado por el equipo Trivia Pokayoke',
                            style: TextStyle(
                              color: isDark ? Colors.white70 : mainBlue,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
