import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/welcome_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/home/product_detail_screen.dart';
import '../screens/favorites/favorites_screen.dart';
import '../screens/notifications/notifications_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/producer/dashboard_screen.dart';
import '../screens/producer/my_products_screen.dart';
import '../screens/producer/product_detail_screen.dart';
import '../screens/producer/add_product_screen.dart';
import '../screens/producer/profile_screen.dart';

class AppRoutes {
  static const String initial = '/';

  static final Map<String, WidgetBuilder> routes = {
    '/': (context) => const WelcomeScreen(),
    '/login': (context) => const LoginScreen(),
    '/register': (context) => const RegisterScreen(),
    '/home': (context) => const HomeScreen(),
    '/product/detail': (context) => const ProductDetailScreen(),
    '/favorites': (context) => const FavoritesScreen(),
    '/notifications': (context) => const NotificationsScreen(),
    '/profile': (context) => const ProfileScreen(),
    '/producer/dashboard': (context) => const ProducerDashboard(),
    '/producer/products': (context) => const MyProductsScreen(),
    '/producer/detail': (context) => const ProducerProductDetail(),
    '/producer/add': (context) => const ProducerAddProduct(),
    '/producer/profile': (context) => const ProducerProfileScreen(),
  };
}
