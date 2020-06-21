import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../screens/booking_detail_screen.dart';


class BookingItem extends StatelessWidget {
  final df = new DateFormat('dd-MM-yyyy hh:mm a');

  final String id;
  final String clientName;
  final String instructorName;
  final String bookingAddress;
  final DateTime dateTime;

  BookingItem(
    this.id,
    this.clientName,
    this.instructorName,
    this.bookingAddress,
    this.dateTime,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(BookingDetailScreen.routeName, arguments: id);
      },
      child: ListTile(
        leading: Hero(
          tag: id,
          child: Image.asset('assets/images/weaveItMapImage.png'),
        ),
        title: Text('$clientName'),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 5,
            ),
            Text('Address: $bookingAddress'),
            SizedBox(
              height: 5,
            ),
            Text('Date: ${df.format(dateTime)}'),
            
          ],
        ),
      ),
    );
  }
}
