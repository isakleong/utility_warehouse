import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:http/http.dart' show Client, Request;
import 'package:utility_warehouse/screens/login.dart';
import 'package:utility_warehouse/settings/configuration.dart';

const debug = true;

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  didChangeDependencies() async {
    super.didChangeDependencies();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {

    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Container(
          width: mediaWidth-120,
          height: mediaHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: "logo",
                child: InkWell(
                  child: Image.asset(
                    "assets/illustration/logo.png", alignment: Alignment.center, fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 100),
              Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(config.darkOpacityBlueColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  startTimer() {
    var _duration = Duration(milliseconds: 2000);
    return Timer(_duration, navigate);
  }

  void navigate() async {
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            transitionDuration: Duration(seconds: 4),
            pageBuilder: (_, __, ___) => Login()));
  }

}