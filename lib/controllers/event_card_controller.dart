import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volunteer_app/services/api.dart';
import 'package:volunteer_app/services/network.dart';

class EventCardController extends GetxController {
  var isPressed = false.obs;
  NetworkService ns = NetworkService();
  // var distance = Offset(28, 28).obs;
  // RxDouble blur = 30.0.obs;

  void onPress() {
    isPressed.value = !isPressed.value;
    // distance.value = Offset(10, 10);
  }

  Color fromStatus(String status) {
    switch (status) {
      case 'upcoming':
      case 'Upcoming(Full)':
      case 'Upcoming(Enrollment deadline Passed)':
      case 'Live':
        return Colors.teal;
      case 'Ended':
      case 'Cancelled':
        return Color.fromARGB(255, 200, 200, 200);
      case 'Ended(Missed)':
        return Color.fromARGB(255, 200, 130, 120);
      case 'Ended(Attended)':
        return Color.fromARGB(255, 120, 200, 156);
      case 'Upcoming(Enrolled)':
        return Color.fromARGB(255, 120, 240, 156);
      default:
        return Colors.teal;
    }
  }

  Future deleteEvent(int id) async {
    try {
      await ns.deleteRequest(Uri.https(apiUrl, '/event/$id'));
    } on DioException catch (e) {
      Get.close(1);
      if (e.response?.data.toString().contains('Not the owner') ?? false)
        Get.snackbar('Not allowed', 'You cannot delete other\'s events',
            backgroundColor: Color.fromARGB(150, 255, 0, 0));
      else
        Get.snackbar('Error', 'Failed to delete event');
    }
  }
  Future unenroll(int eid) async{
    await ns.getRequest(Uri.https(apiUrl,'event/$eid/unenroll'));
  }
  Future enroll(int eid) async{
    await ns.getRequest(Uri.https(apiUrl,'event/$eid/enroll'));
  }
}
