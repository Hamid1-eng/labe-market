import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show consolidateHttpClientResponseBytes;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';

/// Télécharge des images publiques, téléverse vers Firebase Storage
/// et crée des documents produit dans Firestore.
Future<void> seedSampleProducts(BuildContext context) async {
  final List<Map<String, dynamic>> samples = [
    {
      'name': 'Organic Bell Peppers',
      'description':
          'Premium quality peppers harvested daily from the fertile highlands of...',
      'price': 45000,
      'quantity': 10,
      'status': 'Available',
      'seed': 'pepper',
    },
    {
      'name': 'Fonio Grains (5kg)',
      'description':
          'Triple-washed premium fonio. Perfect for traditional dishes and health-conscious cooks.',
      'price': 120000,
      'quantity': 5,
      'status': 'Sold',
      'seed': 'fonio',
    },
    {
      'name': 'Highland Wild Honey',
      'description':
          'Pure, unpasteurized honey collected from the wild blossoms of the Fouta...',
      'price': 85000,
      'quantity': 3,
      'status': 'Available',
      'seed': 'honey',
    },
    {
      'name': 'Arabica Coffee Beans',
      'description':
          'Sun-dried and expertly sorted Arabica beans from our community farms.',
      'price': 150000,
      'quantity': 8,
      'status': 'Available',
      'seed': 'coffee',
    },
  ];

  final fire = FirestoreService();
  final storage = StorageService();

  for (final s in samples) {
    try {
      // Build a picsum URL with a seed so images are consistent
      final seed = s['seed'] as String;
      final imageUrl = 'https://picsum.photos/seed/$seed/1200/900';

      // Download image bytes
      final bytes = await _downloadBytes(Uri.parse(imageUrl));
      if (bytes == null) continue;

      // Write to a temporary file
      final tmpDir = Directory.systemTemp;
      final tmp = await tmpDir.createTemp('seed_');
      final file = File('${tmp.path}/$seed.jpg');
      await file.writeAsBytes(bytes);

      // Upload to Firebase Storage
      final path = 'seeds/$seed-${DateTime.now().millisecondsSinceEpoch}.jpg';
      final uploadedUrl = await storage.uploadFile(file, path);

      if (uploadedUrl == null) continue;

      // Create product document
      final data = <String, dynamic>{
        'name': s['name'],
        'description': s['description'],
        'price': s['price'],
        'quantity': s['quantity'],
        'status': s['status'],
        'imageUrl': uploadedUrl,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await fire.addProduct(data);

      // Clean up temp file
      try {
        await file.delete();
        await tmp.delete();
      } catch (_) {}
    } catch (e) {
      // ignore errors for individual items
    }
  }
}

Future<List<int>?> _downloadBytes(Uri uri) async {
  try {
    final client = HttpClient();
    final request = await client.getUrl(uri);
    final response = await request.close();
    if (response.statusCode == 200) {
      final bytes = await consolidateHttpClientResponseBytes(response);
      client.close(force: true);
      return bytes;
    }
    client.close(force: true);
  } catch (_) {}
  return null;
}

// helper imported at top
