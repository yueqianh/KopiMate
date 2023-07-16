import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kopimate/screens/shop_detail.dart';
import 'package:kopimate/services/firebase_storage_service.dart';
import 'package:provider/provider.dart';
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

  //user current location
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

    userLatLng = LatLng(position.latitude, position.longitude);

    return position;
  }

//Shortest Distance Function definition:
double calculateDistance (double lat1,double lng1,double lat2,double lng2){
double radEarth =6.3781*( pow(10.0,6.0));
double phi1= lat1*(pi/180);
double phi2 = lat2*(pi/180);
    
double delta1=(lat2-lat1)*(pi/180);
double delta2=(lng2-lng1)*(pi/180);
    
double cal1 = sin(delta1/2)*sin(delta1/2)+(cos(phi1)*cos(phi2)*sin(delta2/2)*sin(delta2/2));
    
double cal2= 2 * atan2((sqrt(cal1)), (sqrt(1-cal1)));
double distance =radEarth*cal2 / 1000;
    
return (distance);   
}

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();

    //access firebase shops
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Shops'),
        actions: [
          //button to get user current location
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
          //google maps
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
          
          
          //list of shops
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("shops")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    //get shop
                    final shop = snapshot.data!.docs[index];

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
                                      ShopDetail(shop: Shop(
                                        address: shop['address'],
                                        name: shop['name'], 
                                        imgName: shop['imgName'],
                                        shopId: shop.id,
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
                                //picture of the shops
                                child: FutureBuilder(
                                    future: storage
                                        .downloadURL(shop['imgName']),
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
                                    }
                                  ),
                              ),

                              const SizedBox(width: 10),
                              
                              //name and address of the shops
                              Expanded(
                                child: ListTile(
                                  horizontalTitleGap: 10,
                                  title: Text(shop['name']),
                                  subtitle: Text("Distance: ${calculateDistance(userLatLng.latitude, userLatLng.longitude, shop['lat'].toDouble(), shop['long'].toDouble()).toStringAsFixed(2)}"),
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

              } else if (snapshot.hasError) {
                return Center(
                    child: Text('Error:${snapshot.error}'),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
