import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get productsRef => _db.collection('products');

  Future<DocumentReference> addProduct(Map<String, dynamic> data) async {
    final doc = await productsRef.add(data);
    return doc;
  }

  Future<void> updateProduct(String id, Map<String, dynamic> data) async {
    await productsRef.doc(id).update(data);
  }

  Future<void> deleteProduct(String id) async {
    await productsRef.doc(id).delete();
  }

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    final snap = await productsRef.orderBy('createdAt', descending: true).get();
    return snap.docs
        .map((d) => {...d.data() as Map<String, dynamic>, 'id': d.id})
        .toList();
  }
}
