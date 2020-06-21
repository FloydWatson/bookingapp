import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Navigate To'),
            automaticallyImplyLeading: false,
          ),
          // Expanded(
          //   child: SingleChildScrollView(
          //     child: Padding(
          //       padding: EdgeInsets.all(10),
          //       child: Column(
          //         children: <Widget>[

          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          Divider(),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              // push to home route to run auth logic
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
