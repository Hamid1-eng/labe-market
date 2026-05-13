import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

class ProductModel {
  final String id;
  final String name;
  final int price;
  final int quantity;
  final String location;
  final String phone;
  final String? description;
  final String? status;
  final String imageUrl;
  final String? category;
  final double? rating;
  final String? unitLabel;
  final String? producerName;
  final String? producerAvatar;
  final bool verified;
  final DateTime createdAt;
  final String userId;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.location,
    required this.phone,
    this.description,
    this.status,
    required this.imageUrl,
    this.category,
    this.rating,
    this.unitLabel,
    this.producerName,
    this.producerAvatar,
    this.verified = false,
    required this.createdAt,
    required this.userId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json['id'] as String? ?? '',
    name: json['name'] as String? ?? '',
    price: (() {
      final v = json['price'];
      if (v is int) return v;
      if (v is double) return v.toInt();
      if (v is String) return int.tryParse(v.replaceAll(',', '')) ?? 0;
      return 0;
    })(),
    quantity: (() {
      final v = json['quantity'];
      if (v is int) return v;
      if (v is double) return v.toInt();
      if (v is String) return int.tryParse(v.replaceAll(',', '')) ?? 0;
      return 0;
    })(),
    location: json['location'] as String? ?? '',
    phone: json['phone'] as String? ?? '',
    description: json['description'] as String? ?? '',
    status: json['status'] as String? ?? 'Available',
    imageUrl: json['imageUrl'] as String? ?? '',
    category: json['category'] as String? ?? '',
    rating: (() {
      final v = json['rating'];
      if (v is double) return v;
      if (v is int) return v.toDouble();
      if (v is String) return double.tryParse(v.replaceAll(',', '.'));
      return null;
    })(),
    unitLabel: json['unitLabel'] as String? ?? '',
    producerName: json['producerName'] as String? ?? '',
    producerAvatar: json['producerAvatar'] as String? ?? '',
    verified: json['verified'] as bool? ?? false,
    createdAt: (() {
      final v = json['createdAt'];
      if (v is Timestamp) return v.toDate();
      if (v is String) return DateTime.tryParse(v) ?? DateTime.now();
      if (v is DateTime) return v;
      return DateTime.now();
    })(),
    userId: json['userId'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'quantity': quantity,
    'description': description,
    'status': status,
    'location': location,
    'phone': phone,
    'imageUrl': imageUrl,
    'category': category,
    'rating': rating,
    'unitLabel': unitLabel,
    'producerName': producerName,
    'producerAvatar': producerAvatar,
    'verified': verified,
    'createdAt': createdAt.toIso8601String(),
    'userId': userId,
  };
}
