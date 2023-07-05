import 'dart:convert';

import 'package:barterit_application/mainscreen.dart';
import 'package:barterit_application/model/myconfig.dart';
import 'package:barterit_application/model/user.dart';
import 'package:barterit_application/registrationscreen.dart';
import 'package:barterit_application/resetpassscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  late double screenHeight, screenWidth;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  bool _isChecked = false;
  late bool _isObscured;

  @override
  void initState() {
    _isObscured = true;
    super.initState();
    loadPref();
  }
  
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.secondary,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
              height: screenHeight * 0.40,
              width: screenWidth,
              child: Image.asset("assets/login.png", fit: BoxFit.cover,)
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 8, //make it visible
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                  child: Column(children: [
                    Form(
                      key: _formKey,
                      child: Column(children: [
                      TextFormField(
                        controller: _emailEditingController ,
                        validator: (val) => val!.isEmpty || !val.contains("@") || !val.contains(".")
                          ? "enter a valid email"
                          : null,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(),
                          icon: Icon(Icons.email),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width:2.0),
                          )
                        ),
                      ),
                      TextFormField(
                        controller: _passEditingController ,
                        validator: (val) => val!.isEmpty || (val.length < 5)
                          ?"password must be longer than 5"
                          :null,
                        obscureText: _isObscured,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(),
                          icon: Icon(Icons.lock),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(width:2.0),
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
                        ),
                      ),
                      const SizedBox(height:8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _isChecked,
                            onChanged: (bool? value) {
                              saveremovepref(value!);
                              setState(() {
                                _isChecked = value!;
                              });
                            },
                          ),
                          Flexible(
                            child: GestureDetector(
                              onTap: null,
                              child: const Text('Remember Me',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          minWidth: screenWidth / 2,
                          height: 50,
                          elevation: 10,
                          onPressed: onLogin,
                          color: Theme.of(context).colorScheme.secondary,
                          textColor: Theme.of(context).colorScheme.onError,
                          child: const Text(
                            'LOGIN',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),

                    ]),
                    )              
                  ],),
                ),
              )
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
                  const Text("Don't have an account? ",
                   style: TextStyle(fontSize: 16.0, color:Color.fromARGB(255, 132, 132, 132))),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (content) => const RegistrationScreen()));
                    },
                    child: Text("Sign Up", style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    )),
                  ),
               ],
            ),
            Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
                  const Text("Forgot Password? ",
                   style: TextStyle(fontSize: 16.0, color:Color.fromARGB(255, 132, 132, 132))),
                  GestureDetector(
                    onTap: () {
                      // Navigate to the ResetPasswordScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ResetPasswordScreen()),
                      );
                    },
                    child: Text(
                      "Reset Password",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
               ],
            ),
            const SizedBox(height: 10,),
          ]),
        ),   
    );
  }
  
  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    _isChecked = (prefs.getBool('checkbox')) ?? false;
    if (_isChecked) {
      setState(() {
        _emailEditingController.text = email;
        _passEditingController.text = password;
      });
    }
  }
  
  void saveremovepref(bool value) async {
    FocusScope.of(context).requestFocus(FocusNode());
    String email = _emailEditingController.text;
    String password = _passEditingController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      //save preference
      if (!_formKey.currentState!.validate()) {
        _isChecked = false;
        return;
      }
      await prefs.setString('email', email);
      await prefs.setString('pass', password);
      await prefs.setBool("checkbox", value);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Preferences Stored")));
    } 
    else {
      //delete preference
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      await prefs.setBool('checkbox', false);
      setState(() {
        _emailEditingController.text = '';
        _passEditingController.text = '';
        _isChecked = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Preferences Removed")));
    }
  }

  void onLogin() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    }
    String email = _emailEditingController.text;
    String pass = _passEditingController.text;
    print(pass);
    http.post(Uri.parse("${MyConfig().SERVER}barterit_application/php/login_user.php"),
        body: {
          "email": email,
          "password": pass,
        }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          print(jsondata);
          User user = User.fromJson(jsondata['data']);
          print(user.name);
          print(user.email);
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Login Success")));
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (content) =>  MainScreen(user: user,)));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Login Failed")));
        }
      }
    });
  }

  void _forgotDialog() {
  }
}