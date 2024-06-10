import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volunteer_app/controllers/auth_controller.dart';
import 'package:volunteer_app/controllers/event_detail_controller.dart';
import 'package:volunteer_app/controllers/event_edit_controller.dart';
import 'package:volunteer_app/controllers/event_host_controller.dart';
import 'package:volunteer_app/controllers/home_controller.dart';
import 'package:volunteer_app/controllers/login_page_controller.dart';
import 'package:volunteer_app/controllers/my_events_controller.dart';
import 'package:volunteer_app/controllers/search_controller.dart';
import 'package:volunteer_app/services/network.dart';
import 'package:volunteer_app/views/event_edit.dart';
import 'package:volunteer_app/views/home.dart';
import 'package:volunteer_app/views/event_host.dart';
import 'package:volunteer_app/views/login.dart';
import 'package:volunteer_app/views/register.dart';
import 'package:volunteer_app/views/search.dart';
import 'package:volunteer_app/views/my_events.dart';
import 'package:volunteer_app/views/profile.dart';
import 'package:volunteer_app/views/widgets/skill_select_dialog.dart';

import 'views/event_detail.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Future nsInit= NetworkService.initUser();
  Future skillsInit= SelectSkillsDialog.InitSkills();
  runApp(const MyApp());
  await nsInit;
  await skillsInit;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.circularReveal,
      title: 'Volunteer',
      initialRoute: '/home',
      getPages: [
        GetPage(
          name: '/profile',
          page: () => ProfilePage(),
          binding: BindingsBuilder(
            () {
              Get.lazyPut<AuthController>(() {
                return AuthController();
              });
            },
          ),
        ),
        GetPage(
          name: '/login',
          page: () => const LoginPage(),
          bindings: [
            BindingsBuilder(() {
              Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
            }),
            BindingsBuilder(() {
              Get.lazyPut<LoginPageController>(() => LoginPageController());
            })
          ],
        ),
        GetPage(
          name: '/register',
          page: () => RegistrationPage(),
          binding: BindingsBuilder(
            () {
              Get.lazyPut(() => null);
            },
          ),
        ),
        GetPage(
          name: '/home',
          page: () => const HomePage(),
          binding: BindingsBuilder(
            () {
              Get.lazyPut<HomeController>(() => HomeController());
            },
          ),
        ),
        GetPage(
            name: '/event/host',
            page: () => const EventHost(),
            binding: BindingsBuilder(
              () {
                Get.lazyPut<EventHostController>(() => EventHostController());
              },
            )),
        GetPage(
          name: '/event/:id',
          page: () => const EventDetailPage(),
          binding: BindingsBuilder(() {
            Get.lazyPut<EventController>(() => EventController());
          }),
        ),
        GetPage(name: '/event/edit/:id',
        page: ()=>const EventEdit(),
        binding: BindingsBuilder(() {
          Get.lazyPut<EventEditController>(() => EventEditController());
        })
        ),
        GetPage(
          name: '/search',
          page: () => const SearchPage(),
          binding: BindingsBuilder(
            () {
              Get.lazyPut<SearchPageController>(() => SearchPageController());
            },
          ),
        ),
        GetPage(
          name: '/myevents',
          page: () => const MyEventsPage(),
          binding: BindingsBuilder(
            () {
              Get.lazyPut<MyEventsController>(() => MyEventsController());
            },
          ),
        ),
      ],
    );
  }
}
