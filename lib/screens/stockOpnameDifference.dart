import 'dart:async';
import 'dart:io';
// import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/services.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' show Client;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
// import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:utility_warehouse/models/result.dart';
import 'package:utility_warehouse/models/userModel.dart';
import 'package:utility_warehouse/resources/userAPI.dart';
import 'package:lottie/lottie.dart';
import 'package:utility_warehouse/screens/pick_page_vertical.dart';
import 'package:utility_warehouse/settings/configuration.dart';
import 'package:utility_warehouse/tools/function.dart';
import 'package:utility_warehouse/widget/button.dart';
import 'package:utility_warehouse/widget/textView.dart';
import 'package:xml/xml.dart';

class StockOpnameDifference extends StatefulWidget {

  const StockOpnameDifference({Key key}) : super(key: key);

  @override
  StockOpnameDifferenceState createState() => StockOpnameDifferenceState();
}

class StockOpnameDifferenceState extends State<StockOpnameDifference> {
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

  String dropdownValue = 'One';
  String selectedDropdownValue = "Warehouse Manager";
  List<DropdownMenuItem<String>> userTypeList = [];
  final _dropdownFormKey = GlobalKey<FormState>();

  StateSetter _setState;

  DateTime currentBackPressTime;

  List<Employee> employees = <Employee>[];
  EmployeeDataSource employeeDataSource;

  ColumnSizer _sizer;

  final DataGridController _dataGridController = DataGridController();

  // final List<GlobalObjectKey<FormState>> textWidgetKey = List.generate(12, (index) => GlobalObjectKey<FormState>(index));
  // Size textWidgetSize;

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
    this._sizer = ColumnSizer();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    employees = getEmployeeData();
    employeeDataSource = EmployeeDataSource(context, employeeData: employees, controller: _dataGridController);
    // employeeDataSource = EmployeeDataSource(employees, 5);

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
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  List<Employee> getEmployeeData() {
    return [
      Employee("GIMO005K220", "GIANT Mortar 220", "1.15.24.1", 6, "SAK", "ANDI", "107", "5", "", "", "", ""),
      Employee("GIMO005K220", "GIANT Mortar 220", "1.15.25.1", 6, "SAK", "ANDI", "107", "5", "", "", "", ""),
      Employee("GIMO005K220", "GIANT Mortar 220", "1.15.26.1", 6, "SAK", "ANDI", "107", "5", "", "", "", ""),
      Employee("GIMO005K220", "GIANT Mortar 220", "1.15.27.1", 6, "SAK", "ANDI", "107", "5", "", "", "", ""),
      Employee("GIMO005K260", "GIANT Mortar 260", "1.3.18.1", 6, "SAK", "ANDI", "107", "5", "", "", "", ""),
      Employee("GIMO005K270", "GIANT Mortar 270", "1.3.18.2", 6, "SAK", "ANDI", "107", "5", "", "", "", ""),
      Employee("GIMO005K270", "GIANT Mortar 270", "1.3.18.2", 6, "SAK", "ANDI", "107", "5", "", "", "", ""),
      Employee("NEXAMT00C00901", "Nexa CFT 91 Columbia Nussebaum", "3.3.25.2", 6, "SAK", "ANDI", "107", "5", "", "", "", ""),
      Employee("NEXAMT00S00701", "Nexa CFT 90 Sonoma Oak", "3.3.25.2", 6, "SAK", "ANDI", "107", "5", "", "", "", ""),
      Employee("NEXART00N00401", "Nexa RTV 80 Natural Oak - Tsugawood Ash", "3.3.5.5", 6, "SAK", "ANDI", "107", "5", "", "", "", ""),
      Employee("NEXART00S00701", "Nexa RTV 123 Sonoma Oak", "3.3.23.4", 6, "SAK", "ANDI", "107", "5", "", "", "", ""),
      Employee("NEXART00W00102", "Nexa 1200 Wenge", "3.3.25.2", 6, "SAK", "ANDI", "107", "5", "", "", "", ""),
      Employee("NEXART00W00104", "Nexa 1522 Wenge", "3.1.23.3", 6, "SAK", "ANDI", "107", "5", "", "", "", ""),
      Employee("NEXART00W00401", "Nexa 600 R Wenge", "3.3.23.3", 6, "SAK", "ANDI", "107", "5", "", "", "", ""),
      Employee("NEXART00W01501", "Nexa RTV 124 White Glossy - Silver", "3.3.5.2", 6, "SAK", "ANDI", "107", "5", "", "", "", ""),
      Employee("NEXART00W01601", "Nexa RTV 160 White Glossy", "3.2.21.1", 6, "SAK", "ANDI", "107", "5", "", "", "", ""),
    ];
  }
  
  final CustomColumnSizer _customColumnSizer = CustomColumnSizer();

