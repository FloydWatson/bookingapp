import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/notes.dart';

import '../widgets/app_drawer.dart';

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
        title: const Text('Session Notes'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigator.of(context).pushNamed(EditNoteScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshNotes(context, bookingId),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshNotes(
                      context,
                      bookingId
                    ), // wrapped in anon func to pass context
                    // wrapping with consumer so we do not enter a continuous loop
                    child: Consumer<Notes>(
                      builder: (ctx, noteData, _) => Padding(
                        padding: EdgeInsets.all(16),
                        child: ListView.builder(
                          itemCount: noteData.notes.length,
                          itemBuilder: (_, i) => Column(
                            children: [
                              Text('Note'),
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