import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManualEntryScreen extends StatefulWidget {
  final String userNumber;

  const ManualEntryScreen({Key? key, required this.userNumber})
      : super(key: key);

  @override
  State<ManualEntryScreen> createState() => _ManualEntryScreenState();
}

class _ManualEntryScreenState extends State<ManualEntryScreen> {
  final _codeController = TextEditingController();
  bool _isValid = false;
  bool _loading = false;

  void _onCodeChanged() {
    final text = _codeController.text;
    final isDigits = RegExp(r'^\d{16}$').hasMatch(text);
    setState(() {
      _isValid = isDigits;
    });
  }

  Future<void> _saveCode() async {
    final code = _codeController.text.trim();
    final phone = widget.userNumber;

    try {
      setState(() => _loading = true);

      final sacksRef = FirebaseFirestore.instance.collection('sacks').doc(code);
      final userRef = FirebaseFirestore.instance.collection('users').doc(phone);

      final sackSnapshot = await sacksRef.get();

      if (!sackSnapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El código no existe en los sacos.')),
        );
        setState(() => _loading = false);
        return;
      }

      final sackData = sackSnapshot.data()!;
      final existingUser = sackData['user'];

      if (existingUser != null && existingUser.toString().isNotEmpty) {
        if (existingUser == phone) {
          // Ya está asignado a este mismo usuario
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Este saco ya está asignado a ti.')),
          );
        } else {
          // Ya tiene un usuario distinto
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Este saco ya está asignado a otro usuario.')),
          );
        }
        setState(() => _loading = false);
        return;
      }

      // Asignar el número al campo "user"
      await sacksRef.update({'user': phone});

      // Verifica si el usuario ya tiene este código en su lista
      final userSnapshot = await userRef.get();
      if (userSnapshot.exists) {
        final data = userSnapshot.data()!;
        final List<dynamic> existingSacks = data['sacks'] ?? [];

        if (existingSacks.contains(code)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Este saco ya fue registrado.')),
          );
          setState(() => _loading = false);
          return;
        }
      }

      // Agrega el código al arreglo "sacks"
      await userRef.update({
        'sacks': FieldValue.arrayUnion([code])
      });

      Navigator.pop(context, true); // Devuelve true para actualizar contador
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _codeController.addListener(_onCodeChanged);
  }

  @override
  void dispose() {
    _codeController
      ..removeListener(_onCodeChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Manualmente')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                labelText: 'Código de barras:',
                hintText: 'Ingresa 16 dígitos',
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              maxLength: 16,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_isValid && !_loading) ? _saveCode : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _loading
                    ? const CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2)
                    : const Text('Agregar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
