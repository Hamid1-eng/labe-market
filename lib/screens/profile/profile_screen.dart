import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../core/constants/colors.dart';
import '../../providers/auth_provider.dart';
import '../../services/audio_service.dart';
import '../../services/auth_service.dart';
import '../../services/storage_service.dart';
import '../../widgets/buyer_bottom_nav.dart';
import '../../widgets/buyer_drawer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;
    final displayName = user?.name ?? 'Acheteur Anonyme';
    final firstName = displayName.split(' ').first;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7ED),
      drawer: const BuyerDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
          child: Column(
            children: [
              Builder(
                builder: (ctx) => _Header(
                  onMenuTap: () => Scaffold.of(ctx).openDrawer(),
                  onAvatarTap: () {},
                ),
              ),
              const SizedBox(height: 26),
              _EditableAvatar(
                photoUrl: user?.photoUrl,
                onImageUploaded: (url) {
                  context.read<AuthProvider>().updatePhotoUrl(url);
                  FirebaseAuth.instance.currentUser?.updatePhotoURL(url);
                },
              ),
              const SizedBox(height: 18),
              Text(
                firstName,
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF3E5),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: const Color(0xFFC9E0C2)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.verified_user_outlined,
                      color: AppColors.primary,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Acheteur Vérifié',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Labé, Centre-Ville',
                style: TextStyle(fontSize: 18, color: Color(0xFF444B57)),
              ),
              const SizedBox(height: 26),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'Commandes',
                      value: '24',
                      valueColor: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _StatCard(
                      title: 'Favoris',
                      value: '12',
                      valueColor: AppColors.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              _MenuCard(
                items: [
                  _MenuRowItem(
                    icon: Icons.favorite_border_rounded,
                    background: const Color(0xFFF7DCCB),
                    iconColor: const Color(0xFF8A4800),
                    label: 'Mes Favoris',
                    onTap: () => Navigator.pushReplacementNamed(context, '/favorites'),
                  ),
                  _MenuRowItem(
                    icon: Icons.history_rounded,
                    background: const Color(0xFFE1EBE6),
                    iconColor: AppColors.primary,
                    label: 'Historique des contacts',
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Historique des contacts')),
                    ),
                  ),
                  _MenuRowItem(
                    icon: Icons.settings_rounded,
                    background: const Color(0xFFD8E4FC),
                    iconColor: const Color(0xFF405B9A),
                    label: 'Paramètres du compte',
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Paramètres du compte')),
                    ),
                  ),
                  _MenuRowItem(
                    icon: Icons.record_voice_over_rounded,
                    background: const Color(0xFFE8D8E1),
                    iconColor: const Color(0xFFA04072),
                    label: 'Aide Audio',
                    onTap: () async {
                      await AudioService().readProfileGuide();
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Aide audio en Pular activée')),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 58,
                child: FilledButton.icon(
                  onPressed: () async {
                    await AuthService().signOut();
                    if (!context.mounted) return;
                    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                  },
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text(
                    'Déconnexion',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFAD7D0),
                    foregroundColor: const Color(0xFF9B1C1C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Labé Marché — Version 2.4.0',
                style: TextStyle(color: Color(0xFFB0B0B0)),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BuyerBottomNav(currentIndex: 3),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onMenuTap;
  final VoidCallback onAvatarTap;

  const _Header({required this.onMenuTap, required this.onAvatarTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onMenuTap,
          icon: const Icon(
            Icons.menu_rounded,
            color: AppColors.primary,
            size: 30,
          ),
        ),
        const Expanded(
          child: Text(
            'Labé Marché',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pushNamed(context, '/notifications'),
          icon: const Icon(
            Icons.notifications_outlined,
            color: Color(0xFF2F2F2F),
            size: 28,
          ),
        ),
        const SizedBox(width: 4),
        IconButton(
          onPressed: () => Navigator.pushNamed(context, '/messages'),
          icon: const Icon(
            Icons.search_rounded,
            color: Color(0xFF2F2F2F),
            size: 30,
          ),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: onAvatarTap,
          child: const CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=120&h=120&fit=crop',
            ),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;

  const _StatCard({
    required this.title,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFDCE6FF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, color: Color(0xFF2A313A)),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final List<_MenuRowItem> items;

  const _MenuCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFC9D7C2)),
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            items[i],
            if (i != items.length - 1)
              const Divider(height: 1, thickness: 1, color: Color(0xFFE5E8E1)),
          ],
        ],
      ),
    );
  }
}

class _MenuRowItem extends StatelessWidget {
  final IconData icon;
  final Color background;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  const _MenuRowItem({
    required this.icon,
    required this.background,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: background,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 26),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF7F857D)),
          ],
        ),
      ),
    );
  }
}

class _EditableAvatar extends StatefulWidget {
  final String? photoUrl;
  final Function(String) onImageUploaded;

  const _EditableAvatar({required this.photoUrl, required this.onImageUploaded});

  @override
  State<_EditableAvatar> createState() => _EditableAvatarState();
}

class _EditableAvatarState extends State<_EditableAvatar> {
  bool _uploading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery, maxWidth: 800);
    if (file == null) return;

    setState(() => _uploading = true);
    try {
      final storage = StorageService();
      final path = 'profiles/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final url = await storage.uploadFile(File(file.path), path);
      if (url != null) {
        widget.onImageUploaded(url);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors du téléchargement de l\'image')),
        );
      }
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: 56,
            backgroundColor: const Color(0xFFDCE6FF),
            backgroundImage: widget.photoUrl != null && widget.photoUrl!.isNotEmpty
                ? NetworkImage(widget.photoUrl!)
                : null,
            child: widget.photoUrl == null || widget.photoUrl!.isEmpty
                ? const Icon(Icons.person_rounded, size: 56, color: AppColors.primary)
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20),
            ),
          ),
          if (_uploading)
            const Positioned.fill(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
        ],
      ),
    );
  }
}
