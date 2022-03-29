import 'dart:async';
import 'package:http/http.dart' show Client, Request;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:io';
import 'package:utility_warehouse/settings/configuration.dart';
import 'package:utility_warehouse/widget/button.dart';
import 'package:utility_warehouse/widget/textView.dart';

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

// String url_address_1 = config.baseUrl + "/config/" + "getVersion.php" + (parameter == "" ? "" : "?" + parameter);

String fetchAPI(String url, {String parameter = "", bool print = false, bool secondary = false, BuildContext context}) {
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

void Alert({ context, String title, Widget content, List<Widget> actions, VoidCallback defaultAction, bool cancel = true, String type = "warning", bool showIcon = true,
  bool disableBackButton = false, Future<bool> willPopAction, loading = false, double value, String errorBtnTitle = "Ok" }) {

  bool isShowing = false;

  Configuration config = new Configuration();
  
  if (loading == false) {
    if (actions == null) {
      actions = [];
    }

    if (defaultAction == null) {
      defaultAction = () {};
    }

    Widget icon;
    double iconWidth = 40, iconHeight = 40;
    if (type == "success") {
      icon = Container(
        child: Lottie.asset('assets/illustration/success.json', width: iconWidth, height: iconHeight, fit: BoxFit.contain),
      );
    } else if (type == "error") {
      icon = Container(
        child: Lottie.asset('assets/illustration/failed.json', width: iconWidth, height: iconHeight, fit: BoxFit.contain),
      );
    }

    Widget titleWidget;
    // kalau titlenya gak null, judulnya ada
    if (title != null) {
      // kalau titlenya kosongan, brarti gk ada judulnya
      if (title == "") {
        titleWidget = null;
      } else {
        titleWidget = Row(
          children: <Widget>[
            showIcon ? Padding(padding: EdgeInsets.only(right: 20), child:icon) : Container(),
            Expanded(child: TextView(title, 2)),
          ],
        );
        
      }
    } else {
      // kalau titlenya null berarti auto generate tergantung typenya
      titleWidget = Row(
        children: <Widget>[
          showIcon ? Padding(padding: EdgeInsets.only(right: 20), child:icon) : Container(),
          Expanded(child: TextView("Warning", 2)),
        ],
      );
    }
    
    showDialog (
      context: context,
      barrierDismissible: false,
      builder: (context){
        return WillPopScope(
          // onWillPop: disableBackButton ? () {
          // }:willPopAction,
          onWillPop: null,
          child:AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(7.5)),
            ),
            title: titleWidget,
            content: content == null ? null:content,
            // kalau actions nya kosong akan otomatis mengeluarkan tombol ok untuk menutup alert
            actions: actions.length == 0 ?
            [
              defaultAction != null && cancel ?
              Button(
                key: Key("cancel"),
                child: TextView("Tidak", 2, fontSize: 12, color: Colors.white),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ) : Container(),
              Button(
                key: Key("ok"),
                child: cancel ? TextView("Ya", 2, fontSize: 12, color: Colors.white) : type == "error" ? TextView(errorBtnTitle, 2, fontSize: 12, color: Colors.white) : TextView("Ok", 2, fontSize: 12, color: Colors.white),
                onTap: () {
                  Navigator.of(context).pop();
                  defaultAction();
                },
              ),
              // kalau ada default action akan otomatis menampilkan tombol cancel, jadi akan muncul ok dan cancel
            ]
            :
            [
              // kalau ada pilihan tombol lain, akan otomatis mengeluarkan tulisan cancel
              // Button(
              //   key: Key("cancel"),
              //   child: TextView("Tidak", 2, size: 12, caps: false, color: Colors.white),
              //   fill: false,
              //   onTap: () {
              //     Navigator.of(context).pop();
              //   },
              // )
            ]..addAll(actions)..add(Padding(padding: EdgeInsets.only(right:5)))
          )
        );
      }
    );    
  } else if (loading) {
    showDialog (
      context: context,
      barrierDismissible: false,
      builder: (context){
        return WillPopScope(
          // onWillPop: disableBackButton ? () {
          // }:null,
          onWillPop: disableBackButton ? null : null,
          child: ListView(
            children: [
              SizedBox(height: 30),
              Container(
                child: Lottie.asset('assets/illustration/loader.json', width: 220, height: 220, fit: BoxFit.contain)
              ),
            ],
          )
        );
      }
    );
  }

}