import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kopimate/models/shop.dart';
import 'package:flutter/cupertino.dart';

class ShopModel extends ChangeNotifier {
  List<Shop> shops = [];

  Future<void> fetchShops() async {
    // Firestoreからコレクション'books'(QuerySnapshot)を取得してdocsに代入。
    final docs = await FirebaseFirestore.instance.collection('shops').get();

    // getter docs: docs(List<QueryDocumentSnapshot<T>>型)のドキュメント全てをリストにして取り出す。
    // map(): Listの各要素をBookに変換
    // toList(): Map()から返ってきたIterable→Listに変換する。
    final shops = docs.docs.map((doc) => Shop(doc)).toList();
    this.shops = shops;
    notifyListeners();
  }
}