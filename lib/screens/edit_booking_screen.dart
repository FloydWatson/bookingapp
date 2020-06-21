import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/booking.dart';

import '../providers/bookings.dart';

class EditBookingScreen extends StatefulWidget {
  static const routeName = '/edit-booking';

  @override
  _EditBookingScreenState createState() => _EditBookingScreenState();
}

class _EditBookingScreenState extends State<EditBookingScreen> {
  final _instructorNameFocusNode = FocusNode();
  final _bookingAddressFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  var _editedBooking = Booking(
    id: null,
    clientName: '',
    instructorName: '',
    bookingAddress: '',
    clientId: '',
    instructorId: '',
    dateTime: null,
  );

  var _initValues = {
    'clientName': '',
    'instructorName': '',
    'bookingAddress': '',
  };

  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // add focus node
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final bookingId = ModalRoute.of(context).settings.arguments as String;
      if (bookingId != null) {
        _editedBooking = Provider.of<Bookings>(context, listen: false)
            .findBookingById(bookingId);
        _initValues = {
          'clientName': _editedBooking.clientName,
          'instructorName': _editedBooking.instructorName,
          'bookingAddress': _editedBooking.bookingAddress,
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedBooking.id != null) {
      // add update method
      await Provider.of<Bookings>(context, listen: false)
          .updateBooking(_editedBooking.id, _editedBooking);
    } else {
      try {
        await Provider.of<Bookings>(context, listen: false)
            .addBooking(_editedBooking);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    }
    // set state pop can be moved from finally as above will only pass after everyting required has been awaited
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['clientName'],
                      decoration: InputDecoration(labelText: 'Client Name'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_instructorNameFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a name.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedBooking = Booking(
                          id: _editedBooking.id,
                          clientName: value,
                          instructorName: _editedBooking.instructorName,
                          bookingAddress: _editedBooking.bookingAddress,
                          clientId: _editedBooking.clientId,
                          instructorId: _editedBooking.instructorId,
                          dateTime: _editedBooking.dateTime,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['instructorName'],
                      decoration: InputDecoration(labelText: 'Instructor Name'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_bookingAddressFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a name.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedBooking = Booking(
                          id: _editedBooking.id,
                          clientName: _editedBooking.clientName,
                          instructorName: value,
                          bookingAddress: _editedBooking.bookingAddress,
                          clientId: _editedBooking.clientId,
                          instructorId: _editedBooking.instructorId,
                          dateTime: _editedBooking.dateTime,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['bookingAddress'],
                      decoration: InputDecoration(labelText: 'Booking Address'),
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a address.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedBooking = Booking(
                          id: _editedBooking.id,
                          clientName: _editedBooking.clientName,
                          instructorName: _editedBooking.instructorName,
                          bookingAddress: value,
                          clientId: _editedBooking.clientId,
                          instructorId: _editedBooking.instructorId,
                          dateTime: _editedBooking.dateTime,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
