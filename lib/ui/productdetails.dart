import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'cart.dart';

class ProductDetails extends StatefulWidget {
  //const ProductDetails({Key? key}) : super(key: key);
  var _product;
  ProductDetails(this._product);
  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int _currentIndex = 1;
  List ProductList = [];

  Future addtocart() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var currentuser = auth.currentUser;

    CollectionReference users =
        FirebaseFirestore.instance.collection('users-cart-items');
    return users.doc(currentuser!.email).collection("items").doc().set({
      "name": widget._product["productname"],
      "price": widget._product["price"],
      "images": widget._product["img"],
    });
  }

  Future addtofavourite() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var currentuser = auth.currentUser;

    CollectionReference users =
        FirebaseFirestore.instance.collection('users-favourite-items');
    return users.doc(currentuser!.email).collection("items").doc().set({
      "name": widget._product["productname"],
      "price": widget._product["price"].toString(),
      "images": widget._product["img"],
    });

    print(users);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.keyboard_backspace),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.transparent,
        actions: [
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users-favourite-items')
                  .doc(FirebaseAuth.instance.currentUser!.email)
                  .collection("items")
                  .where("name", isEqualTo: widget._product["productname"])
                  .snapshots(),
              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Handle the case where the data is still loading.
                  return CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  // Handle any error that occurred while fetching data.
                  return Text("Error: ${snapshot.error}");
                }

                if (!snapshot.hasData || snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  // Handle the case where the snapshot has no data or is null.
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                        child: IconButton(
                          icon:Icon(Icons.favorite_outline),
                          onPressed: () {
                                   addtofavourite();
                                 Fluttertoast.showToast(msg: 'Add to Favourite');

                          },

                        )),
                  );
                }

                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return Text("");
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                        child: IconButton(
                      icon: Icon(Icons.favorite),
                      onPressed: () {
                         Fluttertoast.showToast(msg: 'Already Added to favourite!');

                      },

                    )),
                  );
                }
              }),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      pauseAutoPlayOnTouch: true,
                      enlargeCenterPage: true,
                      viewportFraction: 0.8,
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      }),
                  items: widget._product["img"].map<Widget>((imgUrl) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: Image.network(
                            imgUrl,
                            fit: BoxFit.contain,
                            height: 180.0,
                            width: 180.0,
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                Text(widget._product["productname"]),
                Text(widget._product["description"]),
                Text(widget._product["price"].toString()),
                ElevatedButton(
                  onPressed: () {
                    addtocart();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => Cart(widget._product)),
                    // );
                  },
                  child: const Text(
                    'Add to CART',
                    style: TextStyle(fontSize: 40),
                  ),
                )
              ],
              // Add padding around the search bar

              // Use a Material design search bar
            ),
          ),
        ),
      ),
    );
  }
}
