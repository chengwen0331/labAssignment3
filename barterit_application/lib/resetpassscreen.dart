//import 'dart:html';

import 'package:barterit_application/pincodeveriscreen.dart';
import 'package:flutter/material.dart';
enum FormData{Email}

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  Color enabled = Color.fromARGB(255, 63, 56, 89);
  Color enabledtext = Colors.white;
  Color deaible = Colors.grey;
  Color backgroundColor = const Color(0xFF1F1A30);
  bool ispasswordev = true;
  FormData? selected;
  TextEditingController _emailEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        /*appBar: AppBar(
          title: const Text('Material App Bar'),
        ),*/
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops:[0.1,0.4,0.7,0.9],
              colors:[
                Color(0xFF4b4293).withOpacity(0.8),
                Color(0xFF4b4293),
                Color(0xFF08418e),
                Color(0xFF08418e),
              ]
            ),
            image:DecorationImage(
              fit:BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2),BlendMode.dstATop),
              image:const NetworkImage(
                ''
              ),
            ),
          ),
          child:Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 5,
                    color:Color.fromARGB(255, 171, 211, 250).withOpacity(0.4),
                    child:Container(
                      width:400,
                      padding:EdgeInsets.all(40.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child:Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FadeAnimation(
                            delay:0.8,
                            child:Image.network(
                              "", 
                              width:100,
                              height:100,
                            ),
                          ),
                          SizedBox(
                            height:10
                          ),
                          FadeAnimation(
                            delay:1,
                            child:Container(
                              child: Text(
                                "Let us help you",
                                style: TextStyle(
                                  color:Colors.white.withOpacity(0.9),
                                  letterSpacing: 0.5,
                                )
                              )
                            ),
                          ),
                          SizedBox(
                            height:20
                          ),
                          FadeAnimation(
                            delay:1,
                            child:Container(
                              width:300, 
                              height:40,
                              decoration: BoxDecoration(
                                borderRadius:BorderRadius.circular(12.0),
                                color:selected == FormData.Email
                                    ? enabled
                                    : backgroundColor,
                              ),
                              padding:const EdgeInsets.all(5.0),
                              child:TextField(
                                controller: _emailEditingController,
                                onTap: (){
                                  setState(() {
                                    selected = FormData.Email;
                                  });
                                },
                                decoration: InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                      color:selected == FormData.Email
                                        ? enabledtext
                                        : deaible,
                                      size:20,
                                  ),
                                  hintText: 'Email',
                                  hintStyle: TextStyle(
                                    color:selected == FormData.Email
                                        ? enabledtext
                                        : deaible,
                                    fontSize:12,
                                  )
                                ),
                                textAlignVertical: TextAlignVertical.center,
                                style:TextStyle(
                                  color:selected == FormData.Email
                                        ? enabledtext
                                        : deaible,
                                        fontWeight: FontWeight.bold,
                                    fontSize:12,
                                )
                              )                             
                            ),
                          ),
                          const SizedBox(
                            height:25,
                          ),
                          FadeAnimation(
                            delay:1,
                            child:TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                    return const PinCodeVeriScreen(
                                      phoneNumber:'0102756960',
                                    );
                                  },
                              ));
                              }, 
                              child:const Text(
                                "Continue",
                                style:TextStyle(
                                  color:Colors.white,
                                  letterSpacing: 0.5,
                                  fontSize: 16, 
                                  fontWeight: FontWeight.bold
                                )
                              ),
                              style:TextButton.styleFrom(
                                backgroundColor: Color(0xFF2697FF),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14.0,
                                  horizontal: 80
                                ), 
                                shape:RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0)
                                )
                              )                            
                            ),
                          ),
                        ],)
                    )
                  ),
                  const SizedBox(
                            height:10,
                  ),
                ],)),)
        )
    );
  }
}

class FadeAnimation extends StatefulWidget {
  final double delay;
  final Widget child;

  const FadeAnimation({required this.delay, required this.child});

  @override
  _FadeAnimationState createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    final curve =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(curve);
    Future.delayed(Duration(milliseconds: (widget.delay * 1000).round()), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}