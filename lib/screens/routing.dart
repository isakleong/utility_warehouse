import 'package:flutter/material.dart';
import 'package:utility_warehouse/screens/splashscreen.dart';

MaterialPageRoute routing(int mode, int id, List<String> pages, RouteSettings settings) {
  switch (pages[0]) {
    case '':
      return MaterialPageRoute(builder: (context)=> SplashScreen());
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