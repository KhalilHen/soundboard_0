import 'package:flutter/material.dart';
import 'package:soundboard_0/pages/homepage.dart';


class LoginController {




     

  // Future<void> checkUser(BuildContext context, formKey, emailContronller, passwordController)
     Future<void> checkUser(BuildContext context, String email, String password, GlobalKey<FormState> formKey) async {

   



        // if(formKey.currentState!.validate()) {
        //   FirebaseAuth.instance.signInWithEmailAndPassword(
        //     email: email,
        //     password: password,
        //   ).then((value) {
        //     Navigator.pushReplacement(
        //       context,
        //       MaterialPageRoute(builder: (context) => Homepage()),
        //     );
        //   }).catchError((e) {


        //     //
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       SnackBar(
        //         content: Text('Invalid email or password' +e),
        //       ),
        //     );
        //   });
        // }                  


  }
  retrieveCurrentUser() {
    // return FirebaseAuth.instance.currentUser;
  }
}