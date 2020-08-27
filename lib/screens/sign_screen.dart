import 'package:flutter/material.dart';

import '../widgets/sign_widget.dart';
import '../widgets/barcode_widget.dart';

class SignScreen extends StatelessWidget {

  static const routeName = '/sign';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign'),
      ),
      body: BarcodeScanner(), //Sign(),
    );
  }
}