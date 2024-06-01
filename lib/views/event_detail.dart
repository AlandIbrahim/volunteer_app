import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:volunteer_app/controllers/event_detail_controller.dart';

class EventDetailPage extends StatelessWidget {
  const EventDetailPage({super.key});

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
                          'https://picsum.photos/400/200',
                          height: 200.0,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Center(
                      child: Text(
                        event.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      'Organizer: ${event.organization}',
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontStyle: FontStyle.italic,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      children: [
                        const Icon(Icons.location_city, color: Colors.white70),
                        const SizedBox(width: 10.0),
                        Text(
                          event.city.name,
                          style: const TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.white70),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Text(
                            event.location,
                            style: const TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      children: [
                        const Icon(Icons.access_time, color: Colors.white70),
                        const SizedBox(width: 10.0),
                        Text(
                          '${event.startDate}',
                          style: const TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),
                    const Divider(color: Colors.white70),
                    const SizedBox(height: 20.0),
                    if (!controller.enrollable.value)
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
                              var starCol = (rating['self']??0)==0 ? Colors.amber : Colors.yellow;
                              List<double> ratingCounts = [
                                ((rating['counts']?['v'] ?? 0).toDouble() /((rating['counts']?['total'] ?? 1.0)==0?1.0:rating['counts']['total'])),
                                ((rating['counts']?['iv'] ?? 0).toDouble() /((rating['counts']?['total'] ?? 1.0)==0?1.0:rating['counts']['total'])),
                                ((rating['counts']?['iii'] ?? 0).toDouble() /((rating['counts']?['total'] ?? 1.0)==0?1.0:rating['counts']['total'])),
                                ((rating['counts']?['ii'] ?? 0).toDouble() /((rating['counts']?['total'] ?? 1.0)==0?1.0:rating['counts']['total'])),
                                ((rating['counts']?['i'] ?? 0).toDouble() /((rating['counts']?['total'] ?? 1.0)==0?1.0:rating['counts']['total'])),
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
