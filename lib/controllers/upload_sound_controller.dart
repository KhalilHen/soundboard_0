import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:soundboard_0/auth/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:just_audio/just_audio.dart';

class SoundController {
  final supabase = Supabase.instance.client;
  final authService = AuthService();
  Uint8List? _fileBytes;
  String? _fileName;

  Future<void> pickFile(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        withData: true,
      );

      if (result != null) {
        _fileName = result.files.single.name;
        _fileBytes = result.files.single.bytes ?? await File(result.files.single.path!).readAsBytes();

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

  Future<void> uploadFile(BuildContext context, String name, String description) async {
    final user = await authService.getLoggedInUser();
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please log in to upload files.'),
        ),
      );
      Navigator.pop(context);
      return;
    }
    if (_fileBytes == null || _fileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No file selected for upload.'),
        ),
      );
      return;
    }

    try {
      print(name);
      print(user);
      // print(filePath);
      print(_fileName);

      final tableResponse = await supabase.from('sound').insert([
        {
          'title': name,
          'description': description,
          'user_id': user,
          'file_path': _fileName,
        }
      ]).select();

      if (tableResponse.error != null) {
        throw Exception('Failed to insert record: ${tableResponse.error!.message}');
      }
     
      final response = await supabase.storage.from('sounds').uploadBinary(
            'uploads/${user}/${name}/${_fileName}',
            _fileBytes!,
          );

      if (response.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File uploaded successfully!'),
          ),
        );
        Navigator.pop(context);
      } else {
        Navigator.pop(context);

        throw Exception('Failed to upload file: ${response.error!.message}');
      }
    } catch (e) {
      print('Error during file upload: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
      Navigator.pop(context);
    }
  }

  Future<List<Map<String, String>>> retrieveList(BuildContext context) async {
    try {
      final user = await authService.getLoggedInUser();
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please log in to upload files.'),
          ),
        );
        return [];
      }

      final response = await supabase.from('sound').select().eq('user_id', user);

      if (response.isEmpty) {
        print('No files found in database');
        return [];
      }

      List<Map<String, String>> files = [];
      for (var record in response) {
        try {
          final fileName = record['file_path'];
          final id = record['id'];
          final title = record['title'];
          final description = record['description'];
          final whenCreated = record['created_at'];
          // final fileDetails =  title = record['title'], description = record['description'];

          // final signedUrl = await supabase.storage.from('sounds').createSignedUrl('uploads/${user}/${fileName}', 3600); // URL valid for 1 hour

          final signedUrl = await supabase.storage.from('sounds').createSignedUrl('uploads/${user}/${title}/${fileName}', 3600); // URL valid for 1 hour

          print('Generated signed URL: $signedUrl'); // Debug print
          files.add({'title': title, 'url': signedUrl, 'description': description, 'id': id, 'file_path': fileName, 'created_at': whenCreated});
        } catch (e) {
          print('Error generating URL for ${record['file_path']}: $e');
          continue;
        }
      }
      return files;
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

  Future<void> deleteSong(id, path, userId, title) async {
    if (id != null || id.isEmpty) {
      print("No sound found to delete");
    }

    try {
      print("the path" + path);
      print('Attempting to delete sound with ID: $id');
      final response = await supabase.from('sound').delete().eq('id', id);
      print(response);
      if (response.error != null) {
        throw Exception('Failed to delete record: ${response.error!.message}');
      } else {
        //try here to delete also in the storage

        try {
          //TODO Work here later on doesn't work yet

          final folderPath = 'uploads/$userId/$title';

          final listResponse = await supabase.storage.from('sounds').list(path: folderPath);

          if (listResponse.error != null) {
            throw Exception('Failed to list files: ${listResponse.error!.message}');
          }

          final filePaths = listResponse.map((file) => '$folderPath/${file.name}').toList();

          if (filePaths.isEmpty) {
            print('No files found in the folder to delete.');
          } else {
            // Delete all files
            final deleteResponse = await supabase.storage.from('sounds').remove(filePaths);

            if (deleteResponse.error != null) {
              throw Exception('Failed to delete files: ${deleteResponse.error!.message}');
            }

            print('Folder and its files deleted successfully.');
          }

          print('Sound deleted successfully');
        } catch (e) {
          print('There went something wrong with deleting the file from the bucket: $e');
        }

        print('Sound deleted successfully');
      }
    } catch (e) {
      print('Error during sound deletion: $e');
    }
  }
}

extension on List<FileObject> {
  get error => null;
}

extension on PostgrestList {
  get error => null;
}

extension on String {
  get error => null;
}
