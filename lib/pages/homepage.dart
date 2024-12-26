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
  // parseUser currentUser = FirebaseAuth.instance.currentUser;
  final supabase = Supabase.instance.client;

  final authService = AuthService();
  final homepageController = HomePageController();
  final loginController = LoginController();
  final soundController = SoundController();
  int? itemCount;
  String? errorMessage;
  final player = AudioPlayer(); // Create a player
  List<String> audioUrls = [];
  bool isPlaying = false;
  String? currentlyPlayingUrl;

  @override
  void initState() {
    super.initState();
    // player.setUrl(
    //     // "https://ldbacsjpyrkqcnhcbrrk.supabase.co/storage/v1/object/sign/sounds/uploads/Lijpe%20preview%20gelekt%20(2022)%20-%20%20Als%20ze%20niks%20op%20je%20hebben%20dan%20gaan%20ze%20wat%20verzinnen.mp3?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJzb3VuZHMvdXBsb2Fkcy9MaWpwZSBwcmV2aWV3IGdlbGVrdCAoMjAyMikgLSAgQWxzIHplIG5pa3Mgb3AgamUgaGViYmVuIGRhbiBnYWFuIHplIHdhdCB2ZXJ6aW5uZW4ubXAzIiwiaWF0IjoxNzM1MTcwOTE1LCJleHAiOjE3MzU3NzU3MTV9.d_L7RFh4jToC69u376goLMRCMr6h74Mg0zdmL_-nzf8&t=2024-12-25T23%3A55%3A16.252Z");

    //     "https://www.youtube.com/watch?v=gJZWzi8BgBQ&ab_channel=FlutterGuys");
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

  // void handlePlayPause(String fileName) {
  //   try {
  //     final fileUrl = supabase.storage.from('sounds').getPublicUrl('uploads/$fileName').data;

  //     if (fileUrl == null) {
  //       print('File URL is null, please check the file name and path.');
  //       return;
  //     }

  //     if (player.playing) {
  //       player.pause();
  //     } else {
  //       print('Playing $fileUrl');
  //       player.setUrl(fileUrl); // Set the new URL to the player

  //       player.play();
  //     }
  //   } catch (e) {
  //     // print(e);
  //     SnackBar(
  //       content: Text('Error: $e'),
  //     );
  //   }
  // }

  // Future<void> handlePlayPause(String url) async {
  //   try {
  //     if (currentlyPlayingUrl == url) {
  //       // Toggle play/pause for current track
  //       if (isPlaying) {
  //         await player.pause();
  //       } else {
  //         await player.play();
  //       }
  //     } else {
  //       // Play new track
  //       await player.stop();
  //       await player.setUrl(url);
  //       await player.play();
  //       setState(() {
  //         currentlyPlayingUrl = url;
  //       });
  //     }
  //   } catch (e) {
  //     print('Error playing audio: $e');
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error playing audio: $e')),
  //       );
  //     }
  //   }
  // }

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
      final urls = await soundController.retrieveList(context);
      if (mounted) {
        setState(() {
          audioUrls = urls;
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
          // IconButton(
          //     onPressed: () {
          //       handlePlayPause();
          //     },
          //     icon: Icon(Icons.play_arrow)),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 46, 45, 45), // Clean dark background

      // body: Container(

      //     child:  Text(loginController.retrieveCurrentUser().email), // This works

      // ),
      // body:  retretrieveSounds(),

      //For testing if it can find the current user
      // body: Center(
      //   child: Text(
      //     authService.getLoggedInUser() ?? 'No user found',
      //     style: TextStyle(
      //       color: Colors.white,
      //       fontSize: 20,
      //     ),
      //   ),
      // ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemCount: audioUrls.length, 
        itemBuilder: (context, index) {
          final url = audioUrls[index];
          final isThisPlaying = currentlyPlayingUrl == url && isPlaying;
          return Column(
            children: [
              IconButton(
                icon: Icon(Icons.music_note),
                color: Colors.white,
                onPressed: () {
                  print('Button $index pressed');
                  print('Audio file $index pressed');
                  // handlePlayPause(audioUrls[index]);
                  handlePlayPause(url);
                  print('Playing audio from URL: $url');
                },
              ),
            ],
          );
        },
      ),
      // body: Center(
      //   child: IconButton(onPressed: handlePlayPause, icon: Icon(Icons.play_arrow)),
      // ),
      // Gonna try this later gonna work first on playing the audio
      // body: Container(
      //   child: ElevatedButton(
      //     onPressed: () async {x1
      //       final SupabaseClient supabase = Supabase.instance.client;
      //       final Bucket bucket = await supabase.storage.getBucket('sounds');
      //     },
      //     child: Text('Get Sounds'),
      //   ),
      // ),

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
