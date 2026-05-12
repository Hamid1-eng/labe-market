import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import '../../core/constants/colors.dart';
import '../../providers/product_provider.dart';
import '../../widgets/producer_bottom_nav.dart';
import '../../tools/image_seeder.dart';

class MyProductsScreen extends StatefulWidget {
  const MyProductsScreen({super.key});

  @override
  State<MyProductsScreen> createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<ProductProvider>(context, listen: false);
      try {
        // Try anonymous sign-in if not authenticated. This helps when Firestore
        // rules allow reads for authenticated users only.
        try {
          final auth = FirebaseAuth.instance;
          if (auth.currentUser == null) {
            await auth.signInAnonymously();
          }
        } catch (_) {}

        await provider.load();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur lors du chargement des produits: $e'),
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _loading = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final products = provider.items;

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Products', style: TextStyle(fontWeight: FontWeight.w800)),
            SizedBox(height: 2),
            Text(
              'Manage your marketplace inventory and listings.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          if (kDebugMode)
            IconButton(
              tooltip: 'Seed sample products',
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                messenger.showSnackBar(
                  const SnackBar(content: Text('Seeding images...')),
                );
                await seedSampleProducts(context);
                if (!mounted) return;
                await provider.load();
                messenger.showSnackBar(
                  const SnackBar(content: Text('Seeding terminé')),
                );
              },
              icon: const Icon(Icons.cloud_download_outlined),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: provider.load,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                itemCount: products.length,
                separatorBuilder: (_, __) => const SizedBox(height: 18),
                itemBuilder: (c, i) {
                  final p = products[i];
                  // if permissions were denied, show a small banner only once
                  if (i == 0 && provider.permissionDenied) {
                    return Column(
                      children: [
                        Container(
                          width: double.infinity,
                          color: Colors.orange[800],
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.warning, color: Colors.white),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  'Affichage en mode local: permissions Firestore manquantes.',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  // retry loading from Firestore
                                  try {
                                    await provider.load();
                                  } catch (_) {}
                                },
                                child: const Text(
                                  'Réessayer',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    );
                  }
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(14),
                              ),
                              child: p.imageUrl.isNotEmpty
                                  ? Image.network(
                                      p.imageUrl,
                                      height: 220,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    )
                                  : Container(
                                      height: 220,
                                      color: Colors.grey[200],
                                    ),
                            ),
                            Positioned(
                              right: 12,
                              top: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: p.status?.toLowerCase() == 'sold'
                                      ? Colors.orange
                                      : Colors.green,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  p.status ?? 'Available',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          p.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          p.description ?? '',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8FFF0),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          '${p.price}',
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        const Text(
                                          'GNF',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () => Navigator.pushNamed(
                                        context,
                                        '/producer/detail',
                                        arguments: p,
                                      ),
                                      icon: const Icon(Icons.edit, size: 18),
                                      label: const Text('Edit'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFFF0F6FF,
                                        ),
                                        foregroundColor: Colors.black,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  InkWell(
                                    onTap: () async {
                                      final ok = await showDialog<bool>(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text('Supprimer'),
                                          content: const Text(
                                            'Voulez-vous supprimer ce produit ?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(ctx, false),
                                              child: const Text('Annuler'),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(ctx, true),
                                              child: const Text('Supprimer'),
                                            ),
                                          ],
                                        ),
                                      );
                                      if (ok == true) {
                                        await provider.delete(p.id);
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFF5F6),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.redAccent,
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
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/producer/add'),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const ProducerBottomNav(currentIndex: 1),
    );
  }
}
