import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddSackScreen extends StatefulWidget {
  final String userNumber;

  const AddSackScreen({super.key, required this.userNumber});

  @override
  State<AddSackScreen> createState() => _AddSackScreenState();
}

class _AddSackScreenState extends State<AddSackScreen> {
  bool _isScanning = true;
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (!_isScanning) return;

    final barcode = capture.barcodes.first;
    final String? raw = barcode.rawValue;
    if (raw == null) return;

    setState(() => _isScanning = false);

    try {
      // Extraer solo el ID de la primera línea
      final lines = raw.split('\n');
      if (lines.isEmpty || !lines.first.startsWith('ID: ')) {
        throw 'Formato de QR no válido';
      }
      final code = lines.first.replaceFirst('ID: ', '').trim();

      final sackDoc = await _firestore.collection('sacks').doc(code).get();
      if (!sackDoc.exists) {
        _showResultDialog(
          title: 'No encontrado',
          message: 'El costal con ID $code no existe en la base de datos.',
          success: false,
        );
        return;
      }

      final sackData = sackDoc.data()!;
      final existingUser = sackData['user'];

      if (existingUser != null && existingUser.toString().isNotEmpty) {
        if (existingUser == widget.userNumber) {
          _showResultDialog(
            title: 'Ya registrado',
            message: 'Este costal ya está registrado por ti.',
            success: false,
          );
        } else {
          _showResultDialog(
            title: 'Asignado',
            message: 'Este costal ya está asignado a otro usuario.',
            success: false,
          );
        }
        return;
      }

      // Asignar el número telefónico al costal
      await _firestore.collection('sacks').doc(code).update({
        'user': widget.userNumber,
        'registered': true,
      });

      // Agregar el ID del costal al usuario
      await _firestore.collection('users').doc(widget.userNumber).update({
        'sacks': FieldValue.arrayUnion([code])
      });

      _showResultDialog(
        title: 'Costal registrado',
        message: 'El costal con ID $code ha sido añadido exitosamente.',
        success: true,
      );
    } catch (e) {
      _showResultDialog(
        title: 'Error',
        message: 'Ocurrió un error: $e',
        success: false,
      );
    }
  }

  void _showResultDialog({
    required String title,
    required String message,
    required bool success,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (success) {
                Navigator.pop(context, true);
              } else {
                setState(() => _isScanning = true);
              }
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escanear Costal')),
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
        ),
        onDetect: _onDetect,
      ),
    );
  }
}
