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
      case 'Upcoming':
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
    try{
      await ns.getRequest(Uri.https(apiUrl,'event/$eid/unenroll'));
    } on DioException catch(e){
      if(e.response?.data.toString().contains('Not enrolled')??false)
        Get.snackbar('Not allowed', 'You cannot unenroll from an event you are not enrolled in',backgroundColor: Color.fromARGB(150, 255, 0, 0));
      else
        Get.snackbar('Error', 'Failed to unenroll from event');
    }
  }
  Future enroll(int eid) async{
    try{
    await ns.getRequest(Uri.https(apiUrl,'event/$eid/enroll'));
    } on DioException catch(e){
      if(e.response?.data.toString().contains('Enrollment deadline passed')??false)
        Get.snackbar('Not allowed', 'You cannot enroll in an event after the enrollment deadline',backgroundColor: Color.fromARGB(150, 255, 0, 0));
      else if(e.response?.data.toString().contains('Event full')??false)
        Get.snackbar('Not allowed', 'You cannot enroll in an event that is full',backgroundColor: Color.fromARGB(150, 255, 0, 0));
      else if(e.response?.data.toString().contains('Already enrolled')??false)
        Get.snackbar('Already enrolled', 'You cannot enroll in an event you are already enrolled in',backgroundColor: Color.fromARGB(150, 255, 150, 0));
      else Get.snackbar('Error', 'Failed to enroll in event');
    }
  }
}
