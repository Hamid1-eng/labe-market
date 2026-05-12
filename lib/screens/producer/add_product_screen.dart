import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../models/product_model.dart';
import '../../services/storage_service.dart';
import '../../providers/product_provider.dart';
import '../../widgets/producer_bottom_nav.dart';

class ProducerAddProduct extends StatefulWidget {
  const ProducerAddProduct({super.key});

  @override
  State<ProducerAddProduct> createState() => _ProducerAddProductState();
}

class _ProducerAddProductState extends State<ProducerAddProduct> {
  final _name = TextEditingController();
  final _price = TextEditingController();
  final _quantity = TextEditingController();
  final _location = TextEditingController(text: 'Centre de Labé');
  String imageUrl = '';
  final ImagePicker _picker = ImagePicker();
  final StorageService _storage = StorageService();
  bool _uploading = false;
  bool _saving = false;
  bool _offlineSmsSync = true;
  ProductModel? _editingProduct;
  bool _initialized = false;

  static const String _fallbackImage =
      'https://images.unsplash.com/photo-1542838132-92c53300491e?w=1200';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is ProductModel) {
      _editingProduct = args;
      _name.text = args.name;
      _price.text = args.price.toString();
      _quantity.text = args.quantity.toString();
      _location.text = args.location;
      imageUrl = args.imageUrl;
    }
    _initialized = true;
  }

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    _quantity.dispose();
    _location.dispose();
    super.dispose();
  }

  Future<void> _pickAndUpload() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
    );
    if (file == null) return;
    setState(() => _uploading = true);
    final local = File(file.path);
    final path = 'products/${DateTime.now().millisecondsSinceEpoch}.jpg';
    try {
      final url = await _storage.uploadFile(local, path);
      if (url != null) setState(() => imageUrl = url);
    } catch (e) {
      // ignore upload errors for now
    } finally {
      setState(() => _uploading = false);
    }
  }

  Future<void> _saveProduct() async {
    if (_uploading || _saving) return;

    final name = _name.text.trim();
    final location = _location.text.trim();
    final price = int.tryParse(_price.text.replaceAll(',', '').trim());
    final quantity = int.tryParse(_quantity.text.trim());

    if (name.isEmpty || location.isEmpty || price == null || quantity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir correctement tous les champs.'),
        ),
      );
      return;
    }

    setState(() => _saving = true);
    final navigator = Navigator.of(context);

    try {
      // Ensure authenticated for Firestore access
      try {
        final auth = FirebaseAuth.instance;
        if (auth.currentUser == null) {
          await auth.signInAnonymously();
        }
      } catch (_) {}

      final provider = Provider.of<ProductProvider>(context, listen: false);
      final prod = ProductModel(
        id:
            _editingProduct?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        price: price,
        quantity: quantity,
        location: location,
        phone: _editingProduct?.phone ?? '+224 620 00 00 00',
        imageUrl: imageUrl.isEmpty ? _fallbackImage : imageUrl,
        createdAt: _editingProduct?.createdAt ?? DateTime.now(),
        userId: _editingProduct?.userId ?? 'me',
      );

      if (_editingProduct == null) {
        await provider.add(prod);
      } else {
        await provider.update(prod);
      }

      if (!mounted) return;
      navigator.pushReplacementNamed('/producer/products');
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Échec de publication. Réessayez.')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final previewName = _name.text.trim().isEmpty
        ? 'Titre de l\'annonce'
        : _name.text.trim();
    final previewLocation = _location.text.trim().isEmpty
        ? 'Labé, Guinée'
        : _location.text.trim();

    return Scaffold(
      backgroundColor: const Color(0xFFF1F2F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1F2F7),
        elevation: 0,
        foregroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF7EFD9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.portable_wifi_off,
                    size: 18,
                    color: Color(0xFFB56D00),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Hors ligne. Vos actions seront synchronisées dès la reconnexion.',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Détails du produit',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: _pickAndUpload,
              child: Container(
                height: 170,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFB7C7AE),
                    style: BorderStyle.solid,
                  ),
                  color: const Color(0xFFEDEDF2),
                ),
                child: _uploading
                    ? const Center(child: CircularProgressIndicator())
                    : imageUrl.isEmpty
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              _fallbackImage,
                              fit: BoxFit.cover,
                              color: Colors.white70,
                              colorBlendMode: BlendMode.lighten,
                            ),
                          ),
                          const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.add_a_photo_outlined,
                                  size: 36,
                                  color: AppColors.primary,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Touchez pour importer une image',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(imageUrl, fit: BoxFit.cover),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Nom du produit',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _name,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: 'ex: Oignons de Labé',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Prix (GNF)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _price,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: '50,000',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            const Text(
              'Quantité (kg/unités)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _quantity,
              decoration: const InputDecoration(
                hintText: '100 kg',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            const Text(
              'Localisation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _location,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: 'Centre de Labé',
                suffixIcon: Icon(Icons.my_location, color: AppColors.primary),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Téléphone de contact (automatique)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
              decoration: BoxDecoration(
                color: const Color(0xFFE8EDF7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.phone, color: Color(0xFF6A737A)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '+224 620 00 00 00',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Icon(Icons.settings, color: AppColors.primary),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFDDE8FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Synchronisation SMS hors ligne',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Publier via SMS si internet échoue',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _offlineSmsSync,
                    onChanged: (v) => setState(() => _offlineSmsSync = v),
                    activeThumbColor: AppColors.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Aperçu du marché',
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E7DE)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(14),
                    ),
                    child: Stack(
                      children: [
                        Image.network(
                          imageUrl.isEmpty ? _fallbackImage : imageUrl,
                          height: 240,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          right: 12,
                          bottom: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'Prix en attente',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          previewName,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '📍 $previewLocation',
                          style: const TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 10),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              '• Aperçu en direct',
                              style: TextStyle(color: Colors.black54),
                            ),
                            Text(
                              'Saliou Diallo',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: (_uploading || _saving) ? null : _saveProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF8A00),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: _saving
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.6,
                          color: Colors.black,
                        ),
                      )
                    : Text(
                        _editingProduct == null
                            ? 'Publier le produit'
                            : 'Enregistrer le produit',
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'En publiant, vous acceptez nos conditions du marché.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 14),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.volume_up, color: Colors.white),
      ),
      bottomNavigationBar: const ProducerBottomNav(currentIndex: 2),
    );
  }
}
