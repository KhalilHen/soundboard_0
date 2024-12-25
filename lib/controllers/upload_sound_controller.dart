import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SoundController {
  final supabase = Supabase.instance.client;
  Uint8List? _fileBytes;
  String? _fileName;

  Future<void> pickFile(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );

      if (result != null) {
        _fileBytes = result.files.single.bytes;
        _fileName = result.files.single.name;

        if (_fileBytes != null && _fileName != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('File selected: $_fileName'),
            ),
          );
        } else {
          throw Exception('File bytes or name are null.');
        }
      } else {
        throw Exception('No file selected.');
      }
    } catch (e) {
      print('Error during file selection: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  Future<void> uploadFile(BuildContext context) async {
    if (_fileBytes == null || _fileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No file selected for upload.'),
        ),
      );
      return;
    }

    try {
      final response = await supabase.storage.from('sounds').uploadBinary(
            'uploads/$_fileName', // TODO Change this later into a fitting path
            _fileBytes!,
          );

      if (response.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File uploaded successfully!'),
          ),
        );
      } else {
        throw Exception('Failed to upload file: ${response.error!.message}');
      }
    } catch (e) {
      print('Error during file upload: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  // Future<int> retrieveList(BuildContext context) async {
  //   try {
  //     final response = await supabase.storage.from('sounds').list();

  //     if (response.error == null) {
  //       return response.length;

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('List retrieved successfully!'),
  //         ),
  //       );
  //     } else {
  //       return throw Exception('Failed to retrieve list: ${response.error!.message}');
  //     }
  //   } catch (e) {
  //     print('Error during list retrieval: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error: $e'),
  //       ),
  //     );
  //     return 0;
  //   }
  // }

  Future<int> retrieveList(BuildContext context) async {
    try {
      // final response = await supabase.storage.from('sounds').list();
      final response = await supabase.storage.from('sounds').list(path: 'uploads');

      if (response != null) {
        print(response.length);
        return response.length; // Return the count of items
      } else {
        throw Exception('Failed to retrieve list: ${response.error!.message}');
      }
    } catch (e) {
      print('Error during list retrieval: $e');
      return 0; // Return 0 if an error occurs
    }
  }
}

extension on List<FileObject> {
  get error => null;
}

extension on String {
  get error => null;
}
