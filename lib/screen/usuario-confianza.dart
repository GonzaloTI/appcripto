import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/api_response.dart';
import '../service/user_service.dart';
import '../widget/my_drawer.dart';

class UsuariosConfianzaScreen extends StatefulWidget {
  const UsuariosConfianzaScreen({super.key});

  @override
  _UsuariosConfianzaScreenState createState() =>
      _UsuariosConfianzaScreenState();
}

class _UsuariosConfianzaScreenState extends State<UsuariosConfianzaScreen> {
  final TextEditingController codigoUsuarioController = TextEditingController();
  bool isLoading = false; // Indicador de carga

  @override
  void dispose() {
    // Limpia el controlador cuando se destruye el widget
    codigoUsuarioController.dispose();
    super.dispose();
  }

  Future<void> _registrar() async {
    setState(() {
      isLoading = true; // Activa el indicador de carga
    });

    try {
      // Simulación de un registro asíncrono
      String codigo = codigoUsuarioController.text;
      SharedPreferences pref = await SharedPreferences.getInstance();
      String codigoApoderado = pref.getString('roomId') ?? '';

      ApiResponse response = await registrarApoderado(codigo, codigoApoderado);

      print("Código registrado: $codigo");

      codigoUsuarioController.text = "";
// Asegúrate de convertir response.body a String
      final mensaje = response.data.toString();

// Muestra un mensaje basado en la respuesta del servidor
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Éxito"),
          content: Text(mensaje),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      print("Error durante el registro: $e");
    } finally {
      setState(() {
        isLoading = false; // Desactiva el indicador de carga
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios de Confianza'),
      ),
      drawer: const MyDrawer(), // Incluimos el Drawer
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Código de Usuario",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blueAccent, width: 1),
              ),
              child: TextField(
                controller: codigoUsuarioController,
                decoration: const InputDecoration(
                  hintText: "Ingrese el código de usuario",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12), // Espaciado interno
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: isLoading
                    ? null // Desactiva el botón si está cargando
                    : _registrar, // Llama a la función asíncrona
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 14), // Estilo del botón
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text(
                        "Registrar",
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Instrucciones",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blueGrey, width: 1),
                ),
                child: const SingleChildScrollView(
                  child: Text(
                    " INGRESE EL CODIGO DEL USUARIO AL QUE QUIERA DESIGNAR COMO SU FAMILIAR , EL CODIGO SE OBTIENE AL HACER TOCAR EL ROOMID QUE ESTA EN SU PERFIL DEL MENU IZQUIERDO ",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
