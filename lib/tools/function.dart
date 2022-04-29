import 'dart:async';
import 'package:http/http.dart' show Client, Request;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:utility_warehouse/settings/configuration.dart';
import 'package:utility_warehouse/widget/button.dart';
import 'package:utility_warehouse/widget/textView.dart';
import 'package:xml/xml.dart';
import 'package:encrypt/encrypt.dart' as EncryptionPackage;
import 'package:crypto/crypto.dart' as CryptoPackage;
import 'dart:convert' as ConvertPackage;

printHelp(final print) {
  debugPrint("---------------------------------");
  debugPrint(print.toString());
  debugPrint("---------------------------------");
}

getUrlConfig(context) async {
  Configuration configuration = Configuration.of(context);

  String path = '/storage/emulated/0/Android/data/com.example.utility_warehouse/files/deviceconfig.xml';

  File file = File(path);

  if(FileSystemEntity.typeSync(path) != FileSystemEntityType.notFound){
    final document = XmlDocument.parse(file.readAsStringSync());
    final url_address_1 = document.findAllElements('url_address_1').map((node) => node.text);
    final url_address_2 = document.findAllElements('url_address_2').map((node) => node.text);
    configuration.setUrlPath = url_address_1.first;
    configuration.setUrlPathAlt = url_address_2.first;
  }

  return configuration;
}

String fetchAPI(String url, BuildContext context, {String parameter = "", bool print = false, bool secondary = false}) {
  Configuration configuration = Configuration.of(context);

  String urlAPI;
  if(secondary) {
    urlAPI = configuration.urlPathAlt + "/" + url + (parameter == "" ? "" : "&" + parameter);
  } else {
    urlAPI = configuration.urlPath + "/" + url + (parameter == "" ? "" : "&" + parameter);
  }
  
  if(print)
    debugPrint("url api print "+urlAPI);
  return urlAPI;
}

String decryptData(String data) {
  String strPwd = "snwO+67pWwpuypbyeazkkK6CNAfpsOivLuSwR/rd4uM=";
  String strIv = 'K8IgRZtkuepdGc1VnOp6eA==';
  var iv = CryptoPackage.sha256
      .convert(ConvertPackage.utf8.encode(strIv))
      .toString()
      .substring(0, 16); // Consider the first 16 bytes of all 64 bytes
  var key = CryptoPackage.sha256
      .convert(ConvertPackage.utf8.encode(strPwd))
      .toString()
      .substring(0, 32); // Consider the first 32 bytes of all 64 bytes
  EncryptionPackage.IV ivObj = EncryptionPackage.IV.fromUtf8(iv);
  EncryptionPackage.Key keyObj = EncryptionPackage.Key.fromUtf8(key);
  final encrypter = EncryptionPackage.Encrypter(EncryptionPackage.AES(keyObj,
      mode: EncryptionPackage.AESMode.cbc)); // Apply CBC mode
  String firstBase64Decoding = new String.fromCharCodes(
      ConvertPackage.base64.decode(data)); // First Base64 decoding
  final decrypted = encrypter.decrypt(
      EncryptionPackage.Encrypted.fromBase64(firstBase64Decoding),
      iv: ivObj); // Second Base64 decoding (during decryption)
  return decrypted;
}

String encryptData(String data) {
  // String strPwd = "6P8yHVfeZ5JKaXQ6AyaBge";
  // String strIv = 'cHaa5y7pQF5uqA2N';
  String strPwd = "snwO+67pWwpuypbyeazkkK6CNAfpsOivLuSwR/rd4uM=";
  String strIv = 'K8IgRZtkuepdGc1VnOp6eA==';
  var iv = CryptoPackage.sha256
      .convert(ConvertPackage.utf8.encode(strIv))
      .toString()
      .substring(0, 16);
  var key = CryptoPackage.sha256
      .convert(ConvertPackage.utf8.encode(strPwd))
      .toString()
      .substring(0, 32);
  EncryptionPackage.IV ivObj = EncryptionPackage.IV.fromUtf8(iv);
  EncryptionPackage.Key keyObj = EncryptionPackage.Key.fromUtf8(key);

  final encrypter = EncryptionPackage.Encrypter(
      EncryptionPackage.AES(keyObj, mode: EncryptionPackage.AESMode.cbc));

  final encrypted = encrypter.encrypt(data.toString(), iv: ivObj);

  return ConvertPackage.base64
      .encode(ConvertPackage.utf8.encode(encrypted.base64));
}

Future<String> connectionTest(String url, BuildContext context) async {
  Client client = Client();
  String testResult = "ERROR";

  final request = new Request('HEAD', Uri.parse(url))..followRedirects = false;
  try {
    final response = await client.send(request).timeout(
      Duration(seconds: 3),
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

fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus); 
}

void Alert({ context, String title, Widget content, List<Widget> actions, VoidCallback defaultAction, bool cancel = true, String type = "warning", bool showIcon = true,
  bool disableBackButton = false, Future<bool> willPopAction, loading = false, double value, String errorBtnTitle = "OK" }) {

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
    double iconWidth = 80, iconHeight = 80;
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
          onWillPop: disableBackButton ? () {
          }:willPopAction,
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
                child: TextView("Tidak", 2, fontSize: 16, color: Colors.white),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ) : Container(),
              Button(
                key: Key("ok"),
                child: cancel ? TextView("Ya", 2, fontSize: 16, color: Colors.white) : type == "error" ? TextView(errorBtnTitle, 2, fontSize: 16, color: Colors.white) : TextView("Ok", 2, caps: true, fontSize: 16, color: Colors.white),
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
          onWillPop: disableBackButton ? () {
          }:null,
          child: Center(
            child: Container(
                child: Lottie.asset('assets/illustration/loading.json', width: 220, height: 220, fit: BoxFit.contain)
              ),
          )
          // ListView(
          //   children: [
          //     SizedBox(height: 30),
          //     Container(
          //       child: Lottie.asset('assets/illustration/loading.json', width: 220, height: 220, fit: BoxFit.contain)
          //     ),
          //   ],
          // )
        );
      }
    );
  }

}