import 'package:bookingapp/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/bookings.dart';

import '../screens/edit_booking_screen.dart';

class UserBookingsScreen extends StatelessWidget {

  static const routeName = '/user-bookings';

  Future<void> _refreshBookings(BuildContext context) async {
    await Provider.of<Bookings>(context, listen: false).fetchAndSetBookings(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Bookings'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditBookingScreen.routeName);
            },
          ),
        ],
    
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshBookings(context),
        builder: (ctx, snapshot) =>
        snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshBookings(
                        context), // wrapped in anon func to pass context
                    // wrapping with consumer so we do not enter a continuous loop
                    child: Consumer<Bookings>(
                      builder: (ctx, bookingsData, _) => Padding(padding: EdgeInsets.all(16),
                        child: ListView.builder(
                          itemCount: bookingsData.bookings.length,
                          itemBuilder: (_, i) => Column(
                            children: [
                              Text('One Booking'),
                              Divider(),
                            ],
                          ),
                        ),),
                      ),
                ),
      ),
      
    );
  }
}