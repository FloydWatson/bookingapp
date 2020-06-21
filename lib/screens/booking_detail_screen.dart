import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/bookings.dart';

import '../widgets/app_drawer.dart';

class BookingDetailScreen extends StatelessWidget {
  static const routeName = '/booking-detail';

  @override
  Widget build(BuildContext context) {
    final bookingId = ModalRoute.of(context).settings.arguments as String;
    final loadedBooking = Provider.of<Bookings>(context, listen: false)
        .findBookingById(bookingId);

    return Scaffold(
      appBar: AppBar(
        title: Text("${loadedBooking.clientName}'s session"),
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: Hero(
                tag: loadedBooking.id,
                child: Image.asset(
                  'assets/images/weaveItMapImage.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'test',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                'test',
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
