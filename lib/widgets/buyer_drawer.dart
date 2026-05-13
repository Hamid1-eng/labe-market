import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/colors.dart';
import '../providers/auth_provider.dart';
import '../services/auth_service.dart';

class BuyerDrawer extends StatelessWidget {
  const BuyerDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final displayName = user?.name ?? 'Acheteur Anonyme';
    final phone = user?.phone ?? '';

    return Drawer(
      backgroundColor: const Color(0xFFF4F7ED),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFDDE6D5), width: 1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: const Color(0xFFDCE6FF),
                    backgroundImage: user?.photoUrl != null && user!.photoUrl!.isNotEmpty
                        ? NetworkImage(user.photoUrl!)
                        : null,
                    child: user?.photoUrl == null || user!.photoUrl!.isEmpty
                        ? const Icon(Icons.person_rounded, size: 36, color: AppColors.primary)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    displayName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    phone,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF637060),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _DrawerItem(
              icon: Icons.person_outline_rounded,
              label: 'Mon Profil',
              onTap: () {
                Navigator.pop(context);
                final currentRoute = ModalRoute.of(context)?.settings.name;
                if (currentRoute != '/profile') {
                  Navigator.pushReplacementNamed(context, '/profile');
                }
              },
            ),
            _DrawerItem(
              icon: Icons.settings_outlined,
              label: 'Paramètres du compte',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Paramètres en construction')),
                );
              },
            ),
            _DrawerItem(
              icon: Icons.privacy_tip_outlined,
              label: 'Confidentialité',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Confidentialité en construction')),
                );
              },
            ),
            _DrawerItem(
              icon: Icons.info_outline_rounded,
              label: 'À propos',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('À propos en construction')),
                );
              },
            ),
            const Spacer(),
            const Divider(color: Color(0xFFDDE6D5), height: 1),
            _DrawerItem(
              icon: Icons.logout_rounded,
              label: 'Déconnexion',
              iconColor: const Color(0xFF9B1C1C),
              textColor: const Color(0xFF9B1C1C),
              onTap: () async {
                Navigator.pop(context);
                await AuthService().signOut();
                if (!context.mounted) return;
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
              },
            ),
            const SizedBox(height: 12),
            const Text(
              'Labé Marché v2.4.0',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF9CA39A),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? const Color(0xFF3B4738),
        size: 28,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textColor ?? const Color(0xFF2A312A),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      onTap: onTap,
    );
  }
}
