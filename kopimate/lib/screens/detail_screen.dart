import 'package:flutter/material.dart';
import 'package:kopimate/services/firebase_storage_service.dart';
import 'dart:ui';

import '../models/shop.dart';

class DetailPage extends StatelessWidget {
  final Shop shop;

  const DetailPage({Key? key, required this.shop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar.medium(
            title: Text(shop.name),
            expandedHeight: 300.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(shop.name),
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
                  ClipRRect(
                    // Clip it cleanly.
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3.5, sigmaY: 3.5),
                      child: Container(
                        color: Colors.brown.withOpacity(0.4),
                        alignment: Alignment.center,
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
        ],
      ),
    );
  }
}