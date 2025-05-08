import 'package:flutter/material.dart';

class AddSackScreen extends StatelessWidget {
  const AddSackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Añadir Costal')),
      body: Center(
        child: Text('Añadiendo costales...', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
