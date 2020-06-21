import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/note.dart';
import '../models/http_exception.dart';

class Notes with ChangeNotifier {
  List<Note> _notes = [];

  final String authToken;
  final String userId;

  Notes(
    this.authToken,
    this.userId,
    this._notes,
  );

  List<Note> get notes {
    return [..._notes];
  }

  Note findNoteById(String noteId) {
    return _notes.firstWhere((note) => note.id == noteId);
  }

  Future<void> fetchAndSetNotes(String bookingId) async {
    final filterString = 'orderBy="bookingId"&equalTo="$bookingId"';
    final url =
        'https://bookingapp-bc77c.firebaseio.com/notes.json?auth=$authToken&$filterString';

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null) {
        return;
      }

      final List<Note> loadedNotes = [];
      extractedData.forEach((noteId, noteData) {
        loadedNotes.add(Note(
          id: noteId,
          bookingId: noteData['bookingId'],
          title: noteData['title'],
          body: noteData['body'],
        ));
      });
      _notes = loadedNotes;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addNote(Note note) async {
    final url =
        'https://bookingapp-bc77c.firebaseio.com/notes.json?auth=$authToken';

    try {
      final response = await http.post(url,
          body: json.encode(
            {
              'bookingId': note.bookingId,
              'title': note.title,
              'body': note.body
            },
          ));

      final newNote = Note(
        id: json.decode(response.body)['name'],
        bookingId: note.bookingId,
        title: note.title,
        body: note.body,
      );

      _notes.add(newNote);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
