import 'dart:async';
import 'dart:convert';

import 'package:barterit_application/loginscreen.dart';
import 'package:barterit_application/mainscreen.dart';
import 'package:barterit_application/model/myconfig.dart';
import 'package:barterit_application/model/user.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override

  void initState() {
    super.initState();
    checkAndLogin();
  }

  Widget build(BuildContext context){
      return Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height:double.infinity,
            width:double.infinity,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 246, 219)
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                Image.asset('assets/logo.png', scale: 2,),
                const SizedBox(height:16),
                Container(
                  height:100,
                  alignment: Alignment.bottomCenter,
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                )
              ],
            )
          ),
        ],
      );
  }

  checkAndLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    bool ischeck = (prefs.getBool('checkbox')) ?? false;
    late User user;
    if (ischeck) {
      try {
        http.post(
            Uri.parse("${MyConfig().SERVER}barterit_application/php/login_user.php"),
            body: {"email": email, "password": password}).then((response) {
              print(response.body);
          if (response.statusCode == 200) {
            var jsondata = jsonDecode(response.body);
            user = User.fromJson(jsondata['data']);
            Timer(
                const Duration(seconds: 3),
                () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => MainScreen(user: user,))));
          } else {
            user = User(
                id: "na",
                name: "na",
                email: "na",
                phone: "na",
                datereg: "na",
                password: "na",
                otp: "na");
            Timer(
                const Duration(seconds: 3),
                () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => MainScreen(user: user,))));
          }
        }).timeout(const Duration(seconds: 5), onTimeout: () {
        });
      } on TimeoutException catch (_) {
        print("Time out");
      }
    } else {
      user = User(
          id: "na",
          name: "na",
          email: "na",
          phone: "na",
          datereg: "na",
          password: "na",
          otp: "na");
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (content) => MainScreen(user: user,))));
    }}
    
}
