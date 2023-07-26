import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sqlite_demo/ui/home.dart';

import '../const/firebaseauthhelper.dart';

class UserForm extends StatefulWidget {
  const UserForm({Key? key}) : super(key: key);

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  //TextEditingController _genderController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  String dropdownvalue = 'Select Gender';
  var gender = [
    'Select Gender',
    'Male',
    'Female',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('User Profile Form'),
          StreamBuilder(
              stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.email).snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      TextField(
                        controller: _nameController=TextEditingController(text: snapshot.data['name']),
                        decoration: InputDecoration(labelText: 'Name'),
                      ),
                      TextField(
                        controller: _emailController=TextEditingController(text: snapshot.data['email']),
                        decoration: InputDecoration(labelText: 'Email'),
                      ),
                      TextField(
                        controller: _phoneController=TextEditingController(text: snapshot.data['phone']),
                        decoration: InputDecoration(labelText: 'Phone'),
                      ),
                      TextField(
                        controller: _dobController,
                        decoration: InputDecoration(
                            icon: Icon(Icons.calendar_today), labelText: 'DOB'),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(
                                  2000), //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime(2101));
                          if (pickedDate != null) {
                            print(
                                pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            print(
                                formattedDate); //formatted date output using intl package =>  2021-03-16
                            //you can implement different kind of Date Format here according to your requirement
                            setState(() {
                              _dobController.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          } else {
                            print("Date is not selected");
                          }
                        },
                      ),
                      DropdownButton(
                        value: dropdownvalue,
                        isExpanded: true,
                        style: Theme.of(context).textTheme.headline6,
                        hint: Text('Select Gender'),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          size: 30.0,
                        ),
                        dropdownColor: Colors.orange,
                        onChanged: (String? value) {
                          setState(() => dropdownvalue = value!);
                        },
                        items: gender.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                      ),
                      TextField(
                        controller: _ageController=TextEditingController(text: snapshot.data['age'].toString()),
                        decoration: InputDecoration(labelText: 'Age'),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Icon(Icons.error_outline);
                } else {
                  return CircularProgressIndicator();
                }
              }),
          // ElevatedButton(
          //     style: ButtonStyle(
          //       backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          //         (Set<MaterialState> states) {
          //           if (states.contains(MaterialState.pressed)) {
          //             return Theme.of(context)
          //                 .colorScheme
          //                 .primary
          //                 .withOpacity(0.5);
          //           }
          //           return null; // Use the component's default.
          //         },
          //       ),
          //     ),
          //     onPressed: () async {
          //       User? r = await FirebaseAuthHelper.UserInformation(
          //           name: _nameController.text,
          //           email: _emailController.text,
          //           phone: _phoneController.text,
          //           dob: DateTime.parse(_dobController.text),
          //           gender: dropdownvalue,
          //           age: int.parse(_ageController.text));
          //       print(r);
          //       if (r != null) {
          //         Fluttertoast.showToast(
          //           msg: "User Information Successfullly Added",
          //         );
          //
          //         // Navigator.of(context)
          //         //     .pushReplacement(
          //         //   MaterialPageRoute(
          //         //     builder: (context) =>
          //         //     const SignIn(),
          //         //   ),
          //         // );
          //       }
          //     },
          //     child: Text('Save User Information')),
          // TextButton(
          //     onPressed: () async {
          //       Navigator.of(context).pushReplacement(
          //         MaterialPageRoute(
          //           builder: (context) => const Home(),
          //         ),
          //       );
          //     },
          //     child: Text('Go to Home'))
        ],
      )),
    );
  }
}
