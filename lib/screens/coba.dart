import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:utility_warehouse/models/result.dart';
import 'package:utility_warehouse/resources/userAPI.dart';
import 'package:utility_warehouse/settings/configuration.dart';
import 'package:utility_warehouse/tools/function.dart';
import 'package:utility_warehouse/widget/button.dart';
import 'package:utility_warehouse/widget/textView.dart';

class Coba extends StatefulWidget {

  const Coba({Key key}) : super(key: key);

  @override
  CobaState createState() => CobaState();
}


class CobaState extends State<Coba> {
  String userID = "";

  final FocusNode nikFocus = FocusNode();
  final FocusNode whatsappNoFocus = FocusNode();
  final nikController = TextEditingController();
  final whatsappNoController = TextEditingController();

  bool nikValid = false;
  bool whatsappNoValid = false;

  final double _padding = 16.0;
  final double _buttonFontSize = 24.0;

  final Color _primarySwatchColor = Colors.orange;
  final Color _titleAppBarColor = Colors.white;
  final Color _buttonColorWhite = Colors.white;
  final Color _buttonHighlightColor = Colors.grey[800];
  final Color _buttonColorGrey = Colors.grey[500];
  final Color _textColorWhite = Colors.white;

  int valueA;
  int valueB;
  var sbValue = new StringBuffer();
  var sbValueQtyOpnDs = new StringBuffer();
  var sbValueQtyOpnUom = new StringBuffer();
  List<StringBuffer> sbValueList = [];
  String operator;

  @override
  void initState() {
    super.initState();
    sbValue.write("0");
    sbValueQtyOpnDs.write("0");
    sbValueQtyOpnUom.write("0");
    operator = "";
    setState(() {
      nikController.text = "0";
      whatsappNoController.text = "0";
    });
    nikFocus.addListener(_onFocusChange);
    whatsappNoFocus.addListener(_onFocusChange);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
  }

  void _onFocusChange() {
    debugPrint("Focus nik : ${nikFocus.hasFocus.toString()}");
    debugPrint("Focus whatsappNoFocus : ${whatsappNoFocus.hasFocus.toString()}");
    if(whatsappNoFocus.hasFocus) {
      setState(() {
        // sbValue.clear();
        // sbValue.write(sbValueQtyOpnUom.toString());
        // whatsappNoController.text = sbValue.toString();
        whatsappNoController.text = sbValueQtyOpnUom.toString();
      });
    } else if(nikFocus.hasFocus) {
      setState(() {
        // sbValue.clear();
        // sbValue.write(sbValueQtyOpnDs.toString());
        // nikController.text = sbValue.toString();
        nikController.text = sbValueQtyOpnDs.toString();
      });
    }
  }

  void appendValue(String str) => setState(() {
        bool isDoCalculate = false;
        String strValue = sbValue.toString();
        String lastCharacter = strValue.substring(strValue.length - 1);
        if (str == "0" &&
            (lastCharacter == "/" ||
                lastCharacter == "x" ||
                lastCharacter == "-" ||
                lastCharacter == "+")) {
          return;
        } else if (str == "0" && sbValue.toString() == "0") {
          return;
        } else if (str == "=") {
          isDoCalculate = true;
        } else if (str == "/" || str == "x" || str == "-" || str == "+") {
          if (operator.isEmpty) {
            operator = str;
          } else {
            isDoCalculate = true;
          }
        }

        if (!isDoCalculate) {
          if (sbValue.toString() == "0" && str != "0") {
            sbValue.clear();
          }
          sbValue.write(str);
        } else {
          List<String> values = sbValue.toString().split(operator);
          if (values.length == 2 &&
              values[0].isNotEmpty &&
              values[1].isNotEmpty) {
            valueA = int.parse(values[0]);
            valueB = int.parse(values[1]);
            sbValue.clear();
            int total = 0;
            switch (operator) {
              case "/":
                total = valueA ~/ valueB;
                break;
              case "x":
                total = valueA * valueB;
                break;
              case "-":
                total = valueA - valueB;
                break;
              case "+":
                total = valueA + valueB;
            }
            sbValue.write(total);
            if (str == "/" || str == "x" || str == "-" || str == "+") {
              operator = str;
              sbValue.write(str);
            } else {
              operator = "";
            }
          } else {
            String strValue = sbValue.toString();
            String lastCharacter = strValue.substring(strValue.length - 1);
            if (str == "/" || str == "x" || str == "-" || str == "+") {
              operator = "";
              sbValue.clear();
              sbValue
                  .write(strValue.substring(0, strValue.length - 1) + "" + str);
              operator = str;
            } else if (str == "=" &&
                (lastCharacter == "/" ||
                    lastCharacter == "x" ||
                    lastCharacter == "-" ||
                    lastCharacter == "+")) {
              operator = "";
              sbValue.clear();
              sbValue.write(strValue.substring(0, strValue.length - 1));
            }
          }
        }
        if(whatsappNoFocus.hasFocus) {
          sbValueQtyOpnUom = sbValue;
          whatsappNoController.text = sbValueQtyOpnUom.toString();
        } else if(nikFocus.hasFocus) {
          sbValueQtyOpnDs = sbValue;
          nikController.text = sbValueQtyOpnDs.toString();
        }
      });

