import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:utility_warehouse/models/result.dart';
import 'package:utility_warehouse/resources/userAPI.dart';
import 'package:utility_warehouse/settings/configuration.dart';
import 'package:utility_warehouse/tools/function.dart';
import 'package:utility_warehouse/widget/button.dart';
import 'package:utility_warehouse/widget/textView.dart';

class OTPVerification extends StatefulWidget {

  const OTPVerification({Key key}) : super(key: key);

  @override
  OTPVerificationState createState() => OTPVerificationState();
}


class OTPVerificationState extends State<OTPVerification> {
  var onTapRecognizer;

  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    errorController = StreamController<ErrorAnimationType>();
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
        disable: false,
        child: TextView('Verifikasi', 3, color: Colors.white, caps: true),
        onTap: () {
          // submitOTPValidation();
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
                            color: Colors.yellow,
                            fontWeight: FontWeight.bold,
                          ),
                          length: 4,
                          animationType: AnimationType.fade,
                          // validator: (v) {
                          //   if (v.length < 3) {
                          //     return "Kode OTP belum lengkap";
                          //   } else {
                          //     return null;
                          //   }
                          // },
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
                            activeFillColor:
                                hasError ? Colors.yellow : config.lightOpactityBlueColor,
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
                          onCompleted: (v) {
                            print("Completed");
                          },
                          // onTap: () {
                          //   print("Pressed");
                          // },
                          onChanged: (value) {
                            print(value);
                            setState(() {
                              currentText = value;
                            });
                          },
                          beforeTextPaste: (text) {
                            print("Allowing to paste $text");
                            //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                            //but you can show anything you want here, like your pop up saying wrong paste format or etc
                            return true;
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

  // void submitOTPValidation() {
  //   setState(() {
  //     nikController.text.isEmpty ? nikValid = true : nikValid = false;
  //     (whatsappNoController.text.length < 10 || whatsappNoController.text.length > 14) ? whatsappNoValid = true : whatsappNoValid = false;

  //   });

  //   if(!nikValid && !whatsappNoValid){
  //     // doSignUp();
  //   }
  // }

}