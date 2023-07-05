
import 'package:barterit_application/loginscreen.dart';
import 'package:barterit_application/model/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Widget> tabchildren;
  String maintitle = "BarterIt";

  @override
    void initState() {
      super.initState();
      print("Home");
    }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text(maintitle, style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.amber,
          actions: [
            IconButton(
              icon: const Icon(Icons.search,
              color: Colors.white,
              ),
              onPressed: (){},
            ),
            IconButton(
              icon: const Icon(Icons.logout,
              color: Colors.white,
              ),
              onPressed: onLogout,
            ),
          ],
        ),
      ),
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
                //Navigator.of(context).pop();
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