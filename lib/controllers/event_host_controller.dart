import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volunteer_app/services/api.dart';
import 'package:volunteer_app/services/city.dart';
import 'package:volunteer_app/services/network.dart';
import 'package:volunteer_app/views/event_host.dart';

import '../views/widgets/skill_select_dialog.dart';

class EventHostController extends GetxController{
  var formKey = GlobalKey<FormState>();
  var ns=NetworkService();
  var isLoading = false.obs;
  @override
  Future<void> onInit() async {
    skills.value=SelectSkillsDialog.skills;
    super.onInit();
  }
  var titleController = TextEditingController().obs;

  var descriptionController = TextEditingController().obs;

  var locationController = TextEditingController().obs;
  var _selectedEnrollmentDeadline = DateTime.now().obs;
  String get selectedEnrollmentDeadlineDate => _selectedEnrollmentDeadline.value.toString().split(' ')[0];
  String get selectedEnrollmentDeadlineTime => _selectedEnrollmentDeadline.value.toString().split(' ')[1].substring(0,5);
  void setEnrollmentDeadlineDate(DateTime date) => _selectedEnrollmentDeadline.value = DateTime(date.year, date.month, date.day, _selectedEnrollmentDeadline.value.hour, _selectedEnrollmentDeadline.value.minute);
  void setEnrollmentDeadlineTime(TimeOfDay time) => _selectedEnrollmentDeadline.value = DateTime(_selectedEnrollmentDeadline.value.year, _selectedEnrollmentDeadline.value.month, _selectedEnrollmentDeadline.value.day, time.hour, time.minute);
  
  var _selectedStartDateTime = DateTime.now().obs;
  String get selectedStartDate => _selectedStartDateTime.value.toString().split(' ')[0];
  String get selectedStartTime => _selectedStartDateTime.value.toString().split(' ')[1].substring(0,5);
  void setStartDate(DateTime date) => _selectedStartDateTime.value = DateTime(date.year, date.month, date.day, _selectedStartDateTime.value.hour, _selectedStartDateTime.value.minute);
  void setStartTime(TimeOfDay time) => _selectedStartDateTime.value = DateTime(_selectedStartDateTime.value.year, _selectedStartDateTime.value.month, _selectedStartDateTime.value.day, time.hour, time.minute);

  var durationMinutes = 0.obs;
  var durationHours = 0.obs;

  var selectedCity=TextEditingController().obs;
  List<DropdownMenuItem<int>> cities = [
    for (var city in City.values) DropdownMenuItem(child: Text(city.toString().split('.').last), value: city.index)
  ];

  var maxAttendeesController = 0.obs;
  var skills= Map<String,int>().obs;
  var selectedSkills=<String>[].obs;

  Future<void> submit() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      var response = await ns.postRequest(Uri.https(apiUrl, 'event/host'), {
        'title': titleController.value.text,
        'description': descriptionController.value.text,
        'location': locationController.value.text,
        'enrollmentDeadline': _selectedEnrollmentDeadline.value.toIso8601String(),
        'startDate': _selectedStartDateTime.value.toIso8601String(),
        'duration': "${durationHours.value}:${durationMinutes.value}",
        'city': int.parse(selectedCity.value.text)+1,
        'max_attendees': maxAttendeesController.value,
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