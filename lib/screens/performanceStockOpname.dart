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

class PerformanceStockOpname extends StatefulWidget {

  const PerformanceStockOpname({Key key}) : super(key: key);

  @override
  PerformanceStockOpnameState createState() => PerformanceStockOpnameState();
}

class PerformanceStockOpnameState extends State<PerformanceStockOpname> {

  List<Employee> employees = <Employee>[];
  EmployeeDataSource employeeDataSource;

  ColumnSizer _sizer;

  final DataGridController _dataGridController = DataGridController();

  final FocusNode bulanFocus = FocusNode();
  final bulanController = TextEditingController();
  bool bulanValid = false;

  final _dropdownFormKey = GlobalKey<FormState>();
  String selectedBranchDropdownValue = "23A";

  bool pickerIsExpanded = false;
  int _pickerYear = DateTime.now().year;
  DateTime _selectedMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );

  dynamic _pickerOpen = true;

  StateSetter _setState;

  void switchPicker() {
    _setState(() {
      _pickerOpen ^= true;
    });
  }

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
  }

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
      Employee('03-05-2022','110','100%','','',''),
      Employee('04-05-2022','100','100%','','',''),
      Employee('05-05-2022','90','0%','','',''),
      Employee('06-05-2022','105','0%','','',''),
      Employee('07-05-2022','120','100%','','',''),
      Employee('08-05-2022','100','100%','','',''),
      Employee('09-05-2022','120','0%','','',''),
      Employee('10-05-2022','105','100%','','',''),
      Employee('11-05-2022','110','100%','','',''),
      Employee('12-05-2022','120','100%','','',''),
      Employee('13-05-2022','115','100%','','',''),
      Employee('14-05-2022','90','100%','','',''),
      Employee('15-05-2022','90','0%','','',''),
      Employee('16-05-2022','10','100%','','',''),
      Employee('17-05-2022','120','100%','','',''),
      Employee('18-05-2022','100','100%','','',''),
      Employee('19-05-2022','100','0%','','',''),
      Employee('20-05-2022','105','100%','','',''),
    ];
  }

  List<Widget> generateRowOfMonths(from, to) {
    List<Widget> months = [];
    for (int i = from; i <= to; i++) {
      DateTime dateTime = DateTime(_pickerYear, i, 1);
      final backgroundColor = dateTime.isAtSameMomentAs(_selectedMonth)
          ? Theme.of(context).accentColor
          : Colors.transparent;
      months.add(
        AnimatedSwitcher(
          duration: kThemeChangeDuration,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: TextButton(
            key: ValueKey(backgroundColor),
            onPressed: () {
              _setState(() {
                _selectedMonth = dateTime;
              });
            },
            style: TextButton.styleFrom(
              backgroundColor: backgroundColor,
              shape: CircleBorder(),
            ),
            child: Text(
              DateFormat('MMM').format(dateTime),
            ),
          ),
        ),
      );
    }
    return months;
  }

  List<Widget> generateMonths() {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: generateRowOfMonths(1, 6),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: generateRowOfMonths(7, 12),
      ),
    ];
  }
  
  final CustomColumnSizer _customColumnSizer = CustomColumnSizer();
  @override
  Widget build(BuildContext context) {
    Configuration config = Configuration.of(context);
    
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;

    return Scaffold(
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
              child: Scrollbar(
                isAlwaysShown: true,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          // crossAxisAlignment: CrossAxisAlignment.baseline,
                          // textBaseline: TextBaseline.alphabetic,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: TextView("Bulan", 4),
                                ),
                                SizedBox(height: 25),
                                Container(
                                  child: TextView("Bulan", 4, color: Colors.transparent,),
                                ),
                                Container(
                                  child: TextView("Cabang", 4),
                                ),
                                SizedBox(height: 25),
                                Container(
                                  child: TextView("Target", 4),
                                ),
                              ],
                            ),
                            SizedBox(width: 30),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: TextView(":", 6),
                                ),
                                SizedBox(height: 25),
                                Container(
                                  child: TextView("Bulan", 4, color: Colors.transparent,),
                                ),
                                Container(
                                  child: TextView(":", 6),
                                ),
                                SizedBox(height: 25),
                                Container(
                                  child: TextView(":", 6),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    key: Key("bulan"),
                                    controller: bulanController,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    focusNode: bulanFocus,
                                    // readOnly: true,
                                    decoration: InputDecoration(
                                      errorText: bulanValid ? "NIK tidak boleh kosong" : null,
                                    ),
                                    textCapitalization: TextCapitalization.characters,
                                    onTap: (){
                                      // showDatePicker(
                                      //   context: context,
                                      //   initialDate: DateTime.now(),
                                      //   firstDate: DateTime(2000),
                                      //   lastDate: DateTime(2025),
                                      //   initialDatePickerMode: DatePickerMode.year,
                                      // );
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Select Year"),
                                            content: StatefulBuilder(
                                              builder: (BuildContext context, StateSetter setState) {
                                              _setState = setState;
                                              return Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Material(
                                                    color: Theme.of(context).cardColor,
                                                    child: Container(
                                                      height: _pickerOpen ? null : 0.0,
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              IconButton(
                                                                onPressed: () {
                                                                  _setState(() {
                                                                    _pickerYear = _pickerYear - 1;
                                                                  });
                                                                },
                                                                icon: Icon(Icons.navigate_before_rounded),
                                                              ),
                                                              Expanded(
                                                                child: Center(
                                                                  child: Text(
                                                                    _pickerYear.toString(),
                                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ),
                                                              IconButton(
                                                                onPressed: () {
                                                                  _setState(() {
                                                                    _pickerYear = _pickerYear + 1;
                                                                  });
                                                                },
                                                                icon: Icon(Icons.navigate_next_rounded),
                                                              ),
                                                            ],
                                                          ),
                                                          ...generateMonths(),
                                                          SizedBox(
                                                            height: 10.0,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20.0,
                                                  ),
                                                  Text(DateFormat.yMMMM().format(_selectedMonth)),
                                                  ElevatedButton(
                                                    onPressed: (){
                                                      Navigator.of(context).pop();
                                                      setState(() {
                                                        bulanController.text =DateFormat.yMMMM().format(_selectedMonth);
                                                      });
                                                    },
                                                    child: Text(
                                                      'Select date',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }),
                                          );
                                        },
                                      );
                                      // showDatePicker(
                                      //   context: context,
                                      //   initialDate: DateTime.now(),
                                      //   firstDate: DateTime(2000),
                                        
                                      //   lastDate: DateTime.now(),
                                      //   helpText: 'Pilih Bulan', // Can be used as title
                                      //   cancelText: 'Batal',
                                      //   confirmText: 'Ok',
                                      // );
                                    },
                                  ),
                                  SizedBox(height: 30),
                                  DropdownButtonHideUnderline(
                                    child: ButtonTheme(
                                      alignedDropdown: true,
                                      child: DropdownButton<String>(
                                        dropdownColor: Colors.white,
                                        value: selectedBranchDropdownValue,
                                        icon: Icon(Icons.keyboard_arrow_down, color: config.grayColor),
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedBranchDropdownValue = newValue;
                                          });
                                        },
                                        items: <String>['20A','20B','20C','21A','21B','22A','22B','22C','23A','23B','23C','23D']
                                        .map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: TextView(value, 4),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: TextView("72.2%", 4),
                                  ),
                                  // Form(
                                  //   key: _dropdownFormKey,
                                  //   child: DropdownButtonFormField(
                                  //     decoration: InputDecoration(
                                  //       enabledBorder: OutlineInputBorder(
                                  //         borderSide: BorderSide(color: config.grayColor, width: 1.5),
                                  //         borderRadius: BorderRadius.circular(5),
                                  //       ),
                                  //       // filled: true,
                                  //       // fillColor: Colors.white,
                                  //       labelText: "Data Type",
                                  //       labelStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily:'Roboto', fontSize: 16),
                                  //     ),
                                  //     hint: TextView('Data Type', 5),
                                  //     validator: (value) => value == null ? "Select a country" : null,
                                  //     dropdownColor: Colors.white,
                                  //     value: selectedBranchDropdownValue,
                                  //     onChanged: (String value) {
                                  //       _setState(() {
                                  //         selectedBranchDropdownValue = value;
                                  //       });
                                  //     },
                                  //     items: <String>['20A','20B','20C','21A','21B','22A','22B','22C','23A','23B','23C','23D']
                                  //         .map<DropdownMenuItem<String>>((String value) {
                                  //       return DropdownMenuItem<String>(
                                  //         value: value,
                                  //         child: TextView(value, 4),
                                  //       );
                                  //     }).toList(),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            Expanded(flex:2, child: Container()),
                            Expanded(
                              child: Button(
                                disable: false,
                                child: TextView('Proses', 3, color: Colors.white, caps: true),
                                onTap: () {},
                              ),
                            )
                          ],
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                            // onSelectionChanging:
                            //     (List<DataGridRow> addedRows, List<DataGridRow> removedRows) {
                            //   final index = employeeDataSource._employeeData.indexOf(addedRows.last);
                            //   Employee employee = employees[index];
                            //   printHelp("data "+employee.itemDesc);
                            //   _setState(() {
                            //     _dataGridController.selectedIndex = index;
                            //   });
                
                            //   return true;
                            // },
                            columns: <GridColumn>[
                              GridColumn(
                                autoFitPadding: EdgeInsets.all(16),
                                columnName: 'tanggal',
                                label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.45))
                                    )
                                  ),
                                  child: TextView('Tanggal', 6, align: TextAlign.center, fontWeight: FontWeight.bold)
                                )
                              ),
                              GridColumn(
                                autoFitPadding: EdgeInsets.all(16),
                                columnName: 'jumlahSKU',
                                // columnWidthMode: ColumnWidthMode.fitByCellValue,
                                label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.45))
                                    )
                                  ),
                                  child: TextView('Jumlah SKU', 6, align: TextAlign.center, fontWeight: FontWeight.bold),
                                )
                              ),
                              GridColumn(
                                autoFitPadding: EdgeInsets.all(16),
                                columnName: 'stoDays',
                                // columnWidthMode: ColumnWidthMode.fitByCellValue,
                                label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.45))
                                    )
                                  ),
                                  child: TextView('STO Days', 6, align: TextAlign.center, fontWeight: FontWeight.bold),
                                )
                              ),
                              GridColumn(
                                autoFitPadding: EdgeInsets.all(16),
                                columnName: 'accByQty',
                                label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.45))
                                    )
                                  ),
                                  child: TextView('Akurasi\nBy Qty',  6, align: TextAlign.center, fontWeight: FontWeight.bold)
                                )
                              ),
                              GridColumn(
                                autoFitPadding: EdgeInsets.all(16),
                                columnName: 'accQtyByBin',
                                label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.45))
                                    )
                                  ),
                                  child: TextView('Akurasi Qty\npada Bin',  6, align: TextAlign.center, fontWeight: FontWeight.bold)
                                )
                              ),
                              GridColumn(
                                autoFitPadding: EdgeInsets.all(16),
                                columnName: 'accItemByBin',
                                label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.45))
                                    )
                                  ),
                                  child: TextView('Akurasi Item\npada Bin',  6, align: TextAlign.center, fontWeight: FontWeight.bold)
                                )
                              ),
                            ],
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
}

class Employee {
  Employee(this.tanggal, this.jumlahSKU, this.stoDays, this.accByQty, this.accQtyByBin, this.accItemByBin);

  final String tanggal;
  final String jumlahSKU;
  final String stoDays;
  final String accByQty;
  final String accQtyByBin;
  final String accItemByBin;
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource(BuildContext context, {List<Employee> employeeData, DataGridController controller}) {
    _context = context;
    _dataGridController = controller;
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(
          cells: [
              DataGridCell<String>(columnName: 'tanggal', value: e.tanggal),
              DataGridCell<String>(columnName: 'jumlahSKU', value: e.jumlahSKU),
              DataGridCell<String>(columnName: 'stoDays', value: e.stoDays),
              DataGridCell<String>(columnName: 'accByQty', value: e.accByQty),
              DataGridCell<String>(columnName: 'accQtyByBin', value: e.accQtyByBin),
              DataGridCell<String>(columnName: 'accItemByBin', value: e.accItemByBin),
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
            left: e.columnName == 'tanggal'
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