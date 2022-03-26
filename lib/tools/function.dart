import 'dart:async';
import 'package:http/http.dart' show Client, Request;
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:utility_warehouse/settings/configuration.dart';

printHelp(final print) {
  debugPrint("---------------------------------");
  debugPrint(print.toString());
  debugPrint("---------------------------------");
}

Future<String> connectionTest(String url, BuildContext context) async {
  Client client = Client();
  String testResult = "ERROR";

  final request = new Request('HEAD', Uri.parse(url))..followRedirects = false;
  try {
    final response = await client.send(request).timeout(
      Duration(seconds: 10),
        onTimeout: () {
          // time has run out, do what you wanted to do
          return null;
        },
    );

    if(response.statusCode == 200){
      testResult = "OK";
    } else {
      testResult = "ERROR";
    }  
  } catch (e) {
    testResult = "ERROR";
  }

  return testResult;
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

String fetchAPI(String url, {String parameter = "", bool print = false, BuildContext context}) {
  Configuration config;
  if (context != null) {
    config = Configuration.of(context);
  } else {
    config = config;
  }

  String urlAPI = config.baseUrl + "/" + url + (parameter == "" ? "" : "&" + parameter);
  if(print)
    debugPrint("url api "+url);
  return urlAPI;
}