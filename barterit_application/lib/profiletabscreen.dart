import 'dart:convert';

import 'package:barterit_application/loginscreen.dart';
import 'package:barterit_application/model/myconfig.dart';
import 'package:barterit_application/model/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileTabScreen extends StatefulWidget {
  final User user;

  const ProfileTabScreen({super.key, required this.user});

  @override
  State<ProfileTabScreen> createState() => _ProfileTabScreenState();
}

class _ProfileTabScreenState extends State<ProfileTabScreen> {
  late List<Widget> tabchildren;
  String maintitle = "Profile";
  late double screenHeight, screenWidth;

  @override
    void initState() {
      super.initState();
      print("Profile");
    }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Column(children: [
          Container(
            color: Color.fromARGB(255, 255, 250, 202),
            padding: const EdgeInsets.all(8),
            height: screenHeight * 0.25,
            width: screenWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
                Container(
            margin: const EdgeInsets.all(4),
            width: screenWidth * 0.23,
            child: Image.asset(
              "assets/profile.png",
            ),
                ),
                Flexible(
                flex: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(widget.user.name.toString(),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 2, 0, 8),
                      child: Divider(
                        color: Colors.blueGrey,
                        height: 2,
                        thickness: 2.0,
                      ),
                    ),
                    Table(
                      columnWidths: const {
                        0: FractionColumnWidth(0.3),
                        1: FractionColumnWidth(0.7)
                      },
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(children: [
                          const Icon(Icons.email, size:18),
                          Text(widget.user.email.toString(), style:const TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
                        ]),
                      TableRow(children: [
                          const Icon(Icons.phone, size:18),
                          Text(widget.user.phone.toString(), style:const TextStyle(fontSize:12, fontWeight: FontWeight.bold)),
                        ]),
                
                      ],
                    ),
                  ],
                ))
              ]),
          ),
          Container(
            width: screenWidth,
            alignment: Alignment.center,
            color: Colors.amberAccent,
            child: const Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Text("PROFILE SETTINGS",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ),
          Expanded(
                      child: ListView(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          shrinkWrap: true,
                          children: [
                        MaterialButton(
                          onPressed: () => {_updateProfileDialog(1)},
                          child: const Text("UPDATE NAME"),
                        ),
                        const Divider(
                          height: 2,
                        ),
                        MaterialButton(
                          onPressed: () => {_updateProfileDialog(2)},
                          child: const Text("UPDATE PHONE"),
                        ),
                        const Divider(
                          height: 2,
                        ),
                        MaterialButton(
                          onPressed: () => {_updateProfileDialog(3)},
                          child: const Text("UPDATE PASSWORD"),
                        ),
                        const Divider(
                          height: 2,
                        ),
                        MaterialButton(
                          onPressed: () {},
                          child: const Text("MY RATING"),
                        ),
                        const Divider(
                          height: 2,
                        ),
                        MaterialButton(
                          minWidth: screenWidth / 6,
                          height: 50,
                          elevation: 10,
                          onPressed: onLogout,
                          color: Colors.amberAccent,
                          textColor: Colors.black,
                          child: const Text(
                            'LOGOUT',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),

                      ]
              )
            ),
          
        ]),
      ),
    );
  }
  
  _updateProfileDialog(int i) {
    switch (i) {
      case 1:
        _updateNameDialog();
        break;
      case 2:
        _updatePhoneDialog();
        break;
      case 3:
        _updatePasswordDialog();
        break;
    }
  }
  
  void _updateNameDialog() {
    TextEditingController nameEditingController = TextEditingController();
    nameEditingController.text = widget.user.name.toString();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Name",
            style: TextStyle(),
          ),
          content: TextField(
              controller: nameEditingController,
              keyboardType: TextInputType.text),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Confirm",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                http.post(Uri.parse("${MyConfig().SERVER}barterit_application/php/update_profile.php"),
                    body: {
                      "name": nameEditingController.text,
                      "userid": widget.user.id
                    }).then((response) {
                  var data = jsonDecode(response.body);
                  print(response.body);
                  if (response.statusCode == 200 &&
                      data['status'] == 'success') {
                    Fluttertoast.showToast(
                        msg: "Success",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.green,
                        fontSize: 14.0);
                    setState(() {
                      widget.user.name = nameEditingController.text;
                    });
                  } else {
                    Fluttertoast.showToast(
                        msg: "Failed",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.red,
                        fontSize: 14.0);
                  }
                });
              },
            ),
            TextButton(
              child: const Text(
                "Cancel",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  
  void _updatePhoneDialog() {
    TextEditingController phoneEditingController = TextEditingController();
     phoneEditingController.text = widget.user.phone.toString();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Phone Number",
            style: TextStyle(),
          ),
          content: TextField(
              controller: phoneEditingController,
              keyboardType: TextInputType.phone),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Confirm",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                http.post(Uri.parse("${MyConfig().SERVER}barterit_application/php/update_profile.php"),
                    body: {
                      "phone": phoneEditingController.text,
                      "userid": widget.user.id
                    }).then((response) {
                  var data = jsonDecode(response.body);
                  // print(data);
                  if (response.statusCode == 200 &&
                      data['status'] == 'success') {
                    Fluttertoast.showToast(
                        msg: "Success",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.green,
                        fontSize: 14.0);
                    setState(() {
                      widget.user.phone = phoneEditingController.text;
                    });
                  } else {
                    Fluttertoast.showToast(
                        msg: "Failed",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.red,
                        fontSize: 14.0);
                  }
                });
              },
            ),
            TextButton(
              child: const Text(
                "Cancel",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  
  void _updatePasswordDialog() {
    TextEditingController pass1EditingController = TextEditingController();
    TextEditingController pass2EditingController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Update Password",
            style: TextStyle(),
          ),
          content: SizedBox(
            height: screenHeight / 4,
            child: Column(
              children: [
                TextField(
                    controller: pass1EditingController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: 'New password',
                        labelStyle: TextStyle(),
                        icon: Icon(
                          Icons.lock,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2.0),
                        ))),
                TextField(
                    controller: pass2EditingController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: 'Confirm password',
                        labelStyle: TextStyle(),
                        icon: Icon(
                          Icons.lock,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2.0),
                        ))),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Confirm",
                style: TextStyle(),
              ),
              onPressed: () {
                if (pass1EditingController.text !=
                    pass2EditingController.text) {
                  Fluttertoast.showToast(
                      msg: "Passwords are not the same",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      textColor: Colors.red,
                      fontSize: 14.0);
                  return;
                }
                if (pass1EditingController.text.isEmpty ||
                    pass2EditingController.text.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Fill in passwords",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      textColor: Colors.red,
                      fontSize: 14.0);
                  return;
                }
                Navigator.of(context).pop();
                http.post(Uri.parse("${MyConfig().SERVER}barterit_application/php/update_profile.php"),
                    body: {
                      "password": pass1EditingController.text,
                      "userid": widget.user.id
                    }).then((response) {
                  var data = jsonDecode(response.body);
                  //  print(data);
                  if (response.statusCode == 200 &&
                      data['status'] == 'success') {
                    Fluttertoast.showToast(
                        msg: "Success",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.green,
                        fontSize: 14.0);
                  } else {
                    Fluttertoast.showToast(
                        msg: "Failed",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.red,
                        fontSize: 14.0);
                  }
                });
              },
            ),
            TextButton(
              child: const Text(
                "Cancel",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

  }

  void onLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Logout?",
            style: TextStyle(
               
            ),
          ),
          content: const Text("Are you sure you want to logout?",
              style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(
                   
                ),
              ),
              onPressed: () {
                SharedPreferences.getInstance().then((prefs) {
                  prefs.remove('accessToken');
                  prefs.remove('refreshToken');
                });
                ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Logout Success")));
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(
                   
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}