import 'package:flutter/material.dart';
import 'package:soundboard_0/pages/homepage.dart';

import 'package:file_picker/file_picker.dart';
import 'dart:io';

class  SoundController {



   pickFile(context ) async  {



try {


FilePickerResult? result = await FilePicker.platform.pickFiles();

if (result != null) {
  File file = File(result.files.single.path!);
} else {

print("there wen't something wrong");

}

}

catch (e) {
  print(e);
ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Invalid file '+ e.toString() ),
              ),
);


}



   }

  //    Future<void>  uploadFile() {




      



  //  }


}