  void deleteValue() => setState(() {
        String strValue = sbValue.toString();
        if (strValue.length > 0) {
          String lastCharacter = strValue.substring(strValue.length - 1);
          if (lastCharacter == "/" ||
              lastCharacter == "x" ||
              lastCharacter == "-" ||
              lastCharacter == "+") {
            operator = "";
          }
          strValue = strValue.substring(0, strValue.length - 1);
          sbValue.clear();
          sbValue.write(strValue.length == 0 ? "0" : strValue);
          if(whatsappNoFocus.hasFocus) {
            sbValueQtyOpnUom = sbValue;
            whatsappNoController.text = sbValueQtyOpnUom.toString();
          } else if(nikFocus.hasFocus) {
            sbValueQtyOpnDs = sbValue;
            nikController.text = sbValueQtyOpnDs.toString();
          }
        }
      });

  void clearValue() => setState(() {
    operator = "";
    sbValue.clear();
    sbValue.write("0");
    if(whatsappNoFocus.hasFocus) {
      sbValueQtyOpnUom = sbValue;
      whatsappNoController.text = sbValue.toString();
    } else if(nikFocus.hasFocus) {
      sbValueQtyOpnDs = sbValue;
      nikController.text = sbValue.toString();
    }
  });

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

            SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: TextView("Bin Code", 4),
                                  ),
                                  Container(
                                    child: TextView("Item No", 4),
                                  ),
                                  Container(
                                    child: TextView("Item Desc", 4),
                                  ),
                                  Container(
                                    child: TextView("Isi/DS", 4),
                                  ),
                                ],
                              ),
                              SizedBox(width: 30),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: TextView(":", 4),
                                  ),
                                  Container(
                                    child: TextView(":", 4),
                                  ),
                                  Container(
                                    child: TextView(":", 4),
                                  ),
                                  Container(
                                    child: TextView(":", 4),
                                  ),
                                ],
                              ),
                              SizedBox(width: 30),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: TextView("1.2.1.1", 4),
                                    ),
                                    Container(
                                      child: TextView("GIMO005K220", 4),
                                    ),
                                    Container(
                                      child: TextView("GIANT Mortar 220", 4),
                                    ),
                                    Container(
                                      child: TextView("6", 4),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: TextView("Qty Opname Dus", 4),
                                      ),
                                      SizedBox(height: 30),
                                      Container(
                                        child: TextView("Qty Opname Uom", 4),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 30),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: TextView(":", 4),
                                      ),
                                      SizedBox(height: 30),
                                      Container(
                                        child: TextView(":", 4),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 30),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextField(
                                          key: Key("QtyOpnDs"),
                                          controller: nikController,
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.next,
                                          focusNode: nikFocus,
                                          readOnly: true,
                                          showCursor: true,
                                          decoration: InputDecoration(
                                            errorText: nikValid ? "NIK tidak boleh kosong" : null,
                                          ),
                                          textCapitalization: TextCapitalization.characters,
                                          onSubmitted: (value) {
                                            fieldFocusChange(context, nikFocus, whatsappNoFocus);
                                          },
                                        ),
                                        TextField(
                                          key: Key("QtyOpnUom"),
                                          controller: whatsappNoController,
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.next,
                                          focusNode: whatsappNoFocus,
                                          readOnly: true,
                                          showCursor: true,
                                          decoration: InputDecoration(
                                            errorText: whatsappNoValid ? "NIK tidak boleh kosong" : null,
                                          ),
                                          textCapitalization: TextCapitalization.characters,
                                          onSubmitted: (value) {
                                            whatsappNoFocus.unfocus();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Button(
                                      disable: false,
                                      child: TextView('Cancel', 3, color: Colors.white, caps: true),
                                      onTap: () {
                                      },
                                    ),
                                  ),
                                  Container(
                                    child: Button(
                                      disable: false,
                                      child: TextView('Save', 3, color: Colors.white, caps: true),
                                      onTap: () {
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                child: Button(
                                  disable: false,
                                  child: TextView('Prev', 3, color: Colors.white, caps: true),
                                  onTap: () {
                                  },
                                ),
                              ),
                              SizedBox(width: 15),
                              Container(
                                child: Button(
                                  disable: false,
                                  child: TextView('Next', 3, color: Colors.white, caps: true),
                                  onTap: () {
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            key: Key("expanded_bagian_bawah"),
                            flex: 1,
                            child: Column(
                              key: Key("expanded_column_bagian_bawah"),
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 2,
                                        child: RaisedButton(
                                          color: _buttonColorWhite,
                                          highlightColor: _buttonHighlightColor,
                                          child: Text(
                                            "C",
                                            style: TextStyle(
                                                color: _primarySwatchColor,
                                                fontSize: _buttonFontSize),
                                          ),
                                          onPressed: () {
                                            clearValue();
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: RaisedButton(
                                          color: _buttonColorWhite,
                                          highlightColor: _buttonHighlightColor,
                                          child: Icon(
                                            Icons.backspace,
                                            color: _buttonColorGrey,
                                          ),
                                          onPressed: () {
                                            deleteValue();
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: RaisedButton(
                                          color: _buttonColorWhite,
                                          highlightColor: _buttonHighlightColor,
                                          child: Text(
                                            "/",
                                            style: TextStyle(
                                              color: _buttonColorGrey,
                                              fontSize: _buttonFontSize,
                                            ),
                                          ),
                                          onPressed: () {
                                            appendValue("/");
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: RaisedButton(
                                          color: _buttonColorWhite,
                                          highlightColor: _buttonHighlightColor,
                                          child: Text(
                                            "7",
                                            style: TextStyle(
                                              color: _buttonColorGrey,
                                              fontSize: _buttonFontSize,
                                            ),
                                          ),
                                          onPressed: () {
                                            appendValue("7");
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: RaisedButton(
                                          color: _buttonColorWhite,
                                          highlightColor: _buttonHighlightColor,
                                          child: Text(
                                            "8",
                                            style: TextStyle(
                                              color: _buttonColorGrey,
                                              fontSize: _buttonFontSize,
                                            ),
                                          ),
                                          onPressed: () {
                                            appendValue("8");
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: RaisedButton(
                                          color: _buttonColorWhite,
                                          highlightColor: _buttonHighlightColor,
                                          child: Text(
                                            "9",
                                            style: TextStyle(
                                              color: _buttonColorGrey,
                                              fontSize: _buttonFontSize,
                                            ),
                                          ),
                                          onPressed: () {
                                            appendValue("9");
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: RaisedButton(
                                          color: _buttonColorWhite,
                                          highlightColor: _buttonHighlightColor,
                                          child: Text(
                                            "x",
                                            style: TextStyle(
                                              color: _buttonColorGrey,
                                              fontSize: _buttonFontSize,
                                            ),
                                          ),
                                          onPressed: () {
                                            appendValue("x");
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: RaisedButton(
                                          color: _buttonColorWhite,
                                          highlightColor: _buttonHighlightColor,
                                          child: Text(
                                            "4",
                                            style: TextStyle(
                                              color: _buttonColorGrey,
                                              fontSize: _buttonFontSize,
                                            ),
                                          ),
                                          onPressed: () {
                                            appendValue("4");
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: RaisedButton(
                                          color: _buttonColorWhite,
                                          highlightColor: _buttonHighlightColor,
                                          child: Text(
                                            "5",
                                            style: TextStyle(
                                              color: _buttonColorGrey,
                                              fontSize: _buttonFontSize,
                                            ),
                                          ),
                                          onPressed: () {
                                            appendValue("5");
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: RaisedButton(
                                          color: _buttonColorWhite,
                                          highlightColor: _buttonHighlightColor,
                                          child: Text(
                                            "6",
                                            style: TextStyle(
                                              color: _buttonColorGrey,
                                              fontSize: _buttonFontSize,
                                            ),
                                          ),
                                          onPressed: () {
                                            appendValue("6");
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: RaisedButton(
                                          color: _buttonColorWhite,
                                          highlightColor: _buttonHighlightColor,
                                          child: Text(
                                            "-",
                                            style: TextStyle(
                                              color: _buttonColorGrey,
                                              fontSize: _buttonFontSize,
                                            ),
                                          ),
                                          onPressed: () {
                                            appendValue("-");
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: RaisedButton(
                                          color: _buttonColorWhite,
                                          highlightColor: _buttonHighlightColor,
                                          child: Text(
                                            "1",
                                            style: TextStyle(
                                              color: _buttonColorGrey,
                                              fontSize: _buttonFontSize,
                                            ),
                                          ),
                                          onPressed: () {
                                            appendValue("1");
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: RaisedButton(
                                          color: _buttonColorWhite,
                                          highlightColor: _buttonHighlightColor,
                                          child: Text(
                                            "2",
                                            style: TextStyle(
                                              color: _buttonColorGrey,
                                              fontSize: _buttonFontSize,
                                            ),
                                          ),
                                          onPressed: () {
                                            appendValue("2");
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: RaisedButton(
                                          color: _buttonColorWhite,
                                          highlightColor: _buttonHighlightColor,
                                          child: Text(
                                            "3",
                                            style: TextStyle(
                                              color: _buttonColorGrey,
                                              fontSize: _buttonFontSize,
                                            ),
                                          ),
                                          onPressed: () {
                                            appendValue("3");
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: RaisedButton(
                                          color: _buttonColorWhite,
                                          highlightColor: _buttonHighlightColor,
                                          child: Text(
                                            "+",
                                            style: TextStyle(
                                              color: _buttonColorGrey,
                                              fontSize: _buttonFontSize,
                                            ),
                                          ),
                                          onPressed: () {
                                            appendValue("+");
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 3,
                                        child: RaisedButton(
                                          color: _buttonColorWhite,
                                          highlightColor: _buttonHighlightColor,
                                          child: Text(
                                            "0",
                                            style: TextStyle(
                                              color: _buttonColorGrey,
                                              fontSize: _buttonFontSize,
                                            ),
                                          ),
                                          onPressed: () {
                                            appendValue("0");
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: RaisedButton(
                                          color: _primarySwatchColor,
                                          highlightColor: _buttonHighlightColor,
                                          child: Text(
                                            "=",
                                            style: TextStyle(
                                              color: _textColorWhite,
                                              fontSize: _buttonFontSize,
                                            ),
                                          ),
                                          onPressed: () {
                                            appendValue("=");
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                
                  ],
                ),
              ),
            )

            // Container(
            //   padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: <Widget>[      
            //       Column(
            //         children: [
            //           Container(
            //             child: TextField(
            //               key: Key("NIK"),
            //               controller: nikController,
            //               keyboardType: TextInputType.number,
            //               textInputAction: TextInputAction.next,
            //               focusNode: nikFocus,
            //               decoration: InputDecoration(
            //                 labelText: "NIK",
            //                 errorText: nikValid ? "NIK tidak boleh kosong" : null,
            //               ),
            //               textCapitalization: TextCapitalization.characters,
            //               onSubmitted: (value) {
            //                 fieldFocusChange(context, nikFocus, whatsappNoFocus);
            //               },
            //             ),
            //           ),
            //           SizedBox(height: 30),
            //           Container(
            //             child: TextField(
            //               key: Key("WhatsappNo"),
            //               controller: whatsappNoController,
            //               keyboardType: TextInputType.number,
            //               textInputAction: TextInputAction.done,
            //               focusNode: whatsappNoFocus,
            //               decoration: InputDecoration(
            //                 labelText: "Nomor Whatsapp",
            //                 errorText: whatsappNoValid ? whatsappNoController.text.length == 3 ? "Nomor Whatsapp tidak boleh kosong" : (whatsappNoController.text.length < 10 || whatsappNoController.text.length > 14) ? "Nomor Whatsapp tidak valid" : null : null,
            //               ),
            //               textCapitalization: TextCapitalization.characters,
            //               onSubmitted: (value) {
            //                 whatsappNoFocus.unfocus();
            //               },
            //               onChanged: (value) {
            //                  if(!whatsappNoController.text.startsWith("+62")){
            //                   setState(() {
            //                     whatsappNoController.text = "+62";
            //                     whatsappNoController.selection = TextSelection.fromPosition(TextPosition(offset: whatsappNoController.text.length));
            //                   });
            //                 }
            //               },
            //             ),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
          ],
        )
      ),
    );
  }
}