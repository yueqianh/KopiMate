import 'package:flutter/material.dart';
import 'package:kopimate/models/shop_model.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:maps_launcher/maps_launcher.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  ShopScreenState createState() => ShopScreenState();
}

class ShopScreenState extends State<ShopScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider<ShopModel>(
        create: (_) => ShopModel()..fetchShops(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Nearby Shops'),
            backgroundColor: Colors.brown,
          ),
          body: Consumer<ShopModel>(
            builder: (context, model, child) {
              final shops = model.shops;
              return ListView.builder(
                itemCount: shops.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(shops[index].name),
                      subtitle: Text(shops[index].address),
                      isThreeLine: true,
                      leading: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 44,
                          minHeight: 44,
                          maxWidth: 64,
                          maxHeight: 64,
                        ),
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: 'https://picsum.photos/250?image=9',
                        ),
                      ),
                      onTap: () => MapsLauncher.launchQuery(shops[index].name),
                    ),
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
