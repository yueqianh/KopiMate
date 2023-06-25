import 'package:flutter/material.dart';
import 'package:kopimate/services/firebase_storage_service.dart';
import 'package:maps_launcher/maps_launcher.dart';
import '../models/shop.dart';

class ShopDetail extends StatelessWidget {
  final Shop shop;

  const ShopDetail({Key? key, required this.shop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar.medium(
            expandedHeight: 300.0,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const <StretchMode>[
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
                StretchMode.fadeTitle,
              ],
              title: Text(
                shop.name,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              titlePadding: const EdgeInsets.all(20),
              background: SizedBox(
                child: Stack(fit: StackFit.expand, children: [
                  FutureBuilder(
                      future: storage.downloadURL(shop.imgName),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          return Image.network(
                            snapshot.data!,
                            fit: BoxFit.cover,
                          );
                        }
                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            !snapshot.hasData) {
                          return const CircularProgressIndicator();
                        }
                        return Container();
                      }),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.0, 0.3),
                        end: Alignment.topCenter,
                        colors: <Color>[
                          Color.fromARGB(150, 0, 0, 0),
                          Color(0x00000000),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            actions: <Widget>[
              IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                ListTile(
                  leading: const Icon(Icons.map),
                  minLeadingWidth: 10,
                  title: Text(shop.address),
                  subtitle: const Text('Click to find directions'),
                  onTap: () {
                    MapsLauncher.launchQuery(shop.address);
                  },
                ),
                const ListTile(
                  leading: Icon(Icons.question_mark),
                  minLeadingWidth: 10,
                  title: Text('More details coming up'),
                  subtitle: Text('Be patient!'),
                ),
                // ListTiles++
              ],
            ),
          ),
        ],
      ),
    );
  }
}
