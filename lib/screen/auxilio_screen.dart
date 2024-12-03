import 'package:flutter/material.dart';

class AuxilioScreen extends StatelessWidget {
  const AuxilioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auxilio'),
      ),
      body: const Center(
        child: Text('Pantalla de Auxilio'),
      ),
    );
  }
}
