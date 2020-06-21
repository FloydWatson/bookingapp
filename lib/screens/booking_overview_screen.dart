import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/bookings.dart';

import '../widgets/app_drawer.dart';

class BookingOverviewScreen extends StatefulWidget {

  // use if not home
  // static const routeName = '/booking-overview';

  @override
  _BookingOverviewScreenState createState() => _BookingOverviewScreenState();
}

class _BookingOverviewScreenState extends State<BookingOverviewScreen> {

  var _isInit = true;
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Overview'),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Text('Booking Overview'),
      ),
      
    );
  }
}