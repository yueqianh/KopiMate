import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String> downloadURL(String imageName, String imageUrl) async {
    if (imageName != '-') {
      String downloadURL =
          await storage.ref('shops/$imageName.jpg').getDownloadURL();
      return downloadURL;
    } else {
      return imageUrl;
    }
  }
}
