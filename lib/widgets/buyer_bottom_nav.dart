import 'package:flutter/material.dart';
import '../core/constants/colors.dart';

enum BuyerBottomNavVariant { market, favorites }

class BuyerBottomNav extends StatelessWidget {
  final int currentIndex;
  final BuyerBottomNavVariant variant;

  const BuyerBottomNav({
    super.key,
    required this.currentIndex,
    this.variant = BuyerBottomNavVariant.market,
  });

  static const List<String> _marketRoutes = [
    '/home',
    '/map',
    '/messages',
    '/cart',
  ];

  static const List<String> _favoritesRoutes = [
    '/home',
    '/map',
    '/favorites',
    '/cart',
  ];

  List<_NavItem> get _items => switch (variant) {
    BuyerBottomNavVariant.market => const [
      _NavItem(Icons.storefront_outlined, Icons.storefront_rounded, 'Marché'),
      _NavItem(Icons.map_outlined, Icons.map_rounded, 'Carte'),
      _NavItem(
        Icons.chat_bubble_outline_rounded,
        Icons.chat_rounded,
        'Messages',
      ),
      _NavItem(Icons.shopping_cart_outlined, Icons.shopping_cart_rounded, 'Panier'),
    ],
    BuyerBottomNavVariant.favorites => const [
      _NavItem(Icons.storefront_outlined, Icons.storefront_rounded, 'Marché'),
      _NavItem(Icons.map_outlined, Icons.map_rounded, 'Carte'),
      _NavItem(
        Icons.favorite_outline_rounded,
        Icons.favorite_rounded,
        'Favoris',
      ),
      _NavItem(Icons.shopping_cart_outlined, Icons.shopping_cart_rounded, 'Panier'),
    ],
  };

  List<String> get _routes => switch (variant) {
    BuyerBottomNavVariant.market => _marketRoutes,
    BuyerBottomNavVariant.favorites => _favoritesRoutes,
  };

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;
    final route = _routes[index];
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => _onTap(context, index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: const Color(0xFF9CA39A),
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        elevation: 0,
        items: _items
            .map(
              (item) => BottomNavigationBarItem(
                icon: Icon(item.icon),
                activeIcon: Icon(item.activeIcon),
                label: item.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem(this.icon, this.activeIcon, this.label);
}
