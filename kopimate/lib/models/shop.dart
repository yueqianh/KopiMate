import 'package:flutter/material.dart';

import '../services/firebase_storage_service.dart';

class Shop extends StatefulWidget {
  final String address;
  final String imgName;
  final String name;
  final String shopId;

  const Shop(
      {super.key,
      required this.address,
      required this.imgName,
      required this.name,
      required this.shopId});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  final Storage storage = Storage();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
