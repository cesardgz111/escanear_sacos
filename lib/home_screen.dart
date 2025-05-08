// lib/home_screen.dart

import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'add_sack_screen.dart';
import 'manual_entry_screen.dart';
import 'redeem_prize_screen.dart';

class HomeScreen extends StatefulWidget {
  final String? email;

  const HomeScreen({Key? key, this.email}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int _sacCount = 0;

  List<Widget> get _sections => [
        _mainSection(),
        _qrSection(),
        _rewardsSection(),
      ];

  Widget _mainSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/logo-aspros.png', width: 200),
          SizedBox(height: 20),
          Text(
            '¡Bienvenido, ${widget.email}!',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20),
          Text(
            'Sacos registrados: $_sacCount',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
            child: Text('Regresar al Login'),
          ),
        ],
      ),
    );
  }

  Widget _qrSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddSackScreen()),
              );
            },
            child: Text('Añadir saco'),
            style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50)),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push<bool>(
                context,
                MaterialPageRoute(builder: (_) => ManualEntryScreen()),
              ).then((added) {
                if (added == true) {
                  setState(() {
                    _sacCount++;
                  });
                }
              });
            },
            child: Text('Agregar manualmente'),
            style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50)),
          ),
        ],
      ),
    );
  }

  Widget _rewardsSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Premios disponibles:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Text('• 20 sacos registrados = 1 saco gratis'),
          SizedBox(height: 8),
          Text('• 50 sacos registrados = 3 sacos gratis'),
          SizedBox(height: 8),
          Text('• 100 sacos registrados = 8 sacos gratis'),
          SizedBox(height: 8),
          Text('• 200 sacos registrados = 20 sacos gratis'),
          SizedBox(height: 8),
          Text('• 500 sacos registrados = 60 sacos gratis'),
          SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push<int>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RedeemPrizeScreen(totalSacs: _sacCount),
                  ),
                ).then((redeemed) {
                  if (redeemed != null && redeemed > 0) {
                    setState(() {
                      _sacCount -= redeemed;
                    });
                  }
                });
              },
              child: Text('Canjear premio'),
            ),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pantalla Principal')),
      body: Center(child: _sections[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner), label: 'Escanear'),
          BottomNavigationBarItem(
              icon: Icon(Icons.card_giftcard), label: 'Premios'),
        ],
      ),
    );
  }
}
