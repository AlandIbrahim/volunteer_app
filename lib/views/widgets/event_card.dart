import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:get/get.dart';
import 'package:volunteer_app/controllers/event_card_controller.dart';
import 'package:volunteer_app/services/network.dart';
// import 'package:flutter/material.dart';

import '../../models/event.dart';

class EventCard extends StatelessWidget {
  final AllEventDTO event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    EventCardController controller = Get.put(EventCardController());
    const TextStyle btnStyle = const TextStyle(color: Colors.white);
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
              color: controller.fromStatus(event.status),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        event.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                      Row(
                        children: [
                          if(event.status.contains('Live')) 
                              const Icon(Icons.circle, color: Colors.red, size: 16),
                          Text(event.status)
                        ]
                      )
                    ]
                  ),
                  const SizedBox(height: 8),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Get.toNamed('/event/${event.id}');
                        },
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                          const Color(0xff4080aa),
                        )),
                        child: const Text('Details', style: btnStyle),
                      ),
                      if (NetworkService.isOrg) ...[
                        if(NetworkService.uid==event.oid)...[
                        ElevatedButton(
                          onPressed: () {
                            Get.toNamed('/event/edit/${event.id}');
                          },
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(const Color(0xffaa7710),
                          )),
                          child: const Text('Edit', style: btnStyle),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            // popup confirmation:
                            Get.defaultDialog(
                              title: 'Cancel Event',
                              middleText:
                                  'Are you sure you want to delete this event?',
                              textConfirm: 'Yes',
                              textCancel: 'No',
                              backgroundColor: Colors.teal[50],
                              confirmTextColor: Colors.white,
                              buttonColor: const Color(0xffAA1F00),
                              cancelTextColor: Colors.black,
                              onConfirm: () async {
                                try {
                                  await controller.deleteEvent(event.id);
                                } on DioException catch (e) {
                                  Get.close(1);
                                  if (e.response?.data.toString().contains('Not the owner') ??false)
                                    Get.snackbar('Not allowed','You cannot delete other\'s events',backgroundColor: Color.fromARGB(150, 255, 0, 0));
                                  else
                                    Get.snackbar('Error', 'Failed to delete event');
                                }
                              },
                              onCancel: () => Get.close(1),
                            );
                          },
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                            const Color(0xffAA1F00),
                          )),
                          child: const Text('Cancel', style: btnStyle),
                        ),]
                      ] else ...[
                        if(event.status.contains('enroll'))
                        ElevatedButton(
                          onPressed: () {
                            Get.toNamed('/event/${event.id}');
                          },
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                            Colors.green,
                          )),
                          child: const Text('Unenroll', style: btnStyle),
                        ) else if(event.status.contains('upcoming')) ElevatedButton(
                          onPressed: () {
                            Get.toNamed('/event/${event.id}');
                          },
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                            Colors.green,
                          )),
                          child: const Text('Enroll', style: btnStyle),
                        )
                      ]
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
