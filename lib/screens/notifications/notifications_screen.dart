import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../providers/product_provider.dart';
import '../../widgets/buyer_bottom_nav.dart';
import '../../services/audio_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late List<_Notification> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = [
      _Notification(
        id: '1',
        title: 'Pommes de terre fraîches disponibles',
        subtitle:
            'Moussa vient de publier une nouvelle récolte de pommes de terre à seulement 2km de votre position actuelle.',
        time: 'À l\'instant',
        icon: Icons.shopping_bag_outlined,
        accent: AppColors.primary,
        buttonLabel: 'Voir le produit',
        section: 'AUJOURD\'HUI',
        isRead: false,
      ),
      _Notification(
        id: '2',
        title: 'Réponse de Alpha Oumar',
        subtitle:
            'Bonjour, oui les carottes sont toujours disponibles. Vous pouvez passer à la coopérative demain matin.',
        time: '14:20',
        icon: Icons.message_outlined,
        accent: const Color(0xFF6A7ECF),
        buttonLabel: 'Répondre',
        section: 'AUJOURD\'HUI',
        isRead: false,
        avatarUrl:
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=120&h=120&fit=crop',
      ),
      _Notification(
        id: '3',
        title: 'Vérification complétée',
        subtitle:
            'Votre compte acheteur a été vérifié avec succès. Vous pouvez désormais contacter les producteurs certifiés.',
        time: 'Hier',
        icon: Icons.verified_outlined,
        accent: const Color(0xFFC07A2A),
        buttonLabel: '',
        section: 'HIER',
        isRead: true,
        isSimple: true,
      ),
      _Notification(
        id: '4',
        title: 'Baisse de prix : Oignons',
        subtitle:
            'Le prix des oignons de la coopérative de Pita a baissé de 15%. C\'est le moment d\'en profiter !',
        time: 'Hier',
        icon: Icons.trending_down_rounded,
        accent: const Color(0xFFC05A8E),
        buttonLabel: 'Voir l\'offre',
        section: 'HIER',
        isRead: true,
        isSimple: true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductProvider>().items;
    final product = products.isNotEmpty ? products.first : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7ED),
      body: SafeArea(
        child: Column(
          children: [
            _Header(onMarkAllRead: _markAllRead),
            _OfflineBanner(),
            const SizedBox(height: 8),
            Expanded(
              child: _notifications.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.notifications_none_rounded,
                            size: 48,
                            color: Color(0xFFA0A4A0),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Aucune notification',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF8C8F84),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
                      children: _buildNotificationsList(product),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF9E3C67),
        onPressed: () async {
          await AudioService().readNotificationsGuide();
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Guide audio en Pular activé')),
          );
        },
        child: const Icon(Icons.record_voice_over_rounded, color: Colors.white),
      ),
    );
  }

  List<Widget> _buildNotificationsList(dynamic product) {
    final widgets = <Widget>[];
    String? currentSection;

    for (final notif in _notifications) {
      if (notif.section != currentSection) {
        currentSection = notif.section;
        if (widgets.isNotEmpty) {
          widgets.add(const SizedBox(height: 18));
        }
        widgets.add(_SectionLabel(label: currentSection));
        widgets.add(const SizedBox(height: 10));
      }

      if (notif.isSimple) {
        widgets.add(
          _SimpleAlertCard(
            title: notif.title,
            subtitle: notif.subtitle,
            icon: notif.icon,
            accent: notif.accent,
            onDelete: () => _deleteNotification(notif.id),
            trailingButton: notif.buttonLabel.isNotEmpty
                ? TextButton(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Offre ouverte')),
                    ),
                    child: Text(notif.buttonLabel),
                  )
                : null,
          ),
        );
      } else {
        widgets.add(
          _NotificationCard(
            title: notif.title,
            subtitle: notif.subtitle,
            time: notif.time,
            icon: notif.icon,
            accent: notif.accent,
            buttonLabel: notif.buttonLabel,
            avatarUrl: notif.avatarUrl,
            isRead: notif.isRead,
            onTap: () {
              _markAsRead(notif.id);
              if (product == null) return;
              Navigator.pushNamed(
                context,
                '/product/detail',
                arguments: product,
              );
            },
            onDelete: () => _deleteNotification(notif.id),
            onMarkRead: () => _markAsRead(notif.id),
          ),
        );
      }
      widgets.add(const SizedBox(height: 12));
    }

    return widgets;
  }

  void _markAsRead(String id) {
    setState(() {
      final idx = _notifications.indexWhere((n) => n.id == id);
      if (idx != -1) {
        _notifications[idx].isRead = true;
      }
    });
  }

  void _deleteNotification(String id) {
    setState(() {
      _notifications.removeWhere((n) => n.id == id);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Notification supprimée')));
  }

  void _markAllRead() {
    setState(() {
      for (final notif in _notifications) {
        notif.isRead = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Toutes les notifications ont été marquées comme lues'),
      ),
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

class _Notification {
  final String id;
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color accent;
  final String buttonLabel;
  final String section;
  bool isRead;
  final String? avatarUrl;
  final bool isSimple;

  _Notification({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.accent,
    required this.buttonLabel,
    required this.section,
    required this.isRead,
    this.avatarUrl,
    this.isSimple = false,
  });
}

class _NotificationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color accent;
  final String buttonLabel;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onMarkRead;
  final String? avatarUrl;
  final bool isRead;

  const _NotificationCard({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.accent,
    required this.buttonLabel,
    required this.onTap,
    required this.onDelete,
    required this.onMarkRead,
    this.avatarUrl,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isRead ? const Color(0xFFF9F9F9) : Colors.white,
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
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: isRead
                              ? FontWeight.w500
                              : FontWeight.w600,
                          height: 1.05,
                          color: isRead
                              ? const Color(0xFF999999)
                              : Colors.black,
                        ),
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'delete') {
                          onDelete();
                        } else if (value == 'mark_read') {
                          onMarkRead();
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        if (!isRead)
                          const PopupMenuItem<String>(
                            value: 'mark_read',
                            child: Text('Marquer comme lu'),
                          ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Text('Supprimer'),
                        ),
                      ],
                      child: const Text(
                        '⋮',
                        style: TextStyle(
                          color: Color(0xFF8D8F88),
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isRead
                        ? const Color(0xFF999999)
                        : const Color(0xFF4F594C),
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
  final VoidCallback onDelete;

  const _SimpleAlertCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.onDelete,
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
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'delete') {
                    onDelete();
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Text('Supprimer'),
                  ),
                ],
                child: const Text(
                  '⋮',
                  style: TextStyle(color: Color(0xFF8D8F88), fontSize: 18),
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
