import 'package:flutter/material.dart';
import '../core/constants/colors.dart';

class ProducerBottomNav extends StatelessWidget {
  final int currentIndex;

  const ProducerBottomNav({super.key, required this.currentIndex});

  static const List<String> _routes = [
    '/producer/dashboard',
    '/producer/products',
    '/producer/add',
    '/producer/profile',
  ];

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;
    final route = _routes[index];
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onTap(context, index),
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFFF3F5EE),
      selectedItemColor: AppColors.primary,
      unselectedItemColor: const Color(0xFF7C8279),
      selectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view_rounded),
          activeIcon: Icon(Icons.grid_view_rounded),
          label: 'Tableau',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory_2_outlined),
          activeIcon: Icon(Icons.inventory_2_rounded),
          label: 'Produits',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline_rounded),
          activeIcon: Icon(Icons.add_circle_rounded),
          label: 'Ajouter',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline_rounded),
          activeIcon: Icon(Icons.person_rounded),
          label: 'Profil',
        ),
      ],
    );
  }
}
