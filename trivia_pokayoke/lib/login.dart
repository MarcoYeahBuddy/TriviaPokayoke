import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final email = _userController.text.trim();
      final password = _passController.text;

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

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(nombre: nombre, apellido: apellido),
          ),
        );
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'No se encontró un usuario con ese correo.';
            break;
          case 'wrong-password':
            errorMessage = 'Contraseña incorrecta.';
            break;
          case 'invalid-email':
            errorMessage = 'Correo electrónico inválido.';
            break;
          default:
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
    return Scaffold(
      backgroundColor: const Color(0xFF1B2F5C),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
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
                  const SizedBox(height: 40),

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
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration('Contraseña'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Ingrese su contraseña' : null,
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login,
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
