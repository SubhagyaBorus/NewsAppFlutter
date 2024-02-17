import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/view/home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;

    final width = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              height: height * 0.5,
              'assets/images/splash_pic.jpg',
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: height * 0.04,
            ),
            Text(
              "TOP HEADLINES",
              style: GoogleFonts.anton(
                  letterSpacing: 1.5, color: Colors.grey.shade700),
            ),
            SizedBox(
              height: height * 0.04,
            ),
            SpinKitChasingDots(
              size: 40,
              color: Colors.blue,
            )
          ],
        ),
      ),
    );
  }
}
