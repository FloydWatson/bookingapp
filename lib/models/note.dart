import 'package:flutter/foundation.dart';

class Note {
  final String id;
  final String bookingId;
  final String title;
  final String body;

  Note({
    @required this.id,
    @required this.bookingId,
    this.title,
    this.body,
  });
}
