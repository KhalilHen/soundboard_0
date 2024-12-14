import 'package:flutter/material.dart';
import '../dialogs/upload_sound_dialog.dart';
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
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
      ),
      backgroundColor: Color.fromARGB(255, 46, 45, 45), // Clean dark background
     
      
    body: GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, 
      ),
      itemCount: 20, // TODO Change it later into for each
      itemBuilder: (context, index) {
        return IconButton(
      icon: Icon(Icons.music_note),
      color: Colors.white,
      onPressed: () {


      },
        );
      },
    ),

    floatingActionButton: FloatingActionButton(

    child: Icon(Icons.add),
      onPressed: () {

          showDialog(context: context, builder: (context) {
            return UploadSoundForm();
          });

      }

    ),
    );
  }
}
