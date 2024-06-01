import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volunteer_app/controllers/registration_controller.dart';

import 'widgets/organization_register.dart';
import 'widgets/volunteer_register.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage>
    with SingleTickerProviderStateMixin {
  final RegistrationController registrationController =
      Get.put(RegistrationController());
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        registrationController.changeTab(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Volunteer'),
            Tab(text: 'Organization'),
          ],
        ),
      ),
      body: Obx(() {
        if (registrationController.selectedTab.value == 0) {
          return VolunteerRegister();
        } else {
          return OrganizationRegister();
        }
      }),
    );
  }
}
