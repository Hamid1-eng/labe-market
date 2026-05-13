import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/colors.dart';
import '../../models/product_model.dart';
import '../../providers/product_provider.dart';
import '../../widgets/buyer_bottom_nav.dart';
import '../../widgets/buyer_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  final List<String> _filters = const ['Tout', 'Fruits', 'Légumes'];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedFilter = 'Tout';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final provider = context.read<ProductProvider>();
    try {
      final auth = FirebaseAuth.instance;
      if (auth.currentUser == null) {
        await auth.signInAnonymously();
      }
    } catch (_) {}

    try {
      await provider.load();
    } catch (_) {}

    if (mounted) {
      setState(() => _loading = false);
    }
  }

  List<ProductModel> _filteredProducts(List<ProductModel> items) {
    final query = _searchCtrl.text.trim().toLowerCase();
    return items.where((product) {
      final matchesSearch =
          query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.location.toLowerCase().contains(query) ||
          (product.category ?? '').toLowerCase().contains(query);

      final matchesCategory = switch (_selectedFilter) {
        'Tout' => true,
        'Fruits' => (product.category ?? '').toLowerCase().contains('fruit'),
        'Légumes' =>
          (product.category ?? '').toLowerCase().contains('légume') ||
              (product.category ?? '').toLowerCase().contains('legume'),
        _ => true,
      };

      return matchesSearch && matchesCategory;
    }).toList();
  }

  String _formatPrice(int price) {
    final text = price.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && (text.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(text[i]);
    }
    return buffer.toString();
  }

  Future<void> _callPhone(String phone) async {
    if (phone.isEmpty) return;
    final uri = Uri(scheme: 'tel', path: phone);
    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    final products = _filteredProducts(provider.items);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF4F7ED),
      drawer: const BuyerDrawer(),
      floatingActionButton: _AudioButton(
        onTap: () => ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Guide audio activé'))),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(provider),
            const SizedBox(height: 14),
            _buildSearchBar(),
            const SizedBox(height: 14),
            _buildFilters(),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Produits Frais',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Voir tout',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward,
                          size: 18,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    )
                  : RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: _load,
                      child: products.isEmpty
                          ? ListView(
                              children: const [
                                SizedBox(height: 120),
                                Center(
                                  child: Text(
                                    'Aucun produit trouvé',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xFF6B6B6B),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 96),
                              itemBuilder: (context, index) {
                                final product = products[index];
                                return _ProductCard(
                                  product: product,
                                  formatPrice: _formatPrice,
                                  onCall: () => _callPhone(product.phone),
                                  onToggleFavorite: () => context
                                      .read<ProductProvider>()
                                      .toggleFavorite(product.id),
                                  isFavorite: provider.isFavorite(product.id),
                                );
                              },
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemCount: products.length,
                            ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BuyerBottomNav(currentIndex: 0),
    );
  }

  Widget _buildHeader(ProductProvider provider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            icon: const Icon(Icons.menu, size: 32, color: AppColors.primary),
          ),
          const SizedBox(width: 4),
          const Expanded(
            child: Text(
              'Labé Marché',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                height: 1,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/map'),
            icon: const Icon(Icons.search, size: 30, color: Color(0xFF333333)),
          ),
          const SizedBox(width: 4),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFC8D8C0), width: 2),
            ),
            child: ClipOval(
              child: Image.network(
                provider.items.isNotEmpty &&
                        provider.items.first.producerAvatar != null
                    ? provider.items.first.producerAvatar!
                    : 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&h=200&fit=crop',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const ColoredBox(
                  color: Color(0xFFEAEFE5),
                  child: Icon(Icons.person, color: AppColors.primary),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color(0xFFF9D7C0),
      child: const Row(
        children: [
          Icon(Icons.wifi_off_rounded, color: Color(0xFF8C5A2B), size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Mode hors-ligne. Vos actions seront synchronisées.',
              style: TextStyle(
                color: Color(0xFF7B4218),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 58,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFD2D9D0)),
              ),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Rechercher des produits...',
                  hintStyle: TextStyle(color: Color(0xFF7C8579), fontSize: 16),
                  prefixIcon: Icon(Icons.search, color: Color(0xFF7C8579)),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 17,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.tune_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final label = _filters[index];
          final selected = _selectedFilter == label;
          return ChoiceChip(
            label: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : const Color(0xFF2E2E2E),
                fontWeight: FontWeight.w600,
              ),
            ),
            selected: selected,
            selectedColor: AppColors.primary,
            backgroundColor: const Color(0xFFE4E9DE),
            onSelected: (_) => setState(() => _selectedFilter = label),
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: _filters.length,
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  final String Function(int) formatPrice;
  final VoidCallback onCall;
  final VoidCallback onToggleFavorite;
  final bool isFavorite;

  const _ProductCard({
    required this.product,
    required this.formatPrice,
    required this.onCall,
    required this.onToggleFavorite,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final rating = product.rating ?? 4.8;
    final unit = product.unitLabel?.isNotEmpty == true
        ? product.unitLabel!
        : 'kg';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: Color(0xFFE0E6DA)),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => Navigator.pushNamed(
            context,
            '/product/detail',
            arguments: product,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                    child: AspectRatio(
                      aspectRatio: 1.45,
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFFE5EBDD),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 42,
                            color: Color(0xFF9CA39A),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${formatPrice(product.price)} GNF/$unit',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              height: 1.05,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F5EA),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star_border_rounded,
                                color: AppColors.secondary,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: Color(0xFF6C7567),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            product.location,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF4C5648),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 54,
                            child: ElevatedButton.icon(
                              onPressed: onCall,
                              icon: const Icon(Icons.phone_rounded, size: 20),
                              label: const Text(
                                'Appeler',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFBAC7B4)),
                          ),
                          child: IconButton(
                            onPressed: onToggleFavorite,
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: isFavorite
                                  ? Colors.redAccent
                                  : const Color(0xFF60695C),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (product.producerName != null || product.verified)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F6EE),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              product.verified
                                  ? 'Guide Audio Pular'
                                  : 'Audio disponible',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AudioButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AudioButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onTap,
      backgroundColor: const Color(0xFFF59C42),
      foregroundColor: Colors.white,
      child: const Icon(Icons.record_voice_over_rounded, size: 30),
    );
  }
}
