import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volunteer_app/controllers/organization_register_controller.dart';

class OrganizationRegister extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    OrgRegisterController controller = Get.put(OrgRegisterController());

    return Obx(
      () => Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controller.unameController.value,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    controller.changeText(value, controller.unameController);
                  },
                  decoration: InputDecoration(
                    labelText: 'UserName',
                    prefixIcon: const Icon(Icons.person),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        controller.clearText(controller.unameController);
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
              // First Name
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controller.nameController.value,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your organization\'s name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    controller.changeText(
                        value, controller.nameController);
                  },
                  decoration: InputDecoration(
                    labelText: 'Organization Name',
                    prefixIcon: const Icon(Icons.person),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        controller.clearText(controller.nameController);
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
                  controller: controller.emailController.value,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    controller.changeText(value, controller.emailController);
                  },
                  decoration: InputDecoration(
                    labelText: 'Email',
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
                  obscureText: !controller.isPassVisible.value,
                  onChanged: (value) {
                    controller.changeText(value, controller.passController);
                  },
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(controller.isPassVisible.value
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controller.passConfirmController.value,
                  validator: (value) {
                    if (value != controller.passController.value.text) {
                      return 'Password should match';
                    }
                    return null;
                  },
                  obscureText: !controller.isPassVisible.value,
                  onChanged: (value) {
                    controller.changeText(
                        value, controller.passConfirmController);
                  },
                  decoration: InputDecoration(
                    labelText: 'Repeat Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(controller.isPassVisible.value
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controller.addressController.value,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your organization\'s physical address';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    controller.changeText(value, controller.addressController);
                  },
                  decoration: InputDecoration(
                    labelText: 'Address',
                    prefixIcon: const Icon(Icons.library_books_outlined),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        controller.clearText(controller.addressController);
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
                  controller: controller.businessLicenseController.value,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your organization\'s business license number';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    controller.changeText(value, controller.businessLicenseController);
                  },
                  decoration: InputDecoration(
                    labelText: 'Business License',
                    prefixIcon: const Icon(Icons.library_books_outlined),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        controller.clearText(controller.businessLicenseController);
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text('Is Governmental?', style: TextStyle(fontSize: 16)),
                    Checkbox(
                      value: controller.isGovController.value,
                      onChanged: (value) => controller.isGovController.value = value!,
                    )
                  ],
                ),
              ),
              if (controller.errorMessage.isNotEmpty)
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(color: Colors.red),
                ),
              ElevatedButton(
                onPressed: controller.isRequesting.value
                    ? null
                    : () async {
                        controller.submitForm();
                      },
                child: const Text('Register'),
              ),
              TextButton(
                onPressed: () => Get.offNamed('/login'),
                child: const Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
