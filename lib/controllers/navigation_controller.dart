import 'package:get/get.dart';

class NavigationBarController extends GetxController {
  var currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
    switch (currentIndex.value) {
      case 0:
        Get.offNamed('/home');
        break;
      case 1:
        Get.offNamed('/search');
        break;
      case 2:
        Get.offNamed('/myevents');
        break;
      case 3:
        Get.offNamed('/profile');
        break;
    }
  }
}
