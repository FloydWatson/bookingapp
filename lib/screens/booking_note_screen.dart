import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/notes.dart';

import '../widgets/app_drawer.dart';
import '../widgets/note_item.dart';

import '../screens/edit_note_screen.dart';

import '../helpers/note_args.dart';

class BookingNotesScreen extends StatelessWidget {
  static const routeName = '/booking-notes';

  Future<void> _refreshNotes(BuildContext context, String bookingId) async {
    await Provider.of<Notes>(context, listen: false)
        .fetchAndSetNotes(bookingId);
  }

  @override
  Widget build(BuildContext context) {
    final bookingId = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        title: const Text('Session Notes'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditNoteScreen.routeName,
                  arguments: NoteArgs(null, bookingId));
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _refreshNotes(context, bookingId),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => _refreshNotes(
                    context, bookingId), // wrapped in anon func to pass context
                // wrapping with consumer so we do not enter a continuous loop
                child: Consumer<Notes>(
                  builder: (ctx, noteData, _) => Padding(
                    padding: EdgeInsets.all(16),
                    child: noteData.notes.length == 0
                        ? Center(
                            child: Text('You have no notes for this booking'),
                          )
                        : ListView.builder(
                            itemCount: noteData.notes.length,
                            itemBuilder: (_, i) => Column(
                              children: [
                                NoteItem(
                                  noteData.notes[i].id,
                                  noteData.notes[i].bookingId,
                                  noteData.notes[i].title,
                                  noteData.notes[i].body,
                                ),
                                // add booking Item
                                Divider(),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
      ),
    );
  }
}
