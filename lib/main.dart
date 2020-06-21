import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart';
import './providers/bookings.dart';
import './providers/notes.dart';
import './providers/hs_forms.dart';

import './screens/auth_screen.dart';
import './screens/splash_screen.dart';
import './screens/user_bookings_screen.dart';
import './screens/edit_booking_screen.dart';
import './screens/booking_overview_screen.dart';
import './screens/booking_detail_screen.dart';
import './screens/booking_note_screen.dart';
import './screens/edit_note_screen.dart';
import './screens/edit_hs_form.dart';

import './widgets/app_drawer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Bookings>(
          create: (ctx) => Bookings(
            '',
            '',
            [],
          ),
          update: (ctx, auth, previousBookings) => Bookings(
            auth.token,
            auth.userId,
            previousBookings == null ? [] : previousBookings.bookings,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Notes>(
          create: (ctx) => Notes(
            '',
            '',
            [],
          ),
          update: (ctx, auth, previousNotes) => Notes(
            auth.token,
            auth.userId,
            previousNotes == null ? [] : previousNotes.notes,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, HSForms>(
          create: (ctx) => HSForms(
            '',
            '',
            [],
          ),
          update: (ctx, auth, previousHSForms) => HSForms(
            auth.token,
            auth.userId,
            previousHSForms == null ? [] : previousHSForms.hsforms,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Booking App',
          theme: ThemeData(
            primarySwatch: Colors.yellow,
            accentColor: Colors.purple,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth
              ? BookingOverviewScreen()
              : FutureBuilder(
                  // check to see if user is still valid from last session. if it is auth will notify and it will push bookings overview. otherwise auth screen will be pushed
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
                routes: {
                  UserBookingsScreen.routeName: (ctx) => UserBookingsScreen(),
                  EditBookingScreen.routeName: (ctx) => EditBookingScreen(),
                  BookingDetailScreen.routeName: (ctx) => BookingDetailScreen(),
                  BookingNotesScreen.routeName: (ctx) => BookingNotesScreen(),
                  EditNoteScreen.routeName: (ctx) => EditNoteScreen(),
                  EditHSFormScreen.routeName: (ctx) => EditHSFormScreen(),

                },
        ),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generic Booking Company'),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Text('App Body'),
      ),
    );
  }
}
