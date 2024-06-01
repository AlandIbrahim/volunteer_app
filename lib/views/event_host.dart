import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:volunteer_app/controllers/event_host_controller.dart';
import 'package:volunteer_app/services/city.dart';
import 'package:volunteer_app/services/network.dart';
import 'package:volunteer_app/views/widgets/organization_register.dart';

class EventHost extends StatelessWidget {
  const EventHost({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    EventHostController controller = Get.put(EventHostController());
    return Scaffold(
        appBar: AppBar(
          title: const Text('Host your event',
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: Colors.teal,
        ),
        body: Obx(() => Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: controller.titleController.value,
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter a title' : null,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.title),
                          suffixIcon: IconButton(
                              onPressed: () =>
                                  controller.titleController.value.clear(),
                              icon: const Icon(Icons.clear)),
                        ),
                        onChanged: (value) =>
                            controller.titleController.value.text = value,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: controller.descriptionController.value,
                        validator: (value) => value!.isEmpty
                            ? 'Please enter a description'
                            : null,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.description),
                          suffixIcon: IconButton(
                              onPressed: () => controller
                                  .descriptionController.value
                                  .clear(),
                              icon: const Icon(Icons.clear)),
                        ),
                        onChanged: (value) =>
                            controller.descriptionController.value.text = value,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: controller.locationController.value,
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter a location' : null,
                        decoration: InputDecoration(
                          labelText: 'Location',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.location_on),
                          suffixIcon: IconButton(
                              onPressed: () =>
                                  controller.locationController.value.clear(),
                              icon: const Icon(Icons.clear)),
                        ),
                        onChanged: (value) =>
                            controller.locationController.value.text = value,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<int>(
                        items: controller.cities,
                        onChanged: (value) => controller
                            .selectedCity.value.text = value.toString(),
                        value: int.tryParse(controller.selectedCity.value.text),
                        decoration: InputDecoration(
                          labelText: 'City',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.location_city),
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text('Enrollment deadline',
                            style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () async {
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now()
                                        .add(const Duration(days: 365)),
                                  );
                                  if (picked != null)
                                    controller
                                        .setEnrollmentDeadlineDate(picked);
                                },
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    controller: TextEditingController(
                                        text: controller
                                            .selectedEnrollmentDeadlineDate),
                                    decoration: InputDecoration(
                                      labelText: 'Enrollment ends on',
                                      border: const OutlineInputBorder(),
                                      prefixIcon: const Icon(Icons.date_range),
                                    ),
                                  ),
                                ),
                              )),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () async {
                                final TimeOfDay? picked = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (picked != null)
                                  controller.setEnrollmentDeadlineTime(picked);
                              },
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: TextEditingController(
                                      text: controller
                                          .selectedEnrollmentDeadlineTime),
                                  decoration: InputDecoration(
                                    labelText: 'Enrollment ends at',
                                    border: const OutlineInputBorder(),
                                    prefixIcon: const Icon(Icons.access_time),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child:
                            Text('Event start', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () async {
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now()
                                        .add(const Duration(days: 365)),
                                  );
                                  if (picked != null)
                                    controller.setStartDate(picked);
                                },
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    controller: TextEditingController(
                                        text: controller.selectedStartDate),
                                    decoration: InputDecoration(
                                      labelText: 'Event starts on',
                                      border: const OutlineInputBorder(),
                                      prefixIcon: const Icon(Icons.date_range),
                                    ),
                                  ),
                                ),
                              )),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () async {
                                final TimeOfDay? picked = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (picked != null)
                                  controller.setStartTime(picked);
                              },
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: TextEditingController(
                                      text: controller.selectedStartTime),
                                  decoration: InputDecoration(
                                    labelText: 'Event starts at',
                                    border: const OutlineInputBorder(),
                                    prefixIcon: const Icon(Icons.access_time),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text('Duration', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                onChanged: (value) => controller.durationHours
                                    .value = int.tryParse(value) ?? 0,
                                decoration: InputDecoration(
                                  labelText: 'Hours',
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.timer),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                keyboardType: TextInputType.numberWithOptions(
                                    signed: false, decimal: false),
                              )),
                        ),
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            onChanged: (value) => controller.durationMinutes
                                .value = int.tryParse(value) ?? 0,
                            decoration: InputDecoration(
                              labelText: 'Minutes',
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.timer),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.numberWithOptions(
                                signed: false, decimal: false),
                          ),
                        ))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) return 'Please enter a number';
                            int? valNum = int.tryParse(value);
                            if (valNum == null) return 'Please enter a number';
                            if (valNum == 0)
                              return 'At least 1 volunteer has to be present';
                            return null;
                          },
                          onChanged: (value) => controller
                              .maxAttendeesController
                              .value = int.tryParse(value) ?? -1,
                          decoration: const InputDecoration(
                              labelText: 'Max attendees',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.group),
                              helperText:
                                  'leave empty to remove attendee limit'),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.deny('-'),
                          ],
                          keyboardType: const TextInputType.numberWithOptions(
                              signed: false, decimal: false),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () async =>
                            controller.selectedSkills.value = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SelectSkillsDialog(
                                        initialSelectedValues:
                                            controller.selectedSkills.toList(),
                                      );
                                    }) ??
                                controller.selectedSkills.toList(),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: TextEditingController(
                              text: controller.selectedSkills.isNotEmpty
                                  ? controller.selectedSkills.join(', ')
                                  : '',
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Skills',
                              prefixIcon: Icon(Icons.star),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (controller.formKey.currentState!.validate()) {
                            await controller.submit();
                            Get.back();
                          }
                        },
                        child: const Text('Host event'),
                      ),
                    ),
                  ]),
            ))));
  }
}

class SelectSkillsDialog extends StatefulWidget {
  final List<String> initialSelectedValues;
  const SelectSkillsDialog({Key? key, required this.initialSelectedValues})
      : super(key: key);
  static List<String> skills = [];
  @override
  _SelectSkillsDialogState createState() => _SelectSkillsDialogState();
}

class _SelectSkillsDialogState extends State<SelectSkillsDialog> {
  List<String> selectedValues = [];
  @override
  void initState() {
    selectedValues = List.from(widget.initialSelectedValues);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select skills'),
      content: SingleChildScrollView(
          child: ListBody(
        children: SelectSkillsDialog.skills.map((String skill) {
          return CheckboxListTile(
            title: Text(skill),
            value: selectedValues.contains(skill),
            onChanged: (bool? value) {
              setState(() {
                if (value != null) {
                  if (value) {
                    selectedValues.add(skill);
                  } else {
                    selectedValues.remove(skill);
                  }
                }
              });
            },
          );
        }).toList(),
      )),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.of(context).pop(widget.initialSelectedValues),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(selectedValues),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
