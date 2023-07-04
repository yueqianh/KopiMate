import 'package:cloud_firestore/cloud_firestore.dart';

// Create a class Shop that handles firestore documents.
class Shop {
  // Create a constructor with a DocumentSnapshot argument that handles the document
  Shop(DocumentSnapshot doc) {
    //　Assign the fields of the document to the fields of this Shop
    name = doc['name'];
    address = doc['address'];
    imgName = doc['imgName'];
  }
  // Define the fields handled by Shop
  String name = '';
  String address = '';
  String imgName = '';
}