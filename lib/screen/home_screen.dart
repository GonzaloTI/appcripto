import 'package:flutter/material.dart';

import '../widget/my_drawer.dart';
import 'CodeScreen.dart';
import 'auxilio_screen.dart';
import 'emergencia_screen.dart';
import 'mapa_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content: const Text('¿Estás seguro de proceder?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AuxilioScreen()),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showEmergencyMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading:
                  const Icon(Icons.local_fire_department, color: Colors.red),
              title: const Text('Bomberos'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EmergenciaScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_hospital, color: Colors.green),
              title: const Text('Ambulancia'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EmergenciaScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_police, color: Colors.blue),
              title: const Text('Policía'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EmergenciaScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: const MyDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _showConfirmationDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDB2843),
                minimumSize: const Size(300, 80),
              ),
              child: const Text(
                'AUXILIO',
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showEmergencyMenu(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFBC26),
                minimumSize: const Size(300, 80),
              ),
              child: const Text(
                'EMERGENCIA',
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MapaScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0085FC),
                minimumSize: const Size(300, 80),
              ),
              child: const Text(
                'VER MAPA',
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
            ElevatedButton(
              onPressed: () => _showCodeInputModal(context),
              child: const Text('Seguir'),
            ),
          ],
        ),
      ),
    );
  }
}

void _showCodeInputModal(BuildContext context) {
  final TextEditingController codeController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Ajustar el tamaño del bottom sheet
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize
              .min, // Para evitar que se expanda más de lo necesario
          children: [
            TextField(
              controller: codeController,
              decoration: const InputDecoration(
                hintText: 'Código',
              ),
            ),
            const SizedBox(height: 20), // Separación entre el input y la lista
            // Lista de personas
            Container(
              height: 150, // Ajusta la altura si es necesario
              child: ListView.builder(
                itemCount: 4, // Número de elementos en la lista
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Persona ${index + 1}'), // Texto 1, 2, 3, 4
                    onTap: () {
                      // Acción cuando se selecciona un ítem
                      print('Seleccionado: Persona ${index + 1}');
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Obtén el código ingresado
                String code = codeController.text;
                // Aquí rediriges a la pantalla que desees con el código
                Navigator.of(context).pop(); // Cerrar el modal
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CodeScreen(code: code),
                  ),
                );
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    },
  );
}
