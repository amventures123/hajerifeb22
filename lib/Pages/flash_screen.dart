import 'package:flutter/material.dart';

import 'package:animated_splash_screen/animated_splash_screen.dart';

import '../main.dart';

class FlashScreen extends StatefulWidget {
  const FlashScreen({Key key}) : super(key: key);

  @override
  _FlashScreenState createState() => _FlashScreenState();
}

class _FlashScreenState extends State<FlashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
          splash: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Image.asset("assets/images/hajeripng.png")),
          duration: 1000,
          splashIconSize: 3000.0,
          animationDuration: Duration(seconds: 1),
          splashTransition: SplashTransition.scaleTransition,
          nextScreen: Home()),
    );
  }
}
