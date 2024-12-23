import 'package:flutter/material.dart';
import 'package:soundboard_0/auth/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePageController {
  // retrieveSoundButtons()  {

  //   return StreamBuilder(stream: , builder: builder)

  // }

  retretrieveSounds() async {
    final SupabaseClient supabase = Supabase.instance.client;
    final Bucket bucket = await supabase.storage.getBucket('soundboard');
    final stream = supabase.from('sounds').stream(primaryKey: ['id']);

    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No sounds available');
        } else {
          final sounds = snapshot.data;
          return ListView.builder(
            itemCount: sounds?.length,
            itemBuilder: (context, index) {
              final sound = sounds?[index];
              return ListTile(
                title: Text(sound?['name']),
                onTap: () {
                  // Play sound
                },
              );
            },
          );
        }
      },
    );
  }
}
