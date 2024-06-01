import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volunteer_app/controllers/my_events_controller.dart';
import 'package:volunteer_app/views/widgets/event_card.dart';
import 'package:volunteer_app/views/widgets/navigtion_bar.dart';

class MyEventsPage extends StatelessWidget {
  const MyEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    MyEventsController controller = Get.find();
    ScrollController _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !controller.isLoadingMore.value) {
        controller.fetchData(page: controller.currentPage.value + 1);
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.to('/events/1');
          },
          icon: const Icon(Icons.abc),
        ),
        title: const Text(
          'My events',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      bottomNavigationBar: MyNavigationBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.teal,
            ),
          );
        } else {
          if (controller.serverAvailable.value) {
            return Container(
              color: Colors.white,
              child: RefreshIndicator(
                onRefresh: () async {
                  controller.currentPage.value = 1;
                  controller.fetchData(page: 1);
                },
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: controller.isLoadingMore.value
                      ? controller.events.length + 1
                      : controller.events.length,
                  itemBuilder: (context, index) {
                    if (index == controller.events.length) {
                      // Show bottom loading indicator
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.teal,
                        ),
                      );
                    }
                    var event = controller.events[index];
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
                    onPressed: () => controller.fetchData(),
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
