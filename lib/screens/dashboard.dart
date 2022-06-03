
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:utility_warehouse/models/result.dart';
import 'package:utility_warehouse/models/stockOpnameHeaderModel.dart';
import 'package:utility_warehouse/models/userModel.dart';
import 'package:utility_warehouse/resources/databaseHelper.dart';
import 'package:utility_warehouse/resources/stockOpnameAPI.dart';
import 'package:utility_warehouse/screens/processOpnameData.dart';
import 'package:utility_warehouse/settings/configuration.dart';
import 'package:utility_warehouse/tools/function.dart';
import 'package:utility_warehouse/widget/button.dart';
import 'package:utility_warehouse/widget/textView.dart';
import 'package:sqflite/sqflite.dart' as sql;

class Dashboard extends StatefulWidget {
  final User userModel;

  const Dashboard({Key key, this.userModel}) : super(key: key);

  @override
  DashboardState createState() => DashboardState();
}


class DashboardState extends State<Dashboard> {
  User userModel;
  
  DateTime currentBackPressTime;

  String dropdownValue = 'One';
  String selectedDataType = "Stock Opname";
  String selectedUrutanHariDropdownValue = "1";
  List<DropdownMenuItem<String>> userTypeList = [];
  final _dropdownFormKey1 = GlobalKey<FormState>();
  final _dropdownFormKey2 = GlobalKey<FormState>();

