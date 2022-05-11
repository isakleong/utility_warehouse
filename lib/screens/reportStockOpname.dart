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

class ReportStockOpname extends StatefulWidget {

  const ReportStockOpname({Key key}) : super(key: key);

  @override
  ReportStockOpnameState createState() => ReportStockOpnameState();
}

class ReportStockOpnameState extends State<ReportStockOpname> {

  List<Employee> employees = <Employee>[];
  EmployeeDataSource employeeDataSource;

  ColumnSizer _sizer;

  final DataGridController _dataGridController = DataGridController();

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
      Employee('AVEM025KP751','AVITEX Emulsion 751','1.1.12.3',1,'PL','Stock','Positive Adjustment'),
      Employee('WOWO001K109','WOOD-ECO Woodstain 109','1.1.14.6',24,'DS','Stock','Positive Adjustment'),
      Employee('WOWO001K110','WOOD-ECO Woodstain 110','1.1.15.1',24,'DS','Stock','Positive Adjustment'),
      Employee('WOWO001K112','WOOD-ECO Woodstain 112','1.1.15.3',24,'DS','Stock','Positive Adjustment'),
      Employee('WOWO001K115','WOOD-ECO Woodstain 115','1.1.15.6',24,'DS','Stock','Positive Adjustment'),
      Employee('WOWO001KCG','WOOD-ECO Woodstain CG','1.1.16.1',24,'DS','Stock','Positive Adjustment'),
      Employee('WOWO001KCM','WOOD-ECO Woodstain CM','1.1.16.2',24,'DS','Stock','Positive Adjustment'),
      Employee('AVSY002KBY','AVIAN Synthetic Base Y','1.1.17.3',8,'DS','Stock','Positive Adjustment'),
      Employee('AVSY002KBA','AVIAN Synthetic Base A','1.1.17.4',8,'DS','Stock','Positive Adjustment'),
      Employee('AVSY002KBB','AVIAN Synthetic Base B','1.1.17.5',8,'DS','Stock','Positive Adjustment'),
      Employee('AVSY002KBC','AVIAN Synthetic Base C','1.1.17.6',8,'DS','Stock','Positive Adjustment'),
      Employee('POFIJJD0T001','Pow Fit Tee D4','1.1.19.1',8,'DS','Stock','Positive Adjustment'),
      Employee('POFIJIAWRS01','Pow Fit Reduce Sock AW 4x3','1.1.26.5',18,'DS','Stock','Positive Adjustment'),
      Employee('POFIHHD0E001','Pow Fit Elbow D 2 1/2','1.1.38.1',45,'DS','Stock','Positive Adjustment'),
      Employee('AVEM005K725','AVITEX Emulsion 725','1.1.7.3',4,'DS','Stock','Positive Adjustment'),
      Employee('GLSY001KSB','GLOVIN Synthetic SB','1.1.R',24,'DS','Stock','Positive Adjustment'),
      Employee('AGEM020KPSW','ARIES GOLD Emulsion SW','1.10.1.1',1,'PL','Stock','Positive Adjustment'),
      Employee('BOVE001KSW600','BOYO Politur Vernis Water 600','1.10.11.5',24,'DS','Stock','Positive Adjustment'),
      Employee('AVTH001KASP','AVIA Thinner A Special','1.10.15.1',24,'DS','Stock','Positive Adjustment'),
      Employee('NOEM002KBA','NO ODOR Emulsion BA','1.10.3.1',8,'DS','Stock','Positive Adjustment'),
      Employee('AQEM005KBC','AQUAMATT Emulsion BC','1.10.5.3',4,'DS','Stock','Positive Adjustment'),
      Employee('NODR001K019','NO DROP 019','1.10.8.2',24,'DS','Stock','Positive Adjustment'),
      Employee('AREM005K686','ARIES Emulsion 686','1.11.13.3',4,'DS','Stock','Positive Adjustment'),
      Employee('AGEM020KPSB','ARIES GOLD Emulsion SB','1.11.16.4',1,'PL','Stock','Positive Adjustment'),
      Employee('AVSY004K657','AVIAN Synthetic 657','1.11.20.5',4,'DS','Stock','Positive Adjustment'),
      Employee('AVSY004K190','AVIAN Synthetic 190','1.11.22.1',4,'DS','Stock','Positive Adjustment'),
      Employee('AVSY004K192','AVIAN Synthetic 192','1.11.22.2',4,'DS','Stock','Positive Adjustment'),
      Employee('AVSY004K194','AVIAN Synthetic 194','1.11.22.6',4,'DS','Stock','Positive Adjustment'),
      Employee('AREM020KPSW','ARIES Emulsion SW','1.11.3.1',1,'PL','Stock','Positive Adjustment'),
      Employee('YORO020KP74','YOKO Roof 74','1.11.3.7',1,'PL','Stock','Positive Adjustment'),
      Employee('SGAL020KPBB','SUNGUARD Em All in One BB','1.11.39.1',1,'PL','Stock','Positive Adjustment'),
      Employee('AQEM005KBA','AQUAMATT Emulsion BA','1.11.49.1',4,'DS','Stock','Positive Adjustment'),
      Employee('POFIDCAWFS01','Pow Fit Faucet Sock AW 1X3/4','1.11.8.5',130,'DS','Stock','Positive Adjustment'),
      Employee('AGEM020KPSW','ARIES GOLD Emulsion SW','1.12.1.1',1,'PL','Stock','Positive Adjustment'),
      Employee('AGEM020KP305','ARIES GOLD Emulsion 305','1.12.19.3',1,'PL','Stock','Positive Adjustment'),
      Employee('AGEM020KPSW','ARIES GOLD Emulsion SW','1.12.2.1',1,'PL','Stock','Positive Adjustment'),
      Employee('BOVE001KSPOL','BOYO Politur Vernis S','1.12.22.1',24,'DS','Stock','Positive Adjustment'),
      Employee('HCPRBF90P','Budget Paint Roller 9 Inci','1.12.23.1',24,'DS','Stock','Positive Adjustment'),
      Employee('AVSY001KSWM','AVIAN Synthetic SWM','1.12.26.5',24,'DS','Stock','Positive Adjustment'),
      Employee('AVSY001KSWM','AVIAN Synthetic SWM','1.12.26.6',24,'DS','Stock','Positive Adjustment'),
      Employee('AGEM020KPSW','ARIES GOLD Emulsion SW','1.12.3.1',1,'PL','Stock','Positive Adjustment'),
      Employee('AGEM020KPSW','ARIES GOLD Emulsion SW','1.12.4.1',1,'PL','Stock','Positive Adjustment'),
      Employee('AVHA001K007','AVIAN Hammertone 007','1.12.41.1',24,'DS','Stock','Positive Adjustment'),
      Employee('AGEM020KPSW','ARIES GOLD Emulsion SW','1.12.5.1',1,'PL','Stock','Positive Adjustment'),
      Employee('JAEM020KPMW','Jasmine Emulsion MW','1.13.2.3',1,'PL','Stock','Positive Adjustment'),
      Employee('YOSY001K798','YOKO Synthetic 798','1.14.26.4',24,'DS','Stock','Positive Adjustment'),
      Employee('NODR020KPBA','NO DROP Base A','1.15.19.1',1,'PL','Stock','Positive Adjustment'),
      Employee('POFIHHD0E001','Pow Fit Elbow D2 1/2','1.15.2.2',45,'DS','Stock','Positive Adjustment'),
      Employee('SPEM002KSW','SUPERSILK Emulsion SW','1.17.44.4',8,'DS','Stock','Positive Adjustment'),
      Employee('SGAL002KSW','SUNGUARD Emulsion All in One SW','1.17.5.2',8,'DS','Stock','Positive Adjustment'),
      Employee('POFIDCAWT001','Pow Fit Tee AW1x3/4','1.2.22.7',65,'DS','Stock','Positive Adjustment'),
      Employee('POFIDDAWFS01','Pow Fit Faucet Sock AW1','1.2.28.3',120,'DS','Stock','Positive Adjustment'),
      Employee("NEXAMT00C00901", "Nexa CFT 91 Columbia Nussebaum", "3.3.25.2", 4, "UNT", 'Stock','Positive Adjustment'),
      Employee("NEXAMT00S00701", "Nexa CFT 90 Sonoma Oak", "3.3.25.2", 4, "UNT", 'Stock','Positive Adjustment'),
      Employee("NEXART00N00401", "Nexa RTV 80 Natural Oak - Tsugawood Ash", "3.3.5.5", 4, "UNT", 'Stock','Positive Adjustment'),
      Employee("NEXART00S00701", "Nexa RTV 123 Sonoma Oak", "3.3.23.4", 4, "UNT", 'Stock','Positive Adjustment'),
      Employee("NEXART00W00102", "Nexa 1200 Wenge", "3.3.25.2", 4, "UNT", 'Stock','Positive Adjustment'),
      Employee("NEXART00W00104", "Nexa 1522 Wenge", "3.1.23.3", 4, "UNT", 'Stock','Positive Adjustment'),
      Employee("NEXART00W00401", "Nexa 600 R Wenge", "3.3.23.3", 4, "UNT", 'Stock','Positive Adjustment'),
      Employee("NEXART00W01501", "Nexa RTV 124 White Glossy - Silver", "3.3.5.2", 4, "UNT", 'Stock','Positive Adjustment'),
      Employee("NEXART00W01601", "Nexa RTV 160 White Glossy", "3.2.21.1", 4, "UNT", 'Stock','Positive Adjustment'),
    ];
  }
  
  final CustomColumnSizer _customColumnSizer = CustomColumnSizer();
  @override
  Widget build(BuildContext context) {
    Configuration config = Configuration.of(context);
    
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Expanded(
                child: Button(
                  disable: false,
                  child: TextView('Validasi', 3, color: Colors.white, caps: true),
                  onTap: () {
                  },
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Button(
                  disable: false,
                  child: TextView('Export', 3, color: Colors.white, caps: true),
                  onTap: () {
                  },
                ),
              ),
            ],
          ),
        ),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                title: Text('Report Stock Opname'),
                automaticallyImplyLeading: false,
                backgroundColor: config.darkOpacityBlueColor,
                pinned: true,
                floating: true,
                bottom: TabBar(
                  isScrollable: true,
                  tabs: [
                    Tab(child: Text('All Item')),
                    Tab(child: Text('Detail Bin Code')),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: <Widget>[
              WillPopScope(
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
                            // onSelectionChanging:
                            //     (List<DataGridRow> addedRows, List<DataGridRow> removedRows) {
                            //   final index = employeeDataSource._employeeData.indexOf(addedRows.last);
                            //   Employee employee = employees[index];
                            //   printHelp("data "+employee.itemDesc);
                            //   setState(() {
                            //     _dataGridController.selectedIndex = index;
                            //   });
          
                            //   return true;
                            // },
                            columns: <GridColumn>[
                              GridColumn(
                                autoFitPadding: EdgeInsets.all(16),
                                columnName: 'entryType',
                                label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.45))
                                    )
                                  ),
                                  child: TextView('Entry Type', 6, align: TextAlign.center)
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
                                columnName: 'itemDesc',
                                // columnWidthMode: ColumnWidthMode.fitByCellValue,
                                label: Container(
                                  alignment: Alignment.center,
                                  child: TextView('Item\nNo', 6, align: TextAlign.center),
                                )
                              ),
                              GridColumn(
                                autoFitPadding: EdgeInsets.all(16),
                                columnName: 'quantity',
                                label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.45))
                                    )
                                  ),
                                  child: TextView('Quantity',  6, align: TextAlign.center)
                                )
                              ),
                              GridColumn(
                                autoFitPadding: EdgeInsets.all(16),
                                columnName: 'uom',
                                label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.45))
                                    )
                                  ),
                                  child: TextView('Uom',  6, align: TextAlign.center)
                                )
                              ),
                              GridColumn(
                                autoFitPadding: EdgeInsets.all(16),
                                columnName: 'zoneCode',
                                label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.45))
                                    )
                                  ),
                                  child: TextView('Zone Code',  6, align: TextAlign.center)
                                )
                              ),
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ),

              WillPopScope(
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
                            // onSelectionChanging:
                            //     (List<DataGridRow> addedRows, List<DataGridRow> removedRows) {
                            //   final index = employeeDataSource._employeeData.indexOf(addedRows.last);
                            //   Employee employee = employees[index];
                            //   printHelp("data "+employee.itemDesc);
                            //   setState(() {
                            //     _dataGridController.selectedIndex = index;
                            //   });
          
                            //   return true;
                            // },
                            columns: <GridColumn>[
                              GridColumn(
                                autoFitPadding: EdgeInsets.all(16),
                                columnName: 'entryType',
                                label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.45))
                                    )
                                  ),
                                  child: TextView('Entry Typesss', 6, align: TextAlign.center)
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
                                columnName: 'itemDesc',
                                // columnWidthMode: ColumnWidthMode.fitByCellValue,
                                label: Container(
                                  alignment: Alignment.center,
                                  child: TextView('Item\nNo', 6, align: TextAlign.center),
                                )
                              ),
                              GridColumn(
                                autoFitPadding: EdgeInsets.all(16),
                                columnName: 'quantity',
                                label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.45))
                                    )
                                  ),
                                  child: TextView('Quantity',  6, align: TextAlign.center)
                                )
                              ),
                              GridColumn(
                                autoFitPadding: EdgeInsets.all(16),
                                columnName: 'uom',
                                label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.45))
                                    )
                                  ),
                                  child: TextView('Uom',  6, align: TextAlign.center)
                                )
                              ),
                              GridColumn(
                                autoFitPadding: EdgeInsets.all(16),
                                columnName: 'zoneCode',
                                label: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.45))
                                    )
                                  ),
                                  child: TextView('Zone Code',  6, align: TextAlign.center)
                                )
                              ),
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Employee {
  Employee(this.itemNo, this.itemDesc, this.binCode, this.quantity, this.uom, this.zoneCode, this.entryType);

  final String itemNo;
  final String binCode;
  final String itemDesc;
  final int quantity;
  final String uom;
  final String zoneCode;
  final String entryType;
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource(BuildContext context, {List<Employee> employeeData, DataGridController controller}) {
    _context = context;
    _dataGridController = controller;
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(
          cells: [
              DataGridCell<String>(columnName: 'entryType', value: e.entryType),
              DataGridCell<String>(columnName: 'itemNo', value: e.itemNo),
              DataGridCell<String>(columnName: 'itemDesc', value: e.itemDesc),
              DataGridCell<String>(columnName: 'quantity', value: e.quantity.toString()),
              DataGridCell<String>(columnName: 'uom', value: e.uom),
              DataGridCell<String>(columnName: 'zoneCode', value: e.zoneCode),
              DataGridCell<String>(columnName: 'binCode', value: e.binCode),
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