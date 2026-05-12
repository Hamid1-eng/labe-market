import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/product_provider.dart';
import '../../services/auth_service.dart';
import '../../widgets/producer_bottom_nav.dart';

class ProducerProfileScreen extends StatelessWidget {
  const ProducerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final products = context.watch<ProductProvider>().items;
    final user = auth.user;
    final sellerName = user?.name ?? 'Saliou Diallo';
    final sellerPhone = user?.phone.isNotEmpty == true
        ? user!.phone
        : 'Labé Producteur';
    final soldCount = (products.length * 31).toString();
    const avgRating = '4.9';

    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F3F8),
        elevation: 0,
        foregroundColor: const Color(0xFFCBD4C8),
        title: const Row(
          children: [
            Icon(Icons.location_on_outlined, size: 18),
            SizedBox(width: 6),
            Text('Labé Market', style: TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 14),
            child: Icon(Icons.visibility_off_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8DF)),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=300',
                        ),
                      ),
                      Positioned(
                        right: 2,
                        bottom: 2,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.settings,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    sellerName,
                    style: const TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$sellerPhone • Niveau 4',
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC7F2BB),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      'Producteur local vérifié',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF115D1A),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Divider(),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _Metric(value: soldCount, label: 'Produits vendus'),
                      _Metric(value: avgRating, label: 'Note moyenne'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _BlockCard(
              title: 'À propos',
              trailing: const Icon(Icons.edit, color: AppColors.primary),
              child: const Text(
                'Spécialisé dans les agrumes bio et le café d\'altitude du Fouta Djallon. Je fournis des récoltes premium depuis plus de 15 ans avec des pratiques durables.',
                style: TextStyle(height: 1.45, color: Color(0xFF3D434A)),
              ),
            ),
            const SizedBox(height: 14),
            _BlockCard(
              title: 'Performance du marché',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Top 5% des vendeurs ce mois-ci dans la catégorie agrumes.',
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: 0.86,
                      minHeight: 7,
                      backgroundColor: const Color(0xFFA7B6A2),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.volume_up, color: AppColors.primary),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Profil audio',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Écouter la présentation en Pular',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Avis des acheteurs',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                Text(
                  'Voir tout (42)',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const _ReviewCard(
              name: 'Mariama B.',
              review:
                  'Les oranges étaient très fraîches et livrées à temps. Saliou est très professionnel.',
              avatarUrl:
                  'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=300',
            ),
            const SizedBox(height: 10),
            const _ReviewCard(
              name: 'Ibrahima S.',
              review:
                  'Excellente qualité de café. Idéal pour les commandes en gros.',
              avatarUrl:
                  'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=300',
            ),
            const SizedBox(height: 10),
            const _ReviewCard(
              name: 'Aissatou T.',
              review:
                  'Le meilleur producteur de la région. Qualité toujours régulière.',
              avatarUrl:
                  'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=300',
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.settings),
                label: const Text('Paramètres du compte'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFD5E0F6),
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () async {
                  await AuthService().signOut();
                  if (!context.mounted) return;
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text('Se déconnecter'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFF2D2CC),
                  foregroundColor: const Color(0xFF8A120E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const ProducerBottomNav(currentIndex: 3),
    );
  }
}

class _Metric extends StatelessWidget {
  final String value;
  final String label;

  const _Metric({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.black54, fontSize: 12),
        ),
      ],
    );
  }
}

class _BlockCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  const _BlockCard({required this.title, required this.child, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E5D9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                ),
              ),
              trailing ?? const SizedBox.shrink(),
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final String name;
  final String review;
  final String avatarUrl;

  const _ReviewCard({
    required this.name,
    required this.review,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E5D9)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 20, backgroundImage: NetworkImage(avatarUrl)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
                const Text('☆☆☆☆☆', style: TextStyle(color: Color(0xFFD37A00))),
                const SizedBox(height: 4),
                Text(
                  review,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
