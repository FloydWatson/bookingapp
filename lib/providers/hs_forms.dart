import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/hs_form.dart';
import '../models/http_exception.dart';

class HSForms with ChangeNotifier {
  List<HSForm> _hsforms = [];

  final String authToken;
  final String userId;

  HSForms(
    this.authToken,
    this.userId,
    this._hsforms,
  );

  List<HSForm> get hsforms {
    return [..._hsforms];
  }

  HSForm findHSFormById(String hsformId) {
    return _hsforms.firstWhere((hsform) => hsform.id == hsformId);
  }

  String getIdIfExists(String bookingId) {
    final index = _hsforms.indexWhere((form) => form.bookingId == bookingId);
    return index >= 0 ? _hsforms[index].id : null;
  }

  Future<void> fetchAndSetHSForms(String bookingId) async {
    final filterString = 'orderBy="bookingId"&equalTo="$bookingId"';
    final url =
        'https://bookingapp-bc77c.firebaseio.com/hsforms.json?auth=$authToken&$filterString';

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null) {
        return;
      }

      final List<HSForm> loadedHSForms = [];
      extractedData.forEach((hsformId, hsformData) {
        loadedHSForms.add(HSForm(
          id: hsformId,
          bookingId: hsformData['bookingId'],
          rego: hsformData['rego'],
          licenceNumber: hsformData['licenceNumber'],
        ));
      });
      _hsforms = loadedHSForms;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addHSForm(HSForm hsform) async {
    final url =
        'https://bookingapp-bc77c.firebaseio.com/hsforms.json?auth=$authToken';

    try {
      final response = await http.post(url,
          body: json.encode(
            {
              'bookingId': hsform.bookingId,
              'rego': hsform.rego,
              'licenceNumber': hsform.licenceNumber
            },
          ));

      final newHSForm = HSForm(
        id: json.decode(response.body)['name'],
        bookingId: hsform.bookingId,
        rego: hsform.rego,
        licenceNumber: hsform.licenceNumber,
      );

      _hsforms.add(newHSForm);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateHSForm(String id, HSForm newHSForm) async {
    final hsformIndex = _hsforms.indexWhere((hsform) => hsform.id == id);
    if(hsformIndex >= 0){
      final url =
        'https://bookingapp-bc77c.firebaseio.com/hsforms/$id.json?auth=$authToken';

      await http.patch(url, body: json.encode(
        {
          'bookingId': newHSForm.bookingId,
          'rego': newHSForm.rego,
          'licenceNumber': newHSForm.licenceNumber
        }
      ));
      _hsforms[hsformIndex] = newHSForm;
      notifyListeners();
    }
  }

  Future<void> deleteHSForm(String id) async {
    final url =
        'https://bookingapp-bc77c.firebaseio.com/hsforms/$id.json?auth=$authToken';
    
    final existingHSFormIndex = _hsforms.indexWhere((hsform) => hsform.id == id);
    var existingHSForm = _hsforms[existingHSFormIndex];
    _hsforms.removeAt(existingHSFormIndex);
    final response = await http.delete(url);
    // optimistic updating. re add booking if it fails
    // custom error code check
    if(response.statusCode >=400){
      _hsforms.insert(existingHSFormIndex, existingHSForm);
      notifyListeners();
      // throw custom error - dart team discourages us from using Exception() class. instead we create one
      throw HttpException('Could not delete hsform.');
    }
    existingHSForm = null;
  }
}
