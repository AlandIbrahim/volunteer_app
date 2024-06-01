import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volunteer_app/controllers/volunteer_register_controller.dart';

class VolunteerRegister extends StatelessWidget {
  const VolunteerRegister({super.key});

  @override
  Widget build(BuildContext context) {
    VolRegisterController controller = Get.put(VolRegisterController());

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
                  controller: controller.firstNameController.value,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    controller.changeText(
                        value, controller.firstNameController);
                  },
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    prefixIcon: const Icon(Icons.person),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        controller.clearText(controller.firstNameController);
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
              // Last Name
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controller.lastNameController.value,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    controller.changeText(value, controller.lastNameController);
                  },
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    prefixIcon: const Icon(Icons.person),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        controller.clearText(controller.lastNameController);
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
                  obscureText: !controller.isTextVisible.value,
                  onChanged: (value) {
                    controller.changeText(
                        value, controller.passConfirmController);
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: controller.selectedBirthday.value,
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      // Update selected birthday
                      controller.selectBirthday(pickedDate);
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: TextEditingController(
                        text: "${controller.selectedBirthday.value.toLocal()}"
                            .split(' ')[0],
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Birthday',
                        prefixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a date';
                        }
                        if (controller.calculateAge(
                                controller.selectedBirthday.value) <
                            15) {
                          return 'You must be at least 15 years old';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () async {
                    List<String>? pickedLanguages = await showDialog(
                        context: context,
                        builder: (BuildContext context) => SelectLanguageDialog(
                            initialSelectedValues:
                                controller.selectedLanguages));
                    if (pickedLanguages != null) {
                      // Update selected languages
                      controller.selectLanguages(pickedLanguages);
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: TextEditingController(
                        text: controller.selectedLanguages.isNotEmpty
                            ? controller.selectedLanguages.join(', ')
                            : '', // Display an empty string if no languages are selected
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Languages',
                        prefixIcon: Icon(Icons.language),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (controller.selectedLanguages.isEmpty) {
                          return 'Please select at least one language';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Obx(() => DropdownButton<String>(
                          value: controller.selectedGender.value,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              controller.setSelectedGender(newValue);
                            }
                          },
                          items: controller.genders.map((String gender) {
                            return DropdownMenuItem<String>(
                              value: gender,
                              child: Text(gender),
                            );
                          }).toList(),
                        )),
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
                      : () async => controller.submitForm(),
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

class SelectLanguageDialog extends StatefulWidget {
  final List<String> initialSelectedValues;

  const SelectLanguageDialog({super.key, required this.initialSelectedValues});

  @override
  // ignore: library_private_types_in_public_api
  _SelectLanguageDialogState createState() => _SelectLanguageDialogState();
}

class _SelectLanguageDialogState extends State<SelectLanguageDialog> {
  List<String> _selectedValues = [];
  final List<String> _allLanguages = [
    'Kurdish',
    'Arabic',
    'English',
    'Persian',
    'Turkish',
    'Other'
    // Add more languages as needed
  ];

  @override
  void initState() {
    super.initState();
    _selectedValues = List.from(widget.initialSelectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Languages'),
      content: SingleChildScrollView(
        child: ListBody(
          children: _allLanguages.map((language) {
            return CheckboxListTile(
              value: _selectedValues.contains(language),
              title: Text(language),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (bool? isChecked) {
                setState(() {
                  if (isChecked != null) {
                    if (isChecked) {
                      _selectedValues.add(language);
                    } else {
                      _selectedValues.remove(language);
                    }
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop(_selectedValues);
          },
        ),
      ],
    );
  }
}
