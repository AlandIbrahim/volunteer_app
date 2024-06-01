// import '../services/city.dart';
import 'dart:convert';

import 'package:volunteer_app/services/city.dart';

Event eventFromJson(String str) => Event.fromJson(json.decode(str));

// String eventToJson(Event data) => json.encode(data.toJson());

class Event {
  int id;
  String title;
  String description;
  int organizationId;
  String organization;
  City city;
  DateTime enrollmentDeadline;
  DateTime startDate;
  String duration;
  String status;
  String location;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.organizationId,
    required this.enrollmentDeadline,
    required this.location,
    required this.city,
    required this.duration,
    required this.organization,
    required this.startDate,
    required this.status,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        organizationId: json["orgId"],
        organization: json["organization"],
        enrollmentDeadline: DateTime.parse(json["enrollmentDeadline"]),
        startDate: DateTime.parse(json["startDate"]),
        location: json["location"],
        city: City.values[json["city"] - 1],
        duration: json['duration'],
        status: json['status'],
      );

  // Map<String, dynamic> toJson() => {
  //       "id": id,
  //       "title": title,
  //       "description": description,
  //       "organizationID": organizationId,
  //       "date": date.toIso8601String(),
  //       "location": location,
  //       "city": city,
  //     };
}

// List<Event> generateRandomEvents(int count) {
//   final List<String> titles = [
//     'Conference',
//     'Workshop',
//     'Seminar',
//     'Meeting',
//     'Webinar',
//   ];

//   final List<String> descriptions = [
//     'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
//     'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
//     'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
//     'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
//     'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
//   ];

//   final List<String> locations = [
//     'New York',
//     'Los Angeles',
//     'Chicago',
//     'Houston',
//     'Phoenix',
//     'Philadelphia',
//     'San Antonio',
//     'San Diego',
//     'Dallas',
//     'San Jose',
//   ];

//   final Random random = Random();

//   List<Event> events = [];
//   for (int i = 0; i < count; i++) {
//     Event event = Event(
//       id: i + 1,
//       title: titles[random.nextInt(titles.length)],
//       description: descriptions[random.nextInt(descriptions.length)],
//       organizationId: random.nextInt(1000),
//       date: DateTime.now().add(Duration(days: random.nextInt(30))),
//       location: locations[random.nextInt(locations.length)],
//       city: locations[random.nextInt(locations.length)],
//     );
//     events.add(event);
//   }

//   return events;
// }

class AllEventDTO {
  int id;
  String title;
  String organization;
  City city;
  String location;
  DateTime enrollTime;
  DateTime startDate;
  Duration time;

  AllEventDTO({
    required this.id,
    required this.title,
    required this.organization,
    required this.city,
    required this.location,
    required this.enrollTime,
    required this.startDate,
    required this.time,
  });

  factory AllEventDTO.fromJson(Map<String, dynamic> json) {
    List<String> timeParts = json["duration"].split(":");
    return AllEventDTO(
      id: json["id"],
      title: json["title"],
      organization: json["organization"],
      city: City.values[json["city"] - 1],
      location: json["location"],
      enrollTime: DateTime.parse(json["enrollmentDeadline"]),
      startDate: DateTime.parse(json["startDate"]),
      time: Duration(
        hours: int.parse(timeParts[0]),
        minutes: int.parse(
          timeParts[1],
        ),
      ),
    );
  }
}
