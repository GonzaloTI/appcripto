import 'package:cippher/screen/registro.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/User.dart';
import '../model/api_response.dart';
import '../service/user_service.dart';
import 'home_screen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool loading = false;

  Future<void> _loginUser() async {
    ApiResponse response = await login(txtEmail.text, txtPassword.text, "100");

    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.error}')),
      );
    }
  }

  void _saveAndRedirectToHome(User user) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('token', user.token ?? '');
      await pref.setString('userId', user.id ?? '');
      await pref.setString('nombre', user.nombre ?? '');
      await pref.setString('apellido', user.apellido ?? '');
      await pref.setString('email', user.email ?? '');
      await pref.setString('telefono', user.telefono ?? '');
      await pref.setString('roomId', user.id ?? '');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      print("Error al guardar datos o redirigir: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ocurrió un error. Inténtalo de nuevo.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/fondo.jpg"), // Ruta de la imagen
                fit: BoxFit.cover, // Ajusta la imagen al tamaño de la pantalla
              ),
            ),
          ),
          // Contenido principal
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Form(
                key: formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.asset(
                            'images/user.png', // Ruta de la imagen en tus assets
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'YotePiyo',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 248, 252,
                                253), // Cambiar color para visibilidad
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: txtEmail,
                      validator: (val) =>
                          val!.isEmpty ? 'Dirección de correo inválida' : null,
                      decoration: InputDecoration(
                        labelText: 'Correo Electrónico',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor:
                            Colors.white.withOpacity(0.8), // Transparencia
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: txtPassword,
                      obscureText: true,
                      validator: (val) => val!.length < 6
                          ? 'Debe tener al menos 6 caracteres'
                          : null,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 30),
                    loading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                _loginUser();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Iniciar Sesión',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()),
                        );
                      },
                      child: const Text(
                        '¿No tienes una cuenta? Regístrate',
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
