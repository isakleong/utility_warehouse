import 'dart:io';
import 'package:flutter/services.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:utility_warehouse/settings/configuration.dart';
import 'package:utility_warehouse/tools/function.dart';
import 'package:utility_warehouse/widget/button.dart';
import 'package:utility_warehouse/widget/textView.dart';
import 'package:xml/xml.dart';

class Setting extends StatefulWidget {
  final String pageName;

  const Setting({Key key, this.pageName}) : super(key: key);

  @override
  SettingState createState() => SettingState();
}

class SettingState extends State<Setting> {
  bool popUpBack = false;

  bool loginLoading = false;

  bool urlAddressValid_1 = false;
  bool urlAddressValid_2 = false;
  bool urlAddressValid_3 = false;

  final FocusNode urlAdrressFocus_1 = FocusNode();
  final FocusNode urlAdrressFocus_2 = FocusNode();
  final FocusNode urlAdrressFocus_3 = FocusNode();
  final urlAdreessController_1 = TextEditingController();
  final urlAdreessController_2 = TextEditingController();
  final urlAdreessController_3 = TextEditingController();

  String token = "";

  DateTime currentBackPressTime;

  @override
  void initState() {
    super.initState();
    getDeviceConfig();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if(widget.pageName.contains("splashScreen")) {
      setState(() {
        popUpBack = false;
      });
    } else {
      setState(() {
        popUpBack = true;
      });      
    }
  }
  
  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          if(popUpBack) {
            Navigator.of(context).pop();
          } else {
            Navigator.pushReplacementNamed(context, "");
          }
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 60),
              child: SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    height: 50,
                    width: 50,
                    color: Colors.transparent,
                    child: Button(
                      disable: false,
                      child: Icon(Icons.arrow_back, color: Colors.white),
                      onTap: () {
                        if(popUpBack) {
                          Navigator.of(context).pop();
                        } else {
                          Navigator.pushReplacementNamed(context, "");
                        }
                      },
                    ),
                  ),
                ),
              ),
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
                            fieldFocusChange(context, urlAdrressFocus_2, urlAdrressFocus_3);
                          },
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(
                        child: TextField(
                          key: Key("UrlAddress3"),
                          controller: urlAdreessController_3,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          focusNode: urlAdrressFocus_3,
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
                            labelText: "IP Address 3",
                            errorText: urlAddressValid_3 ? "IP tidak boleh kosong" : null,
                          ),
                          onSubmitted: (value) {
                            urlAdrressFocus_3.unfocus();
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
                            Alert(
                              context: context,
                              title: "Konfirmasi,",
                              content: TextView("Apakah Anda yakin ingin menyimpan konfigurasi IP?", 4),
                              cancel: true,
                              type: "warning",
                              defaultAction: (){
                                submitUrlConfig();
                              }
                            );
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
    // Directory dir = await getExternalStorageDirectory();
    // String path = '${dir.path}/deviceconfig.xml';
    String path = '/storage/emulated/0/Android/data/com.example.utility_warehouse/files/deviceconfig.xml';
    File file = File(path);

    if(FileSystemEntity.typeSync(path) != FileSystemEntityType.notFound){
      final document = XmlDocument.parse(file.readAsStringSync());
      final urlAddress_1 = document.findAllElements('url_address_local').map((node) => node.text);
      final urlAddress_2 = document.findAllElements('url_address_public').map((node) => node.text);
      final urlAddress_3 = document.findAllElements('url_address_public_alt').map((node) => node.text);
      final tempToken = document.findAllElements('token').map((node) => node.text);

      try {
        urlAdreessController_1.text = urlAddress_1.first;
        urlAdreessController_1.selection = TextSelection.fromPosition(TextPosition(offset: urlAdreessController_1.text.length));

        urlAdreessController_2.text = urlAddress_2.first;
        urlAdreessController_2.selection = TextSelection.fromPosition(TextPosition(offset: urlAdreessController_2.text.length));

        urlAdreessController_3.text = urlAddress_3.first;
        urlAdreessController_3.selection = TextSelection.fromPosition(TextPosition(offset: urlAdreessController_3.text.length));

        token = tempToken.first;
      } catch (e) {
        print("Error read device config (setting page) : "+e.toString());
      }
    }
  }

  submitUrlConfig() async {
    Alert(context: context, loading: true, disableBackButton: true);

    // Directory dir = await getExternalStorageDirectory();
    // String path = '${dir.path}/deviceconfig.xml';
    String path = '/storage/emulated/0/Android/data/com.example.utility_warehouse/files/deviceconfig.xml';
    File file = File(path);

    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="UTF-8" standalone="yes"');
    builder.element('deviceconfig', nest: () {
      builder.element('url_address_local', nest: urlAdreessController_1.text);
      builder.element('url_address_public', nest: urlAdreessController_2.text);
      builder.element('url_address_public_alt', nest: urlAdreessController_3.text);
      builder.element('token_id', nest: token);
    });
    final document = builder.buildDocument();
    await file.writeAsString(document.toString());

    Navigator.of(context).pop();
    Alert(
      context: context,
      title: "Info,",
      content: TextView("Pengaturan konfigurasi IP berhasil disimpan", 4),
      cancel: false,
      type: "success",
      defaultAction: (){
        setState(() {
          urlAdrressFocus_1.unfocus();
          urlAdrressFocus_2.unfocus();
        });
      }
    );
    // Navigator.pushReplacementNamed(context, "");
  }

}