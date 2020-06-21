import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/booking.dart';
import '../models/http_exception.dart';

class Bookings with ChangeNotifier {
  // list of bookings
  List<Booking> _bookings = [];

  // logged in users details
  final String authToken;
  final String userId;

  Bookings(
    this.authToken,
    this.userId,
    this._bookings,
  );

  // return all bookings
  List<Booking> get bookings {
    return [..._bookings];
  }

  // get booking by id
  Booking findBookingById(String bookingId) {
    return _bookings.firstWhere((booking) => booking.id == bookingId);
  }

  Future<void> fetchAndSetBookings([bool filterByUser = false]) async {
    final filterString = filterByUser ? 'orderBy="instructorId"&equalTo="$userId"' : '';
    final url = 'https://bookingapp-bc77c.firebaseio.com/products.json?auth=$authToken&$filterString';

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      // return if no bookings exist. this is to stop nulls having for each called
      if (extractedData == null) {
        return;
      }

      final List<Booking> loadedBookings = [];
      extractedData.forEach((bookingId, bookingData) { 
        loadedBookings.add(Booking(
          id: bookingId,
          clientName: bookingData['clientName'],
          instructorName: bookingData['instructorName'],
          bookingAddress: bookingData['bookingAddress'],
          clientId: bookingData['clientId'],
          instructorId: bookingData['instructorId'],
          dateTime: DateTime.parse(bookingData['dateTime'])

        ));
      });

      _bookings = loadedBookings;
      notifyListeners();

    } catch (error) {
      throw (error);
    }
  }

  Future<void> addBooking(Booking booking) async {
    final url =
        'https://bookingapp-bc77c.firebaseio.com/bookings.json?auth=$authToken'; // ?auth=$authToken // add when auth req
    final testTimeStamp = DateTime.now().add(Duration(days: 7));

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'clientName': booking.clientName,
            'instructorName': booking.instructorName,
            'bookingAddress': booking.bookingAddress,
            'clientId': 'testBookingClientId',
            'instructorId': userId,
            'dateTime': testTimeStamp.toIso8601String()
          },
        ),
      );

      final newBooking = Booking(
          id: json.decode(response.body)['name'],
          clientName: booking.clientName,
          instructorName: booking.instructorName,
          bookingAddress: booking.bookingAddress,
          clientId: 'testBookingClientId',
          instructorId: userId,
          dateTime: testTimeStamp);

      _bookings.add(newBooking);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteBooking(String id) async {
    final url = 'https://bookingapp-bc77c.firebaseio.com/bookings/$id.json?auth=$authToken';
    // copying original to use as a fail safe
    final existingBookingIndex = _bookings.indexWhere((booking) => booking.id == id);
    var existingBooking = _bookings[existingBookingIndex];
    _bookings.removeAt(existingBookingIndex);
    notifyListeners();
    final response = await http.delete(url);
    // optimistic updating. re add booking if it fails
    // custom error code check
    if (response.statusCode >= 400) {
      _bookings.insert(existingBookingIndex, existingBooking);
      notifyListeners();
      // throw custom error - dart team discourages us from using Exception() class. instead we create one
      throw HttpException('Could not delete booking.');
    }
    existingBooking = null;
  }
}
