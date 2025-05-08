// lib/manual_entry_screen.dart

import 'package:flutter/material.dart';

class ManualEntryScreen extends StatefulWidget {
  const ManualEntryScreen({Key? key}) : super(key: key);

  @override
  State<ManualEntryScreen> createState() => _ManualEntryScreenState();
}

class _ManualEntryScreenState extends State<ManualEntryScreen> {
  final List<String> _sizes = ['Chico', 'Mediano', 'Grande'];
  final List<String> _cornTypes = ['Komanche', 'Supremo', 'Normal'];

  String? _selectedSize;
  String? _selectedCorn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar Manualmente')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Seleccione tamaño:', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedSize,
              items: _sizes
                  .map((size) =>
                      DropdownMenuItem(value: size, child: Text(size)))
                  .toList(),
              onChanged: (value) => setState(() => _selectedSize = value),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              ),
              hint: Text('Elige un tamaño'),
            ),
            SizedBox(height: 24),
            Text('Seleccione tipo de maíz:', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedCorn,
              items: _cornTypes
                  .map((type) =>
                      DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (value) => setState(() => _selectedCorn = value),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              ),
              hint: Text('Elige tipo de maíz'),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_selectedSize != null && _selectedCorn != null)
                    ? () {
                        // Devuelve al HomeScreen el tamaño y tipo seleccionados
                        Navigator.pop(context,
                            {'size': _selectedSize!, 'corn': _selectedCorn!});
                      }
                    : null,
                child: Text('Agregar'),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
