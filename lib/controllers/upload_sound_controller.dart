import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:just_audio/just_audio.dart';

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

//   Future<List<String>> retrieveList(BuildContext context) async {
//     try {
//       final response = await supabase.storage.from('sounds').list(path: 'uploads');

//       List<String> urls = [];
//       for (var file in response) {
//         final url = supabase.storage.from('sounds').getPublicUrl('uploads/${file.name}');
//         urls.add(file.name); // Store just the filename
//       }
//       return urls;
//     } catch (e) {
//       print('Error during list retrieval: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error loading audio files: $e')),
//       );
//       return [];
//     }
//   }
// }

  // Future<List<String>> retrieveList(BuildContext context) async {
  //   try {
  //     final response = await supabase.storage.from('sounds').list(path: 'uploads');

  //     if (response.isEmpty) {
  //       print('No files found in storage');
  //       return [];
  //     }

  //     List<String> urls = [];
  //     for (var file in response) {
  //       try {
  //         // Get the public URL correctly
  //         String publicUrl = supabase.storage.from('sounds').getPublicUrl('uploads/${file.name}');

  //         print('Generated URL: $publicUrl'); // Debug print
  //         urls.add(publicUrl);
  //       } catch (e) {
  //         print('Error generating URL for ${file.name}: $e');
  //         continue;
  //       }
  //     }
  //     return urls;
  //   } catch (e) {
  //     print('Error during list retrieval: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error loading audio files: $e')),
  //     );
  //     return [];
  //   }
  // }
  Future<List<String>> retrieveList(BuildContext context) async {
    try {
      final response = await supabase.storage.from('sounds').list(path: 'uploads');

      if (response.isEmpty) {
        print('No files found in storage');
        return [];
      }

      List<String> urls = [];
      for (var file in response) {
        try {
          // Create a signed URL that will work for a period of time
          final signedUrl = await supabase.storage.from('sounds').createSignedUrl('uploads/${file.name}', 3600); // URL valid for 1 hour

          print('Generated signed URL: $signedUrl'); // Debug print
          urls.add(signedUrl);
        } catch (e) {
          print('Error generating URL for ${file.name}: $e');
          continue;
        }
      }
      return urls;
    } catch (e) {
      print('Error during list retrieval: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading audio files: $e')),
        );
      }
      return [];
    }
  }
}

extension on List<FileObject> {
  get error => null;
}

extension on String {
  get error => null;
}


// Future<void> getSongUrl() {



// }
