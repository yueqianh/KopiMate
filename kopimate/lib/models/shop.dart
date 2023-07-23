import 'package:flutter/material.dart';

import '../services/firebase_storage_service.dart';

class Shop extends StatefulWidget {
  final String address;
  final String imgName;
  final String imgUrl;
  final String name;
  final String shopId;
  final double rating;
  final String phoneNumber;
  final String website;

  const Shop(
      {super.key,
      required this.address,
      required this.imgName,
      required this.imgUrl,
      required this.name,
      required this.shopId,
      required this.rating,
      required this.phoneNumber,
      required this.website});

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
