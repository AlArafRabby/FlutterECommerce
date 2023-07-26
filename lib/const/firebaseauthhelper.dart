import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthHelper {

  static Future<User?> registerUsingEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCredential.user;
      await user!.updateProfile(displayName: name);
      await user.reload();
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }

    return user;
  }


  static Future<User?> UserInformation({
    required String name,
    required String email,
    required String phone,
    required DateTime dob,
    required String gender,
    required int age,
  }) async {

    final FirebaseAuth auth = FirebaseAuth.instance;
    var currentuser=auth.currentUser;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
      // Call the user's CollectionReference to add a new user

    return users.doc(currentuser?.email)
        .set({
      'name': name, // John Doe
      'email': email, // Stokes and Sons
      'phone': phone, // 42
      'gender': gender, // 42
      'age': age // 42
    })
        .then((value){ print("User Added");  })
        .catchError((error) {
      print("Failed to add user: $error");

    });

  }

  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      }
    }

    return user;
  }

}