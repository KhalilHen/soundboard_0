import 'package:flutter/material.dart';
import 'package:soundboard_0/auth/auth_service.dart';
import 'package:soundboard_0/controllers/homepage_controler..dart';
import 'package:soundboard_0/controllers/login_controller.dart';
import '../dialogs/upload_sound_dialog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:soundboard_0/pages/login.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // parseUser currentUser = FirebaseAuth.instance.currentUser;
  final authService = AuthService();
  final homepageController = HomePageController();
  final loginController = LoginController();

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

      // body: Container(

      //     child:  Text(loginController.retrieveCurrentUser().email), // This works

      // ),
      // body:  retretrieveSounds(),

//For testing if it can find the current user
      body: Center(
        child: Text(authService.getLoggedInUser() ?? 'No user found'),
      ),


      
      // body: GridView.builder(
      //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //     crossAxisCount: 4,
      //   ),
      //   itemCount: 20, // TODO Change it later into for each
      //   itemBuilder: (context, index) {
      //     return IconButton(
      //       icon: Icon(Icons.music_note),
      //       color: Colors.white,
      //       onPressed: () {},
      //     );
      //   },
      // ),

//Gonna try this later gonna work first on playing the audio
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
}
