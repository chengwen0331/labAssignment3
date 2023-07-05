import 'dart:async';
import 'dart:convert';

import 'package:barterit_application/loginscreen.dart';
import 'package:barterit_application/model/myconfig.dart';
import 'package:barterit_application/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const RegistrationScreen());

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  final TextEditingController _pass2EditingController = TextEditingController();
  bool _isChecked = false;
  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth, cardwitdh;
  String eula = "";
  late User user;
  late bool _isObscured;

  loadEula() async {
    eula = await rootBundle.loadString('assets/eula.txt');
  }

    @override
  void initState() {
    super.initState();
    _isObscured = true;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text('User Registration'),
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.secondary,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: screenHeight * 0.35,
              width: screenWidth,
              child: Image.asset(
                "assets/register.png",
                fit: BoxFit.cover,
              )),
            Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 8,
              child: Container(
                margin: const EdgeInsets.all(16),
                child: Column(children: [
                  Form(
                    key: _formKey,
                    child: Column(children: [
                      TextFormField(
                          controller: _nameEditingController,
                          validator: (val) => val!.isEmpty || (val.length < 5)
                              ? "name must be longer than 5"
                              : null,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              labelText: 'Name',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.person),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      TextFormField(
                          keyboardType: TextInputType.phone,
                          validator: (val) => val!.isEmpty || (val.length < 10)
                              ? "phone must be longer or equal than 10"
                              : null,
                          controller: _phoneEditingController,
                          decoration: const InputDecoration(
                              labelText: 'Phone',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.phone),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      TextFormField(
                          controller: _emailEditingController,
                          validator: (val) => val!.isEmpty ||
                                  !val.contains("@") ||
                                  !val.contains(".")
                              ? "enter a valid email"
                              : null,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.email),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      TextFormField(
                          controller: _passEditingController,
                          validator: (val) => val!.isEmpty || (val.length < 5)
                              ? "password must be longer than 5"
                              : null,
                          obscureText: _isObscured,
                          decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(),
                              icon: const Icon(Icons.lock),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ),
                              suffixIcon: IconButton(
                                padding: const EdgeInsetsDirectional.only(end:12.0),
                                icon: _isObscured ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                                onPressed:(){
                                  setState((){
                                    _isObscured =! _isObscured;
                                  });
                                }
                              ),
                          )),
                      TextFormField(
                          controller: _pass2EditingController,
                          validator: (val) => val!.isEmpty || (val.length < 5)
                              ? "password must be longer than 5"
                              : null,
                          obscureText: _isObscured,
                          decoration: InputDecoration(
                              labelText: 'Confirm password',
                              labelStyle: TextStyle(),
                              icon: const Icon(Icons.lock),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ),
                              suffixIcon: IconButton(
                                padding: const EdgeInsetsDirectional.only(end:12.0),
                                icon: _isObscured ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                                onPressed:(){
                                  setState((){
                                    _isObscured =! _isObscured;
                                  });
                                }
                              ),
                              )),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: _isChecked,
                            onChanged: (bool? value) {
                              if (!_isChecked) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Terms have been read and accepted.")));
                              }
                              setState(() {
                                _isChecked = value!;
                              });
                            },
                          ),
                          GestureDetector(
                            onTap: _showEULA,
                            child: RichText(
                              text: TextSpan(
                                text: 'I read and agree to ',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Terms & Conditions',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.secondary, // Change the color to blue
                                      decoration: TextDecoration.underline, // Underline the text
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                      MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            minWidth: screenWidth / 2,
                            height: 50,
                            elevation: 10,
                            onPressed: onRegisterDialog,
                            color: Theme.of(context).colorScheme.secondary,
                            textColor: Theme.of(context).colorScheme.onError,
                            child: const Text('CREATE ACCOUNT'),
                      ),
                    ]),
                  )
                ]),
              ),
            ),
          ),
            const SizedBox(
              height: 16,
            ),
            Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
                  const Text("Already have an account? ",
                   style: TextStyle(fontSize: 15.0, )),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (content) => const LoginScreen()));
                    },
                    child: Text("Sign in", style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    )),
                  ),
               ],
            ),
            const SizedBox(height: 10,),
          ],)
        ),
      );    
  }

  void onRegisterDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please check your form"))
      );
      return;
    }
    if (!_isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please accept the terms and conditions"))
      );
      return;
    }

    String passa = _passEditingController.text;
    String passb = _pass2EditingController.text;
    if(passa != passb){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please check your password"))
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Register new account?",
            style: TextStyle(
               
            ),
          ),
          content: const Text("Are you sure?",
              style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(
                   
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                registerUser();
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered)) {
                      return Colors.blue; // Change color when hovered
                    }
                    return Colors.black; // Default color
                  },
                ),
                overlayColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered)) {
                      return Colors.blue.withOpacity(0.1); // Change overlay color when hovered
                    }
                    return Colors.transparent; // Default overlay color
                  },
                ),
                mouseCursor: MaterialStateMouseCursor.clickable, // Change cursor to pointer when hovered
              ),
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
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.black), // Default color
                overlayColor: MaterialStateProperty.all(Colors.transparent), // Default overlay color
                mouseCursor: MaterialStateMouseCursor.clickable, // Change cursor to pointer when hovered
              ),

            ),
          ],
        );
      },
    );
  }
  
  void registerUser() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Please Wait"),
          content: Text("Registration..."),
        );
      },
    );
    
    String name = _nameEditingController.text;
    String email = _emailEditingController.text;
    String phone = _phoneEditingController.text;
    String passa = _passEditingController.text;
    String passb = _pass2EditingController.text;

    http.post(Uri.parse("${MyConfig().SERVER}barterit_application/php/register_user.php"),
        body: {"name": name, "email": email, "phone": phone, "password": passa})
    .then((response) {
      print(response.body);
      if(response.statusCode == 200){
        var jsondata = jsonDecode(response.body);
        if(jsondata['status'] == "success"){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registration success")));
          Timer(
          const Duration(seconds: 5),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (content) => const LoginScreen())));
        }
        else{
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registration success")));
        }
    }});
  }

  void _showEULA() {
    loadEula();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "EULA",
            style: TextStyle(
               
            ),
          ),
          content: SizedBox(
            height: screenHeight / 1.5,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                      child: RichText(
                    softWrap: true,
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                        style: const TextStyle(
                          color: Colors.black, 
                          fontSize: 12.0,
                        ),
                      text: eula
                    ),
                    )),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Close",
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}