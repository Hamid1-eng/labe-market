import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../providers/product_provider.dart';
import '../../models/product_model.dart';
import '../../widgets/buyer_bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loading = true;
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();

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
    final prov = Provider.of<ProductProvider>(context, listen: false);
    try {
      final auth = FirebaseAuth.instance;
      if (auth.currentUser == null) await auth.signInAnonymously();
    } catch (_) {}
    try {
      await prov.load();
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  List<ProductModel> _filtered(List<ProductModel> all) {
    if (_searchQuery.isEmpty) return all;
    final q = _searchQuery.toLowerCase();
    return all.where((p) =>
        p.name.toLowerCase().contains(q) ||
        p.location.toLowerCase().contains(q)).toList();
  }

  String _fmt(int price) {
    final s = price.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ProductProvider>(context);
    final products = _filtered(prov.items);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7ED),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Labé Market',
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.primary)),
                        SizedBox(height: 4),
                        Text('Produits frais de la région',
                            style: TextStyle(fontSize: 15, color: Color(0xFF5A6358))),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F0D6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.location_on, size: 16, color: AppColors.primary),
                        SizedBox(width: 4),
                        Text('Labé', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [BoxShadow(color: Color(0x0F000000), blurRadius: 12, offset: Offset(0, 4))],
                ),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Rechercher un produit...',
                    hintStyle: const TextStyle(color: Color(0xFF9CA39A), fontSize: 16),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF7B8475)),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () {
                            _searchCtrl.clear();
                            setState(() => _searchQuery = '');
                          })
                        : null,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            // Count + offline
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${products.length} produit${products.length > 1 ? 's' : ''}',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF4A5644))),
                  if (prov.permissionDenied)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFFFF3E0), borderRadius: BorderRadius.circular(8)),
                      child: const Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.cloud_off, size: 14, color: Color(0xFFE65100)),
                        SizedBox(width: 4),
                        Text('Mode local', style: TextStyle(fontSize: 11, color: Color(0xFFE65100), fontWeight: FontWeight.w600)),
                      ]),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Grid
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : products.isEmpty
                      ? const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                          Icon(Icons.inventory_2_outlined, size: 56, color: Color(0xFFB0B8AD)),
                          SizedBox(height: 12),
                          Text('Aucun produit trouvé', style: TextStyle(fontSize: 18, color: Color(0xFF7C8579))),
                        ]))
                      : RefreshIndicator(
                          onRefresh: _load,
                          color: AppColors.primary,
                          child: GridView.builder(
                            padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, mainAxisSpacing: 14, crossAxisSpacing: 14, childAspectRatio: 0.68),
                            itemCount: products.length,
                            itemBuilder: (ctx, i) {
                              final p = products[i];
                              return GestureDetector(
                                onTap: () => Navigator.pushNamed(ctx, '/product/detail', arguments: p),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 10, offset: Offset(0, 4))],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                          child: Image.network(p.imageUrl, fit: BoxFit.cover, width: double.infinity,
                                              errorBuilder: (_, __, ___) => Container(color: const Color(0xFFE8EDE2),
                                                  child: const Center(child: Icon(Icons.image, size: 40, color: Color(0xFFB0B8AD))))),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                            Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                                            const SizedBox(height: 4),
                                            Text('${_fmt(p.price)} GNF',
                                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary)),
                                            const Spacer(),
                                            Row(children: [
                                              const Icon(Icons.location_on_outlined, size: 13, color: Color(0xFF8B9287)),
                                              const SizedBox(width: 3),
                                              Expanded(child: Text(p.location.isNotEmpty ? p.location : 'Labé',
                                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(fontSize: 12, color: Color(0xFF8B9287)))),
                                            ]),
                                          ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BuyerBottomNav(currentIndex: 0),
    );
  }
}
