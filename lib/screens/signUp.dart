import 'package:flutter/material.dart';
import 'package:utility_warehouse/models/result.dart';
import 'package:utility_warehouse/resources/userAPI.dart';
import 'package:utility_warehouse/settings/configuration.dart';
import 'package:utility_warehouse/tools/function.dart';
import 'package:utility_warehouse/widget/button.dart';
import 'package:utility_warehouse/widget/textView.dart';

class SignUp extends StatefulWidget {

  const SignUp({Key key}) : super(key: key);

  @override
  SignUpState createState() => SignUpState();
}


class SignUpState extends State<SignUp> {

  final FocusNode nikFocus = FocusNode();
  final FocusNode whatsappNoFocus = FocusNode();
  final nikController = TextEditingController();
  final whatsappNoController = TextEditingController();

  bool nikValid = false;
  bool whatsappNoValid = false;

  @override
  void initState() {
    super.initState();
    whatsappNoController.text = "+62";
    whatsappNoController.selection = TextSelection.fromPosition(TextPosition(offset: whatsappNoController.text.length));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Configuration config = Configuration.of(context);
    
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      bottomNavigationBar: Button(
        disable: false,
        child: TextView('Daftar', 3, color: Colors.white, caps: true),
        onTap: () {
          Navigator.pushNamed(context, "otpVerification");
          // submitSignUpValidation();
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
            Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[      
                  Column(
                    children: [
                      Container(
                        child: TextField(
                          key: Key("NIK"),
                          controller: nikController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          focusNode: nikFocus,
                          decoration: InputDecoration(
                            labelText: "NIK",
                            errorText: nikValid ? "NIK tidak boleh kosong" : null,
                          ),
                          textCapitalization: TextCapitalization.characters,
                          onSubmitted: (value) {
                            fieldFocusChange(context, nikFocus, whatsappNoFocus);
                          },
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(
                        child: TextField(
                          key: Key("WhatsappNo"),
                          controller: whatsappNoController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          focusNode: whatsappNoFocus,
                          decoration: InputDecoration(
                            labelText: "Nomor Whatsapp",
                            errorText: whatsappNoValid ? whatsappNoController.text.length == 3 ? "Nomor Whatsapp tidak boleh kosong" : (whatsappNoController.text.length < 10 || whatsappNoController.text.length > 14) ? "Nomor Whatsapp tidak valid" : null : null,
                          ),
                          textCapitalization: TextCapitalization.characters,
                          onSubmitted: (value) {
                            whatsappNoFocus.unfocus();
                          },
                          onChanged: (value) {
                             if(!whatsappNoController.text.startsWith("+62")){
                              setState(() {
                                whatsappNoController.text = "+62";
                                whatsappNoController.selection = TextSelection.fromPosition(TextPosition(offset: whatsappNoController.text.length));
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
  
  void checkNIKValidation () async {
    FocusScope.of(context).requestFocus(FocusNode());

    Alert(context: context, loading: true, disableBackButton: true);

    await getDeviceConfig(context);

    Result result = await userAPI.nikValidation(context, nikController.text);

    Navigator.of(context).pop();

    if(result.code == 200) {

    } else {
      Alert(
        context: context,
        title: "Maaf,",
        content: Text(result.error_message),
        cancel: false,
        type: "error"
      );  
    }


  }

  void doSignUp() async {
    FocusScope.of(context).requestFocus(FocusNode());

    Alert(context: context, loading: true, disableBackButton: true);

    await getDeviceConfig(context);




  }

  void submitSignUpValidation() {
    setState(() {
      nikController.text.isEmpty ? nikValid = true : nikValid = false;
      (whatsappNoController.text.length < 10 || whatsappNoController.text.length > 14) ? whatsappNoValid = true : whatsappNoValid = false;

    });

    if(!nikValid && !whatsappNoValid){
      // doSignUp();
    }
  }

}