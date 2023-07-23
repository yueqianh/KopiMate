import 'package:flutter/material.dart';
import 'package:kopimate/services/firebase_storage_service.dart';
import 'package:maps_launcher/maps_launcher.dart';
import '../models/shop.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopDetail extends StatefulWidget {
  final Shop shop;

  const ShopDetail({Key? key, required this.shop}) : super(key: key);

  @override
  State<ShopDetail> createState() => _ShopDetailState();
}

class _ShopDetailState extends State<ShopDetail> {
  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();

    launchURL(String urlin) async {
      final Uri url = Uri.parse(urlin);
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: CustomScrollView(
        slivers: <Widget>[
          // sliver app bar
          SliverAppBar.medium(
            expandedHeight: 300.0,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const <StretchMode>[
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
                StretchMode.fadeTitle,
              ],
              title: Text(
                widget.shop.name,
                style: const TextStyle(fontWeight: FontWeight.w700),
                textDirection: TextDirection.ltr,
              ),
              titlePadding: const EdgeInsets.all(20),
              background: SizedBox(
                child: Stack(fit: StackFit.expand, children: [
                  FutureBuilder(
                      future: storage.downloadURL(
                          widget.shop.imgName, widget.shop.imgUrl),
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

          // direction
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                ListTile(
                  leading: const Icon(Icons.map),
                  minLeadingWidth: 10,
                  title: Text(
                    widget.shop.address,
                    textDirection: TextDirection.ltr,
                  ),
                  subtitle: const Text(
                    'Click to find directions',
                    textDirection: TextDirection.ltr,
                  ),
                  onTap: () {
                    MapsLauncher.launchQuery(widget.shop.address);
                  },
                ),
              ],
            ),
          ),

          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                ListTile(
                  leading: const Icon(Icons.star_rate),
                  minLeadingWidth: 10,
                  title: Text(
                    "${widget.shop.rating} / 5",
                    textDirection: TextDirection.ltr,
                  ),
                  subtitle: const Text(
                    'Google Maps Rating',
                    textDirection: TextDirection.ltr,
                  ),
                ),
              ],
            ),
          ),

          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                ListTile(
                    leading: const Icon(Icons.call),
                    minLeadingWidth: 10,
                    title: Text(
                      widget.shop.phoneNumber,
                      textDirection: TextDirection.ltr,
                    ),
                    subtitle: const Text(
                      'Phone Number',
                      textDirection: TextDirection.ltr,
                    ),
                    onTap: () {
                      String number = widget.shop.phoneNumber;
                      if (number != '-') {
                        launchURL("tel://$number");
                      }
                    }),
              ],
            ),
          ),

          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                ListTile(
                  leading: const Icon(Icons.public),
                  minLeadingWidth: 10,
                  title: Text(
                    widget.shop.website,
                    textDirection: TextDirection.ltr,
                  ),
                  subtitle: const Text(
                    'Website',
                    textDirection: TextDirection.ltr,
                  ),
                  onTap: () {
                    String website = widget.shop.website;
                    if (website != '-') {
                      launchURL(widget.shop.website);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
