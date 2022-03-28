import 'package:flutter/material.dart';

class Configuration extends InheritedWidget {
  Configuration({
    Key key,
    Widget child,
  }) : super(key: key, child: child);

  String ip_public = "203.142.77.243";
  String ip_public_alt = "103.76.27.124";
  // String ip_port = "80" ;
  String serverName = "Utility_Warehouse_Dev";
  String apkName = "Utility Warehouse Dev";
  String apkVersion = "1.0";

  String get baseUrl => "http://"+ip_public+"/"+serverName;
  String get baseUrlAlt => "http://"+ip_public_alt+"/"+serverName;

  String initRoute = "";

  bool updateShouldNotify(oldWidget) => true;
  
  static Configuration of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType());
  }

  // color configuration
  Color darkOpacityBlueColor = Color(0xFF0077AF);
  Color grayColor = Color(0xFF545454);
  Color lightGrayColor = Color(0xFFC4C4C4);
  Color lighterGrayColor = Color(0xFFDDDDDD);

}

final config = Configuration();