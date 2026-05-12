import 'package:flutter/material.dart';
import '../../widgets/buyer_bottom_nav.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7ED),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Notifications',
            style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF1F2420))),
        foregroundColor: const Color(0xFF1F2420),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90, height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFFE8EDE2),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(Icons.notifications_none, size: 44, color: Color(0xFFB0B8AD)),
            ),
            const SizedBox(height: 18),
            const Text('Pas de notifications',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF3F4A3E))),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Vous recevrez des alertes quand de nouveaux produits seront disponibles.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Color(0xFF7C8579), height: 1.4),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BuyerBottomNav(currentIndex: 2),
    );
  }
}
