import 'dart:async';

import 'package:flutter/material.dart';
import 'package:soundboard_0/auth/auth_service.dart';
import 'package:soundboard_0/controllers/homepage_controler..dart';
import 'package:soundboard_0/controllers/login_controller.dart';
import 'package:soundboard_0/controllers/upload_sound_controller.dart';
import '../dialogs/upload_sound_dialog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:soundboard_0/pages/login.dart';

import 'package:just_audio/just_audio.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final supabase = Supabase.instance.client;

  final authService = AuthService();
  final homepageController = HomePageController();
  final loginController = LoginController();
  final soundController = SoundController();
  int? itemCount;
  String? errorMessage;
  final player = AudioPlayer(); // Create a player
  List<Map<String, String>> audioFiles = [];

  bool isPlaying = false;
  String? currentlyPlayingUrl;

  @override
  void initState() {
    super.initState();

    _loadItems(); // Fetch data when the widget initializes

    player.playerStateStream.listen((state) {
      if (mounted) {
        
        setState(() {
          isPlaying = state.playing;
        });
        if (state.processingState == ProcessingState.completed) {
          print('Song completed');
          // player.stop();
          isPlaying = false;
          currentlyPlayingUrl = null;
        }
      }
    });
  }


  Future<void> handlePlayPause(String url) async {
    try {
      print('Attempting to play/pause: $url'); // Debug print

      if (currentlyPlayingUrl == url) {
        if (isPlaying) {
          await player.pause();
          print('Paused current track');
        } else {
          await player.play();
          print('Resumed current track');
        }
      } else {
        print('Setting up new track...');
        if (player.playing) {
          await player.stop();
        }

        await player.stop();
        await player.setUrl(url).catchError((error) {
          print('Error setting URL: $error');
          throw error;
        });

        print('URL set successfully, attempting to play...');
        await player.play();
        setState(() {
          currentlyPlayingUrl = url;
        });
        print('New track playing');
      }
    } catch (e) {
      print('Error in handlePlayPause: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error playing audio: $e'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _loadItems() async {
    try {
      final files = await soundController.retrieveList(context);
      if (mounted) {
        setState(() {
          audioFiles = files;
        });
      } else {
        setState(() {});
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString(); // Capture any error messages
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Soundboard',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black87,
        elevation: 2.0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              authService.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
          ),
        
        ],
      ),
      backgroundColor: Color.fromARGB(255, 46, 45, 45), // Clean dark background

   
      body: audioFiles.isEmpty
          ? Center(
              child: Text(
                errorMessage ?? 'No sounds found.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            )
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 0.8,
              ),
              itemCount: audioFiles.length,
              itemBuilder: (context, index) {
                final file = audioFiles[index];
                final url = file['url'] ?? '';
                final title = file['title'] ?? 'Untitled';
                final isThisPlaying = currentlyPlayingUrl == url && isPlaying;
                return Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        isThisPlaying ? Icons.pause : Icons.play_arrow,
                      ),
                      color: Colors.white,
                      onPressed: () {
                        print('Button $index pressed');
                        print('Audio file $index pressed');
                        // handlePlayPause(audioUrls[index]);
                        handlePlayPause(url);
                        print('Playing audio from URL: $url');
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                );
              },
            ),
    

      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return UploadSoundForm();
                });
          }),
    );
  }

  @override
  void dispose() {
    player.dispose(); // Dispose the player when the widget is removed
    super.dispose();
  }
}

extension on String {
  get data => null;
}
