import 'dart:async';

import 'package:barterit_application/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';


class PinCodeVeriScreen extends StatefulWidget {
  final String? phoneNumber;
  
  const PinCodeVeriScreen({
    Key? key,
    this.phoneNumber,
  }) :super(key: key);

  @override
  State<PinCodeVeriScreen> createState() =>
    _PinCodeVeriScreenState();
}

class _PinCodeVeriScreenState extends State<PinCodeVeriScreen>{
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState(){
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose(){
    errorController!.close();
    super.dispose();
  }

  snackBar(String? message){
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration:const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
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
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0,),
                            child:Text(
                              'Phone Number Verification',
                              style:TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22
                              ),
                              textAlign: TextAlign.center,
                            )
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30.0,
                              vertical: 8
                            ),
                            child: RichText(
                              text: TextSpan(
                                text:"Enter the code sent to ",
                                children: [
                                  TextSpan(
                                    text:"${widget.phoneNumber}",
                                    style:const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15
                                    )
                                  )
                                ],
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 15
                                ),
                                
                              ),
                              textAlign:TextAlign.center,
                            )
                          ),
                          const SizedBox(
                            height:20,
                          ),
                          Form(
                            key:formKey,
                            child:PinCodeTextField(
                              appContext: context,
                              pastedTextStyle: TextStyle(
                                color:Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                              length:6,
                              obscureText: true,
                              obscuringCharacter: '*',
                              obscuringWidget: const Icon(
                                Icons.pets,
                                color: Colors.blue,
                                size:24,
                              ),
                              blinkWhenObscuring: true,
                              animationType: AnimationType.fade,
                              validator: (v) {
                                if(v!.length < 3){
                                  return "Validate me";
                                }
                                else{
                                  return null;
                                }
                              },
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(5),
                                fieldHeight: 50,
                                fieldWidth: 40,
                                activeFillColor: Colors.white,
                                inactiveFillColor: Colors.white
                              ),
                              cursorColor: Colors.black,
                              animationDuration: const Duration(milliseconds: 300),
                              enableActiveFill: true,
                              errorAnimationController: errorController,
                              controller: textEditingController,
                              keyboardType: TextInputType.number,
                              boxShadows: const [
                                BoxShadow(
                                  offset: Offset(0, 1),
                                  color:Colors.black12,
                                  blurRadius: 10,
                                )
                              ],
                              onCompleted: (v) {
                                debugPrint("Completed");
                              },
                              onChanged: (value) {
                                debugPrint(value);
                                setState(() {
                                  currentText = value;
                                });
                              },
                              beforeTextPaste: (text) {
                                debugPrint("Allowing to paste $text");
                                return true;
                              },
                            )
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30.0
                            ),
                            child:Text(
                              hasError
                              ? "Please fill up all the cells properly"
                              : "",
                              style:const TextStyle(
                                color:Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.w400
                              ),
                            )
                          ),
                          const SizedBox(
                            height:20
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Didn't receive the code?",
                                style:TextStyle(
                                  color:Colors.black54,
                                  fontSize: 15,
                                )
                              ),
                              TextButton(
                                onPressed:() => snackBar("OTP resend!!"),
                                child:const Text(
                                  "RESEND",
                                  style:TextStyle(
                                    color:Color(0xFF91D3B3),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                  )
                                )
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          FadeAnimation(
                            delay:1,
                            child:TextButton(
                              onPressed: () {
                                formKey.currentState!.validate();
                                if(currentText.length != 6 ||
                                currentText != "123456"){
                                  errorController!.add(ErrorAnimationType.shake);
                                  setState(() => hasError = true);
                                }
                                else{
                                  setState(() {
                                    hasError = false;
                                    snackBar("OTP Verified!!");
                                  });
                                }
                              },
                              child:const Text(
                                "Verify",
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
                              ) ,  
                            ),
                          ),
                        ],)
                    )
                  ),
                  const SizedBox(
                            height: 20,
                  ),
                  FadeAnimation(
                            delay:1,
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                "Want to try again?",
                                style: TextStyle(
                                  color:Colors.grey,
                                  letterSpacing: 0.5,
                                )
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                    return const LoginScreen();
                                  },));
                                },
                                child:Text("Sign in",
                                  style:TextStyle(
                                    color:Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                    fontSize: 14
                                  )
                                ),
                              )
                              ],
                            ),
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