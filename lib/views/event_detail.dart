import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:volunteer_app/controllers/event_detail_controller.dart';

import '../services/api.dart';

class EventDetailPage extends StatelessWidget {
  const EventDetailPage({super.key});
  static const TextStyle fieldStyle= const TextStyle(
    fontSize: 20.0,
    color: Colors.white,
    shadows: [
      Shadow(
        color: Colors.black,
        blurRadius: 2.0,
        offset: Offset(1, 1),
      ),
    ]
  );
  @override
  Widget build(BuildContext context) {
    final EventController controller = Get.find();

    return Obx(() {
      var event = controller.event.value;
      switch (controller.isLoading.value) {
        case true:
          return Scaffold(
            appBar: AppBar(
              backgroundColor: controller.bgColor1.value,
              
              elevation: 0,
            ),
            body: const Center(
                child: CircularProgressIndicator(
              color: Colors.grey,
            )),
          );
        default:
          return Scaffold(
            appBar: AppBar(
              backgroundColor: controller.bgColor1.value,
              title: Text(event.title, style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black87,
                    blurRadius: 2.0,
                    offset: Offset(1.0, 1.0),
                  ),
                ]
                )),
              elevation: 0,
            ),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    controller.bgColor1.value,
                    controller.bgColor2.value
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.network(
                          Uri.https(apiUrl,'event/download/${event.id}').toString(),
                          errorBuilder: (context, error, stackTrace) => SizedBox(height:8),),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      'Organizer: ${event.organization}',
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontStyle: FontStyle.italic,
                        color: Colors.white70,
                        shadows: [
                          Shadow(
                            color: Colors.black45,
                            blurRadius: 2.0,
                            offset: Offset(1.0, 1.0),
                          ),]
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      event.description,
                      maxLines: 5,
                      style: fieldStyle,
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.white70),
                        const SizedBox(width: 10.0),
                        Text("${event.location}, ${event.city.name}",style: fieldStyle,),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    const Text('Enrollment ends on: ',style: fieldStyle),
                    Text('${
                        event.enrollmentDeadline.toString().split(' ')[0]
                      } at around ${
                        event.enrollmentDeadline.toString().split(' ')[1].split(':')[0]
                      }:${
                        event.enrollmentDeadline.toString().split(' ')[1].split(':')[1]
                      }',
                      style: fieldStyle.copyWith(
                        decoration: (
                          event.status.contains('Enrollment deadline Passed')||
                          event.status.contains('Ended'))?TextDecoration.lineThrough:TextDecoration.none,
                        decorationColor: Colors.white,
                        decorationThickness: 3.0,
                    )),
                    const SizedBox(height: 20.0),
                    const Text('Event starts on: ',style: fieldStyle),
                    Text('${
                        event.startDate.toString().split(' ')[0]
                      } at around ${
                        event.startDate.toString().split(' ')[1].split(':')[0]
                      }:${
                        event.startDate.toString().split(' ')[1].split(':')[1]
                      }',
                      style: fieldStyle.copyWith(
                          decoration: event.status.contains('Ended')?TextDecoration.lineThrough:TextDecoration.none,
                          decorationColor: Colors.white,
                          decorationThickness: 3.0,
                        ),
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      children: [
                        const SizedBox(height: 20.0),
                        const Text('Duration: ',style: fieldStyle),
                        Text('${event.duration.split(':')[0]}h ${event.duration.split(':')[1]}m',style: fieldStyle)
                      ]
                    ),
                    const SizedBox(height: 30.0),
                    const Divider(color: Colors.white70),
                    const SizedBox(height: 20.0),
                    if (controller.enrollable.value)
                      ElevatedButton(
                        onPressed: () {
                          if (controller.enrolled.value) {
                            controller.unenroll();
                          } else {
                            controller.enroll();
                          }
                        },
                        child: Text(
                            controller.enrolled.value ? 'Unenroll' : 'Enroll'),
                      )
                    else
                      if(controller.ratingVisible.value)
                      Center(
                        child: Column(
                          children: [
                            const Text('This event has already passed.',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                )),
                            //if(controller.ratingEnabled.value)
                            Obx(() {
                              var rating = controller.rating;
                              var total=rating['counts']?['total']==null?1.0:rating['counts']!['total'];
                              var starCol = (rating['self']??0)==0 ? Colors.amber : Colors.yellow;
                              List<double> ratingCounts = [
                                ((rating['counts']?['v'] ?? 0).toDouble() /total),
                                ((rating['counts']?['iv'] ?? 0).toDouble() /total),
                                ((rating['counts']?['iii'] ?? 0).toDouble() /total),
                                ((rating['counts']?['ii'] ?? 0).toDouble() /total),
                                ((rating['counts']?['i'] ?? 0).toDouble() /total),
                              ];
                              return Column(
                                children: [
                                  if(controller.ratingUnlocked.value)
                                      RatingBar(
                                      ratingWidget: RatingWidget(
                                          full: Icon(Icons.star, color: starCol),
                                          half: Icon(Icons.star_half,color: starCol),
                                          empty: Icon(Icons.star_border,color: starCol)),
                                      onRatingUpdate: (value)=>controller.PostRating(value.toInt()),
                                      allowHalfRating: true,
                                      minRating: 1,
                                      initialRating: ((rating['self']??0)==0?(controller.averageRating()):rating['self']).toDouble(),
                                    )
                                    else IgnorePointer(
                                      child: RatingBar(
                                      ratingWidget: RatingWidget(
                                          full: Icon(Icons.star, color: starCol),
                                          half: Icon(Icons.star_half,color: starCol),
                                          empty: Icon(Icons.star_border,color: starCol)),
                                      onRatingUpdate: (value)=>controller.PostRating(value.toInt()),
                                      allowHalfRating: true,
                                      minRating: 1,
                                      initialRating: ((rating['self']??0)==0?(controller.averageRating()):rating['self']).toDouble(),
                                    ),),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: ColoredBox(
                                      color: const Color.fromARGB(100, 0, 0, 0),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 8, 0, 8),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      8, 0, 8, 0),
                                                  child: Text(
                                                    '5',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16.0),
                                                  ),
                                                ),
                                                Expanded(
                                                    child:
                                                        LinearProgressIndicator(
                                                  value: ratingCounts[0],
                                                  backgroundColor: Colors.white,
                                                  valueColor:
                                                      const AlwaysStoppedAnimation<
                                                          Color>(Colors.amber),
                                                )),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 0, 8, 0),
                                                  child: SizedBox(
                                                    width: 60,
                                                    child: Text(
                                                      '${(ratingCounts[0] * 100).toInt()}%',
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16.0),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      8, 0, 8, 0),
                                                  child: Text(
                                                    '4',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16.0),
                                                  ),
                                                ),
                                                Expanded(
                                                    child:
                                                        LinearProgressIndicator(
                                                  value: ratingCounts[1],
                                                  backgroundColor: Colors.white,
                                                  valueColor:
                                                      const AlwaysStoppedAnimation<
                                                          Color>(Colors.amber),
                                                )),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 0, 8, 0),
                                                  child: SizedBox(
                                                    width: 60,
                                                    child: Text(
                                                      '${(ratingCounts[1] * 100).toInt()}%',
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16.0),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      8, 0, 8, 0),
                                                  child: Text(
                                                    '3',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16.0),
                                                  ),
                                                ),
                                                Expanded(
                                                    child:
                                                        LinearProgressIndicator(
                                                  value: ratingCounts[2],
                                                  backgroundColor: Colors.white,
                                                  valueColor:
                                                      const AlwaysStoppedAnimation<
                                                          Color>(Colors.amber),
                                                )),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 0, 8, 0),
                                                  child: SizedBox(
                                                    width: 60,
                                                    child: Text(
                                                      '${(ratingCounts[2] * 100).toInt()}%',
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16.0),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      8, 0, 8, 0),
                                                  child: Text(
                                                    '2',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16.0),
                                                  ),
                                                ),
                                                Expanded(
                                                    child:
                                                        LinearProgressIndicator(
                                                  value: ratingCounts[3],
                                                  backgroundColor: Colors.white,
                                                  valueColor:
                                                      const AlwaysStoppedAnimation<
                                                          Color>(Colors.amber),
                                                )),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 0, 8, 0),
                                                  child: SizedBox(
                                                    width: 60,
                                                    child: Text(
                                                      '${(ratingCounts[3] * 100).toInt()}%',
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16.0),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      8, 0, 8, 0),
                                                  child: Text(
                                                    '1',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16.0),
                                                  ),
                                                ),
                                                Expanded(
                                                    child:
                                                        LinearProgressIndicator(
                                                  value: ratingCounts[4],
                                                  backgroundColor: Colors.white,
                                                  valueColor:
                                                      const AlwaysStoppedAnimation<
                                                          Color>(Colors.amber),
                                                )),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 0, 8, 0),
                                                  child: SizedBox(
                                                    width: 60,
                                                    child: Text(
                                                      '${(ratingCounts[4] * 100).toInt()}%',
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16.0),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            }),
                          ],
                        ),
                      )
                  ],
                ),
              ),
            ),
          );
      }
    });
  }
}
