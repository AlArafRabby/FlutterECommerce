import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sqlite_demo/ui/productdetails.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  List products = [];

  fetchproducts() async {
    FirebaseFirestore pro = FirebaseFirestore.instance;
    QuerySnapshot qry = await pro.collection("products").get();
    //var qry = await pro.collection("products").get();
    //print(qry.toString());
    setState(() {
      for (int i = 0; i < qry.docs.length; i++) {
        products.add({
          "description": qry.docs[i]["description"],
          "productname": qry.docs[i]["productname"],
          "img": qry.docs[i]["img"],
          "price": qry.docs[i]["price"].toString(),
        });
      }
    });
    //print(products.toList());
    return qry.docs;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchproducts();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: products.length,
      itemBuilder: (_, index) {
        return GestureDetector(
          child: Card(
            elevation: 3,
            child: Column(
              children: [
                Image.network(products.elementAt(index)['img'][0],
                    width: 300, height: 150, fit: BoxFit.fill),
                Text(products[index]["productname"]),
                Text(products[index]["price"].toString()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.favorite,
                      color: Colors.blue,
                    ),
                    Icon(
                      Icons.shopping_cart,
                      color: Colors.blue,
                    ),
                  ],
                )
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductDetails(products[index])),
            );
          },
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          mainAxisExtent: 250),
    );
  }
}
