import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
import '../services/firestore_service.dart';

class ProductProvider extends ChangeNotifier {
  final List<ProductModel> _items = [];
  final FirestoreService _fire = FirestoreService();
  bool _permissionDenied = false;

  bool get permissionDenied => _permissionDenied;

  List<ProductModel> get items => List.unmodifiable(_items);

  Future<void> load() async {
    try {
      final data = await _fire.fetchProducts();
      _items.clear();
      _items.addAll(data.map((d) => ProductModel.fromJson(d)));
      _permissionDenied = false;
      notifyListeners();
    } catch (e) {
      // If permissions prevent reading Firestore, fallback to local samples
      final msg = e.toString().toLowerCase();
      if (msg.contains('permission-denied') || msg.contains('permission')) {
        _permissionDenied = true;
        _items.clear();
        _populateLocalSamples();
        notifyListeners();
        return;
      }
      rethrow;
    }
  }

  void _populateLocalSamples() {
    final now = DateTime.now();
    final samples = [
      {
        'id': 'local-1',
        'name': 'Organic Bell Peppers',
        'price': 45000,
        'quantity': 10,
        'imageUrl': 'https://picsum.photos/seed/pepper/1200/900',
        'description': 'Premium quality peppers harvested daily...',
        'status': 'Available',
      },
      {
        'id': 'local-2',
        'name': 'Fonio Grains (5kg)',
        'price': 120000,
        'quantity': 5,
        'imageUrl': 'https://picsum.photos/seed/fonio/1200/900',
        'description': 'Triple-washed premium fonio.',
        'status': 'Sold',
      },
      {
        'id': 'local-3',
        'name': 'Highland Wild Honey',
        'price': 85000,
        'quantity': 3,
        'imageUrl': 'https://picsum.photos/seed/honey/1200/900',
        'description': 'Pure, unpasteurized honey.',
        'status': 'Available',
      },
    ];

    for (final s in samples) {
      _items.add(
        ProductModel(
          id: s['id'] as String,
          name: s['name'] as String,
          price: s['price'] as int,
          quantity: s['quantity'] as int,
          location: '',
          phone: '',
          description: s['description'] as String?,
          status: s['status'] as String?,
          imageUrl: s['imageUrl'] as String,
          createdAt: now,
          userId: 'local',
        ),
      );
    }
  }

  Future<void> add(ProductModel p) async {
    final map = p.toJson();
    map['createdAt'] = FieldValue.serverTimestamp();
    final doc = await _fire.addProduct(map);
    final created = {...map, 'id': doc.id};
    _items.insert(0, ProductModel.fromJson(created));
    notifyListeners();
  }

  Future<void> update(ProductModel p) async {
    final map = p.toJson();
    await _fire.updateProduct(p.id, map);
    final idx = _items.indexWhere((e) => e.id == p.id);
    if (idx != -1) {
      _items[idx] = p;
      notifyListeners();
    }
  }

  Future<void> delete(String id) async {
    await _fire.deleteProduct(id);
    _items.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}
