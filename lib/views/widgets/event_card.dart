import 'dart:ui';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:get/get.dart';
import 'package:volunteer_app/controllers/event_card_controller.dart';
// import 'package:flutter/material.dart';

import '../../models/event.dart';

class EventCard extends StatelessWidget {
  final AllEventDTO event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    EventCardController controller = Get.put(EventCardController());

    return Obx(() {
      var distance = controller.isPressed.value
          ? const Offset(10, 10)
          : const Offset(28, 28);
      double blur = controller.isPressed.value ? 5.0 : 30.0;
      return GestureDetector(
        onTap: () {
          controller.onPress();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color(0xFFE7ECEF),
              boxShadow: [
                BoxShadow(
                  blurRadius: blur,
                  offset: -distance,
                  color: Colors.white,
                  inset: controller.isPressed.value,
                ),
                BoxShadow(
                  blurRadius: blur,
                  offset: distance,
                  color: Color(0xFFA7A9AF),
                  inset: controller.isPressed.value,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Image.network(
                    'https://picsum.photos/400/200',
                    height: 200,
                    width: 400,
                    fit: BoxFit.fill,
                  ),
                  const SizedBox(height: 8),
                  // Text(
                  //   event.description,
                  //   style: const TextStyle(fontSize: 16),
                  // ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        'Date: ',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${event.startDate}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Location: ',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${event.location}, ${event.city.toString().split('.')[1]}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Get.toNamed('/event/${event.id}');
                        },
                        child: const Text('Open Event'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
