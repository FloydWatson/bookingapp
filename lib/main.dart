import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart';

import './screens/auth_screen.dart';
import './screens/splash_screen.dart';

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
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Booking App',
          theme: ThemeData(
            primarySwatch: Colors.yellow,
            accentColor: Colors.purple,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth ? Home() : FutureBuilder(
                // check to see if user is still valid from last session. if it is auth will notify and it will push products overview. otherwise auth screen will be pushed
                      future: auth.tryAutoLogin(),
                      builder: (ctx, authResultSnapshot) =>
                          authResultSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen(),
                    ),
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
