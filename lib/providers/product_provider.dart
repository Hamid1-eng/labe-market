import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
import '../services/firestore_service.dart';

class ProductProvider extends ChangeNotifier {
  final List<ProductModel> _items = [];
  final Set<String> _favoriteIds = <String>{};
  final FirestoreService _fire = FirestoreService();
  bool _permissionDenied = false;

  bool get permissionDenied => _permissionDenied;

  List<ProductModel> get items => List.unmodifiable(_items);

  List<ProductModel> get favoriteItems => _items
      .where((item) => _favoriteIds.contains(item.id))
      .toList(growable: false);

  // Pour compatibilité avec le screen acheteur
  List<dynamic> get products {
    return _items
        .map(
          (item) => {
            'id': item.id,
            'name': item.name,
            'price': item.price,
            'quantity': item.quantity,
            'location': item.location,
            'phone': item.phone,
            'imageUrl': item.imageUrl,
            'rating': '4.8', // À adapter selon vos besoins
          },
        )
        .toList();
  }

  Future<void> fetchProducts() async {
    await load();
  }

  Future<void> load() async {
    try {
      final data = await _fire.fetchProducts();
      _items.clear();
      _items.addAll(data.map((d) => ProductModel.fromJson(d)));
      _permissionDenied = false;
      if (_items.isNotEmpty && _favoriteIds.isEmpty) {
        _favoriteIds.addAll(_items.take(3).map((e) => e.id));
      }
      notifyListeners();
    } catch (e) {
      // If permissions prevent reading Firestore, fallback to local samples
      final msg = e.toString().toLowerCase();
      if (msg.contains('permission-denied') || msg.contains('permission')) {
        _permissionDenied = true;
        _items.clear();
        _populateLocalSamples();
        _favoriteIds
          ..clear()
          ..addAll(_items.take(3).map((e) => e.id));
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
        'name': 'Tomates Fraîches',
        'price': 15000,
        'quantity': 50,
        'location': 'Labé, quartier Tata',
        'phone': '+224622111111',
        'category': 'LÉGUMES',
        'imageUrl':
            'https://images.unsplash.com/photo-1592924357228-91a4daadcccf?w=400&h=300&fit=crop',
        'description': 'Tomates rouges fraîches de première qualité',
        'status': 'Available',
        'rating': 4.8,
        'unitLabel': 'kg',
        'producerName': 'Diallo Agri',
        'producerAvatar':
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&h=400&fit=crop',
        'verified': true,
      },
      {
        'id': 'local-2',
        'name': 'Miel Pur Artisanal',
        'price': 85000,
        'quantity': 10,
        'location': 'Labé, centre-ville',
        'phone': '+224622222222',
        'category': 'PRODUIT ARTISANAL',
        'imageUrl':
            'https://images.unsplash.com/photo-1587049352847-4d4b1f6d3a87?w=400&h=300&fit=crop',
        'description': 'Miel pur non transformé',
        'status': 'Available',
        'rating': 4.9,
        'unitLabel': 'L',
        'producerName': 'Vendeur Certifié',
        'producerAvatar':
            'https://images.unsplash.com/photo-1521119989659-a83eee488004?w=400&h=400&fit=crop',
        'verified': true,
      },
      {
        'id': 'local-3',
        'name': 'Pommes de Terre',
        'price': 12000,
        'quantity': 100,
        'location': 'Timbi Madina',
        'phone': '+224622333333',
        'category': 'FÉCULENTS',
        'imageUrl':
            'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=400&h=300&fit=crop',
        'description': 'Pommes de terre fraîchement récoltées',
        'status': 'Available',
        'rating': 4.5,
        'unitLabel': 'kg',
        'producerName': 'Coopérative Timbi',
        'producerAvatar':
            'https://images.unsplash.com/photo-1544723795-3fb6469f5b39?w=400&h=400&fit=crop',
        'verified': true,
      },
      {
        'id': 'local-4',
        'name': 'Oignons Rouges',
        'price': 18000,
        'quantity': 80,
        'location': 'Labé, quartier Kégnéko',
        'phone': '+224622444444',
        'category': 'LÉGUMES',
        'imageUrl':
            'https://images.unsplash.com/photo-1599599810694-b5ac4dd64b73?w=400&h=300&fit=crop',
        'description': 'Oignons rouges de qualité supérieure',
        'status': 'Available',
        'rating': 4.7,
        'unitLabel': 'sac',
        'producerName': 'Moussa Bah',
        'producerAvatar':
            'https://images.unsplash.com/photo-1504593811423-6dd665756598?w=400&h=400&fit=crop',
        'verified': false,
      },
      {
        'id': 'local-5',
        'name': 'Carottes Biologiques',
        'price': 16000,
        'quantity': 60,
        'location': 'Labé, quartier Tata',
        'phone': '+224622555555',
        'category': 'LÉGUMES',
        'imageUrl':
            'https://images.unsplash.com/photo-1598103442097-8b74394b95c6?w=400&h=300&fit=crop',
        'description': 'Carottes fraîches biologiques',
        'status': 'Available',
        'rating': 4.6,
        'unitLabel': 'botte',
        'producerName': 'Alpha Oumar',
        'producerAvatar':
            'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400&h=400&fit=crop',
        'verified': true,
      },
      {
        'id': 'local-6',
        'name': 'Riz Local Premium',
        'price': 250000,
        'quantity': 40,
        'location': 'Dalaba, Cooperative',
        'phone': '+224622666666',
        'category': 'CÉRÉALES',
        'imageUrl':
            'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=1200&h=900&fit=crop',
        'description': 'Riz local de qualité premium',
        'status': 'Available',
        'rating': 5.0,
        'unitLabel': 'sac 50kg',
        'producerName': 'Coopérative Dalaba',
        'producerAvatar':
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&h=400&fit=crop',
        'verified': true,
      },
    ];

    for (final s in samples) {
      _items.add(
        ProductModel(
          id: s['id'] as String,
          name: s['name'] as String,
          price: s['price'] as int,
          quantity: s['quantity'] as int,
          location: s['location'] as String,
          phone: s['phone'] as String,
          description: s['description'] as String?,
          status: s['status'] as String?,
          imageUrl: s['imageUrl'] as String,
          category: s['category'] as String?,
          rating: (s['rating'] as num?)?.toDouble(),
          unitLabel: s['unitLabel'] as String?,
          producerName: s['producerName'] as String?,
          producerAvatar: s['producerAvatar'] as String?,
          verified: s['verified'] as bool? ?? false,
          createdAt: now,
          userId: 'local',
        ),
      );
    }
  }

  bool isFavorite(String id) => _favoriteIds.contains(id);

  void toggleFavorite(String id) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    notifyListeners();
  }

  ProductModel? byId(String id) {
    for (final item in _items) {
      if (item.id == id) return item;
    }
    return null;
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
