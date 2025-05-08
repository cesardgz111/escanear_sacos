// lib/redeem_prize_screen.dart

import 'package:flutter/material.dart';

class RedeemPrizeScreen extends StatefulWidget {
  final int totalSacs;

  const RedeemPrizeScreen({Key? key, required this.totalSacs})
      : super(key: key);

  @override
  State<RedeemPrizeScreen> createState() => _RedeemPrizeScreenState();
}

class _RedeemPrizeScreenState extends State<RedeemPrizeScreen> {
  late int _remainingSacs;
  final List<Map<String, int>> _prizes = [
    {'required': 1, 'reward': 1},
    {'required': 2, 'reward': 3},
    {'required': 3, 'reward': 8},
    {'required': 4, 'reward': 20},
    {'required': 5, 'reward': 60},
  ];

  @override
  void initState() {
    super.initState();
    _remainingSacs = widget.totalSacs;
  }

  void _redeem(int required, int reward) {
    setState(() {
      _remainingSacs -= required;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Has canjeado $required sacos por $reward sacos gratis. Sobrantes: $_remainingSacs'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Canjear Premio')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sacos registrados: ${widget.totalSacs}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Sacos disponibles para canjear: $_remainingSacs',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: _prizes.length,
                itemBuilder: (context, index) {
                  final prize = _prizes[index];
                  final req = prize['required']!;
                  final rew = prize['reward']!;
                  final canRedeem = _remainingSacs >= req;
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text('$req sacos = $rew sacos gratis'),
                      trailing: ElevatedButton(
                        onPressed: canRedeem ? () => _redeem(req, rew) : null,
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
