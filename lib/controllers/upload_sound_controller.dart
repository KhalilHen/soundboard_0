import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class SoundController {
  final supabase = Supabase.instance.client;

  Future<void> pickFile(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );

      if (result != null) {
        Uint8List? fileBytes = result.files.single.bytes;
        String fileName = result.files.single.name;

        if (fileBytes != null) {
          // Upload the file to the specified bucket
          final response = await supabase.storage.from('sounds').uploadBinary(
                'uploads/$fileName', // TODO Change this later into a fitting folder
                fileBytes,
              );

          // Check the response
          if (response.error == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('File uploaded successfully!'),
              ),
            );
          } else {
            throw Exception('Failed to upload file: ${response.error!.message}');
          }
        } else {
          throw Exception('File bytes are null.');
        }
      } else {
        throw Exception('No file selected.');
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

  // Future<void> pickFile(BuildContext context) async {
  //   try {
  //     FilePickerResult? result = await FilePicker.platform.pickFiles(
  //       // type: FileType.audio,
  //       type: FileType.any,
  //     );

  //     if (result != null && result.files.single.path != null) {

  //       String filePath = result.files.single.path!;

  //       String fileName = result.files.single.name;

  //       // Read the file
  //       File file = File(filePath);

  //       // Upload the file to the specified bucket
  //       final response = await supabase.storage.from('sounds').upload(
  //             'uploads/$fileName', // Path in the bucket
  //             file,
  //           );

  //       // Check the response
  //       if (response.error == null) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text('File uploaded successfully!'),
  //           ),
  //         );
  //       } else {
  //         throw Exception('Failed to upload file: ${response.error!.message}');
  //       }
  //     } else {
  //       throw Exception('No file selected.');
  //     }
  //   } catch (e) {
  //     print('Error during file upload: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error: $e'),
  //       ),
  //     );
  //   }
  // }

  // Future<void> pickFile(BuildContext context) async {
  //   try {
  //     FilePickerResult? result = await FilePicker.platform.pickFiles(
  //       // type: FileType.audio,
  //       type: FileType.any,
  //     );

  //     if (result != null && result.files.single.path != null) {
  //       final fileBytest = result.files.first.bytes;
  //       final fileName = result.files.first.name;

  //       await supabase.storage.from('sounds').upload(
  //             'uploads/$fileName', // Path in the bucket
  //             File.fromRawPath(fileBytest!),
  //           );
  //     }
  //   } catch (e) {
  //     print('Error during file upload: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error: $e'),
  //       ),
  //     );
  //   }
  // }
}

extension on String {
  get error => null;
}
