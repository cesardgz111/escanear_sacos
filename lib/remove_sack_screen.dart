import 'package:flutter/material.dart';

class RemoveSackScreen extends StatelessWidget {
  const RemoveSackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Eliminar Costal')),
      body: Center(
        child: Text('Eliminar costales...', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
