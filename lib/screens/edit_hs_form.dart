import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/hs_form.dart';

import '../providers/hs_forms.dart';

import '../helpers/hs_form_args.dart';

class EditHSFormScreen extends StatefulWidget {
  static const routeName = '/edit-hs-form';

  @override
  _EditHSFormScreenState createState() => _EditHSFormScreenState();
}

class _EditHSFormScreenState extends State<EditHSFormScreen> {
  final _licenceNumberFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  var _editedHSForm = HSForm(
    id: null,
    bookingId: null,
    rego: '',
    licenceNumber: '',
  );

  var _initValues = {
    'rego': '',
    'licenceNumber': '',
  };

  var _isInit = true;
  var _isLoading = false;

  @override
  void dispose() {
    _licenceNumberFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // add focus node
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      final HSFormArgs args = ModalRoute.of(context).settings.arguments;
      if (args.hsformId != null) {
        // await Provider.of<HSForms>(context, listen: false).fetchAndSetHSForms(args.bookingId);
        _editedHSForm = Provider.of<HSForms>(context, listen: false)
            .findHSFormById(args.hsformId);
        _initValues = {
          'rego': _editedHSForm.rego,
          'licenceNumber': _editedHSForm.licenceNumber,
        };
      } else {
        _editedHSForm = HSForm(
          id: null,
          bookingId: args.bookingId,
          rego: '',
          licenceNumber: '',
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
    if (_editedHSForm.id != null) {
      // add update method
      await Provider.of<HSForms>(context, listen: false)
          .updateHSForm(_editedHSForm.id, _editedHSForm);
    } else {
      try {
        await Provider.of<HSForms>(context, listen: false).addHSForm(_editedHSForm);
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
        title: Text('Edit HSForm'),
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
                      initialValue: _initValues['rego'],
                      decoration: InputDecoration(labelText: 'Registration Number'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_licenceNumberFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a rego.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedHSForm = HSForm(
                          id: _editedHSForm.id,
                          bookingId: _editedHSForm.bookingId,
                          rego: value,
                          licenceNumber: _editedHSForm.licenceNumber,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['licenceNumber'],
                      decoration: InputDecoration(labelText: 'Licence Number'),
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a Licence Number.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedHSForm = HSForm(
                          id: _editedHSForm.id,
                          bookingId: _editedHSForm.bookingId,
                          rego: _editedHSForm.rego,
                          licenceNumber: value,
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
