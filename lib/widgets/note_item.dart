import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_note_screen.dart';

import '../providers/notes.dart';

import '../helpers/note_args.dart';

class NoteItem extends StatelessWidget {

  final String id;
  final String bookingId;
  final String title;
  final String body;

  NoteItem(this.id, this.bookingId, this.title, this.body);


  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);

    return ListTile(
      title: Text('$title'),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 5,
          ),
          Text('$body'),
        ],
      ),
      
      // leading: Icon(Icons.bookmark),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditNoteScreen.routeName, arguments: NoteArgs(id, bookingId));
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  await Provider.of<Notes>(context, listen: false)
                      .deleteNote(id);
                } catch (error) {
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text(
                        'Deleting failed!',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}