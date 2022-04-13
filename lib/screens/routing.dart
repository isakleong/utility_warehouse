import 'package:flutter/material.dart';
import 'package:utility_warehouse/screens/dashboard.dart';
import 'package:utility_warehouse/screens/login.dart';
import 'package:utility_warehouse/screens/otpVerification.dart';
import 'package:utility_warehouse/screens/processOpnameData.dart';
import 'package:utility_warehouse/screens/signUp.dart';
import 'package:utility_warehouse/screens/splashscreen.dart';

MaterialPageRoute routing(int mode, int id, List<String> pages, RouteSettings settings) {
  switch (pages[0]) {
    case '':
      return MaterialPageRoute(builder: (context)=> SplashScreen());
      break;
    case 'login':
      return MaterialPageRoute(builder: (context)=> Login());
      break;
    case 'signUp':
      return MaterialPageRoute(builder: (context)=> SignUp(model: settings.arguments));
      break;
    case 'otpVerification':
      return MaterialPageRoute(builder: (context)=> OTPVerification(model: settings.arguments));
      break;
    case 'dashboard':
      return MaterialPageRoute(builder: (context)=> Dashboard());
      break;
    case 'processOpnameData':
      return MaterialPageRoute(builder: (context)=> ProcessOpnameData());
      break;
    // case 'examplePage 1':
    //   return MaterialPageRoute(builder: (context)=> Page1(result: settings.arguments));
    //   break;
    // case 'examplePage 2':
    //   return MaterialPageRoute(builder: (context)=> Page2());
    //   break;
    // case 'examplePage 3':
    //   return MaterialPageRoute(builder: (context)=> Page3(mode: mode, id: id, model: settings.arguments));
    //   break;
    default:
      return MaterialPageRoute(builder: (_) {
        return Scaffold(
          appBar: AppBar(title: Text("Error")),
          body: Center(child: Text('Error page')),
        );
    });
  }
}