import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volunteer_app/controllers/login_page_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    LoginPageController controller = Get.put(LoginPageController());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.offNamed('/home');
          },
          icon: const Icon(Icons.close),
        ),
      ),
      body: Obx(
        () => Form(
          key: controller.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controller.emailController.value,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    controller.changeText(value, controller.emailController);
                  },
                  decoration: InputDecoration(
                    labelText: 'UserName',
                    prefixIcon: const Icon(Icons.email),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        controller.clearText(controller.emailController);
                      },
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controller.passController.value,
                  validator: (value) {
                    if (controller.passController.value.text.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (controller.passController.value.text.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                  obscureText: !controller.isTextVisible.value,
                  onChanged: (value) {
                    controller.changeText(value, controller.passController);
                  },
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(controller.isTextVisible.value
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        controller.toggleTextVisibility();
                      },
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (controller.errorMessage != '')
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(color: Colors.red),
                ),
              ElevatedButton(
                onPressed: controller.isloading.value
                    ? null
                    : () async {
                        await controller.submitForm();
                      },
                child: const Text('Login'),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () => Get.offNamed('/register'),
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
