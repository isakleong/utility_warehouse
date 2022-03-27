import 'dart:async';
import 'package:flutter/services.dart';
import 'package:http/http.dart' show Client;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:utility_warehouse/screens/pick_page.dart';
import 'package:utility_warehouse/settings/configuration.dart';
import 'package:utility_warehouse/tools/function.dart';

class Login extends StatefulWidget {

  const Login({Key key}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}


class LoginState extends State<Login> {
  static const platform = const MethodChannel("connectionTest");

  bool unlockPassword = true;
  bool loginLoading = false;

  bool usernameValid = false;
  bool passwordValid = false;

  final FocusNode usernameFocus = FocusNode();  
  final FocusNode passwordFocus = FocusNode();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

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
  }
  
  @override
  Widget build(BuildContext context) {
    Configuration config = Configuration.of(context);
    
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: WillPopScope(
        onWillPop: willPopScope,
        child: Stack(
          children:<Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              // child: Image.asset("assets/illustration/bg.png", alignment: Alignment.center, fit: BoxFit.fill),
              color: Colors.orange[200],
            ),
            Center(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Hero(
                        tag: 'logo',
                        child: Container(
                          width: 220,
                          height: 220,
                          child: Image.asset("assets/illustration/logo.png", alignment: Alignment.center, fit: BoxFit.contain),
                        ),
                      ),
                      Container(
                        child: TextField(
                          key: Key("Username"),
                          controller: usernameController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          focusNode: usernameFocus,
                          decoration: InputDecoration(
                            labelText: "Username",
                            errorText: usernameValid ? "Username tidak boleh kosong" : null,
                          ),
                          textCapitalization: TextCapitalization.characters,
                          onSubmitted: (value) {
                            _fieldFocusChange(context, usernameFocus, passwordFocus);
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        child: TextField(
                          key: Key("Password"),
                          controller: passwordController,
                          obscureText: unlockPassword,
                          focusNode: passwordFocus,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.go,
                          decoration: InputDecoration(
                            hintText: "Password",
                            errorText: passwordValid ? "Password tidak boleh kosong" : null,
                            suffixIcon: InkWell(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Icon(
                                  Icons.remove_red_eye,
                                  color:  unlockPassword ? config.lightGrayColor : config.grayColor,
                                  size: 18,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  unlockPassword = !unlockPassword;
                                });
                              },
                            ),
                          ),
                          
                          
                          onSubmitted: (value) {
                            passwordFocus.unfocus();
                            submitValidation();
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 15),
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                          primary: config.darkOpacityBlueColor,
                          padding: EdgeInsets.all(14),
                          elevation: 2,
                          ),
                          child: Text("MASUK ", style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PickPage()),
                            );
                            // submitValidation();
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Theme(
                            data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
                            child: Text("v"+config.apkVersion, style: TextStyle(color: config.grayColor)),
                          ),
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

  void submitValidation() {
    setState(() {
      usernameController.text.isEmpty ? usernameValid = true : usernameValid = false;
      passwordController.text.isEmpty ? passwordValid = true : passwordValid = false;
    });

    if(!usernameValid && !passwordValid){
      printHelp("SUCCESS VALIDATE LOGIN");
    }
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus); 
  }


  Future<bool> willPopScope() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || 
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Tekan sekali lagi untuk keluar dari aplikasi", textAlign: TextAlign.center),
      ));
      return Future.value(false);
    }
    return Future.value(true);
  }

}