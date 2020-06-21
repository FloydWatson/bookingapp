import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';

import '../providers/notes.dart';

import '../helpers/note_args.dart';

class EditNoteScreen extends StatefulWidget {
  static const routeName = '/edit-note';

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final _bodyFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  var _editedNote = Note(
    id: null,
    bookingId: null,
    title: '',
    body: '',
  );

  var _initValues = {
    'title': '',
    'body': '',
  };

  var _isInit = true;
  var _isLoading = false;

  @override
  void dispose() {
    _bodyFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // add focus node
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final NoteArgs args = ModalRoute.of(context).settings.arguments;
      if (args.noteId != null) {
        _editedNote = Provider.of<Notes>(context, listen: false)
            .findNoteById(args.noteId);
        _initValues = {
          'title': _editedNote.title,
          'body': _editedNote.body,
        };
      } else {
        _editedNote = Note(
          id: null,
          bookingId: args.bookingId,
          title: '',
          body: '',
        );
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
    if (_editedNote.id != null) {
      // add update method
      await Provider.of<Notes>(context, listen: false)
          .updateNote(_editedNote.id, _editedNote);
    } else {
      try {
        await Provider.of<Notes>(context, listen: false).addNote(_editedNote);
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
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_bodyFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a title.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedNote = Note(
                          id: _editedNote.id,
                          bookingId: _editedNote.bookingId,
                          title: value,
                          body: _editedNote.body,
                        );
                      },
                    ),
                    TextFormField(
                      maxLines: 10,
                      initialValue: _initValues['body'],
                      decoration: InputDecoration(labelText: 'Body'),
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a body.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedNote = Note(
                          id: _editedNote.id,
                          bookingId: _editedNote.bookingId,
                          title: _editedNote.title,
                          body: value,
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
