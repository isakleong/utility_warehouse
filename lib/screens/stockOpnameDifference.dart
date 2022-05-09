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
                    onSelectionChanged: (List<DataGridRow> addedRows, List<DataGridRow> removedRows) {
                      final index = employeeDataSource._employeeData.indexOf(addedRows.last);
                      Employee employee = employees[index];
                      printHelp("data "+employee.itemDesc);

                      return true;
                    },
                    // onSelectionChanging:
                    //     (List<DataGridRow> addedRows, List<DataGridRow> removedRows) {
                    //   final index = employeeDataSource._employeeData.indexOf(addedRows.last);
                    //   Employee employee = employees[index];
                    //   printHelp("data "+employee.itemDesc);

                    //   return true;
                    // },
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