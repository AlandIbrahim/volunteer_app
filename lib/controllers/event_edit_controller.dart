import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api.dart';
import '../services/city.dart';
import '../services/network.dart';
import '../views/event_host.dart';

import '../views/widgets/skill_select_dialog.dart';

class EventEditController extends GetxController {
  var eventId = ''.obs;
  var formKey = GlobalKey<FormState>();
  var ns = NetworkService();
  var isLoading = false.obs;
  @override
  Future<void> onInit() async {
    eventId.value = Get.parameters['id'] ?? 'No ID found';
    try {
      var eventFetch = await ns.getRequest(Uri.https(apiUrl, 'event/' + eventId.value, {"forEdit": "true"}));
      titleController.value.text = eventFetch.data['title'];
      descriptionController.value.text = eventFetch.data['description'];
      locationController.value.text = eventFetch.data['location'];
      _selectedEnrollmentDeadline.value = DateTime.parse(eventFetch.data['enrollmentDeadline']);
      _selectedStartDateTime.value = DateTime.parse(eventFetch.data['startDate']);
      var duration = eventFetch.data['duration'].split(':');
      durationHours.value = int.parse(duration[0]);
      durationMinutes.value = int.parse(duration[1]);
      selectedCity.value.text = (eventFetch.data['city'] - 1).toString();
      maxAttendeesController.value.text = eventFetch.data['maxAttendees'].toString();
      selectedSkills.value = eventFetch.data['skills'].map<String>((skill) => skill.toString()).toList();
    } on DioException catch (e) {
      Get.back(closeOverlays: true);
      if (e.response?.data.toString().contains('Not the owner') ?? false)
        Get.snackbar('Not allowed', 'You cannot edit other\'s events',backgroundColor: Color.fromARGB(150, 255, 0, 0));
      else Get.snackbar('Error', 'Failed to edit event');
    } catch (e) {
      print("Error fetching data: $e");
      Get.back(closeOverlays: true);
    }

    super.onInit();
  }

  var titleController = TextEditingController().obs;

  var descriptionController = TextEditingController().obs;

  var locationController = TextEditingController().obs;
  var _selectedEnrollmentDeadline = DateTime.now().obs;
  String get selectedEnrollmentDeadlineDate =>
      _selectedEnrollmentDeadline.value.toString().split(' ')[0];
  String get selectedEnrollmentDeadlineTime => _selectedEnrollmentDeadline.value
      .toString()
      .split(' ')[1]
      .substring(0, 5);
  void setEnrollmentDeadlineDate(DateTime date) =>
      _selectedEnrollmentDeadline.value = DateTime(
          date.year,
          date.month,
          date.day,
          _selectedEnrollmentDeadline.value.hour,
          _selectedEnrollmentDeadline.value.minute);
  void setEnrollmentDeadlineTime(TimeOfDay time) =>
      _selectedEnrollmentDeadline.value = DateTime(
          _selectedEnrollmentDeadline.value.year,
          _selectedEnrollmentDeadline.value.month,
          _selectedEnrollmentDeadline.value.day,
          time.hour,
          time.minute);

  var _selectedStartDateTime = DateTime.now().obs;
  String get selectedStartDate =>
      _selectedStartDateTime.value.toString().split(' ')[0];
  String get selectedStartTime =>
      _selectedStartDateTime.value.toString().split(' ')[1].substring(0, 5);
  void setStartDate(DateTime date) => _selectedStartDateTime.value = DateTime(
      date.year,
      date.month,
      date.day,
      _selectedStartDateTime.value.hour,
      _selectedStartDateTime.value.minute);
  void setStartTime(TimeOfDay time) => _selectedStartDateTime.value = DateTime(
      _selectedStartDateTime.value.year,
      _selectedStartDateTime.value.month,
      _selectedStartDateTime.value.day,
      time.hour,
      time.minute);

  var durationMinutes = 0.obs;
  var durationHours = 0.obs;

  var selectedCity = TextEditingController().obs;
  List<DropdownMenuItem<int>> cities = [
    for (var city in City.values)
      DropdownMenuItem(
          child: Text(city.toString().split('.').last), value: city.index)
  ];

  var maxAttendeesController = TextEditingController().obs;
  var skills = SelectSkillsDialog.skills;
  var selectedSkills = <String>[].obs;

  Future<void> submit() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      var response = await ns.patchRequest(Uri.https(apiUrl, 'event/$eventId'), {
        'title': titleController.value.text,
        'description': descriptionController.value.text,
        'location': locationController.value.text,
        'enrollmentDeadline':
            _selectedEnrollmentDeadline.value.toIso8601String(),
        'startDate': _selectedStartDateTime.value.toIso8601String(),
        'duration': "${durationHours.value.toString().padLeft(2,'0')}:${durationMinutes.value.toString().padLeft(2,'0')}",
        'city': int.parse(selectedCity.value.text) + 1,
        'maxAttendees': int.parse(maxAttendeesController.value.text),
        'skills': [for (var skill in selectedSkills) skills[skill]]
      });
      isLoading.value = false;
      if (response.statusCode == 200) {
        Get.offAll(() => const EventHost());
      } else {
        Get.snackbar('Error', response.data['detail']);
      }
    }
  }
}
