import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/colors.dart';
import '../../models/product_model.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  String _fmt(int price) {
    final s = price.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  Future<void> _callPhone(BuildContext context, String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible de passer l\'appel')),
      );
    }
  }

  Future<void> _openWhatsApp(BuildContext context, String phone) async {
    final cleaned = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('https://wa.me/$cleaned');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('WhatsApp non disponible')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as ProductModel;
    final phone = product.phone.isNotEmpty ? product.phone : '+224620000000';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7ED),
      body: CustomScrollView(
        slivers: [
          // Image header
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(product.imageUrl, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(color: const Color(0xFFE8EDE2))),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0x99000000)],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16, left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: product.status?.toLowerCase() == 'sold'
                            ? const Color(0xFFFF8A00) : AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        product.status == 'Sold' ? 'Vendu' : 'Disponible',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + price
                  Text(product.name,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF1F2420))),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('${_fmt(product.price)} GNF',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.primary)),
                  ),
                  const SizedBox(height: 20),
                  // Info cards
                  Row(
                    children: [
                      Expanded(child: _InfoTile(icon: Icons.inventory_2, label: 'Quantité', value: '${product.quantity} Kg')),
                      const SizedBox(width: 12),
                      Expanded(child: _InfoTile(icon: Icons.location_on, label: 'Lieu',
                          value: product.location.isNotEmpty ? product.location : 'Labé')),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Description
                  const Text('Description', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8DF)),
                    ),
                    child: Text(
                      product.description?.isNotEmpty == true ? product.description! : 'Produit frais de la région de Labé, cultivé avec soin par nos producteurs locaux.',
                      style: const TextStyle(fontSize: 16, height: 1.5, color: Color(0xFF3F4A3E)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Producer info
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8DF)),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          backgroundColor: AppColors.primary,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Producteur local', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 2),
                              Text(phone, style: const TextStyle(color: Color(0xFF7C8579), fontSize: 14)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC7F2BB),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('Vérifié', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF115D1A))),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Contact buttons
                  const Text('Contacter le producteur', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 60,
                          child: ElevatedButton.icon(
                            onPressed: () => _callPhone(context, phone),
                            icon: const Icon(Icons.phone, size: 22),
                            label: const Text('Appeler', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 4,
                              shadowColor: AppColors.primary.withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 60,
                          child: ElevatedButton.icon(
                            onPressed: () => _openWhatsApp(context, phone),
                            icon: const Icon(Icons.chat, size: 22),
                            label: const Text('WhatsApp', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF25D366),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 4,
                              shadowColor: const Color(0xFF25D366).withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8DF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF7C8579))),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
