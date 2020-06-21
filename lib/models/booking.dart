import 'package:flutter/foundation.dart';

class Booking {
  final String id;
  final String clientName;
  final String instructorName;
  final String bookingAddress;
  final String clientId;
  final String instructorId;
  final DateTime dateTime;

  Booking({
    @required this.id,
    @required this.clientName,
    @required this.instructorName,
    @required this.bookingAddress,
    this.clientId,
    this.instructorId,
    this.dateTime,
  });
}
