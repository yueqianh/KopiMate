import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kopimate/models/shop_model.dart';
import 'package:kopimate/screens/shop_detail.dart';
import 'package:kopimate/services/firebase_storage_service.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};

  final LatLng _center = const LatLng(1.3521, 103.8198);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

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

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    return position;
  }

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    return ChangeNotifierProvider<ShopModel>(
      create: (_) => ShopModel()..fetchShops(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nearby Shops'),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  Position position = await _determinePosition();

                  mapController.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(
                          target: LatLng(position.latitude, position.longitude),
                          zoom: 14)));

                  markers.clear();

                  markers.add(Marker(
                      markerId: const MarkerId('currentLocation'),
                      position: LatLng(position.latitude, position.longitude)));

                  setState(() {});
                },
                child: Icon(Icons.location_on),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            SizedBox(
              height: 300,
              width: double.maxFinite,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 11.0,
                ),
                markers: markers,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Consumer<ShopModel>(
                builder: (context, model, child) {
                  final shops = model.shops;
                  return ListView.builder(
                    itemCount: shops.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 1.0),
                        child: Card(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ShopDetail(shop: shops[index]),
                                  ));
                            },
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 120,
                                  height: 100,
                                  child: FutureBuilder(
                                      future: storage
                                          .downloadURL(shops[index].imgName),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<String> snapshot) {
                                        if (snapshot.connectionState ==
                                                ConnectionState.done &&
                                            snapshot.hasData) {
                                          return ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
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
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
