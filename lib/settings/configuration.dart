import 'package:flutter/material.dart';

class Configuration extends InheritedWidget {
  Configuration({
    Key key,
    Widget child,
  }) : super(key: key, child: child);

  // String ip_public = "192.168.0.213";
  // String ip_public_alt = "192.168.10.213";
  String ip_public = "192.168.10.213";
  String ip_public_alt = "103.76.27.124";
  // String ip_port = "80" ;
  String serverName = "NewUtilityWarehouseDev";
  String apkName = "Utility Warehouse Dev";
  String apkVersion = "1.0";

  String baseUrl = "";
  String baseUrlAlt = "";

  // String get baseUrl => "http://"+ip_public+"/"+serverName;
  // String get baseUrlAlt => "http://"+ip_public_alt+"/"+serverName;

  String initRoute = "";

  bool updateShouldNotify(oldWidget) => true;
  
  static Configuration of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType());
  }

  // color configuration
  Color darkOpacityBlueColor = Color(0xFF0077AF);
  Color lightOpactityBlueColor = Color(0xFFD2EEFA);
  Color grayColor = Color(0xFF545454);
  Color lightGrayColor = Color(0xFFC4C4C4);
  Color lighterGrayColor = Color(0xFFDDDDDD);

  void setBaseUrl(String url) {
    this.baseUrl = url;
  }

  void setBaseUrlAlt(String url) {
    this.baseUrlAlt = url;
  }

}

final config = Configuration();