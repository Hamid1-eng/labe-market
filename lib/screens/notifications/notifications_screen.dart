import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../providers/product_provider.dart';
import '../../widgets/buyer_bottom_nav.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductProvider>().items;
    final product = products.isNotEmpty ? products.first : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7ED),
      body: SafeArea(
        child: Column(
          children: [
            _Header(
              onMarkAllRead: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Toutes les notifications ont été marquées comme lues',
                  ),
                ),
              ),
            ),
            _OfflineBanner(),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
                children: [
                  const _SectionLabel(label: 'AUJOURD\'HUI'),
                  const SizedBox(height: 10),
                  _NotificationCard(
                    title: 'Pommes de terre fraîches disponibles',
                    subtitle:
                        'Moussa vient de publier une nouvelle récolte de pommes de terre à seulement 2km de votre position actuelle.',
                    time: 'À l\'instant',
                    icon: Icons.shopping_bag_outlined,
                    accent: AppColors.primary,
                    buttonLabel: 'Voir le produit',
                    onTap: () {
                      if (product == null) return;
                      Navigator.pushNamed(
                        context,
                        '/product/detail',
                        arguments: product,
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _NotificationCard(
                    title: 'Réponse de Alpha Oumar',
                    subtitle:
                        'Bonjour, oui les carottes sont toujours disponibles. Vous pouvez passer à la coopérative demain matin.',
                    time: '14:20',
                    icon: Icons.message_outlined,
                    accent: const Color(0xFF6A7ECF),
                    buttonLabel: 'Répondre',
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ouverture de la réponse')),
                    ),
                    avatarUrl:
                        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=120&h=120&fit=crop',
                  ),
                  const SizedBox(height: 18),
                  const _SectionLabel(label: 'HIER'),
                  const SizedBox(height: 10),
                  _SimpleAlertCard(
                    title: 'Vérification complétée',
                    subtitle:
                        'Votre compte acheteur a été vérifié avec succès. Vous pouvez désormais contacter les producteurs certifiés.',
                    icon: Icons.verified_outlined,
                    accent: const Color(0xFFC07A2A),
                  ),
                  const SizedBox(height: 12),
                  _SimpleAlertCard(
                    title: 'Baisse de prix : Oignons',
                    subtitle:
                        'Le prix des oignons de la coopérative de Pita a baissé de 15%. C\'est le moment d\'en profiter !',
                    icon: Icons.trending_down_rounded,
                    accent: const Color(0xFFC05A8E),
                    trailingButton: TextButton(
                      onPressed: () =>
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Offre ouverte')),
                          ),
                      child: const Text('Voir l\'offre'),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8D7BD),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.wifi_off_rounded, color: Color(0xFF8D5A2A)),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Working Offline. Your actions will sync once reconnected.',
                            style: TextStyle(
                              color: Color(0xFF7B4218),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF9E3C67),
        onPressed: () => ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Guide audio ouvert'))),
        child: const Icon(Icons.record_voice_over_rounded, color: Colors.white),
      ),
      bottomNavigationBar: const BuyerBottomNav(currentIndex: 2),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onMarkAllRead;

  const _Header({required this.onMarkAllRead});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 12, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.menu_rounded,
              color: AppColors.primary,
              size: 30,
            ),
          ),
          const Expanded(
            child: Text(
              'Notifications',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
            ),
          ),
          TextButton(
            onPressed: onMarkAllRead,
            child: const Text(
              'Tout marquer\ncomme lu',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                height: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: const Color(0xFFF8E6C8),
      child: const Row(
        children: [
          Icon(Icons.sync_disabled_rounded, color: Color(0xFF8B5A21), size: 18),
          SizedBox(width: 8),
          Text(
            'Working Offline. Your actions will sync once reconnected.',
            style: TextStyle(color: Color(0xFF7B4218), fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xFF8C8F84),
        fontSize: 14,
        letterSpacing: 1.1,
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color accent;
  final String buttonLabel;
  final VoidCallback onTap;
  final String? avatarUrl;

  const _NotificationCard({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.accent,
    required this.buttonLabel,
    required this.onTap,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border(left: BorderSide(color: accent, width: 4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: accent.withValues(alpha: 0.15),
            backgroundImage: avatarUrl != null
                ? NetworkImage(avatarUrl!)
                : null,
            child: avatarUrl == null ? Icon(icon, color: accent) : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          height: 1.05,
                        ),
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        color: Color(0xFF8D8F88),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF4F594C),
                    fontSize: 15,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      buttonLabel,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SimpleAlertCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final Widget? trailingButton;

  const _SimpleAlertCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    this.trailingButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF0FF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: accent.withValues(alpha: 0.15),
                child: Icon(icon, color: accent),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF4F594C),
              fontSize: 15,
              height: 1.45,
            ),
          ),
          if (trailingButton != null) ...[
            const SizedBox(height: 10),
            trailingButton!,
          ],
        ],
      ),
    );
  }
}
