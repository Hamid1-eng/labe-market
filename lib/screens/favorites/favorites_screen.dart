import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../widgets/buyer_bottom_nav.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7ED),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Mes Favoris',
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
              child: const Icon(Icons.favorite_outline, size: 44, color: Color(0xFFB0B8AD)),
            ),
            const SizedBox(height: 18),
            const Text('Aucun favori pour l\'instant',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF3F4A3E))),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Explorez le marché et ajoutez vos produits préférés ici.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Color(0xFF7C8579), height: 1.4),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
              icon: const Icon(Icons.storefront),
              label: const Text('Explorer le marché', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary, foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BuyerBottomNav(currentIndex: 1),
    );
  }
}
