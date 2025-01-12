import 'package:flutter/material.dart';
import 'package:soundboard_0/pages/homepage.dart';
import 'package:soundboard_0/auth/auth_service.dart';
import 'package:soundboard_0/auth/auth_gate.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class LoginController {
  final authService = AuthService();

  // Future<void> checkUser(BuildContext context, formKey, emailContronller, passwordController)
  Future<void> checkUser(BuildContext context, String email, String password, GlobalKey<FormState> formKey) async {
    if (formKey.currentState!.validate()) {



      await AuthService().signInWithEmaiPassword(email, password).then((value) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Homepage()),
        ).then((_) {
          // Clear the form fields after navigation
          formKey.currentState!.reset();
        });
      }).catchError((e) {
        formKey.currentState!.reset();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid email or password: ' + e.toString()),
          ),
        );
      });
    }
  }
}
