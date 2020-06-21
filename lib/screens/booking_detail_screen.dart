import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/bookings.dart';
import '../providers/hs_forms.dart';

import '../widgets/app_drawer.dart';

import '../screens/booking_note_screen.dart';
import '../screens/edit_hs_form.dart';

import '../helpers/hs_form_args.dart';

class BookingDetailScreen extends StatefulWidget {
  static const routeName = '/booking-detail';

  @override
  _BookingDetailScreenState createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {

  var _isInit = true;

  @override
  void didChangeDependencies() async {
    if(_isInit){
      var bookingId = ModalRoute.of(context).settings.arguments as String;
      await Provider.of<HSForms>(context, listen: false).fetchAndSetHSForms(bookingId);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bookingId = ModalRoute.of(context).settings.arguments as String;
    final loadedBooking = Provider.of<Bookings>(context, listen: false)
        .findBookingById(bookingId);
    final hsForms = Provider.of<HSForms>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
          Navigator.of(context).pop();
        }),
        title: Text("${loadedBooking.clientName}'s session"),
      ),
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
              'Session with ${loadedBooking.clientName}',
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
                'Session address ${loadedBooking.bookingAddress}',
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            Divider(),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              child: Text('Health and Safety Form'),
              onPressed: () {
                Navigator.of(context).pushNamed(EditHSFormScreen.routeName, arguments: HSFormArgs(hsForms.getIdIfExists(bookingId), bookingId));
              },
            ),
            Divider(),
            RaisedButton(
              child: Text('Session Notes'),
              onPressed: () {
                Navigator.of(context).pushNamed(BookingNotesScreen.routeName, arguments: bookingId);
              },
            ),
             
          ],
        ),
      ),
    );
  }
}
