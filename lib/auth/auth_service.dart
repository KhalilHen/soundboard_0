import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient supaBase = Supabase.instance.client;

  Future<AuthResponse> signInWithEmaiPassword(String email, String password) async {
    return await supaBase.auth.signInWithPassword(password: password, email: email);
  }

  // String? get user => supaBase.auth.user;
//Sing up fuction
  Future<AuthResponse> signUpWithEmaiPassword(String email, String password) async {
    return await supaBase.auth.signUp(email: email, password: password);

  }



      //Sign out function
Future<void> signOut() async {
    await supaBase.auth.signOut();
  } 


  


  String? getLoggedInUser() {
    final session = supaBase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }
}
