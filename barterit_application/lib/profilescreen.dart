import 'package:barterit_application/loginscreen.dart';
import 'package:barterit_application/registrationscreen.dart';
import 'package:flutter/material.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
    final buttonWidth = screenWidth * 0.5;
    return Scaffold(
      appBar: AppBar(
          title: const Text("Profile", style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.amber,
        ),
      body: Center(
        child: 
          Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(4),
                          width: screenWidth * 0.42,
                          child: Image.asset(
                            "assets/profile.png",
                          ),
                        ),
                        const SizedBox(height: 1),
                        const Text(
                          "Guest",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
            ),
            const SizedBox(height: 16),
            SizedBox(
                      width: screenWidth / 1.2,
                      height: 60,
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (content) => const LoginScreen()),
                                );
                              },
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                  const EdgeInsets.all(12), 
                                ),
                                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.pressed)) {
                                      return Colors.yellow; 
                                    } else if (states.contains(MaterialState.hovered)) {
                                      return Colors.yellow; 
                                    }
                                    return Colors.orange; 
                                  },
                                ),
                              ),
                              child: const Text(
                                "Log in",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
            
            const SizedBox(height: 8),
            SizedBox(
                      width: screenWidth / 1.2,
                      height: 60,
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8), 
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (content) => const RegistrationScreen()),
                                );
                              },
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                  const EdgeInsets.all(12), 
                                ),
                                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.pressed)) {
                                      return Colors.yellow; 
                                    } else if (states.contains(MaterialState.hovered)) {
                                      return Colors.yellow; 
                                    }
                                    return Colors.orange; 
                                  },
                                ),
                              ),
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
          ],
        ),

      ),
    );
  }
}