  showDetailRow(BuildContext context, Employee employeeDetail) {
    String binCodeDetailData = employees[_dataGridController.selectedIndex].binCode;
    String itemNoDetailData = employees[_dataGridController.selectedIndex].itemNo;
    String itemDescDetailData = employees[_dataGridController.selectedIndex].itemDesc;
    String coliDetailData = employees[_dataGridController.selectedIndex].coli.toString();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.all(20),
          backgroundColor: Colors.white,
          insetAnimationDuration:
              const Duration(milliseconds: 100),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(15),
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
                                  child: TextView(binCodeDetailData, 4),
                                ),
                                Container(
                                  child: TextView(itemNoDetailData, 4),
                                ),
                                Container(
                                  child: TextView(itemDescDetailData, 4),
                                ),
                                Container(
                                  child: TextView(coliDetailData, 4),
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
                                    child: TextView("Qty\nOpname Dus", 4),
                                  ),
                                  SizedBox(height: 30),
                                  Container(
                                    child: TextView("Qty\nOpname Uom", 4),
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
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Container(
                          //       child: Button(
                          //         disable: false,
                          //         child: TextView('Cancel', 3, color: Colors.white, caps: true),
                          //         onTap: () {
                          //         },
                          //       ),
                          //     ),
                          //     Container(
                          //       child: Button(
                          //         disable: false,
                          //         child: TextView('Save', 3, color: Colors.white, caps: true),
                          //         onTap: () {
                          //         },
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
            
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Column(
                      //   children: [
                      //     Container(
                      //       child: Button(
                      //         disable: false,
                      //         child: TextView('Prev', 3, color: Colors.white, caps: true),
                      //         onTap: () {
                      //         },
                      //       ),
                      //     ),
                      //     SizedBox(width: 15),
                      //     Container(
                      //       child: Button(
                      //         disable: false,
                      //         child: TextView('Next', 3, color: Colors.white, caps: true),
                      //         onTap: () {
                      //         },
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // SizedBox(width: 15),
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
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Expanded(
                      child: Container(
                        child: Button(
                          disable: false,
                          child: TextView('Prevs', 3, color: Colors.white, caps: true),
                          onTap: () {
                            _setState(() {
                              _dataGridController.selectedIndex = _dataGridController.selectedIndex - 1;
                              printHelp("CEK IDN "+_dataGridController.selectedIndex.toString());
                              binCodeDetailData = "hehee";
                              // itemNoDetailData = employees[_dataGridController.selectedIndex].itemNo;
                              // itemDescDetailData = employees[_dataGridController.selectedIndex].itemDesc;
                              // coliDetailData = employees[_dataGridController.selectedIndex].coli.toString();
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Container(
                        child: Button(
                          disable: false,
                          child: TextView('Next', 3, color: Colors.white, caps: true),
                          onTap: () {
                            _dataGridController.selectedIndex = _dataGridController.selectedIndex + 1;
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Container(
                        child: Button(
                          disable: false,
                          child: TextView('Cancel', 3, color: Colors.white, caps: true),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Container(
                        child: Button(
                          disable: false,
                          child: TextView('Save', 3, color: Colors.white, caps: true),
                          onTap: () {
                          },
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Configuration config = Configuration.of(context);
    
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      bottomNavigationBar: Container(
        width: mediaWidth,
        child: Button(
          disable: false,
          child: TextView('Upload', 3, color: Colors.white, caps: true),
          onTap: () {
          },
        ),
      ),
      body: WillPopScope(
        onWillPop: (){
          Navigator.of(context).pop();
        },
        child: Stack(
          children:<Widget>[
            Container(
              height: mediaHeight,
              width: mediaWidth,
              // color: Colors.white,
              child: Image.asset("assets/illustration/background.png", fit: BoxFit.fill),
            ),
            
            ///original
            SafeArea(
              child: Card(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Container(
                  decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                        width: 1.0, color: Colors.grey.withOpacity(0.45)))),
                  child: SfDataGrid(
                    controller: _dataGridController,
                    selectionMode: SelectionMode.single,
                    source: employeeDataSource,
                    columnWidthMode: ColumnWidthMode.fitByColumnName,
                    // columnWidthMode: ColumnWidthMode.auto,
                    columnSizer: this._sizer,
                    gridLinesVisibility: GridLinesVisibility.horizontal,
                    headerGridLinesVisibility: GridLinesVisibility.horizontal,
                    onQueryRowHeight: (RowHeightDetails details) {
                      if (details.rowIndex == 0)
                        return details.rowHeight;
                      else
                        return details.getIntrinsicRowHeight(details.rowIndex);
                    },
                    // shrinkWrapColumns: true,
                    shrinkWrapRows: true,
                    // onSelectionChanged: (List<DataGridRow> addedRows, List<DataGridRow> removedRows) {
                    //   final index = employeeDataSource._employeeData.indexOf(addedRows.last);
                    //   Employee employee = employees[index];
                    //   printHelp("data "+employee.itemDesc);

                    //   showDetailRow(context, employee);

                    //   return true;
                    // },
                    onSelectionChanging:
                        (List<DataGridRow> addedRows, List<DataGridRow> removedRows) {
                      final index = employeeDataSource._employeeData.indexOf(addedRows.last);
                      Employee employee = employees[index];
                      printHelp("data "+employee.itemDesc);
                      setState(() {
                        _dataGridController.selectedIndex = index;
                      });
                      showDetailRow(context, employee);

                      return true;
                    },
                    columns: <GridColumn>[
                      GridColumn(
                        autoFitPadding: EdgeInsets.all(8),
                        columnName: 'itemNo',
                        // columnWidthMode: ColumnWidthMode.fitByCellValue,
                        label: Container(
                          alignment: Alignment.center,
                          child: TextView('Item\nNo', 6, align: TextAlign.center),
                        )
                      ),
                      GridColumn(
                        autoFitPadding: EdgeInsets.all(8),
                        columnName: 'binCode',
                        label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.45))
                            )
                          ),
                          child: TextView('Bin Code', 6, align: TextAlign.center)
                        )
                      ),
                      GridColumn(
                        autoFitPadding: EdgeInsets.all(8),
                        columnName: 'itemDescription',
                        label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.45))
                            )
                          ),
                          child: TextView('Item\nDescription',  6, align: TextAlign.center)
                        )
                      ),
                      GridColumn(
                        autoFitPadding: EdgeInsets.all(8),
                        columnName: 'coli',
                        label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.45))
                            )
                          ),
                          child: TextView('Coli', 6, align: TextAlign.center)
                        )
                      ),
                      GridColumn(
                        autoFitPadding: EdgeInsets.all(8),
                        columnName: 'uom',
                        label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.45))
                            )
                          ),
                          child: TextView('Uom', 6, align: TextAlign.center)
                        )
                      ),
                      GridColumn(
                        autoFitPadding: EdgeInsets.all(8),
                        columnName: 'namaPIC',
                        label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.45))
                            )
                          ),
                          child: TextView('Nama', 6, align: TextAlign.center)
                        )
                      ),
                      GridColumn(
                        autoFitPadding: EdgeInsets.all(8),
                        columnName: 'qtySTODs',
                        label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.45))
                            )
                          ),
                          child: TextView('Qty\nSTO\nDS', 6, align: TextAlign.center)
                        )
                      ),
                      GridColumn(
                        autoFitPadding: EdgeInsets.all(8),
                        columnName: 'qtySTOUom',
                        label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.45))
                            )
                          ),
                          child: TextView('Qty\nSTO\nUom', 6, align: TextAlign.center)
                        )
                      ),
                      GridColumn(
                        autoFitPadding: EdgeInsets.all(8),
                        columnName: 'qtySTODs2',
                        label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.45))
                            )
                          ),
                          child: TextView('Qty\nSTO\nDS 2', 6, align: TextAlign.center)
                        )
                      ),
                      GridColumn(
                        autoFitPadding: EdgeInsets.all(8),
                        columnName: 'qtySTOUom2',
                        label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.45))
                            )
                          ),
                          child: TextView('Qty\nSTO\nUom 2', 6, align: TextAlign.center)
                        )
                      ),
                      GridColumn(
                        autoFitPadding: EdgeInsets.all(8),
                        columnName: 'qtySTODsFinal',
                        label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.45))
                            )
                          ),
                          child: TextView('Qty\nSTO\nDS Final', 6, align: TextAlign.center)
                        )
                      ),
                      GridColumn(
                        autoFitPadding: EdgeInsets.all(8),
                        columnName: 'qtySTOUomFinal',
                        label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.45))
                            )
                          ),
                          child: TextView('Qty\nSTO\nUom Final', 6, align: TextAlign.center)
                        )
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
}

