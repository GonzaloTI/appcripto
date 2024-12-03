import 'package:flutter/material.dart';

class EmergenciaScreen extends StatelessWidget {
  const EmergenciaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergencia'),
      ),
      body: const Center(
        child: Text('Pantalla de Emergencia'),
      ),
    );
  }
}
