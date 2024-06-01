import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:volunteer_app/services/network.dart';
import '../services/api.dart';

class VolRegisterController extends GetxController {
  var unameController = TextEditingController().obs;
  var emailController = TextEditingController().obs;
  var phoneController = TextEditingController().obs;
  var firstNameController = TextEditingController().obs;
  var lastNameController = TextEditingController().obs;
  var selectedGender = 'Male'.obs;
  final List<String> genders = ['Male', 'Female'];
  var cityController = TextEditingController().obs;
  var passController = TextEditingController().obs;
  var passConfirmController = TextEditingController().obs;
  var isTextVisible = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var errorMessage = ''.obs;
  var isRequesting = false.obs;
  var selectedBirthday = DateTime.now().obs;
  var selectedLanguages = <String>[].obs;
  NetworkService ns = NetworkService();

  void setSelectedGender(String gender) {
    selectedGender.value = gender;
  }

  // to calculate the age
  int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  // Clear text
  void clearText(Rx<TextEditingController> controller) {
    controller.value.clear();
  }

  // to change the text of the controller
  void changeText(String newText, Rx<TextEditingController> controller) {
    final selection = controller.value.selection;

    // Set the new text
    controller.value.text = newText;

    // Restore the selection
    controller.value.selection = selection;
  }

  void toggleTextVisibility() {
    isTextVisible.value = !isTextVisible.value;
  }

  // Select birthday
  void selectBirthday(DateTime date) {
    selectedBirthday.value = date;
  }

  // Select languages
  void selectLanguages(List<String> languages) {
    selectedLanguages.value = languages;
  }

  // form validation
  void submitForm() async {
    isRequesting.value = true;
    if (formKey.currentState!.validate() &&
        calculateAge(selectedBirthday.value) > 14) {
      // Form is valid, perform submission
      Uri uri = Uri.https(apiUrl, volReg); // Adjust the API endpoint
      try {
        var response = await ns.postRequest(uri, {
          'userName': unameController.value.text,
          'password': passController.value.text,
          'birthday': selectedBirthday.value.toIso8601String(),
          'languages': selectedLanguages.join(', '),
          'firstName': firstNameController.value.text,
          'lastName': lastNameController.value.text,
          'email': emailController.value.text,
          'gender': selectedGender.value == 'female',
          // Add other fields as needed
        });

        if (response.statusCode == 200) {
          print('Form submitted');
          await ns.postRequest(Uri.https(apiUrl, login), {
            'userName': unameController.value.text,
            'password': passController.value.text,
          });
          isRequesting.value = false;
          Get.offNamed('/home');
        } else {
          print('Form submission failed');
          errorMessage.value = response.data;
          isRequesting.value = false;
        }
      } catch (e) {
        print(e);
        isRequesting.value = false;
      }
    } else {
      // Form is not valid

      print('Form is not valid');
      isRequesting.value = false;
    }
  }
}
