import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volunteer_app/controllers/navigation_controller.dart';

class MyNavigationBar extends StatelessWidget {
  final NavigationBarController controller =
      Get.put(NavigationBarController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Theme(
          data: Theme.of(context).copyWith(
            // Copy the current theme and update only the BottomNavigationBar theme
            canvasColor: Colors.teal, // Set background color
          ),
          child: BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: (index) => controller.changePage(index),
            // backgroundColor: Colors.black, // Set background color
            selectedItemColor: Colors.white, // Set selected item color
            unselectedItemColor: Colors.grey[400],
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ));
  }
}
