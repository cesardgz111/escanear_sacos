// lib/register_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  String? _verificationId;
  bool _codeSent = false;
  bool _isLoading = false;

  Future<void> _verifyPhone() async {
    setState(() => _isLoading = true);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: _phoneController.text.trim(),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieval
        await FirebaseAuth.instance.signInWithCredential(credential);
        await _createUser();
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verificación fallida: ${e.message}')),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _isLoading = false;
          _codeSent = true;
          _verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  Future<void> _registerWithCode() async {
    setState(() => _isLoading = true);
    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: _codeController.text.trim(),
    );
    try {
      final userCred =
          await FirebaseAuth.instance.signInWithCredential(credential);
      await _createUser(userCred.user!.uid);
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar: $e')),
      );
    }
  }

  Future<void> _createUser([String? uid]) async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = uid ?? user!.uid;
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'name': _nameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    _goToHome();
  }

  void _goToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) =>
            HomeScreen(email: FirebaseAuth.instance.currentUser?.phoneNumber),
      ),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrarse')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!_codeSent) ...[
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Número de teléfono'),
                keyboardType: TextInputType.phone,
              ),
            ],
            if (_codeSent) ...[
              TextField(
                controller: _codeController,
                decoration: InputDecoration(labelText: 'Código SMS'),
                keyboardType: TextInputType.number,
              ),
            ],
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () => _codeSent ? _registerWithCode() : _verifyPhone(),
                child:
                    Text(_codeSent ? 'Verificar y registrar' : 'Enviar código'),
              ),
            ),
            if (_isLoading) ...[
              SizedBox(height: 24),
              CircularProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }
}
