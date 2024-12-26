import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../controllers/upload_sound_controller.dart';

class UploadSoundForm extends StatefulWidget {
  @override
  _UploadSoundFormState createState() => _UploadSoundFormState();
}

class _UploadSoundFormState extends State<UploadSoundForm> {
  final soundController = SoundController();

  final nameController = TextEditingController();
//  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Upload Sound'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // TextFormField(
            //   controller: nameController,
            //   decoration: InputDecoration(labelText: 'Sound Name'),
            //   validator: (value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Please enter a sound name';
            //     }
            //     return null;
            //   },
            // ), TODO Temporarily removed  as not yet implented
            // TextFormField(
            //   decoration: InputDecoration(labelText: 'Sound File Path'),
            //   validator: (value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Please enter a sound file path';
            //     }
            //     return null;
            //   },

            // ),
            ElevatedButton(
                onPressed: () {
                  // soundController.uploadSound(nameController.text, 'sound file path');
                  soundController.pickFile(context);
                },
                child: Text('Select Sound File')),
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
          onPressed: () {
            soundController.uploadFile(context);
          },
          child: Text('Upload'),
        ),
      ],
    );
  }
}
