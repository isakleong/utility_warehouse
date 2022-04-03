import 'dart:async';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:utility_warehouse/models/result.dart';
import 'package:utility_warehouse/resources/userAPI.dart';
import 'package:utility_warehouse/screens/login.dart';
import 'package:utility_warehouse/settings/configuration.dart';
import 'package:utility_warehouse/tools/function.dart';
import 'package:utility_warehouse/widget/button.dart';
import 'package:utility_warehouse/widget/textView.dart';
import 'package:xml/xml.dart';

class OTPVerification extends StatefulWidget {
  final model;

  const OTPVerification({Key key, this.model}) : super(key: key);

  @override
  OTPVerificationState createState() => OTPVerificationState();
}


class OTPVerificationState extends State<OTPVerification> {
  var model;
  var generatedToken = [];

  var onTapRecognizer;

  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  StreamController<ErrorAnimationType> errorController;

  bool hasError = true;
  bool otpValid = true;
  String otpText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  bool unlockNewPassword = true;
  bool unlockConfirmPassword = true;

  bool newPasswordValid = false;
  bool confirmPasswordValid = false;

  final FocusNode newPasswordFocus = FocusNode();
  final FocusNode confirmPasswordFocus = FocusNode();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  StateSetter _setState;

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    errorController = StreamController<ErrorAnimationType>();

    model = widget.model;
    generatedToken = model["tokenID"].toString().split("|");

    print("generate token "+generatedToken[1]);
    print("generate user id "+model["userID"]);
    print("generate nik "+model["nik"]);

    super.initState();
  }

  @override
  void dispose() {
    errorController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      bottomNavigationBar: Button(
        disable: hasError,
        child: TextView('Verifikasi', 3, color: Colors.white, caps: true),
        onTap: () {
          submitOTPValidation();
        },
      ),
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Stack(
          children:<Widget>[
            Container(
              height: mediaHeight,
              width: mediaWidth,
              // color: Colors.white,
              child: Image.asset("assets/illustration/bga.png", fit: BoxFit.fill),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
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
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                  child: TextView("Verifikasi Kode", 1),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                  child: TextView("Silahkan masukkan 4 digit kode yang telah dikirim ke nomor Whatsapp Anda", 6, align: TextAlign.center),
                ),
                SizedBox(height: 30),
                Form(
                    key: formKey,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 30),
                        child: PinCodeTextField(
                          appContext: context,
                          pastedTextStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          length: 4,
                          animationType: AnimationType.scale,
                          errorTextSpace: 30,
                          validator: (v) {
                            if(otpValid) {
                              if (v.length < 4) {
                                return "Kode Verifikasi belum lengkap, mohon dicek kembali";
                              } else {
                                return null;
                              }
                            } else {
                              return "Kode Verifikasi tidak valid, mohon dicek kembali";
                            }
                          },
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(10),
                            fieldHeight: 70,
                            fieldWidth: 60,
                            inactiveColor: config.darkOpacityBlueColor,
                            selectedColor: config.darkOpacityBlueColor,
                            activeColor: config.darkOpacityBlueColor,
                            selectedFillColor: config.lightOpactityBlueColor,
                            inactiveFillColor: config.lightOpactityBlueColor,
                            activeFillColor: !otpValid ? Colors.red[200] : config.lightOpactityBlueColor,
                          ),
                          cursorColor: Colors.black,
                          animationDuration: Duration(milliseconds: 300),
                          textStyle: TextStyle(fontSize: 20, height: 1.6),
                          enableActiveFill: true,
                          errorAnimationController: errorController,
                          controller: textEditingController,
                          keyboardType: TextInputType.number,
                          boxShadows: [
                            BoxShadow(
                              offset: Offset(0, 1),
                              color: Colors.black12,
                              blurRadius: 10,
                            )
                          ],

                          // onTap: () {
                          //   print("Pressed");
                          // },
                          onChanged: (value) {
                            setState(() {
                              otpText = value;
                            });

                            if(value.length == 4) {
                              setState(() {
                                hasError = false;
                              });
                            } else {
                              setState(() {
                                hasError = true;
                                otpValid = true;
                              });
                            }
                          },
                          beforeTextPaste: (text) {
                            print("Allowing to paste $text");
                            //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                            //but you can show anything you want here, like your pop up saying wrong paste format or etc
                            return false;
                          },
                        )),
                  ),
              ],
            ),
            
          ],
        )
      ),
    );
  }

  void submitOTPValidation() async {
    if(otpText != generatedToken[1]) {
      setState(() {
        otpValid = false;
      });
    } else {
      // user registration
      doSignUp();
    }
  }

  void doSignUp() async {
    Alert(context: context, loading: true, disableBackButton: true);

    await getDeviceConfig(context);

    Result result = await userAPI.signUp(context, model["userID"].toString(), generatedToken[1].toString(), model["nik"].toString());

    Navigator.of(context).pop();

    if(result.code == 200) {
      await updateXMLConfig(generatedToken[1]);
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
    } else {
      Alert(
        context: context,
        title: "Maaf",
        content: Text(result.error_message),
        cancel: false,
        type: "error"
      );  
    }
  }

  void submitUpdatePasswordValidation() async {
    _setState(() {
      newPasswordController.text.isEmpty ? newPasswordValid = true : newPasswordValid = false;
      confirmPasswordController.text.isEmpty ? confirmPasswordValid = true : confirmPasswordValid = false;
    });

    if(!newPasswordValid && !confirmPasswordValid){
      doUpdatePassword();
    }
  }

  void doUpdatePassword() async {
    FocusScope.of(context).requestFocus(FocusNode());

    Alert(context: context, loading: true, disableBackButton: true);

    await getDeviceConfig(context);

    Result result = await userAPI.updatePassword(context, model["userID"], newPasswordController.text);

    Navigator.of(context).pop();

    if(result.code == 200) {
      Alert(
        context: context,
        title: "Info",
        content: Text("Registrasi NIK berhasil\nSilahkan login menggunakan login server Anda"),
        cancel: false,
        type: "success",
        defaultAction: () {
          Navigator.pushReplacementNamed(context, "login");
        }
      );
    } else {

    }
  }

  updateXMLConfig(String newToken) async {
    Directory dir = await getExternalStorageDirectory();
    String path = '${dir.path}/deviceconfig.xml';
    File file = File(path);

    var url_address_1, url_address_2;

    if(FileSystemEntity.typeSync(path) != FileSystemEntityType.notFound){
      final document = XmlDocument.parse(file.readAsStringSync());
      url_address_1 = document.findAllElements('url_address_1').map((node) => node.text);
      url_address_2 = document.findAllElements('url_address_2').map((node) => node.text);

      final builder = XmlBuilder();
      builder.processing('xml', 'version="1.0" encoding="UTF-8" standalone="yes"');
      builder.element('deviceconfig', nest: () {
        builder.element('url_address_1', nest: url_address_1);
        builder.element('url_address_2', nest: url_address_2);
        builder.element('token_id', nest: newToken);
      });
      final newDocument = builder.buildDocument();
      await file.writeAsString(newDocument.toString());
    } else {
      final builder = XmlBuilder();
      builder.processing('xml', 'version="1.0" encoding="UTF-8" standalone="yes"');
      builder.element('deviceconfig', nest: () {
        builder.element('url_address_1', nest: "http://203.142.77.243/NewUtilityWarehouseDev");
        builder.element('url_address_2', nest: "http://103.76.27.124/NewUtilityWarehouseDev");
        builder.element('token_id', nest: newToken);
      });
      final document = builder.buildDocument();
      await file.writeAsString(document.toString());
    }
  }

}