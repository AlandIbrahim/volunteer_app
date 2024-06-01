import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volunteer_app/controllers/auth_controller.dart';
import 'package:volunteer_app/services/network.dart';
import '../services/api.dart';

class LoginPageController extends GetxController {
  var emailController = TextEditingController().obs;
  var passController = TextEditingController().obs;
  var isTextVisible = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var errorMessage = ''.obs;
  var isloading = false.obs;
  var token = ''.obs;
  NetworkService ns = NetworkService();

  AuthController authController = Get.put(AuthController());

  // Clear text
  void clearText(Rx<TextEditingController> controller) {
    controller.value.text = '';
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

  // form validation
  Future<bool> submitForm() async {
    isloading.value = true;
    if (formKey.currentState!.validate()) {
      // Form is valid, perform submission
      Uri uri = Uri.https(apiUrl, login);
      try {
        // var response = await http.post(
        //   uri,
        //   headers: <String, String>{
        //     'Content-Type': 'application/json; charset=UTF-8'
        //   },
        //   body: jsonEncode(<String, String>{
        //     'username': emailController.value.text,
        //     'password': passController.value.text,
        //   }),
        // );
        var response = await ns.postRequest(uri, {
          'username': emailController.value.text,
          'password': passController.value.text,
        });
        // print(response.headers);
        if (response?.statusCode == 200) {
          print('Form submitted');
          // print(response.body);

          authController.logIn();
          isloading.value = false;
          return true;
        } else {
          print('Form is not validdddd');
          // errorMessage.value = response?.body;
          isloading.value = false;
          return false;
        }
      } catch (e) {
        print(e);
        isloading.value = false;
        return false;
      }
    } else {
      // Form is not valid
      print('Form is not valid');
      isloading.value = false;
      return false;
    }
  }
}
