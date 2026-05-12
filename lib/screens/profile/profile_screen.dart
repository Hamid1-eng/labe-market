import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../services/auth_service.dart';
import '../../widgets/buyer_bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7ED),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Mon Profil',
            style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF1F2420))),
        foregroundColor: const Color(0xFF1F2420),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8DF)),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.person, color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 12),
                  const Text('Acheteur',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  const Text('Labé, Guinée',
                      style: TextStyle(color: Color(0xFF7C8579))),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F0D6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('Membre actif',
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _MenuItem(icon: Icons.shopping_bag_outlined, label: 'Mes commandes', onTap: () {}),
            _MenuItem(icon: Icons.favorite_outline, label: 'Mes favoris',
                onTap: () => Navigator.pushReplacementNamed(context, '/favorites')),
            _MenuItem(icon: Icons.notifications_none, label: 'Notifications',
                onTap: () => Navigator.pushReplacementNamed(context, '/notifications')),
            _MenuItem(icon: Icons.settings_outlined, label: 'Paramètres', onTap: () {}),
            _MenuItem(icon: Icons.help_outline, label: 'Aide', onTap: () {}),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton.icon(
                onPressed: () async {
                  await AuthService().signOut();
                  if (!context.mounted) return;
                  Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                },
                icon: const Icon(Icons.logout),
                label: const Text('Se déconnecter', style: TextStyle(fontSize: 16)),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFF2D2CC),
                  foregroundColor: const Color(0xFF8A120E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BuyerBottomNav(currentIndex: 3),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _MenuItem({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primary),
                const SizedBox(width: 14),
                Expanded(child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                const Icon(Icons.chevron_right, color: Color(0xFFB0B8AD)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
