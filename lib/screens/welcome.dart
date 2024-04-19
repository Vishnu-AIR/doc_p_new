import 'package:dummy1/screens/home.dart';
import 'package:dummy1/screens/navbar.dart';
import 'package:dummy1/screens/signup.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  final bool isLoggedIn;
  const WelcomeScreen({Key? key, required this.isLoggedIn}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    const welcomeDuration = Duration(seconds: 1);

    // After the welcome duration, navigate to the second screen
    Future.delayed(welcomeDuration, () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => isLoggedIn ? NavBar() : SignUpScreen()),
      );
    });

    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0XFF00FFFF),
                    Color(0XFF00AAFF),
                    Color(0XFF0062FF)
                  ]),
              image: DecorationImage(
                  image: AssetImage("assets/images/img_startup_screen.png"),
                  fit: BoxFit.fitWidth,
                  scale: 8,
                  alignment: Alignment.bottomCenter)),
          child: Center(
            child: Image.asset(
              "assets/images/img_7_1.png",
              scale: 3,
            ),
          )),
    );
  }
}
