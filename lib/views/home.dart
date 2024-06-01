import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volunteer_app/controllers/home_controller.dart';
import 'package:volunteer_app/services/network.dart';
import 'package:volunteer_app/views/widgets/navigtion_bar.dart';
import 'package:volunteer_app/views/widgets/event_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find();
    ScrollController _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !homeController.isLoadingMore.value) {
        homeController.fetchData(page: homeController.currentPage.value + 1);
      }
    });

    return Scaffold(
      appBar: AppBar(
        
        leading: NetworkService.isOrg? IconButton(
          onPressed: () {
            Get.toNamed('/event/host');
          },
          icon: const Icon(Icons.add, color: Colors.white),
        ):null,
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      bottomNavigationBar: MyNavigationBar(),
      body: Obx(() {
        if (homeController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.teal,
            ),
          );
        } else {
          if (homeController.serverAvailable.value) {
            return Container(
              color: Colors.white,
              child: RefreshIndicator(
                onRefresh: () async {
                  homeController.currentPage.value = 1;
                  homeController.fetchData(page: 1);
                },
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: homeController.isLoadingMore.value
                      ? homeController.events.length + 1
                      : homeController.events.length,
                  itemBuilder: (context, index) {
                    if (index == homeController.events.length) {
                      // Show bottom loading indicator
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.teal,
                        ),
                      );
                    }
                    var event = homeController.events[index];
                    return Column(
                      children: [
                        EventCard(event: event),
                        const SizedBox(
                          height: 40,
                        )
                      ],
                    );
                  },
                ),
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Failed to connect, please try again'),
                  TextButton(
                    child: const Text('Try Again'),
                    onPressed: () => homeController.fetchData(),
                  )
                ],
              ),
            );
          }
        }
      }),
    );
  }
}
