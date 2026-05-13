import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
// import '../../core/constants/colors.dart'; // retired: not used in this screen
import '../../models/product_model.dart';
import '../../providers/product_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  String formatPrice(int price) {
    final text = price.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && (text.length - i) % 3 == 0) buffer.write(' ');
      buffer.write(text[i]);
    }
    return buffer.toString();
  }

  Future<void> callPhone(BuildContext context, String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (!await launchUrl(uri)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible de lancer l’appel')),
      );
    }
  }

  Future<void> openWhatsApp(BuildContext context, String phone) async {
    final cleaned = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('https://wa.me/${cleaned.replaceAll('+', '')}');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('WhatsApp non disponible')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as ProductModel;
    final provider = context.watch<ProductProvider>();
    final isFavorite = provider.isFavorite(product.id);
    final phone = product.phone.isNotEmpty ? product.phone : '+224620000000';
    final unit = product.unitLabel?.isNotEmpty == true
        ? product.unitLabel!
        : 'kg';
    final rating = (product.rating ?? 4.9).toStringAsFixed(1);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                expandedHeight: 390,
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_rounded, size: 30),
                ),
                actions: [
                  IconButton(
                    onPressed: () => context
                        .read<ProductProvider>()
                        .toggleFavorite(product.id),
                    icon: Icon(
                      isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      size: 28,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.share_rounded, size: 27),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: _productImageErrorBuilder,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                height: 1.08,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${formatPrice(product.price)} GNF / $unit',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 17,
                                  color: Color(0xFF5B6471),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    product.location,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF4F594C),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => context
                                      .read<ProductProvider>()
                                      .toggleFavorite(product.id),
                                  icon: Icon(
                                    isFavorite
                                        ? Icons.favorite_rounded
                                        : Icons.favorite_border_rounded,
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F8FA),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: const Color(0xFFE1E5DE)),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundImage: NetworkImage(
                                  product.producerAvatar?.isNotEmpty == true
                                      ? product.producerAvatar!
                                      : 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&h=400&fit=crop',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            product.producerName?.isNotEmpty ==
                                                    true
                                                ? product.producerName!
                                                : 'Ahmadou Diallo',
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500,
                                              height: 1.05,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '★ $rating',
                                          style: const TextStyle(fontSize: 17),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      product.verified
                                          ? 'Producteur Certifié'
                                          : 'Vendeur local',
                                      style: const TextStyle(
                                        fontSize: 17,
                                        color: Color(0xFF1B6F1E),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    OutlinedButton(
                                      onPressed: () =>
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Profil producteur ouvert',
                                              ),
                                            ),
                                          ),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.black,
                                        side: const BorderSide(
                                          color: Color(0xFFE0E4DC),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                        ),
                                        minimumSize: const Size.fromHeight(46),
                                      ),
                                      child: const Text(
                                        'Voir Profil Complet',
                                        style: TextStyle(fontSize: 17),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          product.description?.isNotEmpty == true
                              ? product.description!
                              : 'Ce produit est sélectionné directement auprès des producteurs locaux. Il est disponible rapidement pour les acheteurs de Labé et environs.',
                          style: const TextStyle(
                            fontSize: 17,
                            height: 1.48,
                            color: Color(0xFF22262D),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: InfoTile(
                                icon: Icons.inventory_2_outlined,
                                title: 'Disponibilité',
                                value: '${product.quantity} Kg',
                              ),
                            ),
                            const SizedBox(width: 18),
                            Expanded(
                              child: InfoTile(
                                icon: Icons.access_time_rounded,
                                title: 'Récolté le',
                                value: '12 Oct. 2023',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.network(
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4b/Guinea_regions_map.png/1280px-Guinea_regions_map.png',
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: _mapImageErrorBuilder,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 14,
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          await callPhone(context, phone);
                        },
                        icon: const Icon(Icons.phone_rounded),
                        label: const Text(
                          'Appeler',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: const BorderSide(color: Color(0xFFE0E4DC)),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () => openWhatsApp(context, phone),
                        icon: const Icon(Icons.chat),
                        label: const Text(
                          'WhatsApp',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF25D366),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _productImageErrorBuilder(
  BuildContext context,
  Object error,
  StackTrace? stackTrace,
) {
  return Container(
    color: const Color(0xFFE7ECE2),
    alignment: Alignment.center,
    child: const Icon(
      Icons.image_not_supported,
      size: 48,
      color: Color(0xFF9CA39A),
    ),
  );
}

Widget _mapImageErrorBuilder(
  BuildContext context,
  Object error,
  StackTrace? stackTrace,
) {
  return Container(
    height: 180,
    color: const Color(0xFFE7ECE2),
    alignment: Alignment.center,
    child: const Icon(Icons.map_rounded, size: 48, color: Color(0xFF9CA39A)),
  );
}

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const InfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 21, color: Colors.black),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontSize: 18)),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 18, color: Color(0xFF1B6F1E)),
        ),
      ],
    );
  }
}
