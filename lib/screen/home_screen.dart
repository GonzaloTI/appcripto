import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/api_response.dart';
import '../service/constant.dart';
import '../service/user_service.dart';
import '../widget/my_drawer.dart';
import 'CodeScreen.dart';
import 'auxilio_screen.dart';
import 'emergencia_screen.dart';
import 'mapa_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _userList = [];
  bool _loading = false;

  Future<void> retrieveUsers() async {
    setState(() {
      _loading = true;
    });

    SharedPreferences pref = await SharedPreferences.getInstance();
    String userId = pref.getString('userId') ?? '';

    ApiResponse response = await getprotegidos(userId);
    if (response.error == null) {
      setState(() {
        _userList = response.data as List<dynamic>;
        _loading = false;
      });
    } else if (response.error == unauthorized) {
      if (context.mounted) {
        Navigator.of(context).pushNamed('/login');
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}'),
        ));
      }
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    retrieveUsers();
  }

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
              const SizedBox(
                  height: 20), // Separación entre el input y la lista
              // Lista de personas
              _loading
                  ? const CircularProgressIndicator()
                  : Container(
                      height: 150, // Ajusta la altura si es necesario
                      child: ListView.builder(
                        itemCount: _userList.length,
                        itemBuilder: (context, index) {
                          final user = _userList[index];
                          return ListTile(
                            title: Text('${user.nombre} ${user.apellido}'),
                            subtitle: Text('Teléfono: ${user.telefono}'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CodeScreen(
                                      code: user.id, nombre: user.nombre),
                                ),
                              );
                              print('Seleccionado: ${user.id}');
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
                      builder: (context) =>
                          CodeScreen(code: code, nombre: "por codigo"),
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
