import 'package:flutter/material.dart';
import 'package:utility_warehouse/screens/adjustmentStockOpname.dart';
import 'package:utility_warehouse/screens/coba.dart';
import 'package:utility_warehouse/screens/dashboard.dart';
import 'package:utility_warehouse/screens/login.dart';
import 'package:utility_warehouse/screens/otpVerification.dart';
import 'package:utility_warehouse/screens/performanceStockOpname.dart';
import 'package:utility_warehouse/screens/pick_page_vertical.dart';
import 'package:utility_warehouse/screens/processOpnameData.dart';
import 'package:utility_warehouse/screens/reportStockOpname.dart';
import 'package:utility_warehouse/screens/setting.dart';
import 'package:utility_warehouse/screens/signUp.dart';
import 'package:utility_warehouse/screens/splashscreen.dart';
import 'package:utility_warehouse/screens/stockOpnameDifference.dart';
import 'package:utility_warehouse/screens/stockopname.dart';

MaterialPageRoute routing(int mode, int id, List<String> pages, RouteSettings settings) {
  switch (pages[0]) {
    case '':
      return MaterialPageRoute(builder: (context)=> SplashScreen());
      break;
    case 'setting':
      return MaterialPageRoute(builder: (context)=> Setting(pageName: settings.arguments));
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
      return MaterialPageRoute(builder: (context)=> Dashboard(userModel: settings.arguments));
      break;
    case 'processOpnameData':
      return MaterialPageRoute(builder: (context)=> ProcessOpnameData(model: settings.arguments));
      break;
    case 'stockOpname':
      return MaterialPageRoute(builder: (context)=> StockOpname());
      break;
    case 'stockOpnameDifference':
      return MaterialPageRoute(builder: (context)=> StockOpnameDifference());
      break;
    case 'adjustmentStockOpname':
      return MaterialPageRoute(builder: (context)=> AdjustmentStockOpname());
      break;
    case 'reportStockOpname':
      return MaterialPageRoute(builder: (context)=> ReportStockOpname());
      break;
    case 'performanceStockOpname':
      return MaterialPageRoute(builder: (context)=> PerformanceStockOpname());
      break;
    case 'pick':
      return MaterialPageRoute(builder: (context)=> PickPageVertical(model: settings.arguments));
      break;
    case 'coba':
      return MaterialPageRoute(builder: (context)=> Coba());
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