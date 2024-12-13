import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'drawer_item.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String userName = "User";
  String userEmail = "user@gmail.com";
  String userPhone = "No disponible";
  String userRoomId = "No disponible";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userName =
          "${pref.getString('nombre') ?? 'User'} ${pref.getString('apellido') ?? ''}"
              .trim();
      userEmail = pref.getString('email') ?? 'user@gmail.com';
      userPhone = pref.getString('telefono') ?? 'No disponible';
      userRoomId = pref.getString('roomId') ?? 'No disponible';
    });
  }

  void _showRoomIdModal(BuildContext context, String roomId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Room ID"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                roomId,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: roomId));
                  Navigator.pop(context); // Cierra el modal después de copiar
                  showDialog(
                    context: context,
                    builder: (context) => const AlertDialog(
                      title: Text("Éxito"),
                      content: Text("¡Código copiado al portapapeles!"),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: const Text(
                  "Copiar",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage("images/user.png"),
                ),
                const SizedBox(height: 10),
                Flexible(
                  child: Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Flexible(
                  child: Text(
                    "Email: $userEmail",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Flexible(
                  child: Text(
                    "Teléfono: $userPhone",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      _showRoomIdModal(context, userRoomId);
                    },
                    child: Text(
                      "Room ID: $userRoomId",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...drawerItems.map((item) {
            return ListTile(
              leading: Icon(item['icon']),
              title: Text(item['title']),
              onTap: () {
                Navigator.pushReplacementNamed(context, item['route']);
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}
