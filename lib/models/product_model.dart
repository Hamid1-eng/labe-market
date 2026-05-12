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
    'createdAt': createdAt.toIso8601String(),
    'userId': userId,
  };
}
