import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../providers/product_provider.dart';
import '../../widgets/producer_bottom_nav.dart';

class ProducerDashboard extends StatefulWidget {
  final String userName;

  const ProducerDashboard({super.key, this.userName = 'Saliou Diallo'});

  @override
  State<ProducerDashboard> createState() => _ProducerDashboardState();
}

class _ProducerDashboardState extends State<ProducerDashboard> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Ensure authenticated for Firestore access
      try {
        final auth = FirebaseAuth.instance;
        if (auth.currentUser == null) {
          await auth.signInAnonymously();
        }
      } catch (_) {}
      final provider = Provider.of<ProductProvider>(context, listen: false);
      await provider.load();
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final sampleProducts = provider.items;
    final published = sampleProducts.length;
    final sold = published * 5; // dummy
    final rating = 4.9;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.primary,
        title: const Text(''),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bonjour,',
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.userName,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: sampleProducts.isNotEmpty
                        ? NetworkImage(sampleProducts.first.imageUrl)
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _StatCard(
                title: 'Produits publiés',
                value: '$published',
                icon: Icons.archive,
                color: const Color(0xFFBEECC6),
              ),
              const SizedBox(height: 12),
              _StatCard(
                title: 'Produits vendus',
                value: '$sold',
                icon: Icons.shopping_bag,
                color: const Color(0xFFFFE0C9),
              ),
              const SizedBox(height: 12),
              _StatCard(
                title: 'Note/Fiabilité',
                value: '$rating/5',
                icon: Icons.star,
                color: const Color(0xFFFFE0F0),
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 180,
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: sampleProducts.length,
                        itemBuilder: (c, i) {
                          final p = sampleProducts[i];
                          return Container(
                            width: 160,
                            margin: const EdgeInsets.only(
                              right: 12,
                              top: 8,
                              bottom: 8,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    p.imageUrl,
                                    height: 110,
                                    width: 160,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  p.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '+12%',
                                  style: const TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const ProducerBottomNav(currentIndex: 0),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color,
            child: Icon(icon, color: Colors.black87),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.black54)),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
