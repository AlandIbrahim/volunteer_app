import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:volunteer_app/services/network.dart';
import '../services/api.dart';

class OrgRegisterController extends GetxController {
  var unameController = TextEditingController().obs;
  var emailController = TextEditingController().obs;
  var phoneController = TextEditingController().obs;
  var nameController = TextEditingController().obs;
  var addressController = TextEditingController().obs;
  var passController = TextEditingController().obs;
  var passConfirmController = TextEditingController().obs;
  var businessLicenseController = TextEditingController().obs;
  var isGovController= false.obs;
  var isPassVisible = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var errorMessage = ''.obs;
  var isRequesting = false.obs;
  NetworkService ns = NetworkService();
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
    isPassVisible.value = !isPassVisible.value;
  }
  // form validation
  void submitForm() async {
    isRequesting.value = true;
    if (formKey.currentState!.validate()) {
      // Form is valid, perform submission
      Uri uri = Uri.https(apiUrl, orgReg); // Adjust the API endpoint
      try {
        var response = await ns.postRequest(uri, {
          'userName': unameController.value.text,
          'password': passController.value.text,
          'name': nameController.value.text,
          'email': emailController.value.text,
          'isGovernmental': isGovController.value,
          'address': addressController.value.text,
          'businessLicense': businessLicenseController.value.text,
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