class Employee {
  Employee(this.itemNo, this.itemDesc, this.binCode, this.coli, this.uom, this.nama,
  this.qtySTODs, this.qtySTOUom, this.qtySTODs2, this.qtySTOUom2, this.qtySTODFinal, this.qtySTOUomFinal);

  final String itemNo;
  final String binCode;
  final String itemDesc;
  final int coli;
  final String uom;
  final String nama;
  final String qtySTODs;
  final String qtySTOUom;
  final String qtySTODs2;
  final String qtySTOUom2;
  final String qtySTODFinal;
  final String qtySTOUomFinal;
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource(BuildContext context, {List<Employee> employeeData, DataGridController controller}) {
    _context = context;
    _dataGridController = controller;
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(
          cells: [
              DataGridCell<String>(columnName: 'itemNo', value: e.itemNo),
              DataGridCell<String>(columnName: 'binCode', value: e.binCode),
              DataGridCell<String>(columnName: 'itemDesc', value: e.itemDesc),
              DataGridCell<int>(columnName: 'coli', value: e.coli),
              DataGridCell<String>(columnName: 'uom', value: e.uom),
              DataGridCell<String>(columnName: 'nama', value: e.nama),
              DataGridCell<String>(columnName: 'qtySTODs', value: e.qtySTODs),
              DataGridCell<String>(columnName: 'qtySTOUom', value: e.qtySTOUom),
              DataGridCell<String>(columnName: 'qtySTODs2', value: e.qtySTODs2),
              DataGridCell<String>(columnName: 'qtySTOUom2', value: e.qtySTOUom2),
              DataGridCell<String>(columnName: 'qtySTODsFinal', value: e.qtySTODs),
              DataGridCell<String>(columnName: 'qtySTOUomFinal', value: e.qtySTOUom),
            ]))
        .toList();
  }

  BuildContext _context;
  DataGridController _dataGridController;
  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        decoration: BoxDecoration(
              border: Border(
            left: e.columnName == 'itemNo'
                ? BorderSide.none
                : BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.45)),
          )),
        alignment: Alignment.center,
        padding: EdgeInsets.all(0),
        // child: Text(e.value.toString(), softWrap: true, overflow: TextOverflow.visible),
        child: TextView(e.value.toString(), 6),
      );
    }).toList());
  }

  ///////////////////////// new
  // EmployeeDataSource(this.employeeData, this.rowsPerPage) {
  //   buildPaginateDataGridRows();
  // }
  
  // void buildPaginateDataGridRows() {
  //   _paginatedEmployees = _employeeRows
  //       .map<DataGridRow>((e) => DataGridRow(cells: [
  //             DataGridCell<String>(columnName: 'itemNo', value: e.itemNo),
  //             DataGridCell<String>(columnName: 'itemDesc', value: e.itemDesc),
  //             DataGridCell<String>(columnName: 'binCode', value: e.binCode),
  //             DataGridCell<int>(columnName: 'coli', value: e.coli),
  //             DataGridCell<String>(columnName: 'uom', value: e.uom),
  //             DataGridCell<String>(columnName: 'nama', value: e.nama),
  //             DataGridCell<String>(columnName: 'qtySTODs', value: e.qtySTODs),
  //             DataGridCell<String>(columnName: 'qtySTOUom', value: e.qtySTOUom),
  //             DataGridCell<String>(columnName: 'qtySTODs2', value: e.qtySTODs2),
  //             DataGridCell<String>(columnName: 'qtySTOUom2', value: e.qtySTOUom2),
  //             DataGridCell<String>(columnName: 'qtySTODsFinal', value: e.qtySTODs),
  //             DataGridCell<String>(columnName: 'qtySTOUomFinal', value: e.qtySTOUom),
  //           ]))
  //       .toList();
  // }

  // List<Employee> employeeData = [];

  // List<DataGridRow> _paginatedEmployees = [];
  // List<Employee> _employeeRows = [];
  // int rowsPerPage = 0;

  // @override
  // List<DataGridRow> get rows => _paginatedEmployees;

  // @override
  // DataGridRowAdapter buildRow(DataGridRow row) {
  //   return DataGridRowAdapter(
  //       cells: row.getCells().map<Widget>((e) {
  //     return Container(
  //       alignment: Alignment.center,
  //       decoration: BoxDecoration(
  //           border: Border(
  //         left: e.columnName == 'itemNo'
  //             ? BorderSide.none
  //             : BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.45)),
  //       )),
  //       padding: EdgeInsets.all(0),
  //       child: Text(e.value.toString()),
  //     );
  //   }).toList());
  // }

  // @override
  // Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
  //   final int startIndex = newPageIndex * rowsPerPage;
  //   int endIndex = startIndex + rowsPerPage;
  //   if (endIndex <= employeeData.length && startIndex < employeeData.length) {
  //     _employeeRows =
  //         employeeData.getRange(startIndex, endIndex).toList(growable: false);
  //   } else {
  //     if (startIndex < employeeData.length && endIndex > employeeData.length) {
  //       endIndex = employeeData.length;
  //       _employeeRows =
  //           employeeData.getRange(startIndex, endIndex).toList(growable: false);
  //     } else {
  //       employeeData = [];
  //     }
  //   }

  //   buildPaginateDataGridRows();
  //   notifyListeners();
  //   return true;
  // }

}

class CustomColumnSizer extends ColumnSizer {
  @override
  double computeCellWidth(GridColumn column, DataGridRow row, Object cellValue,
      TextStyle textStyle) {
    return super.computeCellWidth(column, row, cellValue, textStyle);
  }
}