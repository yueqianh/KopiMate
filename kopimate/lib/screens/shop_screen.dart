import 'package:flutter/material.dart';
import 'package:kopimate/models/shop_model.dart';
import 'package:kopimate/screens/detail_screen.dart';
import 'package:kopimate/services/firebase_storage_service.dart';
import 'package:provider/provider.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    return ChangeNotifierProvider<ShopModel>(
      create: (_) => ShopModel()..fetchShops(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nearby Shops'),
        ),
        body: Consumer<ShopModel>(
          builder: (context, model, child) {
            final shops = model.shops;
            return ListView.builder(
              itemCount: shops.length,
              itemBuilder: (context, index) {
                return Card(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailPage(shop: shops[index]),
                          ));
                    },
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.all(0),
                          width: 120,
                          height: 100,
                          child: FutureBuilder(
                              future: storage.downloadURL(shops[index].imgName),
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.hasData) {
                                  return ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                    child: Image.network(
                                      snapshot.data!,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                }
                                if (snapshot.connectionState ==
                                        ConnectionState.waiting ||
                                    !snapshot.hasData) {
                                  return const CircularProgressIndicator();
                                }
                                return Container();
                              }),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ListTile(
                            horizontalTitleGap: 10,
                            title: Text(shops[index].name),
                            subtitle: Text(shops[index].address),
                            isThreeLine: true,
                            contentPadding: const EdgeInsets.all(0),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
