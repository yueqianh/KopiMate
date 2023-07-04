import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kopimate/models/shop.dart';
import 'package:flutter/cupertino.dart';

class ShopModel extends ChangeNotifier {
  List<Shop> shops = [];

  Future<void> fetchShops() async {
    // Get the collection 'shops' (QuerySnapshot) from Firestore and assign it to docs.
    final docs = await FirebaseFirestore.instance.collection('shops').get();

    // getter docs: Extract all documents of docs (List<QueryDocumentSnapshot<T>> type) as a list
    // map(): Convert each element of List to Shops
    // toList(): Convert from Iterable to List returned from Map().
    final shops = docs.docs.map((doc) => Shop(doc)).toList();
    this.shops = shops;
    notifyListeners();
  }
}