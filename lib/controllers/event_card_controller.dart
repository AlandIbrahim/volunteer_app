import 'package:get/get.dart';

class EventCardController extends GetxController {
  var isPressed = false.obs;
  // var distance = Offset(28, 28).obs;
  // RxDouble blur = 30.0.obs;

  void onPress() {
    isPressed.value = !isPressed.value;
    // distance.value = Offset(10, 10);
  }
}
