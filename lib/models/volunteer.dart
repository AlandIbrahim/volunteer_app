import 'dart:ffi';
import '../services/city.dart';

class Volunteer {
  final int id;
  final String? userName;
  final String firstName;
  final String lastName;
  final Int8 age;
  final bool gender; // true for women, false for men
  // final bool kycIsPassport; // true for passport, false for national id
  // final bool kycTextVerified;
  // final bool kycPhotoVerified;
  // final bool kycSelfieVerified;
  final List<String> languages;
  final City city;

  Volunteer({
    required this.id,
    this.userName,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.gender,
    // required this.kycIsPassport,
    // required this.kycTextVerified,
    // required this.kycPhotoVerified,
    // required this.kycSelfieVerified,
    required this.languages,
    required this.city,
  });
}

class Profile {
  final String uid;
  final String userName;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  String fullName() => (lastName??'')==''?(firstName??''):"$firstName $lastName";
  final String? birthDate;
  final bool? gender;
  final City? city;
  final bool? isGov;
  Profile({
    required this.uid,
    required this.userName,
    this.firstName,
    this.middleName,
    this.lastName,
    this.birthDate,
    this.gender,
    this.city,
    this.isGov,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      firstName: json["firstName"]??json['name'],
      middleName: json["middleName"],
      lastName: json["lastName"],
      birthDate: json["year"],
      userName: json["userName"],
      gender: json["gender"],
      city: City.values[json["city"]??1 - 1],
      uid: json['uid'],
      isGov: json['isGov'],
    );
  }
}
