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
    employeeDataSource = EmployeeDataSource(employeeData: employees);
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
      Employee("AGEM005K010 LOREM LOREM LOREM LOREM LOREM IPSUM", "ARIES GOLD Emulsion 110", "1.2.1.1", 6, "SAK", "ANDI", "107", "5", "", "", "", ""),
      Employee("AGEM005K102", "ARIES GOLD Emulsion 102", "1.2.1.1", 6, "SAK", "ANDI", "107", "5", "", "", "", ""),
      Employee("GIMO005K220", "GIANT Mortar 220 pck", "1.2.1.1", 6, "SAK", "ANDI", "107", "5", "", "", "", ""),
      Employee("GIMO005K220", "GIANT Mortar 220 alk", "1.2.1.1", 6, "SAK", "ANDI", "107", "5", "", "", "", ""),
      Employee("GIMO005K220", "GIANT Mortar 220 bro", "1.2.1.1", 6, "SAK", "ANDI", "107", "5", "", "", "", ""),
      Employee("GIMO005K220", "GIANT Mortar 220 der", "1.2.1.1", 6, "SAK", "ANDI", "107", "5", "", "", "", ""),
      Employee("GIMO005K220", "GIANT Mortar 220 van", "1.2.1.1", 6, "SAK", "ANDI", "107", "5", "", "", "", ""),
      Employee("GIMO005K220", "GIANT Mortar 220 hmm", "1.2.1.1", 6, "SAK", "ANDI", "107", "5", "", "", "", ""),
      Employee("GIMO005K220", "GIANT Mortar 220 huhu", "1.2.1.1", 6, "SAK", "ANDI", "107", "5", "", "", "", ""),
      Employee("GIMO005K220", "GIANT Mortar 220 haha", "1.2.1.1", 6, "SAK", "ANDI", "107", "5", "", "", "", ""),
      Employee("GIMO005K220", "GIANT Mortar 220 wew", "1.2.1.1", 6, "SAK", "ANDI", "107", "5", "", "", "", ""),
      Employee("GIMO005K220", "GIANT Mortar 220 end", "1.2.1.1", 6, "SAK", "ISAK", "107", "5", "", "", "", ""),
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
          child: TextView('Masuk', 3, color: Colors.white, caps: true),
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

            // SafeArea(
            //   child: Card(
            //     child: LayoutBuilder(builder: (context, constraint) {
            //       return Column(
            //         children: [
            //           SizedBox(
            //             height: constraint.maxHeight - 60,
            //             width: constraint.maxWidth,
            //             child: SingleChildScrollView(
            //               scrollDirection: Axis.horizontal,
            //               child: SfDataGrid(
            //                 source: employeeDataSource,
            //                 columnWidthMode: ColumnWidthMode.auto,
            //                 columnSizer: this._sizer,
            //                 gridLinesVisibility: GridLinesVisibility.horizontal,
            //                 headerGridLinesVisibility: GridLinesVisibility.horizontal,
            //                 onQueryRowHeight: (RowHeightDetails details) {
            //                   if (details.rowIndex == 0)
            //                     return details.rowHeight;
            //                   else
            //                     return details.getIntrinsicRowHeight(details.rowIndex);
            //                 },
            //                 shrinkWrapColumns: true,
            //                 shrinkWrapRows: true,
            //                 columns: <GridColumn>[
            //                   GridColumn(
            //                     autoFitPadding: EdgeInsets.all(0),
            //                     columnName: 'itemNo',
            //                     // columnWidthMode: ColumnWidthMode.fitByCellValue,
            //                     label: Container(
            //                       alignment: Alignment.center,
            //                       child: TextView('Item\nNo', 6, align: TextAlign.center),
            //                     )
            //                   ),
            //                   GridColumn(
            //                     autoFitPadding: EdgeInsets.all(0),
            //                     columnName: 'binCode',
            //                     label: Container(
            //                       alignment: Alignment.center,
            //                       decoration: BoxDecoration(
            //                         border: Border(
            //                           left: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.45))
            //                         )
            //                       ),
            //                       child: TextView('Bin Code', 6, align: TextAlign.center)
            //                     )
            //                   ),
            //                   GridColumn(
            //                     autoFitPadding: EdgeInsets.all(0),
            //                     columnName: 'itemDescription',
            //                     label: Container(
            //                       alignment: Alignment.center,
            //                       decoration: BoxDecoration(
            //                         border: Border(
            //                           left: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.45))
            //                         )
            //                       ),
            //                       child: TextView('Item\nDescription',  6, align: TextAlign.center)
            //                     )
            //                   ),
            //                   GridColumn(
            //                     autoFitPadding: EdgeInsets.all(0),
            //                     columnName: 'coli',
            //                     label: Container(
            //                       alignment: Alignment.center,
            //                       decoration: BoxDecoration(
            //                         border: Border(
            //                           left: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.45))
            //                         )
            //                       ),
            //                       child: TextView('Coli', 6, align: TextAlign.center)
            //                     )
            //                   ),
            //                   GridColumn(
            //                     autoFitPadding: EdgeInsets.all(0),
            //                     columnName: 'uom',
            //                     label: Container(
            //                       alignment: Alignment.center,
            //                       decoration: BoxDecoration(
            //                         border: Border(
            //                           left: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.45))
            //                         )
            //                       ),
            //                       child: TextView('Uom', 6, align: TextAlign.center)
            //                     )
            //                   ),
            //                   GridColumn(
            //                     autoFitPadding: EdgeInsets.all(0),
            //                     columnName: 'namaPIC',
            //                     label: Container(
            //                       alignment: Alignment.center,
            //                       decoration: BoxDecoration(
            //                         border: Border(
            //                           left: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.45))
            //                         )
            //                       ),
            //                       child: TextView('Nama', 6, align: TextAlign.center)
            //                     )
            //                   ),
            //                   GridColumn(
            //                     autoFitPadding: EdgeInsets.all(0),
            //                     columnName: 'qtySTODs',
            //                     label: Container(
            //                       alignment: Alignment.center,
            //                       decoration: BoxDecoration(
            //                         border: Border(
            //                           left: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.45))
            //                         )
            //                       ),
            //                       child: TextView('Qty\nSTO\nDS', 6, align: TextAlign.center)
            //                     )
            //                   ),
            //                   GridColumn(
            //                     autoFitPadding: EdgeInsets.all(0),
            //                     columnName: 'qtySTOUom',
            //                     label: Container(
            //                       alignment: Alignment.center,
            //                       decoration: BoxDecoration(
            //                         border: Border(
            //                           left: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.45))
            //                         )
            //                       ),
            //                       child: TextView('Qty\nSTO\nUom', 6, align: TextAlign.center)
            //                     )
            //                   ),
            //                   GridColumn(
            //                     autoFitPadding: EdgeInsets.all(0),
            //                     columnName: 'qtySTODs2',
            //                     label: Container(
            //                       alignment: Alignment.center,
            //                       decoration: BoxDecoration(
            //                         border: Border(
            //                           left: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.45))
            //                         )
            //                       ),
            //                       child: TextView('Qty\nSTO\nDS 2', 6, align: TextAlign.center)
            //                     )
            //                   ),
            //                   GridColumn(
            //                     autoFitPadding: EdgeInsets.all(0),
            //                     columnName: 'qtySTOUom2',
            //                     label: Container(
            //                       alignment: Alignment.center,
            //                       decoration: BoxDecoration(
            //                         border: Border(
            //                           left: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.45))
            //                         )
            //                       ),
            //                       child: TextView('Qty\nSTO\nUom 2', 6, align: TextAlign.center)
            //                     )
            //                   ),
            //                   GridColumn(
            //                     autoFitPadding: EdgeInsets.all(0),
            //                     columnName: 'qtySTODsFinal',
            //                     label: Container(
            //                       alignment: Alignment.center,
            //                       decoration: BoxDecoration(
            //                         border: Border(
            //                           left: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.45))
            //                         )
            //                       ),
            //                       child: TextView('Qty\nSTO\nDS Final', 6, align: TextAlign.center)
            //                     )
            //                   ),
            //                   GridColumn(
            //                     autoFitPadding: EdgeInsets.all(0),
            //                     columnName: 'qtySTOUomFinal',
            //                     label: Container(
            //                       alignment: Alignment.center,
            //                       decoration: BoxDecoration(
            //                         border: Border(
            //                           left: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.45))
            //                         )
            //                       ),
            //                       child: TextView('Qty\nSTO\nUom Final', 6, align: TextAlign.center)
            //                     )
            //                   ),
            //                 ]
            //               ),
            //             )
            //           ),
            //           Container(
            //             // height: 60,
            //             color: Colors.white,
            //             child: SfDataPager(
            //               delegate: employeeDataSource,
            //               direction: Axis.horizontal,
            //               pageCount: (employees.length / 5).round().toDouble(),
            //             ),
            //           )
            //         ],
            //       );
            //     }),
            //   ),
            // ),
            
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
                    footerFrozenRowsCount: 1,
                    footer: Container(
                      color: Colors.grey[400],
                      child: Center(
                        child: Button(
                          disable: false,
                          child: TextView('Upload', 3, color: Colors.white, caps: true),
                          onTap: () {

                          },
                        ),
                      )
                    ),
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

            // HorizontalDataTable(
            //   leftHandSideColumnWidth: MediaQuery.of(context).size.width * 0.15,
            //   rightHandSideColumnWidth: MediaQuery.of(context).size.width * 0.66,
            //   isFixedHeader: true,
            //   headerWidgets: _getTitleWidget(),
            //   leftSideItemBuilder: _generateFirstColumnRow,
            //   rightSideItemBuilder: _generateRightHandSideColumnRow,
            //   itemCount: 3,
            //   rowSeparatorWidget: const Divider(
            //     color: Colors.black54,
            //     height: 1.0,
            //     thickness: 0.0,
            //   ),
            //   horizontalScrollbarStyle: const ScrollbarStyle(
            //     thumbColor: Colors.red,
            //     isAlwaysShown: false,
            //     thickness: 4.0,
            //     radius: Radius.circular(5.0),
            //   ),
            // ),

            // SafeArea(
            //   child: SingleChildScrollView(
            //     scrollDirection: Axis.horizontal,
            //     child: Padding(
            //       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
            //       child: FittedBox(
            //         child: DataTable(
            //           columnSpacing : 25,
            //           columns: [
            //             DataColumn(label: TextView("Item\nNo", 4)),
            //             DataColumn(label: TextView("Bin\nCode", 4)),
            //             DataColumn(label: TextView("Item\nDescription", 4)),
            //             DataColumn(label: TextView("Coli", 4)),
            //             DataColumn(label: TextView("Uom", 4)),
            //             DataColumn(label: TextView("Nama", 4)),
            //             DataColumn(label: TextView("Qty STO\nDS", 4)),
            //             DataColumn(label: TextView("Qty STO\nUom", 4)),
            //             DataColumn(label: TextView("Qty STO\nDS 2", 4)),
            //             DataColumn(label: TextView("Qty STO\nUom 2", 4)),
            //             DataColumn(label: TextView("Qty STO\nDS Final", 4)),
            //             DataColumn(label: TextView("Qty STO\nUom Final", 4)),
            //           ],
            //           rows: [
            //             DataRow(
            //               cells: [
            //                 DataCell(Text(
            //                   "GIMO005K220",
            //                   overflow: TextOverflow.visible,
            //                   softWrap: true, overflow: TextOverflow.visible,
            //                 )),
            //                 DataCell(TextView("1.2.1.1", 4)),
            //                 DataCell(TextView("GIANT Mortar 220", 4)),
            //                 DataCell(TextView("6", 4)),
            //                 DataCell(TextView("SAK", 4)),
            //                 DataCell(TextView("Andi", 4)),
            //                 DataCell(TextView("107", 4)),
            //                 DataCell(TextView("Qty STO 5", 4)),
            //                 DataCell(TextView("", 4)),
            //                 DataCell(TextView("", 4)),
            //                 DataCell(TextView("", 4)),
            //                 DataCell(TextView("", 4)),
            //               ],
            //             ),
            //             DataRow(
            //               cells: [
            //                 DataCell(Text(
            //                   "GIMO005K220",
            //                   overflow: TextOverflow.visible,
            //                   softWrap: true, overflow: TextOverflow.visible,
            //                 )),
            //                 DataCell(TextView("1.2.1.1", 4)),
            //                 DataCell(TextView("GIANT Mortar 220", 4)),
            //                 DataCell(TextView("6", 4)),
            //                 DataCell(TextView("SAK", 4)),
            //                 DataCell(TextView("Andi", 4)),
            //                 DataCell(TextView("107", 4)),
            //                 DataCell(TextView("Qty STO 5", 4)),
            //                 DataCell(TextView("", 4)),
            //                 DataCell(TextView("", 4)),
            //                 DataCell(TextView("", 4)),
            //                 DataCell(TextView("", 4)),
            //               ],
            //             ),
            //             DataRow(
            //               cells: [
            //                 DataCell(Text(
            //                   "GIMO005K220",
            //                   overflow: TextOverflow.visible,
            //                   softWrap: true, overflow: TextOverflow.visible,
            //                 )),
            //                 DataCell(TextView("1.2.1.1", 4)),
            //                 DataCell(TextView("GIANT Mortar 220", 4)),
            //                 DataCell(TextView("6", 4)),
            //                 DataCell(TextView("SAK", 4)),
            //                 DataCell(TextView("Andi", 4)),
            //                 DataCell(TextView("107", 4)),
            //                 DataCell(TextView("Qty STO 5", 4)),
            //                 DataCell(TextView("", 4)),
            //                 DataCell(TextView("", 4)),
            //                 DataCell(TextView("", 4)),
            //                 DataCell(TextView("", 4)),
            //               ],
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // )

            
            // SfDataGrid(
            //   source: employeeDataSource,
            //   columnWidthMode: ColumnWidthMode.fill,
            //   columns: <GridColumn>[
            //     GridColumn(
            //       columnName: 'itemNo',
            //       label: Container(
            //         padding: EdgeInsets.all(16.0),
            //         alignment: Alignment.center,
            //         child: TextView('Item No', 4)
            //       )
            //     ),
            //     GridColumn(
            //       columnName: 'binCode',
            //       label: Container(
            //         padding: EdgeInsets.all(8.0),
            //         alignment: Alignment.center,
            //         child: Text('Bin Code', overflow: TextOverflow.visible,)
            //       )
            //     ),
            //     GridColumn(
            //       columnName: 'itemDescription',
            //       label: Container(
            //         padding: EdgeInsets.all(8.0),
            //         alignment: Alignment.center,
            //         child: Text('Item Description', overflow: TextOverflow.visible,)
            //       )
            //     ),
            //     GridColumn(
            //       columnName: 'coli',
            //       label: Container(
            //         padding: EdgeInsets.all(8.0),
            //         alignment: Alignment.center,
            //         child: Text('Coli', overflow: TextOverflow.visible,)
            //       )
            //     ),
            //     GridColumn(
            //       columnName: 'uom',
            //       label: Container(
            //         padding: EdgeInsets.all(8.0),
            //         alignment: Alignment.center,
            //         child: Text('Uom', overflow: TextOverflow.visible,)
            //       )
            //     ),
            //     GridColumn(
            //       columnName: 'namaPIC',
            //       label: Container(
            //         padding: EdgeInsets.all(8.0),
            //         alignment: Alignment.center,
            //         child: Text('Nama', overflow: TextOverflow.visible,)
            //       )
            //     ),
            //     GridColumn(
            //       columnName: 'qtySTODs',
            //       label: Container(
            //         padding: EdgeInsets.all(8.0),
            //         alignment: Alignment.center,
            //         child: Text('Qty STO DS', overflow: TextOverflow.visible,)
            //       )
            //     ),
            //     GridColumn(
            //       columnName: 'qtySTOUom',
            //       label: Container(
            //         padding: EdgeInsets.all(8.0),
            //         alignment: Alignment.center,
            //         child: Text('Qty STO Uom', overflow: TextOverflow.visible,)
            //       )
            //     ),
            //     GridColumn(
            //       columnName: 'qtySTODs2',
            //       label: Container(
            //         padding: EdgeInsets.all(8.0),
            //         alignment: Alignment.center,
            //         child: Text('Qty STO DS 2', overflow: TextOverflow.visible,)
            //       )
            //     ),
            //     GridColumn(
            //       columnName: 'qtySTOUom2',
            //       label: Container(
            //         padding: EdgeInsets.all(8.0),
            //         alignment: Alignment.center,
            //         child: Text('Qty STO Uom 2', overflow: TextOverflow.visible,)
            //       )
            //     ),
            //     GridColumn(
            //       columnName: 'qtySTODsFinal',
            //       label: Container(
            //         padding: EdgeInsets.all(8.0),
            //         alignment: Alignment.center,
            //         child: Text('Qty STO DS Final', overflow: TextOverflow.visible,)
            //       )
            //     ),
            //     GridColumn(
            //       columnName: 'qtySTOUomFinal',
            //       label: Container(
            //         padding: EdgeInsets.all(8.0),
            //         alignment: Alignment.center,
            //         child: Text('Qty STO Uom Final', overflow: TextOverflow.visible,)
            //       )
            //     ),
            //   ],
            // ),


            // Center(
            //   child: SingleChildScrollView(
            //     reverse: true,
            //     child: Container(
            //       padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: <Widget>[
            //           Hero(
            //             tag: 'logo',
            //             child: Container(
            //               width: mediaWidth*0.5,
            //               height: mediaWidth*0.5,
            //               child: Image.asset("assets/illustration/logo.png", alignment: Alignment.center, fit: BoxFit.contain),
            //             ),
            //           ),
            //           Form(
            //             key: _dropdownFormKey,
            //             child: DropdownButtonFormField(
            //               decoration: InputDecoration(
            //                 enabledBorder: OutlineInputBorder(
            //                   borderSide: BorderSide(color: config.grayColor, width: 1.5),
            //                   borderRadius: BorderRadius.circular(5),
            //                 ),
            //                 // filled: true,
            //                 // fillColor: Colors.white,
            //                 labelText: "Login Sebagai",
            //                 labelStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily:'Roboto', fontSize: 16),
            //               ),
            //               hint: TextView('Login Sebagai', 5),
            //               validator: (value) => value == null ? "Select a country" : null,
            //               dropdownColor: Colors.white,
            //               value: selectedDropdownValue,
            //               onChanged: (String value) {
            //                 setState(() {
            //                   selectedDropdownValue = value;
            //                   usernameController.clear();
            //                   passwordController.clear();
            //                   usernameValid = false;
            //                   passwordValid = false;
            //                   if(value == "Warehouse Manager") {
            //                     usernameTextHint = "###-##-###";
            //                     maskFormatter = MaskTextInputFormatter(mask: "###-##-###", filter: { "#": RegExp(r'[a-zA-Z0-9]') }, type: MaskAutoCompletionType.eager);
            //                   } else if(value == "Kepala Gudang") {
            //                     usernameTextHint = "###-##";
            //                     maskFormatter = MaskTextInputFormatter(mask: "###-##", filter: { "#": RegExp(r'[a-zA-Z0-9]') }, type: MaskAutoCompletionType.eager);
            //                   } else  {
            //                     usernameTextHint = "###-##-##";
            //                     maskFormatter = MaskTextInputFormatter(mask: "###-##-##", filter: { "#": RegExp(r'[a-zA-Z0-9]') }, type: MaskAutoCompletionType.eager);
            //                   }
            //                 });
            //               },
            //               items: <String>['Warehouse Manager', 'Kepala Gudang', 'Helper']
            //                   .map<DropdownMenuItem<String>>((String value) {
            //                 return DropdownMenuItem<String>(
            //                   value: value,
            //                   child: TextView(value, 4),
            //                 );
            //               }).toList(),
            //             ),
            //           ),
            //           SizedBox(height: 20),
            //           Container(
            //             child: TextField(
            //               key: Key("Username"),
            //               inputFormatters: [maskFormatter],
            //               controller: usernameController,
            //               keyboardType: TextInputType.text,
            //               textInputAction: TextInputAction.next,
            //               focusNode: usernameFocus,
            //               decoration: InputDecoration(
            //                 floatingLabelBehavior: FloatingLabelBehavior.always,
            //                 hintText: usernameTextHint,
            //                 hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize:16, fontFamily: 'Roboto'),
            //                 labelStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily:'Roboto', fontSize: 16),
            //                 border: OutlineInputBorder(),
            //                 enabledBorder: OutlineInputBorder(
            //                   borderRadius: BorderRadius.all(Radius.circular(4)),
            //                   borderSide: BorderSide(width: 1.5, color: config.grayColor),
            //                 ),
            //                 focusedBorder: OutlineInputBorder(
            //                   borderRadius: BorderRadius.all(Radius.circular(4)),
            //                   borderSide: BorderSide(width: 1.5, color: config.darkOpacityBlueColor),
            //                 ),
            //                 labelText: "Username",
            //                 errorText: usernameValid ? "Username tidak boleh kosong" : null,
            //               ),
            //               textCapitalization: TextCapitalization.characters,
            //               onSubmitted: (value) {
            //                 fieldFocusChange(context, usernameFocus, passwordFocus);
            //               },
            //             ),
            //           ),
            //           SizedBox(height: 20),
            //           Container(
            //             child: TextField(
            //               key: Key("Password"),
            //               controller: passwordController,
            //               obscureText: unlockPassword,
            //               focusNode: passwordFocus,
            //               keyboardType: TextInputType.text,
            //               textInputAction: TextInputAction.go,
            //               decoration: InputDecoration(
            //                 floatingLabelBehavior: FloatingLabelBehavior.always,
            //                 labelStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily:'Roboto', fontSize: 16),
            //                 // hintText: "Password",
            //                 labelText: "Password",
            //                 border: OutlineInputBorder(),
            //                 enabledBorder: OutlineInputBorder(
            //                   borderRadius: BorderRadius.all(Radius.circular(4)),
            //                   borderSide: BorderSide(width: 1.5, color: config.grayColor),
            //                 ),
            //                 focusedBorder: OutlineInputBorder(
            //                   borderRadius: BorderRadius.all(Radius.circular(4)),
            //                   borderSide: BorderSide(width: 1.5, color: config.darkOpacityBlueColor),
            //                 ),
            //                 errorText: passwordValid ? "Password tidak boleh kosong" : null,
            //                 suffixIcon: InkWell(
            //                   child: Container(
            //                     padding: EdgeInsets.symmetric(horizontal: 5),
            //                     child: Icon(
            //                       Icons.remove_red_eye,
            //                       color:  unlockPassword ? config.lightGrayColor : config.grayColor,
            //                       size: 18,
            //                     ),
            //                   ),
            //                   onTap: () {
            //                     setState(() {
            //                       unlockPassword = !unlockPassword;
            //                     });
            //                   },
            //                 ),
            //               ),
            //               onSubmitted: (value) {
            //                 passwordFocus.unfocus();
            //                 submitLoginValidation();
            //               },
            //             ),
            //           ),
            //           SizedBox(height: 30),
            //           Container(
            //             width: mediaWidth,
            //             child: Button(
            //               disable: false,
            //               child: TextView('Masuk', 3, color: Colors.white, caps: true),
            //               onTap: () {
            //                   // Navigator.push(
            //                   //   context,
            //                   //   MaterialPageRoute(builder: (context) => PickPageVertical()),
            //                   // );
            //                   submitLoginValidation();
            //                 },
            //             ),
            //           ),
            //           Padding(
            //             padding: EdgeInsets.only(top: 20),
            //             child: Align(
            //               alignment: Alignment.bottomRight,
            //               child: Theme(
            //                 data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
            //                 child: Text("v"+config.apkVersion, style: TextStyle(color: config.grayColor)),
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        )
      ),
    );
  }
}

class Employee {
  Employee(this.itemNo, this.binCode, this.itemDesc, this.coli, this.uom, this.nama,
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
  EmployeeDataSource({List<Employee> employeeData}) {
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(
          cells: [
              DataGridCell<String>(columnName: 'itemNo', value: e.itemNo),
              DataGridCell<String>(columnName: 'itemDesc', value: e.itemDesc),
              DataGridCell<String>(columnName: 'binCode', value: e.binCode),
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