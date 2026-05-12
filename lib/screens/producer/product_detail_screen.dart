import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';
import '../../core/constants/colors.dart';
import '../../providers/product_provider.dart';
import '../../widgets/producer_bottom_nav.dart';

class ProducerProductDetail extends StatelessWidget {
  const ProducerProductDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as ProductModel;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Image.network(
                  product.imageUrl,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Chip(
                    backgroundColor: const Color(0xFFFFA726),
                    label: const Text('Qualité premium'),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      _InfoBox(
                        label: 'Prix / Kg',
                        value: '${product.price} GNF',
                      ),
                      _InfoBox(
                        label: 'Disponible',
                        value: '${product.quantity} Kg',
                      ),
                      _InfoBox(label: 'Commande min', value: '10 Kg'),
                      _InfoBox(label: 'Récolté', value: 'Il y a 2 jours'),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Description du produit',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.toJson()['description'] ??
                        'Aucune description fournie.',
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      '/producer/add',
                      arguments: product,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text('Modifier l\'annonce'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      final provider = context.read<ProductProvider>();
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Supprimer ce produit ?'),
                          content: const Text('Cette action est irréversible.'),
                          actions: [
                            TextButton(
                              onPressed: () => navigator.pop(false),
                              child: const Text('Annuler'),
                            ),
                            TextButton(
                              onPressed: () => navigator.pop(true),
                              child: const Text('Supprimer'),
                            ),
                          ],
                        ),
                      );
                      if (confirmed != true) return;
                      await provider.delete(product.id);
                      if (!context.mounted) return;
                      Navigator.pushReplacementNamed(
                        context,
                        '/producer/products',
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: const Text('Supprimer le produit'),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F2A2A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: const [
                        Text(
                          'Analyse du marché',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
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
      bottomNavigationBar: const ProducerBottomNav(currentIndex: 1),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String label;
  final String value;

  const _InfoBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 64) / 2,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6F3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
