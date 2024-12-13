import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/User.dart';
import '../model/api_response.dart';
import '../service/user_service.dart';
import 'home_screen.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos del formulario
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Variables para los campos personalizados
  String? _selectedSexo; // Para el DropdownButton de sexo
  DateTime? _selectedFechaN; // Para el DatePicker de fecha de nacimiento

  // Función vacía para registrar al usuario
  Future<void> _registerUser() async {
    print("Registro iniciado...");
    try {
      ApiResponse response = await register(
        nombre: _nombreController.text,
        apellido: _apellidoController.text,
        sexo: _selectedSexo ?? "",
        fechaNacimiento: _selectedFechaN ?? DateTime(2000, 1, 1),
        telefono: _telefonoController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (response.data != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registro exitoso. Bienvenido, !")),
        );
        _saveAndRedirectToHome(response.data as User);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error del servidor: $e")),
      );
    }
    // Aquí implementarás la lógica de registro
    print("Registro iniciado...");
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

      // Usar Navigator.pushReplacement para evitar volver a la pantalla actual
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      // Manejar errores (opcional)
      print("Error al guardar datos o redirigir: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ocurrió un error. Inténtalo de nuevo.")),
      );
    }
  }

  // Función para abrir el selector de fecha
  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != _selectedFechaN) {
      setState(() {
        _selectedFechaN = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registro"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: "Nombre"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor ingrese su nombre.";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _apellidoController,
                decoration: InputDecoration(labelText: "Apellido"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor ingrese su apellido.";
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Sexo"),
                value: _selectedSexo,
                items: ["M", "F"].map((sexo) {
                  return DropdownMenuItem<String>(
                    value: sexo,
                    child: Text(sexo == "M" ? "Masculino" : "Femenino"),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedSexo = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor seleccione su sexo.";
                  }
                  return null;
                },
              ),
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Fecha de Nacimiento",
                    ),
                    controller: TextEditingController(
                      text: _selectedFechaN != null
                          ? "${_selectedFechaN!.day}-${_selectedFechaN!.month}-${_selectedFechaN!.year}"
                          : "",
                    ),
                    validator: (value) {
                      if (_selectedFechaN == null) {
                        return "Por favor seleccione su fecha de nacimiento.";
                      }
                      return null;
                    },
                  ),
                ),
              ),
              TextFormField(
                controller: _telefonoController,
                decoration: InputDecoration(labelText: "Teléfono"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor ingrese su teléfono.";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains("@")) {
                    return "Por favor ingrese un email válido.";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: "Contraseña"),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 6) {
                    return "La contraseña debe tener al menos 6 caracteres.";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _registerUser();
                  }
                },
                child: Text("Registrar"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
