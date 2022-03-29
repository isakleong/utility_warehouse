import 'dart:async';
import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' show Client;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:utility_warehouse/models/result.dart';
import 'package:utility_warehouse/resources/userAPI.dart';
import 'package:utility_warehouse/screens/pick_page.dart';
import 'package:lottie/lottie.dart';
import 'package:utility_warehouse/settings/configuration.dart';
import 'package:utility_warehouse/tools/function.dart';
import 'package:utility_warehouse/widget/button.dart';
import 'package:utility_warehouse/widget/textView.dart';

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
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeRight,
    // ]);
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
                      Hero(
                        tag: 'logo',
                        child: Container(
                          width: mediaWidth*0.5,
                          height: mediaWidth*0.5,
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
                      Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Button(
                          disable: false,
                          child: TextView('Masuk', 3, color: Colors.white, caps: true),
                          onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => PickPage()),
                              // );
                              submitValidation();
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

  void doLogin() async {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      loginLoading = true;
    });

    Alert(context: context, loading: true, disableBackButton: true);

    await getDeviceConfig(context);

    Result result = await userAPI.login(context, usernameController.text, passwordController.text);

    Navigator.of(context).pop();

    if(result.code == 200) {
      printHelp("yeeeeeee");
      // Navigator.pushReplacementNamed(
      //   context,
      //   "dashboard"
      // );
    } else {
      Alert(
        context: context,
        title: "Maaf,",
        content: Text(result.error_message),
        cancel: false,
        type: "error"
      );  
    }

    setState(() {
      loginLoading = false;
    });

  }

  void submitValidation() {
    setState(() {
      usernameController.text.isEmpty ? usernameValid = true : usernameValid = false;
      passwordController.text.isEmpty ? passwordValid = true : passwordValid = false;
    });

    if(!usernameValid && !passwordValid){
      printHelp("tes");
      doLogin();
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