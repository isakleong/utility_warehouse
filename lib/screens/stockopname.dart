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

class StockOpname extends StatefulWidget {

  const StockOpname({Key key}) : super(key: key);

  @override
  StockOpnameState createState() => StockOpnameState();
}

class StockOpnameState extends State<StockOpname> {
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

  final FocusNode qtyOpnDsFocus = FocusNode();
  final FocusNode qtyOpnUomFocus = FocusNode();
  final qtyOpnDsController = TextEditingController();
  final qtyOpnUomController = TextEditingController();

  bool qtyOpnDsValid = false;
  bool qtyOpnUomValid = false;

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
      qtyOpnDsController.text = "0";
      qtyOpnUomController.text = "0";
    });
    qtyOpnDsFocus.addListener(_onFocusChange);
    qtyOpnUomFocus.addListener(_onFocusChange);
    
  }

  void _onFocusChange() {
    debugPrint("Focus nik : ${qtyOpnDsFocus.hasFocus.toString()}");
    debugPrint("Focus qtyOpnUomFocus : ${qtyOpnUomFocus.hasFocus.toString()}");
    if(qtyOpnUomFocus.hasFocus) {
      setState(() {
        // sbValue.clear();
        // sbValue.write(sbValueQtyOpnUom.toString());
        // qtyOpnUomController.text = sbValue.toString();
        qtyOpnUomController.text = sbValueQtyOpnUom.toString();
      });
    } else if(qtyOpnDsFocus.hasFocus) {
      setState(() {
        // sbValue.clear();
        // sbValue.write(sbValueQtyOpnDs.toString());
        // qtyOpnDsController.text = sbValue.toString();
        qtyOpnDsController.text = sbValueQtyOpnDs.toString();
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
        if(qtyOpnUomFocus.hasFocus) {
          sbValueQtyOpnUom = sbValue;
          qtyOpnUomController.text = sbValueQtyOpnUom.toString();
        } else if(qtyOpnDsFocus.hasFocus) {
          sbValueQtyOpnDs = sbValue;
          qtyOpnDsController.text = sbValueQtyOpnDs.toString();
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
          if(qtyOpnUomFocus.hasFocus) {
            sbValueQtyOpnUom = sbValue;
            qtyOpnUomController.text = sbValueQtyOpnUom.toString();
          } else if(qtyOpnDsFocus.hasFocus) {
            sbValueQtyOpnDs = sbValue;
            qtyOpnDsController.text = sbValueQtyOpnDs.toString();
          }
        }
      });

  void clearValue() => setState(() {
    operator = "";
    sbValue.clear();
    sbValue.write("0");
    if(qtyOpnUomFocus.hasFocus) {
      sbValueQtyOpnUom = sbValue;
      qtyOpnUomController.text = sbValue.toString();
    } else if(qtyOpnDsFocus.hasFocus) {
      sbValueQtyOpnDs = sbValue;
      qtyOpnDsController.text = sbValue.toString();
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
      Employee('AVEM025KP751','AVITEX Emulsion 751','1.1.12.3',1,'',''),
      Employee('WOWO001K109','WOOD-ECO Woodstain 109','1.1.14.6',24,'',''),
      Employee('WOWO001K110','WOOD-ECO Woodstain 110','1.1.15.1',24,'',''),
      Employee('WOWO001K112','WOOD-ECO Woodstain 112','1.1.15.3',24,'',''),
      Employee('WOWO001K115','WOOD-ECO Woodstain 115','1.1.15.6',24,'',''),
      Employee('WOWO001KCG','WOOD-ECO Woodstain CG','1.1.16.1',24,'',''),
      Employee('WOWO001KCM','WOOD-ECO Woodstain CM','1.1.16.2',24,'',''),
      Employee('AVSY002KBY','AVIAN Synthetic Base Y','1.1.17.3',8,'',''),
      Employee('AVSY002KBA','AVIAN Synthetic Base A','1.1.17.4',8,'',''),
      Employee('AVSY002KBB','AVIAN Synthetic Base B','1.1.17.5',8,'',''),
      Employee('AVSY002KBC','AVIAN Synthetic Base C','1.1.17.6',8,'',''),
      Employee('POFIJJD0T001','Pow Fit Tee D4','1.1.19.1',8,'',''),
      Employee('POFIJIAWRS01','Pow Fit Reduce Sock AW 4x3','1.1.26.5',18,'',''),
      Employee('POFIHHD0E001','Pow Fit Elbow D 2 1/2','1.1.38.1',45,'',''),
      Employee('AVEM005K725','AVITEX Emulsion 725','1.1.7.3',4,'',''),
      Employee('GLSY001KSB','GLOVIN Synthetic SB','1.1.R',24,'',''),
      Employee('AGEM020KPSW','ARIES GOLD Emulsion SW','1.10.1.1',1,'',''),
      Employee('BOVE001KSW600','BOYO Politur Vernis Water 600','1.10.11.5',24,'',''),
      Employee('AVTH001KASP','AVIA Thinner A Special','1.10.15.1',24,'',''),
      Employee('NOEM002KBA','NO ODOR Emulsion BA','1.10.3.1',8,'',''),
      Employee('AQEM005KBC','AQUAMATT Emulsion BC','1.10.5.3',4,'',''),
      Employee('NODR001K019','NO DROP 019','1.10.8.2',24,'',''),
      Employee('AREM005K686','ARIES Emulsion 686','1.11.13.3',4,'',''),
      Employee('AGEM020KPSB','ARIES GOLD Emulsion SB','1.11.16.4',1,'',''),
      Employee('AVSY004K657','AVIAN Synthetic 657','1.11.20.5',4,'',''),
      Employee('AVSY004K190','AVIAN Synthetic 190','1.11.22.1',4,'',''),
      Employee('AVSY004K192','AVIAN Synthetic 192','1.11.22.2',4,'',''),
      Employee('AVSY004K194','AVIAN Synthetic 194','1.11.22.6',4,'',''),
      Employee('AREM020KPSW','ARIES Emulsion SW','1.11.3.1',1,'',''),
      Employee('YORO020KP74','YOKO Roof 74','1.11.3.7',1,'',''),
      Employee('SGAL020KPBB','SUNGUARD Em All in One BB','1.11.39.1',1,'',''),
      Employee('AQEM005KBA','AQUAMATT Emulsion BA','1.11.49.1',4,'',''),
      Employee('POFIDCAWFS01','Pow Fit Faucet Sock AW 1X3/4','1.11.8.5',130,'',''),
      Employee('AGEM020KPSW','ARIES GOLD Emulsion SW','1.12.1.1',1,'',''),
      Employee('AGEM020KP305','ARIES GOLD Emulsion 305','1.12.19.3',1,'',''),
      Employee('AGEM020KPSW','ARIES GOLD Emulsion SW','1.12.2.1',1,'',''),
      Employee('BOVE001KSPOL','BOYO Politur Vernis S','1.12.22.1',24,'',''),
      Employee('HCPRBF90P','Budget Paint Roller 9 Inci','1.12.23.1',24,'',''),
      Employee('AVSY001KSWM','AVIAN Synthetic SWM','1.12.26.5',24,'',''),
      Employee('AVSY001KSWM','AVIAN Synthetic SWM','1.12.26.6',24,'',''),
      Employee('AGEM020KPSW','ARIES GOLD Emulsion SW','1.12.3.1',1,'',''),
      Employee('AGEM020KPSW','ARIES GOLD Emulsion SW','1.12.4.1',1,'',''),
      Employee('AVHA001K007','AVIAN Hammertone 007','1.12.41.1',24,'',''),
      Employee('AGEM020KPSW','ARIES GOLD Emulsion SW','1.12.5.1',1,'',''),
      Employee('JAEM020KPMW','Jasmine Emulsion MW','1.13.2.3',1,'',''),
      Employee('YOSY001K798','YOKO Synthetic 798','1.14.26.4',24,'',''),
      Employee('NODR020KPBA','NO DROP Base A','1.15.19.1',1,'',''),
      Employee('POFIHHD0E001','Pow Fit Elbow D2 1/2','1.15.2.2',45,'',''),
      Employee('SPEM002KSW','SUPERSILK Emulsion SW','1.17.44.4',8,'',''),
      Employee('SGAL002KSW','SUNGUARD Emulsion All in One SW','1.17.5.2',8,'',''),
      Employee('POFIDCAWT001','Pow Fit Tee AW1x3/4','1.2.22.7',65,'',''),
      Employee('POFIDDAWFS01','Pow Fit Faucet Sock AW1','1.2.28.3',120,'',''),
      Employee("NEXAMT00C00901", "Nexa CFT 91 Columbia Nussebaum", "3.3.25.2", 4, '',''),
      Employee("NEXAMT00S00701", "Nexa CFT 90 Sonoma Oak", "3.3.25.2", 4, '',''),
      Employee("NEXART00N00401", "Nexa RTV 80 Natural Oak - Tsugawood Ash", "3.3.5.5", 4, '',''),
      Employee("NEXART00S00701", "Nexa RTV 123 Sonoma Oak", "3.3.23.4", 4, '',''),
      Employee("NEXART00W00102", "Nexa 1200 Wenge", "3.3.25.2", 4, '',''),
      Employee("NEXART00W00104", "Nexa 1522 Wenge", "3.1.23.3", 4, '',''),
      Employee("NEXART00W00401", "Nexa 600 R Wenge", "3.3.23.3", 4, '',''),
      Employee("NEXART00W01501", "Nexa RTV 124 White Glossy - Silver", "3.3.5.2", 4, '',''),
      Employee("NEXART00W01601", "Nexa RTV 160 White Glossy", "3.2.21.1", 4, '',''),
    ];
  }
  
  final CustomColumnSizer _customColumnSizer = CustomColumnSizer();

  showDetailRow(BuildContext context, Employee employeeDetail) {
    String binCodeDetailData = employees[_dataGridController.selectedIndex].binCode;
    String itemNoDetailData = employees[_dataGridController.selectedIndex].itemNo;
    String itemDescDetailData = employees[_dataGridController.selectedIndex].itemDesc;
    String coliDetailData = employees[_dataGridController.selectedIndex].coli.toString();
    qtyOpnDsController.text = employees[_dataGridController.selectedIndex].qtyUomDs;
    qtyOpnUomController.text = employees[_dataGridController.selectedIndex].qtyUom;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
          _setState = setState;
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
                                        controller: qtyOpnDsController,
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.next,
                                        focusNode: qtyOpnDsFocus,
                                        readOnly: true,
                                        showCursor: true,
                                        decoration: InputDecoration(
                                          errorText: qtyOpnDsValid ? "NIK tidak boleh kosong" : null,
                                        ),
                                        textCapitalization: TextCapitalization.characters,
                                        onSubmitted: (value) {
                                          fieldFocusChange(context, qtyOpnDsFocus, qtyOpnUomFocus);
                                        },
                                      ),
                                      TextField(
                                        key: Key("QtyOpnUom"),
                                        controller: qtyOpnUomController,
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.next,
                                        focusNode: qtyOpnUomFocus,
                                        readOnly: true,
                                        showCursor: true,
                                        decoration: InputDecoration(
                                          errorText: qtyOpnUomValid ? "NIK tidak boleh kosong" : null,
                                        ),
                                        textCapitalization: TextCapitalization.characters,
                                        onSubmitted: (value) {
                                          qtyOpnUomFocus.unfocus();
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
                                binCodeDetailData = employees[_dataGridController.selectedIndex].binCode;
                                itemNoDetailData = employees[_dataGridController.selectedIndex].itemNo;
                                itemDescDetailData = employees[_dataGridController.selectedIndex].itemDesc;
                                coliDetailData = employees[_dataGridController.selectedIndex].coli.toString();
                                qtyOpnDsController.text = employees[_dataGridController.selectedIndex].qtyUomDs;
                                qtyOpnUomController.text = employees[_dataGridController.selectedIndex].qtyUom;
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
                              _setState(() {
                                _dataGridController.selectedIndex = _dataGridController.selectedIndex + 1;
                                printHelp("CEK IDN "+_dataGridController.selectedIndex.toString());
                                binCodeDetailData = employees[_dataGridController.selectedIndex].binCode;
                                itemNoDetailData = employees[_dataGridController.selectedIndex].itemNo;
                                itemDescDetailData = employees[_dataGridController.selectedIndex].itemDesc;
                                coliDetailData = employees[_dataGridController.selectedIndex].coli.toString();
                                qtyOpnDsController.text = employees[_dataGridController.selectedIndex].qtyUomDs;
                                qtyOpnUomController.text = employees[_dataGridController.selectedIndex].qtyUom;
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
        });
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
                    columnWidthMode: ColumnWidthMode.fill,
                    // columnWidthMode: ColumnWidthMode.fitByCellValue,
                    // columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
                    // columnSizer: this._sizer,
                    gridLinesVisibility: GridLinesVisibility.horizontal,
                    headerGridLinesVisibility: GridLinesVisibility.horizontal,
                    onQueryRowHeight: (RowHeightDetails details) {
                      // if (details.rowIndex == 0)
                      //   return details.rowHeight;
                      // else
                      //   return details.getIntrinsicRowHeight(details.rowIndex);
                      return details.getIntrinsicRowHeight(details.rowIndex)*1.5;
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
                        autoFitPadding: EdgeInsets.all(16),
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
                        autoFitPadding: EdgeInsets.all(16),
                        columnName: 'itemNo',
                        // columnWidthMode: ColumnWidthMode.fitByCellValue,
                        label: Container(
                          alignment: Alignment.center,
                          child: TextView('Item\nNo', 6, align: TextAlign.center),
                        )
                      ),
                      GridColumn(
                        autoFitPadding: EdgeInsets.all(16),
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
                        autoFitPadding: EdgeInsets.all(16),
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
                        autoFitPadding: EdgeInsets.all(16),
                        columnName: 'qtyUomDs',
                        label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.45))
                            )
                          ),
                          child: TextView('Qty Uom DS', 6, align: TextAlign.center)
                        )
                      ),
                      GridColumn(
                        autoFitPadding: EdgeInsets.all(16),
                        columnName: 'qtyUom',
                        label: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.45))
                            )
                          ),
                          child: TextView('Qty Uom', 6, align: TextAlign.center)
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
  Employee(this.itemNo, this.itemDesc, this.binCode, this.coli, this.qtyUomDs, this.qtyUom);

  final String itemNo;
  final String binCode;
  final String itemDesc;
  final int coli;
  final String qtyUomDs;
  final String qtyUom;
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource(BuildContext context, {List<Employee> employeeData, DataGridController controller}) {
    _context = context;
    _dataGridController = controller;
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(
          cells: [
              DataGridCell<String>(columnName: 'binCode', value: e.binCode),
              DataGridCell<String>(columnName: 'itemNo', value: e.itemNo),
              DataGridCell<String>(columnName: 'itemDesc', value: e.itemDesc),
              DataGridCell<int>(columnName: 'coli', value: e.coli),
              DataGridCell<String>(columnName: 'qtyUomDs', value: e.qtyUomDs),
              DataGridCell<String>(columnName: 'qtyUomDs', value: e.qtyUom),
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
        padding: EdgeInsets.all(16),
        // child: Text(e.value.toString(), softWrap: true, overflow: TextOverflow.visible),
        child: TextView(e.value.toString(), 6),
      );
    }).toList());
  }

}

class CustomColumnSizer extends ColumnSizer {
  @override
  double computeCellWidth(GridColumn column, DataGridRow row, Object cellValue,
      TextStyle textStyle) {
    return super.computeCellWidth(column, row, cellValue, textStyle);
  }
}