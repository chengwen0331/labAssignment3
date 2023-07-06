
import 'package:barterit_application/chatscreen.dart';
import 'package:barterit_application/explorescreen.dart';
import 'package:barterit_application/homescreen.dart';
import 'package:barterit_application/itemlistingscreen.dart';
import 'package:barterit_application/model/user.dart';
import 'package:barterit_application/profilescreen.dart';
import 'package:flutter/material.dart';
import 'profiletabscreen.dart';


class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "Home";

  @override
    void initState() {
      super.initState();
      tabchildren = [

      HomeScreen(user: widget.user,),
      ExploreScreen(user: widget.user,),
      ItemListingScreen(user: widget.user,),
      ChatScreen(user: widget.user,),
      //ProfileTabScreen(user: widget.user,),
      widget.user.id.toString()== "na"
        ? const ProfileScreen()
        : ProfileTabScreen(user: widget.user)
    ];
    }

    @override
    void dispose(){
      super.dispose();
      print("dispose");
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabchildren[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        selectedItemColor: Colors.amber, // Set the desired color for the selected icon
        unselectedItemColor: Color.fromARGB(255, 65, 65, 65),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, ),
              label: "HOME"),
          BottomNavigationBarItem(
              icon: Icon(Icons.search, ),
              label: "EXPLORE"),
          BottomNavigationBarItem(
              icon: Icon(Icons.store_mall_directory, ),
              label: "LISTING"),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat, ), 
              label: "MESSAGE"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, ), 
              label: "PROFILE")
        ],
      ),
    );
  }

  void onTabTapped(int index) {

    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
        maintitle = "Home";
      }
      if (_currentIndex == 1) {
        maintitle = "Explore";
      }
      if (_currentIndex == 2) {
        maintitle = "Item listing";
      }
      if (_currentIndex == 3) {
        maintitle = "Message";
      }
      if (_currentIndex == 3) {
        maintitle = "Profile";
      }
    });
  }
}
