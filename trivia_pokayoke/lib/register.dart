import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passController.text.trim(),
        );

        final uid = userCredential.user?.uid;

        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'uid': uid,
          'nombre': _nombreController.text.trim(),
          'apellido': _apellidoController.text.trim(),
          'email': _emailController.text.trim(),
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              nombre: _nombreController.text.trim(), // Obtén el nombre del controlador
              apellido: _apellidoController.text.trim(), // Obtén el apellido del controlador
            ),
          ),
        );
      } on FirebaseAuthException catch (e) {
        String message = switch (e.code) {
          'email-already-in-use' => 'El correo ya está registrado.',
          'weak-password' => 'La contraseña es demasiado débil.',
          'invalid-email' => 'Correo electrónico inválido.',
          _ => 'Error: ${e.message}',
        };

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
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
                    'Registro de Usuario',
                    style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),

                  TextFormField(
                    controller: _nombreController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration('Nombre'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Ingrese su nombre' : null,
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _apellidoController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration('Apellido'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Ingrese su apellido' : null,
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _emailController,
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
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Registrarse', style: TextStyle(fontSize: 18, color: Colors.white)),
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
        borderSide: const BorderSide(color: Colors.greenAccent),
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: const Color(0xFF2E3A5F),
    );
  }
}
