import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'home_page.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int _intentosRestantes = 3;
  bool _showPassword = false;
  bool _isLoading = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final email = _userController.text.trim();
      final password = _passController.text;

      setState(() {
        _isLoading = true;
      });

      try {
        final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        final uid = userCredential.user!.uid;
        final docSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();

        final data = docSnapshot.data();
        if (data == null || !data.containsKey('nombre') || !data.containsKey('apellido')) {
          throw FirebaseAuthException(code: 'invalid-profile', message: 'Faltan datos del perfil.');
        }

        final String nombre = data['nombre'];
        final String apellido = data['apellido'];

        setState(() {
          _isLoading = false;
        });

        if (mounted) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final mainBlue = const Color(0xFF1B2F5C);

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => _LoginSuccessDialog(
              isDark: isDark,
              mainBlue: mainBlue,
              onContinue: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(nombre: nombre, apellido: apellido),
                  ),
                );
              },
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          _isLoading = false;
        });
        String errorMessage;
        if (e.code == 'wrong-password') {
          _intentosRestantes--;
          if (_intentosRestantes > 0) {
            errorMessage = 'Contraseña incorrecta. Intentos restantes: $_intentosRestantes';
          } else {
            errorMessage = 'Demasiados intentos fallidos. Intenta más tarde.';
          }
        } else if (e.code == 'user-not-found') {
          errorMessage = 'No se encontró un usuario con ese correo.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'Correo electrónico inválido.';
        } else {
          errorMessage = 'Error: ${e.message}';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF1B2F5C),
      body: SafeArea(
        child: Column(
          children: [
            // Logo o decorativo con figura, sombra y fondo translúcido
            SizedBox(
              height: screenHeight * 0.22,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.75),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(18),
                  child: Image.asset(
                    'images/trivia_ucb_logo.png',
                    fit: BoxFit.contain,
                    height: screenHeight * 0.13,
                  ),
                ),
              ),
            ),
            // Scroll principal con formulario envuelto en un rectángulo escalable y translúcido
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 400,
                      minWidth: 0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.10),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
                          width: 1.5,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const Text(
                              'Iniciar Sesión',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 30),
                            TextFormField(
                              controller: _userController,
                              style: const TextStyle(color: Colors.white),
                              decoration: _inputDecoration('Correo electrónico'),
                              validator: (value) =>
                                  value == null || value.isEmpty ? 'Ingrese su correo' : null,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _passController,
                              obscureText: !_showPassword,
                              style: const TextStyle(color: Colors.white),
                              decoration: _inputDecoration('Contraseña').copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _showPassword ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.white70,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _showPassword = !_showPassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty ? 'Ingrese su contraseña' : null,
                            ),
                            const SizedBox(height: 30),
                            if (_isLoading)
                              const CircularProgressIndicator(color: Colors.orangeAccent)
                            else
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _intentosRestantes > 0 ? _login : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orangeAccent,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: const Text(
                                    'Entrar',
                                    style: TextStyle(fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ),
                            const SizedBox(height: 20),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RegisterPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                '¿No tienes cuenta? Regístrate',
                                style: TextStyle(color: Colors.white70, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Footer institucional con barra y logos más grandes, mejor contraste y fondo translúcido
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    height: 2,
                    width: double.infinity,
                    color: Colors.white24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.75),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.10),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(
                          'images/trivia_ucb_logo.png',
                          height: 48,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 28),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.75),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.10),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(
                          'images/logo_ucb.png',
                          height: 48,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '© 2025 Universidad Católica Boliviana - Todos los derechos reservados',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white38),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.orangeAccent),
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: const Color(0xFF2E3A5F),
    );
  }
}

class _LoginSuccessDialog extends StatefulWidget {
  final bool isDark;
  final Color mainBlue;
  final VoidCallback onContinue;

  const _LoginSuccessDialog({
    required this.isDark,
    required this.mainBlue,
    required this.onContinue,
  });

  @override
  State<_LoginSuccessDialog> createState() => _LoginSuccessDialogState();
}

class _LoginSuccessDialogState extends State<_LoginSuccessDialog> {
  int seconds = 2;
  late Timer _timer;
  bool canContinue = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        if (seconds > 1) {
          seconds--;
        } else {
          canContinue = true;
          _timer.cancel();
          // Ingresar automáticamente al terminar el timer
          Future.microtask(() {
            if (mounted) widget.onContinue();
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: widget.isDark ? widget.mainBlue.withOpacity(0.98) : widget.mainBlue.withOpacity(0.92),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "images/cerebro_bien.png",
              height: 54,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 18),
            const Text(
              '¡Inicio de sesión exitoso!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    blurRadius: 2,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            canContinue
                ? const SizedBox.shrink()
                : Column(
                    children: [
                      const CircularProgressIndicator(color: Colors.orangeAccent),
                      const SizedBox(height: 12),
                      Text(
                        'Entrando en $seconds...',
                        style: const TextStyle(color: Colors.white70, fontSize: 15),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
