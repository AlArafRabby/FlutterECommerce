import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  //const Cart({Key? key}) : super(key: key);2
  var cartproduct;
  Cart(this.cartproduct);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
          child: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (BuildContext context, AsyncSnapshot<User?> userSnapshot) {
              print(FirebaseAuth.instance.authStateChanges());
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                print("------------------- waiting");
                print(FirebaseAuth.instance.currentUser!.email);
                // Handle loading state while checking the authentication state.
                return CircularProgressIndicator();
              }
              else if (userSnapshot.hasError) {
                print("------------------- hasError");
                print(FirebaseAuth.instance.currentUser!.email);
                // Handle authentication error case.
                return Center(
                  child: Text('Authentication error'),
                );
              }

              else if (userSnapshot.data == null) {
                print("------------------- null");
                print(FirebaseAuth.instance.currentUser!.email);
                // User is not authenticated. Show appropriate UI (e.g., login screen).
                return Center(
                  child: Text('User not authenticated'),
                );
              }
              // User is authenticated. Return the StreamBuilder for Firestore data.
              if(userSnapshot.connectionState == ConnectionState.done){
                print("------------------- done");
                print(FirebaseAuth.instance.currentUser!.email);
                return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users-cart-items')
                      .doc(FirebaseAuth.instance.currentUser!.email)
                      .collection("items")
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Something is wrong'),
                      );
                    }
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (_, index) {
                          if (snapshot.hasError) {
                            // Handle error case.
                            return Text('error');
                          }

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            // Handle loading state.
                            return const CircularProgressIndicator();
                          }

                          DocumentSnapshot _d=snapshot.data!.docs[index];
                          return Card(
                            child: ListTile(
                              leading: Text(_d['name']),
                              title: Text("\$ ${_d['price'].toString()}"),
                              trailing: GestureDetector(
                                child: CircleAvatar(
                                  child: Icon(Icons.remove_circle),
                                ),
                                onTap: (){
                                  FirebaseFirestore.instance.collection("users-cart-items").doc(FirebaseAuth.instance.currentUser!.email).collection("items").doc(_d.id).delete();
                                },
                              ),
                            ),
                          );
                        });
                  },
                );
              }
              return Center(
                child: Text('Please wait'),
              );

      },


          )),
    );
  }
}
