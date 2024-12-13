import 'package:cippher/route/app_router.dart';
import 'package:cippher/service/servicebackground.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Necesario para inicializar `SharedPreferences` antes de ejecutar la app
  String initialRoute = await _determineInitialRoute();
  runApp(
    ChangeNotifierProvider(
      create: (_) => BackgroundService(),
      child: MyApp(initialRoute: initialRoute),
    ),
  );
}

Future<String> _determineInitialRoute() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token =
      prefs.getString('token'); // Verifica si hay un token almacenado
  return token != null && token.isNotEmpty
      ? '/'
      : '/LOGIN'; // Decide la ruta inicial
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({required this.initialRoute, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SEGURIDAD PERSONAL',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: initialRoute,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
