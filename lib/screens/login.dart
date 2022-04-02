import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' show Client;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:utility_warehouse/models/result.dart';
import 'package:utility_warehouse/models/userModel.dart';
import 'package:utility_warehouse/resources/userAPI.dart';
import 'package:utility_warehouse/screens/pick_page.dart';
import 'package:lottie/lottie.dart';
import 'package:utility_warehouse/settings/configuration.dart';
import 'package:utility_warehouse/tools/function.dart';
import 'package:utility_warehouse/widget/button.dart';
import 'package:utility_warehouse/widget/textView.dart';
import 'package:xml/xml.dart';

class Login extends StatefulWidget {

  const Login({Key key}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}


class LoginState extends State<Login> {
  static const platform = const MethodChannel("connectionTest");

  bool unlockPassword = true;
  bool unlockNewPassword = true;
  bool unlockConfirmPassword = true;
  bool loginLoading = false;

  bool usernameValid = false;
  bool passwordValid = false;
  bool newPasswordValid = false;
  bool confirmPasswordValid = false;

  final FocusNode usernameFocus = FocusNode();  
  final FocusNode passwordFocus = FocusNode();
  final FocusNode newPasswordFocus = FocusNode();
  final FocusNode confirmPasswordFocus = FocusNode();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  StateSetter _setState;

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
    usernameController.text = "000-WH-MG9";
    passwordController.text = "Gustiawan22";
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
                            fieldFocusChange(context, usernameFocus, passwordFocus);
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
                            submitLoginValidation();
                          },
                        ),
                      ),
                      Container(
                        width: mediaWidth,
                        padding: EdgeInsets.only(top: 15),
                        child: Button(
                          disable: false,
                          child: TextView('Masuk', 3, color: Colors.white, caps: true),
                          onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => PickPage()),
                              // );
                              submitLoginValidation();
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

  getToken(context) async {
    Configuration config = Configuration.of(context);
    Directory dir = await getExternalStorageDirectory();
    String path = '${dir.path}/deviceconfig.xml';
    File file = File(path);

    if(FileSystemEntity.typeSync(path) != FileSystemEntityType.notFound){
      final document = XmlDocument.parse(file.readAsStringSync());
      final tokenID = document.findAllElements('token_id').map((node) => node.text);
      return tokenID.first;
    } else {
      return "";
    }
  }

  void doUpdatePassword() async {

  }

  void doLogin() async {
    FocusScope.of(context).requestFocus(FocusNode());

    Alert(context: context, loading: true, disableBackButton: true);

    await getDeviceConfig(context);

    Result result = await userAPI.login(context, usernameController.text, passwordController.text);

    Navigator.of(context).pop();

    if(result.code == 200) {
      // auth validation
      String tokenID = await getToken(context);
      // tokenID = "5753";
      User user = await userAPI.authValidation(context, usernameController.text, tokenID);
      
      bool isAuthValid = false;
      try {
        if(user.userId != "") {
          isAuthValid = true;
        }
      } catch (e) {
        isAuthValid = false;
      }

      if(isAuthValid) {
        if(DateTime.now().isBefore(user.dtmValid)) {
          if(passwordController.text.contains("1234")){
            Navigator.pushReplacementNamed(
              context,
              "dashboard"
            );
          } else {
            setState(() {
              newPasswordController.clear();
              confirmPasswordController.clear();
            });
            Alert(
              context: context,
              title: "Silahkan masukkan password baru,",
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  _setState = setState;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        key: Key("NewPassword"),
                        controller: newPasswordController,
                        obscureText: unlockNewPassword,
                        focusNode: newPasswordFocus,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: "Password",
                          errorText: newPasswordValid ? "Password tidak boleh kosong" : null,
                          suffixIcon: InkWell(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Icon(
                                Icons.remove_red_eye,
                                color:  unlockNewPassword ? config.lightGrayColor : config.grayColor,
                                size: 18,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                unlockNewPassword = !unlockNewPassword;
                              });
                            },
                          ),
                        ),
                        onSubmitted: (value) {
                          fieldFocusChange(context, newPasswordFocus, confirmPasswordFocus);
                        },
                      ),
                      SizedBox(height: 15),
                      TextField(
                        key: Key("ConfirmPassword"),
                        controller: confirmPasswordController,
                        obscureText: unlockConfirmPassword,
                        focusNode: confirmPasswordFocus,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.go,
                        decoration: InputDecoration(
                          hintText: "Konfirmasi Password",
                          errorText: confirmPasswordValid ? "Konfirmasi password tidak boleh kosong" : null,
                          suffixIcon: InkWell(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Icon(
                                Icons.remove_red_eye,
                                color:  unlockConfirmPassword ? config.lightGrayColor : config.grayColor,
                                size: 18,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                unlockConfirmPassword = !unlockConfirmPassword;
                              });
                            },
                          ),
                        ),
                        onSubmitted: (value) {
                          confirmPasswordFocus.unfocus();
                          submitUpdatePasswordValidation();
                        },
                      ),
                    ],
                  );
                }
              ),
              cancel: false,
              type: "warning",
              defaultAction: () {
                submitUpdatePasswordValidation();
              }
            );  
          }

        } else {
          Alert(
            context: context,
            title: "Maaf,",
            content: TextView("Anda tidak lagi memiliki izin untuk mengakses aplikasi ini.\nSilahkan hubungi tim SFA untuk info lebih lanjut.", 4),
            cancel: false,
            type: "error"
          );  
        }

      } else {
        Alert(
          context: context,
          title: "Maaf,",
          content: TextView("Perangkat baru terdeteksi\nMohon untuk melakukan registrasi NIK terlebih dahulu", 4),
          cancel: false,
          type: "error",
          defaultAction: () {
            Navigator.of(context).pop();
            Navigator.pushNamed(context, "signUp");
          }
        );  
      }

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

    // setState(() {
    //   loginLoading = false;
    // });

  }

  void codeVerification() async {
    
  }

  void submitUpdatePasswordValidation() {
    _setState(() {
      newPasswordController.text.isEmpty ? newPasswordValid = true : newPasswordValid = false;
      confirmPasswordController.text.isEmpty ? confirmPasswordValid = true : confirmPasswordValid = false;
    });

    if(!newPasswordValid && !confirmPasswordValid){
      doUpdatePassword();
    }
  }

  void submitLoginValidation() {
    setState(() {
      usernameController.text.isEmpty ? usernameValid = true : usernameValid = false;
      passwordController.text.isEmpty ? passwordValid = true : passwordValid = false;
    });

    if(!usernameValid && !passwordValid){
      doLogin();
    }
  }

  // fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
  //   currentFocus.unfocus();
  //   FocusScope.of(context).requestFocus(nextFocus); 
  // }


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