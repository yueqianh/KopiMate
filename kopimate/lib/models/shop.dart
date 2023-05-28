import 'package:cloud_firestore/cloud_firestore.dart';

// firestoreのドキュメントを扱うクラスBookを作る。
class Shop {
  // ドキュメントを扱うDocumentSnapshotを引数にしたコンストラクタを作る
  Shop(DocumentSnapshot doc) {
    //　ドキュメントの持っているフィールド'title'をこのBookのフィールドtitleに代入
    name = doc['name'];
  }
  // Bookで扱うフィールドを定義しておく。
  String name = '';
}
