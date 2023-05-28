import 'package:flutter/material.dart';
import 'package:kopimate/models/shop_model.dart';
import 'package:provider/provider.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  ShopScreenState createState() => ShopScreenState();
}

class ShopScreenState extends State<ShopScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider<ShopModel>(
        create: (_) => ShopModel()..fetchShops(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('本一覧'),
          ),
          body: Consumer<ShopModel>(
            builder: (context, model, child) {
              final shops = model.shops;
              return ListView.builder(
                itemCount: shops.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(shops[index].name),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
