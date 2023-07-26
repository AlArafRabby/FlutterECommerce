import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqlite_demo/ui/signin.dart';

import '../const/firebaseauthhelper.dart';
import 'home.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Sign Up'),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              TextButton(onPressed: () async {
                User? user =  await FirebaseAuthHelper.registerUsingEmailPassword(name: _nameController.text, email: _emailController.text, password: _passwordController.text);
                if (user != null) {
                  Fluttertoast.showToast(msg: 'Register Successfull');
                  Navigator.of(context)
                      .pushReplacement(
                    MaterialPageRoute(
                      builder: (context) =>
                          const SignIn(),
                    ),
                  );
                }
              }, child: Text('Register')),
              TextButton(onPressed: () async {

                  Navigator.of(context)
                      .pushReplacement(
                    MaterialPageRoute(
                      builder: (context) =>
                      const SignIn(),
                    ),
                  );

              }, child: Text('Already Register go to Login Page'))
            ],
          ),
        )
    );
  }
}