  StateSetter _setState;
  String downloadLoadingMessage = "";

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    setState(() {
      userModel = widget.userModel;
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    setState(() {
      userTypeList = [
        DropdownMenuItem(child: TextView('Stock Opname', 5, color: Colors.white), value: "WM"),
        DropdownMenuItem(child: TextView('Stock Opname Difference', 5, color: Colors.white), value: "KG"),
      ];
    });
    
    await SQLHelper.createDatabase(tableName: "hk_stockopnameheader");
    await SQLHelper.createDatabase(tableName: "hk_stockopnamedetail");
    await SQLHelper.createDatabase(tableName: "sfa_productconversion");
    await SQLHelper.createDatabase(tableName: "hk_stockopnameheaderselisih");
    await SQLHelper.createDatabase(tableName: "hk_stockopnamedetailselisih");
  }

  downloadHeaderData() async {
    final now = DateTime.now();
    final formatter = new DateFormat('yyyy-MM-dd');
    String pullDate = formatter.format(now);
    pullDate = "2022-05-23";

    setState(() {
      downloadLoadingMessage = "Downloading header data";
    });

    Result downloadHeaderResult = await stockOpnameAPI.downloadOpnameDataHeader(context, parameter: "data-type=$selectedDataType&branch-id=${userModel.userId.substring(0, 3)}&pull-date=$pullDate");
    printHelp("CODE "+downloadHeaderResult.code.toString());
    if(downloadHeaderResult.code == 200) {
      _setState(() {
        downloadLoadingMessage = "Extracting header data";
      });

      StockOpnameHeader stockOpnameHeader = downloadHeaderResult.data;
      print("fetch "+stockOpnameHeader.customerName);

      //extract header data
      final database = await SQLHelper.createDatabase();

      //raw query
      // await database.transaction((txn) async {
      //   int id1 = await txn.rawInsert(
      //       'INSERT INTO hk_stockopnameheader(Id, TanggalTarikData, Cabang, SuratJalanTerakhir, KodeCustomer, NamaCustomer, JumlahBinTerdaftar, BinTepat, KetepatanJumlahPadaBin, KetepatanJumlahBin, JumlahPadaBin, ZoneShipment, ZoneReceipt, ZoneAdjustment, TotalQty, SaldoItemDesimal, NamaKepalaCabang, NamaKepalaAdministrasi, SelisihItemBinContent, Jumlah Helper, DividenData, UpdateUserId, UpdateTime, Complete, Upload, DownloadCount) VALUES($stockOpnameHeader.Id, "${stockOpnameHeader.pullDate}", "${stockOpnameHeader.branchId}", "${stockOpnameHeader.lastSJ}", "${stockOpnameHeader.customerId}", "${stockOpnameHeader.customerName}", ${stockOpnameHeader.registeredBinCount}, ${stockOpnameHeader.exactBin}, ${stockOpnameHeader.quantityAccuracyOnBin}, ${stockOpnameHeader.}           )');
      //   print('inserted1: $id1');
      //   int id2 = await txn.rawInsert(
      //       'INSERT INTO Test(name, value, num) VALUES(?, ?, ?)',
      //       ['another name', 12345678, 3.1416]);
      //   print('inserted2: $id2');
      // });

      var mapData = <String, dynamic>{};
      mapData.addEntries([
        MapEntry('Id', stockOpnameHeader.id),
        MapEntry('TanggalTarikData', stockOpnameHeader.pullDate),
        MapEntry('Cabang', stockOpnameHeader.branchId),
        MapEntry('SuratJalanTerakhir', stockOpnameHeader.lastSJ),
        MapEntry('KodeCustomer', stockOpnameHeader.customerId),
        MapEntry('KodeCustomer', stockOpnameHeader.customerId),
      ]);
      
      print(mapData);
      // final dbData = {'title': title, 'description': descrption};
      // final id = await db.insert('items', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);

    }
  }

  doDownloadData() async {
    // Alert(context: context, loading: true, disableBackButton: true);
    // var now = DateTime.now();
    // var formatter = new DateFormat('yyyy-MM-dd');
    // String pullDate = formatter.format(now);
    // Result downloadLogResult = await stockOpnameAPI.getDownloadOpnameLog(context, parameter: "data-type=$selectedDataType&branch-id=${userModel.userId.substring(0, 3)}&pull-date=$pullDate");
    // Navigator.of(context).pop();
    // print(downloadLogResult.data.toString());

    //demo preparation
    downloadHeaderData();
    showDialog (
      context: context,
      barrierDismissible: false,
      builder: (context){
        return WillPopScope(
          onWillPop: () async {
            return false; 
          },
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrollable: true,
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
              _setState = setState;
              return Column(
                children: [
                  Container(
                    child: Lottie.asset('assets/illustration/loading.json', width: 220, height: 220, fit: BoxFit.contain)
                  ),
                  SizedBox(height: 30),
                  Container(
                    child: TextView(downloadLoadingMessage, 4, color: Colors.white),
                  ),
                ],
              );
            }),
          )
        );
      }
    );

    // Alert(context: context, loading: true, loadingMessage: "Download header data", disableBackButton: true);
    

  }

  // Widget showData() {
  //   return Container();
  // }
  
  @override
  Widget build(BuildContext context) {
    Configuration config = Configuration.of(context);
    
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;

    // showData();
    
    return Scaffold(
      body: WillPopScope(
        onWillPop: willPopScope,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: false,
              snap: false,
              floating: false,
              // expandedHeight: 400,
              expandedHeight: mediaHeight/2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(80),
                bottomRight: Radius.circular(80)
                ),
              ),
              leading: Container(
                margin: EdgeInsets.all(8),
                child: Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)
                    )
                  ),
                  child: InkWell(
                    onTap: (){
                      Alert(
                        context: context,
                        title: "Konfirmasi,",
                        content: Text("Apakah Anda yakin ingin keluar dari aplikasi?"),
                        cancel: true,
                        type: "warning",
                        defaultAction: () async {
                          Navigator.pushReplacementNamed(
                            context,
                            "login",
                          );
                        }
                      );
                    },
                    highlightColor: Colors.blue.withOpacity(0.4),
                    splashColor: Colors.green.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(50),
                    child: Icon(Icons.arrow_back, color: Colors.black, size: 30),
                  ),
                ),
              ),
              
              
              // Button(
              //   disable: false,
              //   colorUsed: Color(0xFFFFFFFF),
              //   child: Icon(Icons.arrow_back, color: Colors.black),
              //   onTap: () {
              
              //   },
              // ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF1A2980),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(80), bottomRight: Radius.circular(80)),
                ),
                child: FlexibleSpaceBar(
                  // titlePadding: const EdgeInsetsDirectional.only(start: 16.0, bottom: 16.0),
                  // centerTitle: false,
                  // title: Text(
                  //   'Beach Side',
                  //   textScaleFactor: 1.0,
                  //   style: TextStyle(
                  //       color: Colors.white, fontWeight: FontWeight.bold),
                  // ),
                  background: ClipRRect(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(80), bottomRight: Radius.circular(80)),
                    child: Image.asset('assets/illustration/bg_process_opname_1.png', fit: BoxFit.cover)
                  )
                ),
              ),
            ),

            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: List.generate(userModel.moduleId.length,(index){
                  return Column(
                    children: [
                      Card(
                        margin: EdgeInsets.all(20),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          highlightColor: Colors.blue.withOpacity(0.4),
                          splashColor: Colors.green.withOpacity(0.5),
                          onTap: () {
                            if(userModel.moduleId[index].toLowerCase().replaceAll(RegExp(r"\s+"), "")=="adjustmentstockopname") {
                              Navigator.pushNamed(context, "adjustmentStockOpname");
                            } else if(userModel.moduleId[index].toLowerCase().replaceAll(RegExp(r"\s+"), "")=="monitoringstockopname") {
                              Navigator.pushNamed(context, "performanceStockOpname");
                            } else if(userModel.moduleId[index].toLowerCase().replaceAll(RegExp(r"\s+"), "")=="downloadopnamedata") {

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    // elevation: 0,
                                    // backgroundColor: Colors.transparent,
                                    child: Stack(
                                        clipBehavior: Clip.none, 
                                        alignment: Alignment.topCenter,
                                        children: [
                                          Container(
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
                                              child: SingleChildScrollView(
                                                // reverse: true,
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(vertical: 20),
                                                      child: TextView("Download Opname Data", 2),
                                                    ),
                                                    Form(
                                                      key: _dropdownFormKey1,
                                                      child: DropdownButtonFormField(
                                                        decoration: InputDecoration(
                                                          enabledBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(color: config.grayColor, width: 1.5),
                                                            borderRadius: BorderRadius.circular(5),
                                                          ),
                                                          labelText: "Tipe Data",
                                                          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily:'Roboto', fontSize: 16),
                                                        ),
                                                        hint: TextView('Tipe Data', 5),
                                                        dropdownColor: Colors.white,
                                                        value: selectedDataType,
                                                        onChanged: (String value) {
                                                          setState(() {
                                                            selectedDataType = value;
                                                          });
                                                        },
                                                        items: <String>['Stock Opname', 'Stock Opname Difference']
                                                            .map<DropdownMenuItem<String>>((String value) {
                                                          return DropdownMenuItem<String>(
                                                            value: value,
                                                            child: TextView(value, 4),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ),
                                                    SizedBox(height: 30),
                                                    Align(
                                                      alignment: Alignment.bottomRight,
                                                      child:   Button(
                                                        child: TextView('Download', 3, color: Colors.white, caps: true),
                                                        onTap: (){
                                                          Navigator.of(context).pop();
                                                          doDownloadData();
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: -70,
                                            child: CircleAvatar(
                                              backgroundColor: config.lightOpactityBlueColor,
                                              radius: 70,
                                              child: Lottie.asset('assets/illustration/helper.json', fit: BoxFit.contain),
                                            )
                                          ),
                                        ],
                                      )
                                    );
                                });
                            } else if(userModel.moduleId[index].toLowerCase().replaceAll(RegExp(r"\s+"), "")=="pick") {
                              Navigator.pushNamed(context, "pick", arguments: userModel);
                            } else if(userModel.moduleId[index].toLowerCase().replaceAll(RegExp(r"\s+"), "")=="processopnamedata") {
                              Navigator.pushNamed(context, "processOpnameData", arguments: userModel);
                            } else if(userModel.moduleId[index].toLowerCase().replaceAll(RegExp(r"\s+"), "")=="reportstockopname") {
                              Navigator.pushNamed(context, "reportStockOpname");
                            } else if(userModel.moduleId[index].toLowerCase().replaceAll(RegExp(r"\s+"), "")=="stockopname") {
                              Navigator.pushNamed(context, "stockOpname");
                            } else if(userModel.moduleId[index].toLowerCase().replaceAll(RegExp(r"\s+"), "")=="stockopnamedifference") {
                              Navigator.pushNamed(context, "stockOpnameDifference");
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Container(
                                  child: Icon(Icons.padding, size: 100, color: config.darkOpacityBlueColor)
                                ),
                                SizedBox(width: 30),
                                Expanded(
                                  child: TextView(userModel.moduleId[index], 1)
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                
                // <Widget>[
                //   Card(
                //     margin: EdgeInsets.all(20),
                //     elevation: 5,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(16),
                //     ),
                //     child: InkWell(
                //       borderRadius: BorderRadius.circular(16),
                //       onTap: () {
                //         Navigator.pushNamed(context, "processOpnameData");
                //       },
                //       child: Padding(
                //         padding: EdgeInsets.all(20),
                //         child: Row(
                //           children: [
                //             Container(
                //               child: Icon(Icons.padding, size: 100, color: config.darkOpacityBlueColor)
                //             ),
                //             SizedBox(width: 30),
                //             Expanded(
                //               child: TextView("Process Opname Data", 1)
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ),
                //   Card(
                //     margin: EdgeInsets.all(20),
                //     elevation: 5,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(16),
                //     ),
                //     child: InkWell(
                //       borderRadius: BorderRadius.circular(16),
                //       onTap: () {},
                //       child: Padding(
                //         padding: EdgeInsets.all(20),
                //         child: Row(
                //           children: [
                //             Container(
                //               child: Icon(Icons.padding, size: 100, color: config.darkOpacityBlueColor)
                //             ),
                //             SizedBox(width: 30),
                //             Expanded(
                //               child: TextView("Stock Opname Difference", 1)
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ),
                // ],
              ),
            ),

            // SliverList(
            //   delegate: SliverChildBuilderDelegate(
            //     (BuildContext context, int index) {
            //       return Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Card(
            //             margin: EdgeInsets.all(20),
            //             elevation: 5,
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(16),
            //             ),
            //             child: InkWell(
            //               borderRadius: BorderRadius.circular(16),
            //               onTap: () {
            //                 Navigator.pushNamed(context, "processOpnameData");
            //               },
            //               child: Padding(
            //                 padding: EdgeInsets.all(20),
            //                 child: Row(
            //                   children: [
            //                     Container(
            //                       child: Icon(Icons.padding, size: 100, color: config.darkOpacityBlueColor)
            //                     ),
            //                     SizedBox(width: 30),
            //                     Expanded(
            //                       child: TextView("Process Opname Data", 1)
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //           ),
            //           Card(
            //             margin: EdgeInsets.all(20),
            //             elevation: 5,
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(16),
            //             ),
            //             child: InkWell(
            //               borderRadius: BorderRadius.circular(16),
            //               onTap: () {},
            //               child: Padding(
            //                 padding: EdgeInsets.all(20),
            //                 child: Row(
            //                   children: [
            //                     Container(
            //                       child: Icon(Icons.padding, size: 100, color: config.darkOpacityBlueColor)
            //                     ),
            //                     SizedBox(width: 30),
            //                     Expanded(
            //                       child: TextView("Stock Opname Difference", 1)
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ],
            //       );
            //     },
            //     childCount: 1,
            //   ),
            // ),
          ],
        )
        
        // Stack(
        //   children: [
        //     Container(
        //       height: mediaHeight*0.5,
        //       width: mediaWidth,
        //       // color: Colors.white,
        //       child: Image.asset("assets/illustration/bg_process_opname.png", fit: BoxFit.fill),
        //     ),
        //     Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Card(
        //           margin: EdgeInsets.all(20),
        //           elevation: 10,
        //           shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(16),
        //           ),
        //           child: InkWell(
        //             borderRadius: BorderRadius.circular(16),
        //             onTap: () {
        //               Navigator.pushNamed(context, "processOpnameData");
        //             },
        //             child: Padding(
        //               padding: EdgeInsets.all(20),
        //               child: Row(
        //                 children: [
        //                   Container(
        //                     child: Icon(Icons.padding, size: 100, color: config.darkOpacityBlueColor)
        //                   ),
        //                   SizedBox(width: 30),
        //                   Expanded(
        //                     child: TextView("Process Opname Data", 1)
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ),
        //         ),
        //         SizedBox(height: 30),
        //         Card(
        //           margin: EdgeInsets.all(20),
        //           elevation: 10,
        //           shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(16),
        //           ),
        //           child: InkWell(
        //             borderRadius: BorderRadius.circular(16),
        //             onTap: () {},
        //             child: Padding(
        //               padding: EdgeInsets.all(20),
        //               child: Row(
        //                 children: [
        //                   Container(
        //                     child: Icon(Icons.padding, size: 100, color: config.darkOpacityBlueColor)
        //                   ),
        //                   SizedBox(width: 30),
        //                   Expanded(
        //                     child: TextView("Stock Opname Difference", 1)
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
      
            
        //     // Column(
        //     //   mainAxisAlignment: MainAxisAlignment.center,
        //     //   children: [
        //     //      InkWell(
        //     //          onTap: () {},
        //     //          child: Center(
        //     //            child: Row(
        //     //              mainAxisAlignment: MainAxisAlignment.center,
        //     //              children: [
        //     //                Center(
        //     //                  child: Card(
        //     //                    shape: RoundedRectangleBorder(
        //     //                        borderRadius: BorderRadius.circular(100.0)),
        //     //                    elevation: 5,
        //     //                    child: Padding(
        //     //                      padding: const EdgeInsets.all(10.0),
        //     //                      child: Icon(Icons.padding, size: 80, color: config.darkOpacityBlueColor),
        //     //                    ),
        //     //                  ),
        //     //                ),
        //     //                SizedBox(width: 20),
        //     //                Padding(
        //     //                  padding: const EdgeInsets.all(10.0),
        //     //                  child: Container(
        //     //                    alignment: Alignment.bottomCenter,
        //     //                    child: TextView('Proses Opname Data', 1)
        //     //                  ),
        //     //                ),
        //     //              ],
        //     //            ),
        //     //          ),
        //     //       ),
        //     //   ],
        //     // ),

        //   ],
        // )
      ),
    );
  }

  Future<bool> willPopScope() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || 
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Tekan sekali lagi untuk keluar dari aplikasi", textAlign: TextAlign.center),
      ));
      return Future.value(false);
    }
    return Future.value(true);
  }

}

class MenuListItem {
  final IconData icon;
  final String title;

  MenuListItem(this.icon, this.title);
}