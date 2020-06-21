import 'package:flutter/foundation.dart';

class HSForm {
  final String id;
  final String bookingId;
  final String rego;
  final String licenceNumber;

  HSForm({
    @required this.id,
    @required this.bookingId,
    this.rego,
    this.licenceNumber,
  });

}