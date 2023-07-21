import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import '../components/user_textfield.dart';
import 'package:geocoding/geocoding.dart';

class AddShopScreen extends StatefulWidget {
  const AddShopScreen({super.key});
  

  @override
  State<AddShopScreen> createState() => _AddShopScreenState();
}

class _AddShopScreenState extends State<AddShopScreen> {
  //text editing controllers
  final _controllerName = TextEditingController();
  final _controllerAddress = TextEditingController();
  GlobalKey<FormState> key = GlobalKey();
  String imageUrl = '';

  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('shops');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add a shop!')),
      backgroundColor: const Color.fromARGB(255, 208, 185, 174),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 30),

                //logo
                const Text(
                  'KopiMate',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontFamily: 'Pacific',
                  ),
                ),

                Image.asset('lib/images/coffee.png', height: 70),
                const SizedBox(height: 30),

                //name
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: UserTextField(
                    controller: _controllerName,
                    hintText: 'Shop Name',
                    obscureText: false,
                  ),
                ),

                const SizedBox(height: 10),

                //address
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: UserTextField(
                    controller: _controllerAddress,
                    hintText: 'Address',
                    obscureText: false,
                  ),
                ),

                const SizedBox(height: 10),

                //add image
                IconButton(
                    onPressed: () async {
                      /*
                * Step 1. Pick/Capture an image   (image_picker)
                * Step 2. Upload the image to Firebase storage
                * Step 3. Get the URL of the uploaded image
                * Step 4. Store the image URL inside the corresponding
                *         document of the database.
                * Step 5. Display the image on the list
                *
                * */

                      /*Step 1:Pick image*/
                      //Install image_picker
                      //Import the corresponding library

                      ImagePicker imagePicker = ImagePicker();
                      XFile? file = await imagePicker.pickImage(source: ImageSource.camera);

                      if (file == null) return;
                      //Import dart:core
                      String uniqueFileName = _controllerAddress.text;

                      /*Step 2: Upload to Firebase storage*/
                      //Install firebase_storage
                      //Import the library

                      //Get a reference to storage root
                      Reference referenceRoot = FirebaseStorage.instance.ref();
                      Reference referenceDirImages = referenceRoot.child('shops/');

                      //Create a reference for the image to be stored
                      Reference referenceImageToUpload =
                          referenceDirImages.child('$uniqueFileName.jpg');

                      //Handle errors/success
                      try {
                        //Store the file
                        await referenceImageToUpload.putFile(File(file!.path));
                        //Success: get the download URL
                        imageUrl =
                            await referenceImageToUpload.getDownloadURL();
                      } catch (error) {
                        //Some error occurred
                      }
                    },
                    icon: const Icon(Icons.camera_alt)),

                // add shop
                /*
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      foregroundColor: Colors.white70,
                      backgroundColor: Colors.brown[800],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    onPressed: addShop,
                    child: const Text(
                      'Add Shop!',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                */
                ElevatedButton(
                  onPressed: () async {
                    if (imageUrl.isEmpty) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Please upload an image')));

                      return;
                    }

                    else  {
                      String name = _controllerName.text;
                      String address = _controllerAddress.text;
                      List<Location> location = await locationFromAddress(address);
                      
                      //Add a new item
                      _reference.add({
                        'address': address,
                        'imgName': address,
                        'lat': location[0].latitude,
                        'long':location[0].longitude,
                        'name':name,
                        'type': 'Cafe',
                      });
                    }
                  },
                  child: Text('Submit'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
