import 'dart:ffi';

class Feedback {
  final int fromID;
  final int toID;
  final Int8 rating;
  final String? comment;

  Feedback({
    required this.fromID,
    required this.toID,
    required this.rating,
    this.comment,
  });
}
