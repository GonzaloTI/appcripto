import 'package:cippher/screen/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screen/home_screen.dart';
import '../screen/usuario-confianza.dart';

class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/inicio':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/LOGIN':
        return MaterialPageRoute(builder: (_) => const Login());
      case '/usuario-confianza':
        return MaterialPageRoute(
            builder: (_) => const UsuariosConfianzaScreen());
      case '/logout':
        return MaterialPageRoute(builder: (_) => LogoutHandler());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Ruta desconocida: ${settings.name}'),
            ),
          ),
        );
    }
  }
}

// Componente para manejar el logout
class LogoutHandler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Borra las preferencias compartidas y redirige
    _performLogout(context);
    return const SizedBox.shrink(); // Retorna una vista vacía
  }

  Future<void> _performLogout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Borra todos los datos de SharedPreferences
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/LOGIN',
      (route) => false, // Elimina todas las rutas anteriores
    );
  }
}
