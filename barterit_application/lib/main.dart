
import 'package:barterit_application/splashscreen.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData( brightness: Brightness.light,),
      title: 'Barterlt',
      home: const SplashScreen(),
      
    );
  }
}