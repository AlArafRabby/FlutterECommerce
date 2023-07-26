import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqlite_demo/ui/signup.dart';

import '../const/firebaseauthhelper.dart';
import 'home.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    return Scaffold(
      body:
      Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Sign In'),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            TextButton(onPressed: () async {
              User? user =  await FirebaseAuthHelper.signInUsingEmailPassword(email: _emailController.text, password: _passwordController.text);
              if (user != null) {
                Fluttertoast.showToast(msg: 'Register Successfull');
                Navigator.of(context)
                    .pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>
                        Home(),
                  ),
                );
              }
            }, child: Text('Login')),
            TextButton(onPressed: () async {

              Navigator.of(context)
                  .pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>
                  const SignUp(),
                ),
              );

            }, child: Text('New User! Register For Login'))
          ],
        ),
      )
    );
  }
}
