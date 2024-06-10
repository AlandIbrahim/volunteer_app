import 'package:flutter/material.dart';
import 'package:volunteer_app/services/network.dart';

import '../../services/api.dart';

class SelectSkillsDialog extends StatelessWidget {
  static Future InitSkills() async {
    var skillFetch=await NetworkService().getRequest(Uri.https(apiUrl,'skill/'));
    skills={for (var skill in skillFetch.data) skill['name']: skill['id']};
  }
  final List<String> initialSelectedValues;
  static Map<String,int> skills={};
  const SelectSkillsDialog({Key? key, required this.initialSelectedValues})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> selectedValues = List.from(initialSelectedValues);

    return AlertDialog(
      title: const Text('Select skills'),
      content: SingleChildScrollView(
        child: ListBody(
          children: SelectSkillsDialog.skills.keys.map((String skill) {
            return CheckboxListTile(
              title: Text(skill),
              value: selectedValues.contains(skill),
              onChanged: (bool? value) {
                if (value == true) {
                  selectedValues.add(skill);
                } else {
                  selectedValues.remove(skill);
                }
              },
            );
          }).toList()
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(initialSelectedValues),
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
