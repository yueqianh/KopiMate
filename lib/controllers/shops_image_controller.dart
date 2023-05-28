import 'package:get/get.dart';
import 'package:kopimate/services/firebase_storage_service.dart';

class ShopsImageController extends GetxController {
  final allShopImages = <String>[].obs;

  @override
  void onReady() {
    getAllShops();
    super.onReady();
  }

  Future<void> getAllShops() async {
    List<String> imgName = [
      'chyeSengHuatHardware',
      'lamYeoCoffeePowderFactory',
      'nylonCoffeeRoasters',
    ];
    for (var img in imgName) {
      final imgUrl = await Get.find<FirebaseStorageService>().getImage(img);
      allShopImages.add(imgUrl!);
    }
  }
}
