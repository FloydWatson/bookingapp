
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../screens/edit_booking_screen.dart';

import '../providers/bookings.dart';

class UserBookingItem extends StatelessWidget {

  final df = new DateFormat('dd-MM-yyyy hh:mm a');

  final String id;
  final String clientName;
  final String instructorName;
  final String bookingAddress;
  final DateTime dateTime;

  UserBookingItem(
    this.id,
    this.clientName,
    this.instructorName,
    this.bookingAddress,
    this.dateTime,
  );

  @override
  Widget build(BuildContext context) {
    // scaffold will not work inside of future below so we have to set it as a final withing the build method. That way it is always known what scaffold is being used within catch block for snack bar
    final scaffold = Scaffold.of(context);

    return ListTile(
      title: Text('Client: $clientName'),
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
          Text('Date: ${df.format(dateTime)}')
        ],
      ),
      
      // leading: Icon(Icons.bookmark),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditBookingScreen.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  await Provider.of<Bookings>(context, listen: false)
                      .deleteBooking(id);
                } catch (error) {
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text(
                        'Deleting failed!',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
