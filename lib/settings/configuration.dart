import 'package:flutter/material.dart';

class Configuration extends InheritedWidget {
  Configuration({
    Key key,
    Widget child,
  }) : super(key: key, child: child);

  String ip_public = "203.142.77.243";
  String ip_public_alt = "103.76.27.124";
  String serverName = "NewUtilityWarehouseDev";
  String apkName = "Utility Warehouse Dev";
  String apkVersion = "1.0";

  String urlPathLocal;
  String urlPathPublic;
  String urlPathPublicAlt;

  String get baseUrl => "http://"+ip_public+"/"+serverName+"/";
  String get baseUrlAlt => "http://"+ip_public_alt+"/"+serverName+"/";

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

  
  String get getUrlPathLocal {
    return urlPathLocal;
  }

  String get getUrlPathPublic {
    return urlPathPublic;
  }

  String get getUrlPathPublicAlt {
    return urlPathPublicAlt;
  }

  set setUrlPathLocal(String url) {
    urlPathLocal = url;
  }

  set setUrlPathPublic(String url) {
    urlPathPublic = url;
  }

  set setUrlPathPublicAlt(String url) {
    urlPathPublicAlt = url;
  }

}

final config = Configuration();