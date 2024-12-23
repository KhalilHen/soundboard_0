import 'package:flutter/material.dart';
import 'package:soundboard_0/pages/homepage.dart';
import '../controllers/login_controller.dart';
import '../auth/auth_service.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var iconVisible = false;

  final emailContronller = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final authService = AuthService();
  //temporary function placement  to test
  void Login() async {
    final email = emailContronller.text;
    final password = passwordController.text;
    try {
      await authService.signInWithEmaiPassword(email, password).then((value) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Homepage()),
        );
      }).catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid email or password' + e.toString()),
          ),
        );
      });
    } catch (e) {}
  }

//This is for clearing the form field s after submiting
  @override
  void dispose() {
    emailContronller.dispose();
    passwordController.dispose();
    super.dispose();
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
      ),
      backgroundColor: Color.fromARGB(255, 46, 45, 45),
      body: Form(
        key: formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Login',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              SizedBox(height: 100),
              Container(
                width: 350,
                child: TextFormField(
                  controller: emailContronller,
                  onFieldSubmitted: (value) {
                    emailContronller.clear();
                  },
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a email';
                    }
                    return null;
                  },
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 350,
                child: TextFormField(
                  controller: passwordController,
                  onFieldSubmitted: (value) {
                    passwordController.clear();
                  },
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          iconVisible = !iconVisible;
                        });
                      },
                      icon: Icon(iconVisible ? Icons.visibility : Icons.visibility_off),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                  obscureText: !iconVisible,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    // if(formKey.currentState!.validate()) {
                    //   print('Form is valid');

                    //   Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(builder: (context) => Homepage()),
                    //   );
                    // } else {
                    //   print('Form is invalid');
                    // }

                    var loginController = LoginController();
                    loginController.checkUser(context, emailContronller.text, passwordController.text, formKey);
                  },
                  child: Text('Submit')),
              ElevatedButton(
                onPressed: () {
                  // Navigator.pushNamed(context, '/homepage');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Homepage()),
                  );
                },
                child: Text('Go to Homepage'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
