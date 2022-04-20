import 'dart:async';
import 'dart:io';
// import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' show Client;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:utility_warehouse/models/result.dart';
import 'package:utility_warehouse/models/userModel.dart';
import 'package:utility_warehouse/resources/userAPI.dart';
import 'package:utility_warehouse/settings/configuration.dart';
import 'package:utility_warehouse/tools/function.dart';
import 'package:utility_warehouse/widget/button.dart';
import 'package:utility_warehouse/widget/textView.dart';
import 'package:xml/xml.dart';

class Setting extends StatefulWidget {

  const Setting({Key key}) : super(key: key);

  @override
  SettingState createState() => SettingState();
}

class SettingState extends State<Setting> {
  bool loginLoading = false;

  bool urlAddressValid_1 = false;
  bool urlAddressValid_2 = false;

  final FocusNode urlAdrressFocus_1 = FocusNode();  
  final FocusNode urlAdrressFocus_2 = FocusNode();  
  final urlAdreessController_1 = TextEditingController();
  final urlAdreessController_2 = TextEditingController();

  String token = "";

  DateTime currentBackPressTime;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await getDeviceConfig();
  }
  
  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          printHelp("BACK PRESS");
          Navigator.pushReplacementNamed(context, "");
         return false; 
        },
        child: Stack(
          children:<Widget>[
            Container(
              height: mediaHeight,
              width: mediaWidth,
              // color: Colors.white,
              child: Image.asset("assets/illustration/background.png", fit: BoxFit.fill),
            ),
            Center(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 60),
                        child: Container(
                          child: TextView("Pengaturan", 1),
                        ),
                      ),
                      Container(
                        child: TextField(
                          key: Key("UrlAddress1"),
                          controller: urlAdreessController_1,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          focusNode: urlAdrressFocus_1,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize:16, fontFamily: 'Roboto'),
                            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily:'Roboto', fontSize: 16),
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(width: 1.5, color: config.grayColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(width: 1.5, color: config.darkOpacityBlueColor),
                            ),
                            labelText: "IP Address 1",
                            errorText: urlAddressValid_1 ? "IP tidak boleh kosong" : null,
                          ),
                          onSubmitted: (value) {
                            fieldFocusChange(context, urlAdrressFocus_1, urlAdrressFocus_2);
                          },
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(
                        child: TextField(
                          key: Key("UrlAddress2"),
                          controller: urlAdreessController_2,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          focusNode: urlAdrressFocus_2,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize:16, fontFamily: 'Roboto'),
                            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily:'Roboto', fontSize: 16),
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(width: 1.5, color: config.grayColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(width: 1.5, color: config.darkOpacityBlueColor),
                            ),
                            labelText: "IP Address 2",
                            errorText: urlAddressValid_2 ? "IP tidak boleh kosong" : null,
                          ),
                          onSubmitted: (value) {
                            urlAdrressFocus_2.unfocus();
                          },
                        ),
                      ),
                      SizedBox(height: 50),
                      Container(
                        width: mediaWidth,
                        child: Button(
                          disable: false,
                          child: TextView('Simpan', 3, color: Colors.white, caps: true),
                          onTap: () {
                              submitUrlConfig();
                            },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }

  getDeviceConfig() async {
    // Configuration config = Configuration.of(context);
    Directory dir = await getExternalStorageDirectory();
    String path = '${dir.path}/deviceconfig.xml';
    File file = File(path);

    printHelp("HMMM");

    if(FileSystemEntity.typeSync(path) != FileSystemEntityType.notFound){
      final document = XmlDocument.parse(file.readAsStringSync());
      final url_address_1 = document.findAllElements('url_address_1').map((node) => node.text);
      final url_address_2 = document.findAllElements('url_address_2').map((node) => node.text);
      final tempToken = document.findAllElements('token').map((node) => node.text);

      urlAdreessController_1.text = url_address_1.first;
      urlAdreessController_1.selection = TextSelection.fromPosition(TextPosition(offset: urlAdreessController_1.text.length));

      urlAdreessController_2.text = url_address_2.first;
      urlAdreessController_2.selection = TextSelection.fromPosition(TextPosition(offset: urlAdreessController_2.text.length));

      token = tempToken.first;
    }
  }

  submitUrlConfig() async {
    Alert(context: context, loading: true, disableBackButton: true);

    Directory dir = await getExternalStorageDirectory();
    String path = '${dir.path}/deviceconfig.xml';
    File file = File(path);

    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="UTF-8" standalone="yes"');
    builder.element('deviceconfig', nest: () {
      builder.element('url_address_1', nest: urlAdreessController_1.text);
      builder.element('url_address_2', nest: urlAdreessController_2.text);
      builder.element('token_id', nest: token);
    });
    final document = builder.buildDocument();
    await file.writeAsString(document.toString());

    Navigator.of(context).pop();
    Navigator.pushReplacementNamed(context, "");
  }

}