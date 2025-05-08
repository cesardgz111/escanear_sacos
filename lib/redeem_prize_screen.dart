// lib/redeem_prize_screen.dart

import 'package:flutter/material.dart';

class RedeemPrizeScreen extends StatelessWidget {
  final int totalSacs;

  const RedeemPrizeScreen({Key? key, required this.totalSacs})
      : super(key: key);

  static const List<Map<String, int>> _prizes = [
    {'required': 1, 'reward': 1},
    {'required': 2, 'reward': 3},
    {'required': 3, 'reward': 8},
    {'required': 4, 'reward': 20},
    {'required': 5, 'reward': 60},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Canjear Premio')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sacos registrados: $totalSacs',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: _prizes.length,
                itemBuilder: (context, index) {
                  final req = _prizes[index]['required']!;
                  final rew = _prizes[index]['reward']!;
                  final canRedeem = totalSacs >= req;
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text('$req sacos = $rew sacos gratis'),
                      trailing: ElevatedButton(
                        onPressed: canRedeem
                            ? () {
                                Navigator.pop(context, req);
                              }
                            : null,
                        child: Text('Canjear'),
                      ),
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
