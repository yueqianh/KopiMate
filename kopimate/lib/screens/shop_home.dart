import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kopimate/screens/add_shop_screen.dart';
import 'package:kopimate/screens/shop_detail.dart';
import 'package:kopimate/services/firebase_storage_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/shop.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};
  final LatLng _center = const LatLng(1.3521, 103.8198);
  LatLng userLatLng = const LatLng(1.3521, 103.8198);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // User current location.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    userLatLng = LatLng(position.latitude, position.longitude);

    return position;
  }

// Shortest Distance Function definition.
  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    double radEarth = 6.3781 * (pow(10.0, 6.0));
    double phi1 = lat1 * (pi / 180);
    double phi2 = lat2 * (pi / 180);

    double delta1 = (lat2 - lat1) * (pi / 180);
    double delta2 = (lng2 - lng1) * (pi / 180);

    double cal1 = sin(delta1 / 2) * sin(delta1 / 2) +
        (cos(phi1) * cos(phi2) * sin(delta2 / 2) * sin(delta2 / 2));

    double cal2 = 2 * atan2((sqrt(cal1)), (sqrt(1 - cal1)));
    double distance = radEarth * cal2 / 1000;

    return (distance);
  }

//sort shops based on distance
  final Query ref = FirebaseFirestore.instance.collection("New Shop");
  List<DocumentSnapshot>? shops;
  StreamSubscription<QuerySnapshot>? subscription;

  @override
  void initState() {
    super.initState();
    subscription = ref.snapshots().listen((data) {
      setState(() {
        shops = data.docs;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    shops?.sort((a, b) {
      return calculateDistance(userLatLng.latitude, userLatLng.longitude,
              a['lat'].toDouble(), a['long'].toDouble())
          .compareTo(calculateDistance(userLatLng.latitude,
              userLatLng.longitude, b['lat'].toDouble(), b['long'].toDouble()));
    });

    return shops != null
        ? Scaffold(
            appBar: AppBar(
              title: const Text('Nearby Shops'),
              actions: [
                // Button to get user current location and update distance of nearby shops.
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () async {
                      Position position = await _determinePosition();

                      mapController.animateCamera(
                          CameraUpdate.newCameraPosition(CameraPosition(
                              target:
                                  LatLng(position.latitude, position.longitude),
                              zoom: 14)));

                      markers.clear();

                      markers.add(Marker(
                          markerId: const MarkerId('currentLocation'),
                          position:
                              LatLng(position.latitude, position.longitude)));

                      setState(() {});
                    },
                    child: const Icon(Icons.location_on),
                  ),
                ),

                // Button to add shops.
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddShopScreen()),
                      );
                    },
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
            body: Column(children: [
              SizedBox(
                height: 300,
                width: double.maxFinite,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 11.0,
                  ),
                  markers: Set<Marker>.of(markers),
                ),
              ),

              const SizedBox(height: 10),

              // List of shops.
              Expanded(
                  child: ListView.builder(
                itemCount: shops?.length,
                itemBuilder: (context, index) {
                  final List<LatLng> latLen = <LatLng>[];
                  for (int i = 0; i < shops!.length; i++) {
                    latLen.add(
                        LatLng(shops?[i].get('lat'), shops?[i].get('long')));
                  }

                  loadData() async {
                    for (int i = 0; i < shops!.length; i++) {
                      markers.add(Marker(
                        markerId: MarkerId(i.toString()),
                        position: latLen[i],
                        infoWindow: InfoWindow(
                          title: shops?[i].get('name'),
                        ),
                      ));
                    }
                  }

                  loadData();

                  // Get shop.
                  final shop = shops?[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 1.0),
                    child: Card(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShopDetail(
                                shop: Shop(
                                  address: shop?['address'],
                                  name: shop?['name'],
                                  imgName: shop?['imgName'],
                                  imgUrl: shop?['imgUrl'],
                                  shopId: shop!.id,
                                  rating: shop['rating'],
                                  phoneNumber: shop['phoneNumber'],
                                  website: shop['website'],
                                ),
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 120,
                              height: 100,

                              // picture of the shops
                              child: FutureBuilder(
                                  future: storage.downloadURL(
                                      shop?['imgName'], shop?['imgUrl']),
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

                            //name and address of the shops
                            Expanded(
                              child: ListTile(
                                horizontalTitleGap: 10,
                                title: Text(
                                  shop?['name'],
                                  maxLines: 1,
                                ),
                                subtitle: Text(
                                  "${calculateDistance(userLatLng.latitude, userLatLng.longitude, shop?['lat'].toDouble(), shop?['long'].toDouble()).toStringAsFixed(2)}km from you\n${shop?['address']}",
                                  maxLines: 2,
                                ),
                                isThreeLine: true,
                                contentPadding: const EdgeInsets.all(0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ))
            ]),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
