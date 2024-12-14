import 'package:flutter/material.dart';

class UploadSoundForm extends StatefulWidget {
  @override
  _UploadSoundFormState createState() => _UploadSoundFormState();
}

class _UploadSoundFormState extends State<UploadSoundForm> {



  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Upload Sound'),
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Sound Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a sound name';
                }
                return null;
              },
             
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Sound File Path'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a sound file path';
                }
                return null;
              },
             
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
      onPressed: null,
          child: Text('Upload'),
        ),
      ],
    );
  }
}