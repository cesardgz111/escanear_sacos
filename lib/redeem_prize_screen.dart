// lib/redeem_prize_screen.dart

import 'package:flutter/material.dart';

class RedeemPrizeScreen extends StatelessWidget {
  final int totalSacs;

  const RedeemPrizeScreen({Key? key, required this.totalSacs})
      : super(key: key);

  static const List<Map<String, dynamic>> _prizes = [
    {
      'name': 'Audífonos',
      'required': 1,
      'image': 'assets/images/audifonos.jpg',
    },
    {
      'name': 'Celular',
      'required': 2,
      'image': 'assets/images/celular.jpg',
    },
    {
      'name': 'Licuadora',
      'required': 3,
      'image': 'assets/images/licuadora.jpg',
    },
    {
      'name': 'Laptop',
      'required': 4,
      'image': 'assets/images/laptop.jpg',
    },
    {
      'name': 'Moto',
      'required': 5,
      'image': 'assets/images/moto.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Canjear Premio')),
      body: Padding(
        padding: const EdgeInsets.all(36.0),
        child: Column(
          children: [
            Text(
              'Sacos registrados: $totalSacs',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _prizes.length,
                itemBuilder: (context, index) {
                  final prize = _prizes[index];
                  final name = prize['name'] as String;
                  final req = prize['required'] as int;
                  final imagePath = prize['image'] as String;
                  final canRedeem = totalSacs >= req;

                  return Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Nombre del premio arriba
                        Container(
                          color: Colors.green[100],
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // Imagen más alta
                        SizedBox(
                          height: 220,
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                          ),
                        ),

                        // Texto y botón
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '$req sacos',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    backgroundColor: canRedeem
                                        ? Colors.green
                                        : Colors.grey[400],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: canRedeem
                                      ? () => Navigator.pop(context, req)
                                      : null,
                                  child: Text(
                                    'Canjear',
                                    style: TextStyle(
                                      color: canRedeem
                                          ? Colors.white
                                          : Colors.grey[700],
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
