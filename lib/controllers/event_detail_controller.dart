// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volunteer_app/models/event.dart';
import 'package:volunteer_app/services/api.dart';
import 'package:volunteer_app/services/city.dart';
import 'package:volunteer_app/services/network.dart';

class EventController extends GetxController {
  var eventId = ''.obs;
  var isLoading = false.obs;
  var bgColor1 = Colors.teal[500]!.obs;
  var bgColor2 = Colors.teal[900]!.obs;
  var enrollable = false.obs;
  var enrolled = false.obs;
  var ratingUnlocked = false.obs;
  var rating=Map().obs;
  NetworkService networkService = NetworkService();
  var event = Event(
          city: City.sulaymaniyah,
          description: 'd',
          duration: 'd',
          enrollmentDeadline: DateTime.now(),
          id: 0,
          location: 'l',
          organization: 'o',
          organizationId: 0,
          startDate: DateTime.now(),
          title: 't',
          status: 's')
      .obs;

  @override
  void onInit() {
    super.onInit();
    eventId.value = Get.parameters['id'] ?? 'No ID found';
    getEvent();
    fetchRating();
  }

  void getEvent() async {
    isLoading.value = true;
    var response =
        await networkService.getRequest(Uri.https(apiUrl, 'event/$eventId'));
    event.value = Event.fromJson(response.data);
    if (event.value.status.contains('Enrolled')) {
      enrolled.value = true;
    }
    if (event.value.status.contains('Ended') ||
        event.value.status.contains('Cancelled') ||
        event.value.status.contains('deadline') ||
        event.value.status.contains('Live')) {
      enrollable.value = true;
      bgColor1.value = Colors.grey[400]!;
      bgColor2.value = Colors.grey[800]!;
    }
    if (event.value.status.contains('Attended')) ratingUnlocked.value = true;
    isLoading.value = false;
  }

  void enroll() async {
    try {
      await networkService.getRequest(Uri.https(apiUrl, 'event/$eventId/enroll'));
      enrolled.value = true;
    } on DioException catch (e) {
      print(e);
      enrolled.value = false;
      Get.snackbar('Error', 'Could not enroll , please try again');
    }
  }

  void unenroll() async {
    try {
      var response = await networkService
          .getRequest(Uri.https(apiUrl, 'event/$eventId/unenroll'));
      enrolled.value = false;
    } catch (e) {
      enrolled.value = true;
      Get.snackbar('Error', 'Could not unenroll , please try again');
    }
  }
  void fetchRating() async {
    try {
      var response = await networkService
          .getRequest(Uri.https(apiUrl, 'event/$eventId/rate'));
      rating.value = response.data;
    } catch (e) {print(e);}
  }
  void PostRating(int rate) async {
    var prev=rating;
    if(ratingUnlocked.value==false){
      Get.snackbar('Error', 'Rating is not available for you');
      // reset rating to previous value

      return;
      }
    try {
      if((rating['self']??0)==0){
        rating['self']=rate;
        incrementCounts(rate);
        rating['counts']['total']+=1;
        await networkService.postRequest(Uri.https(apiUrl, 'event/$eventId/rate'), {'rating':rate==0?1:rate});
      }
      else if(rating['self']==rate){
        rating['self']=0;
        decrementCounts(rate);
        rating['counts']['total']-=1;
        await networkService.deleteRequest(Uri.https(apiUrl, 'event/$eventId/rate'));
      }
      else {
        incrementCounts(rate);
        decrementCounts(rating['self']);
        rating['self']=rate;
        await networkService.patchRequest(Uri.https(apiUrl, 'event/$eventId/rate'), {'rating':rate});
      }
    } catch (e) {
      rating=prev;
      Get.snackbar('Error', 'Could not rate , please try again');
    }
  }
  void incrementCounts(int rate){
    switch(rate){
      case 1:rating['counts']['i']+=1;break;
      case 2:rating['counts']['ii']+=1;break;
      case 3:rating['counts']['iii']+=1;break;
      case 4:rating['counts']['iv']+=1;break;
      case 5:rating['counts']['v']+=1;break;
    }
  }
  void decrementCounts(int rate){
    switch(rate){
      case 1:rating['counts']['i']-=1;break;
      case 2:rating['counts']['ii']-=1;break;
      case 3:rating['counts']['iii']-=1;break;
      case 4:rating['counts']['iv']-=1;break;
      case 5:rating['counts']['v']-=1;break;
    }
  }
  double averageRating()=>(rating['counts']?['total']??0)==0? 0:
    (rating['counts']['i']*1
    +rating['counts']['ii']*2
    +rating['counts']['iii']*3
    +rating['counts']['iv']*4
    +rating['counts']['v']*5)
    /rating['counts']['total'];
}
