import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../models/product_model.dart';
import '../../providers/product_provider.dart';
import '../../widgets/buyer_bottom_nav.dart';
import '../../widgets/buyer_drawer.dart';
import '../../services/audio_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductProvider>().items;
    final ProductModel? featured = products.isNotEmpty ? products.first : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7ED),
      drawer: const BuyerDrawer(),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(context),
                _buildOfflineBanner(),
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: FlutterMap(
                          options: const MapOptions(
                            initialCenter: LatLng(11.3167, -12.2833),
                            initialZoom: 13.0,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.labe.market',
                            ),
                            MarkerLayer(
                              markers: products.map((p) {
                                final hash = p.id.hashCode;
                                final random = Random(hash);
                                final latOffset =
                                    (random.nextDouble() - 0.5) * 0.05;
                                final lngOffset =
                                    (random.nextDouble() - 0.5) * 0.05;
                                return Marker(
                                  point: LatLng(
                                    11.3167 + latOffset,
                                    -12.2833 + lngOffset,
                                  ),
                                  width: 48,
                                  height: 48,
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(18),
                                          ),
                                        ),
                                        builder: (_) => _BottomProductCard(
                                          product: p,
                                          onTap: () => Navigator.pushNamed(
                                            context,
                                            '/product/detail',
                                            arguments: p,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Icon(
                                        Icons.eco_rounded,
                                        color: const Color(0xFF1B6F1E),
                                        size: 28,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 40,
                        right: 18,
                        child: _RoundActionButton(
                          icon: Icons.volume_up_rounded,
                          color: const Color(0xFF1B6F1E),
                          onTap: () {},
                          size: 56,
                        ),
                      ),
                      Positioned(
                        right: 22,
                        top: 220,
                        child: Column(
                          children: [
                            _RoundSquareButton(
                              icon: Icons.add,
                              color: Colors.white,
                              iconColor: Colors.black,
                              onTap: () {},
                            ),
                            const SizedBox(height: 8),
                            _RoundSquareButton(
                              icon: Icons.remove,
                              color: Colors.white,
                              iconColor: Colors.black,
                              onTap: () {},
                            ),
                            const SizedBox(height: 14),
                            _RoundSquareButton(
                              icon: Icons.my_location_rounded,
                              color: const Color(0xFF2F8A2F),
                              iconColor: Colors.white,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                      // Note: product details now shown on marker tap via bottom sheet.
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 102,
              right: 24,
              child: FloatingActionButton(
                backgroundColor: const Color(0xFFF57C00),
                onPressed: () async {
                  await AudioService().readProductGuide(
                    featured?.name ?? 'Marché',
                  );
                },
                child: const Icon(
                  Icons.record_voice_over_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BuyerBottomNav(currentIndex: 1),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Row(
        children: [
          Builder(
            builder: (ctx) => IconButton(
              onPressed: () => Scaffold.of(ctx).openDrawer(),
              icon: const Icon(
                Icons.menu_rounded,
                color: Color(0xFF1B6F1E),
                size: 32,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'Labé Marché',
              style: TextStyle(
                color: Color(0xFF1B6F1E),
                fontWeight: FontWeight.w700,
                fontSize: 29,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search_rounded,
              color: Color(0xFF3B3B3B),
              size: 32,
            ),
          ),
          const SizedBox(width: 6),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
            icon: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF3B3B3B),
              size: 28,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFD4D9D1), width: 2),
            ),
            child: ClipOval(
              child: Image.network(
                'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=200&h=200&fit=crop',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const ColoredBox(
                  color: Color(0xFFEAEFE5),
                  child: Icon(Icons.person, color: Color(0xFF1B6F1E)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfflineBanner() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF7D7BD),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: const Row(
        children: [
          Icon(Icons.wifi_off_rounded, color: Color(0xFF8D5A2A), size: 22),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Mode hors-ligne. Vos actions seront synchronisées.',
              style: TextStyle(
                color: Color(0xFF7B4218),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapTag extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _MapTag({required this.label, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 0,
          height: 0,
          decoration: BoxDecoration(
            border: Border(
              left: const BorderSide(color: Colors.transparent, width: 12),
              right: const BorderSide(color: Colors.transparent, width: 12),
              top: BorderSide(color: color, width: 12),
            ),
          ),
        ),
      ],
    );
  }
}

class _RoundActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;
  final double size;

  const _RoundActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
    this.iconColor = Colors.white,
    this.size = 46,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: const CircleBorder(),
      elevation: 5,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(icon, color: iconColor, size: 28),
        ),
      ),
    );
  }
}

class _RoundSquareButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;

  const _RoundSquareButton({
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      elevation: 5,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: SizedBox(
          width: 64,
          height: 64,
          child: Icon(icon, color: iconColor, size: 24),
        ),
      ),
    );
  }
}

class _BottomProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const _BottomProductCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F7F1),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFD7E0D2)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                product.imageUrl.isNotEmpty
                    ? product.imageUrl
                    : 'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=300&h=300&fit=crop',
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 90,
                  height: 90,
                  color: const Color(0xFFE5EBDD),
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.verified ? 'PRODUCTEUR VÉRIFIÉ' : 'PRODUCTEUR',
                        style: const TextStyle(
                          color: Color(0xFF1B6F1E),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Icon(
                        Icons.favorite_border_rounded,
                        color: Color(0xFF394239),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF121826),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${product.price} GNF /',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color(0xFF1B6F1E),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 82,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: onTap,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text(
                            'Voir',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
