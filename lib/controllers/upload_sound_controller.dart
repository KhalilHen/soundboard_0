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
}

extension on String {
  get error => null;
}
