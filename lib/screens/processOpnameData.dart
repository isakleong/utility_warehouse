import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:utility_warehouse/models/result.dart';
import 'package:utility_warehouse/models/userModel.dart';
import 'package:utility_warehouse/resources/stockOpnameAPI.dart';
import 'package:utility_warehouse/settings/configuration.dart';
import 'package:utility_warehouse/tools/function.dart';
import 'package:utility_warehouse/widget/button.dart';
import 'package:utility_warehouse/widget/textView.dart';

class ProcessOpnameData extends StatefulWidget {
  final User model;

  const ProcessOpnameData({Key key, this.model}) : super(key: key);

  @override
  ProcessOpnameDataState createState() => ProcessOpnameDataState();
}


class ProcessOpnameDataState extends State<ProcessOpnameData> {
  User userModel;

  String selectedDaySequence = "1";
  String selectedCountPIC = "1";
  String selectedDataType = "Stock Opname";
  
  // String selectedPIC = "Andi";
  List<String> selectedPIC = ["Andi", "Andi"];
  List<List<String>> selectedListPIC = [];

  int totalItem = 200;

  List<Color> selectedDay = [];

  // var helperList = <HelperItem>[
  //   HelperItem(1, 'Andi', false),
  //   HelperItem(2, 'Tommy', false),
  //   HelperItem(3, 'Jerry', false),
  //   HelperItem(4, 'Alex', false),
  //   HelperItem(5, 'Berto', false),
  // ];

  // var helperList = <String>['Andi', 'Tommy', 'Jerry', 'Alex', 'Berto', 'Recca', 'Isak', 'Rudy'];
  var helperList = <String>[];
  List<String> selectedHelperList = [];
  bool isSubmitHelper = false;

  // List<HelperItem> helperSelectedList = [];

  // static final List<GlobalKey> _key = List.generate(20, (index) => GlobalKey());
  final List<GlobalObjectKey<FormState>> _key = List.generate(20, (index) => GlobalObjectKey<FormState>(index));

  StateSetter _setState;

  @override
  void initState() {
    super.initState();
    selectedListPIC = new List.generate(2, (i) => ["Andi", "Tommy", "Jerry"]);
    userModel = widget.model;
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    // for(int i = 0; i < 20; i ++) {
    //   selectedDay.add
    // }
    initColorWidget();
  }

  getHelperList() async {
    FocusScope.of(context).requestFocus(FocusNode());
    Alert(context: context, loading: true, disableBackButton: true);

    Result result = await stockOpnameAPI.getHelperList(context, userModel.userId.substring(0, 3));

    Navigator.of(context).pop();

    if(result.code == 200) {
      setState(() {
        helperList = result.data.split(',');
        for(int i = 0; i < helperList.length; i++) {
          helperList[i] = helperList[i].replaceAll("\"", '');
          helperList[i] = helperList[i].replaceAll("\[",'');
          helperList[i] = helperList[i].replaceAll("\]",'');
        }
      });
    } else {
      Alert(
        context: context,
        title: "Maaf",
        content: Text(result.error_message),
        cancel: false,
        type: "error"
      );  
    }
  }

  void initColorWidget() {
    // selectedDay.add(config.lightGrayColor);
    selectedDay.add(Colors.white);
    for(int i = 0; i < 19; i++){
      // if(i>1) {
      //   selectedDay.add(Color(0xFF0066ff));
      // } else {
      //   selectedDay.add(config.lightGrayColor);
      // }
      selectedDay.add(Color(0xFF0066ff));
    }
  }

  showHelperList() {
    setState(() {
      selectedHelperList.clear();
    });
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            // title: TextView("Pilih Helper", 3),
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
                      child: Scrollbar(
                        isAlwaysShown: true,
                        child: SingleChildScrollView(
                          // reverse: true,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: TextView("Pilih Helper", 2),
                              ),
                              HelperListWidget(
                                helperList,
                                helperSelectedList: selectedHelperList,
                                onSelectionChanged: (selectedList) {
                                  setState(() {
                                    selectedHelperList = selectedList;
                                  });
                                },
                              ),
                              // ChipWidget(
                              //   helperList,
                              //   helperSelectedList: selectedHelperList,
                              //   onSelectionChanged: (selectedList) {
                              //     setState(() {
                              //       selectedHelperList = selectedList;
                              //     });
                              //   },
                              // ),
                              SizedBox(height: 20),
                              Align(
                                alignment: Alignment.bottomRight,
                                child:   Button(
                                  child: TextView("Pilih", 4),
                                  onTap: (){
                                    setState(() {
                                      isSubmitHelper = true;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ],
                          ),
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
  }

  doProcessOpnameData() async {
    Alert(context: context, loading: true, disableBackButton: true);

    //http://192.168.10.213/NewUtilityWarehouseDev/StockOpnameGadget/process_data_opname.php?Cabang=02A&TanggalTarikData=2022-05-16&Jenis=ALL&ProductGroupCode&Username=02A-KG&HariKe=1&Helper=coba helper

    // $pullDate = $_GET["pull-date"];
    // $dayOf = $_GET["day-of"];
    // $branchId = $_GET["branch-id"];
    // $userId = $_GET["user-id"];
    // $helper = $_GET["helper"];

    //pengecekan
    //1. harus ada di tabel HK_ProcessOpnameLog
    //2. 

    var now = DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String pullDate = formatter.format(now);

    String helper = "";
    for(int i = 0; i < selectedHelperList.length; i++) {
      if(i!=selectedHelperList.length - 1) {
        helper+=selectedHelperList[i]+",";
      } else {
        helper+=selectedHelperList[i];
      }
    }

    Result processLogResult = await stockOpnameAPI.getProcessOpnameLog(context, parameter: "data-type=$selectedDataType&branch-id=${userModel.userId.substring(0, 3)}&pull-date=$pullDate&day-of=$selectedDaySequence");

    if(processLogResult.code == 200) {
      if(processLogResult.data > 0) {
        Navigator.of(context).pop();
        Alert(
          context: context,
          title: "Info,",
          content: Text("Apakah Anda yakin ingin memproses lagi?\n(Proses ke-${processLogResult.data+1})"),
          cancel: true,
          type: "warning",
          defaultAction: () async {
            Alert(context: context, loading: true, disableBackButton: true);

            Result processResult = await stockOpnameAPI.processOpnameData(context, parameter: "data-type=$selectedDataType&branch-id=${userModel.userId.substring(0, 3)}&pull-date=$pullDate&day-of=$selectedDaySequence&user-id=${userModel.userId}&helper=$helper");

            Navigator.of(context).pop();

            if(processResult.code == 200) {
              Alert(
                context: context,
                title: "Info,",
                content: Text(processResult.message),
                cancel: false,
                type: "success"
              );
            } else {
              Alert(
                context: context,
                title: "Maaf,",
                content: Text(processResult.error_message),
                cancel: false,
                type: "error"
              );
            }
          }
        );

      } else {
        Result processResult = await stockOpnameAPI.processOpnameData(context, parameter: "branch-id=${userModel.userId.substring(0, 3)}&pull-date=$pullDate&day-of=$selectedDaySequence&user-id=${userModel.userId}&helper=$helper");

        Navigator.of(context).pop();

        if(processResult.code == 200) {
          Alert(
            context: context,
            title: "Info,",
            content: Text(processResult.message),
            cancel: false,
            type: "success"
          );
        } else {
          Alert(
            context: context,
            title: "Maaf,",
            content: Text(processResult.error_message),
            cancel: false,
            type: "error"
          );      
        }
      }

    } else {
      Alert(
        context: context,
        title: "Maaf,",
        content: Text(processLogResult.error_message),
        cancel: false,
        type: "error"
      );  
    }
    
    // Result result = await stockOpnameAPI.processOpnameData(context, parameter: "branch-id=${userModel.userId.substring(0, 3)}&pull-date=$pullDate&day-of=$selectedDaySequence&user-id=${userModel.userId}&helper=$helper");

    // if(result.code == 200) {
    //   print("SUCCESS");
    // } else {
    //   Alert(
    //     context: context,
    //     title: "Maaf",
    //     content: Text(result.error_message),
    //     cancel: false,
    //     type: "error"
    //   );  
    // }
    
  }
  
  @override
  Widget build(BuildContext context) {
    Configuration config = Configuration.of(context);
    
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      bottomNavigationBar: Button(
        disable: selectedHelperList.length > 0 ? false : true,
        child: TextView('Process', 3, color: Colors.white, caps: true),
        onTap: () {
          printHelp("tipe data "+selectedDataType);
          printHelp("urut hari "+selectedDaySequence);
          printHelp("helper "+selectedHelperList.toString());

          doProcessOpnameData();

        },
      ),
      body: Stack(
        children: [
          Container(
            height: mediaHeight,
            width: mediaWidth,
            color: Color(0xFF1A2980),
          ),
          SafeArea(
            child: Container(
              height: mediaHeight*0.5,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Material(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)
                            )
                          ),
                          child: InkWell(
                            onTap: (){
                              Navigator.of(context).pop();
                            },
                            highlightColor: Colors.blue.withOpacity(0.4),
                            splashColor: Colors.green.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(50),
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(Icons.arrow_back, color: Colors.black, size: 30),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            child: TextView("Tipe Data", 2, color: Colors.white),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white, borderRadius: BorderRadius.circular(10)
                              ),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: selectedDataType,
                                onChanged: (String newValue) =>
                                  setState(() => selectedDataType = newValue),
                                items: <String>['Stock Opname','Stock Opname Difference']
                                    .map<DropdownMenuItem<String>>(
                                        (String value) => DropdownMenuItem<String>(
                                              value: value,
                                              child: TextView(value, 4, color: Colors.black),
                                            ))
                                    .toList(),
                                icon: Icon(Icons.keyboard_arrow_down),
                                iconSize: 30,
                                underline: SizedBox(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: Container(
                          child: TextView("Urutan Hari Ke", 2, color: Colors.white),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(20, (index){
                            return Container(
                              key: _key[index],
                              height: 200,
                              width: 100,
                              margin: EdgeInsets.only(top: 15, left: 10, right: 10),
                              decoration: new BoxDecoration(
                                color: selectedDay[index],
                                border: Border.all(color: Colors.black, width: 0.0),
                                borderRadius: new BorderRadius.all(Radius.elliptical(100, 100)),
                              ),
                              child: InkWell(
                                onTap: (){
                                  index > 2 ?
                                  setState(() {
                                    for(int i = 3; i < 20; i++){
                                      if(i!=index) {
                                        selectedDay[i] = Color(0xFF0066ff);
                                      }
                                    }
                                    selectedDay[index] = Colors.white;
                                    Scrollable.ensureVisible(_key[index].currentContext);
                                  })
                                  :
                                  null;
                                },
                                child: Column(
                                  children: [
                                    (index+1) >= 10 ? SizedBox(height: 7) : Container(),
                                    Container(
                                      padding: (index+1) >= 10 ? EdgeInsets.all(18) : EdgeInsets.all(20),
                                      decoration: new BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.black, width: 0.0),
                                      ),
                                      child: Text((index+1).toString(), style: TextStyle(fontSize: (index+1) >= 10 ? 14 : 20)),
                                    ),
                                    // Container(
                                    //   child: TextView("Sudah".toString(), 1, color: Colors.white)
                                    // )
                                  ],
                                ),
                                // Column(
                                //   children: [
                                //     (index+1) >= 10 ? SizedBox(height: 7) : Container(),
                                //     Container(
                                //       padding: (index+1) >= 10 ? EdgeInsets.all(18) : EdgeInsets.all(20),
                                //       decoration: new BoxDecoration(
                                //         color: Colors.white,
                                //         shape: BoxShape.circle,
                                //         border: Border.all(color: Colors.black, width: 0.0),
                                //       ),
                                //       child: Text((index+1).toString(), style: TextStyle(fontSize: (index+1) >= 10 ? 14 : 20)),
                                //     ),
                                //     Expanded(child: Container()),
                                //     Container(
                                //       margin: EdgeInsets.only(bottom: 10),
                                //       child: Icon(Icons.check_circle_rounded, size: 40, color: Colors.white),
                                //     )
                                //   ],
                                // )
                              )
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: mediaWidth,
              height: mediaHeight*0.5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(80),
                  topRight: Radius.circular(80),
                )
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 40),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            child: TextView("Kepala Gudang", 4),
                          ),
                          SizedBox(width: 30),
                          Container(
                            child: TextView(":", 4),
                          ),
                          SizedBox(width: 30),
                          Expanded(
                            child: Container(
                              child: TextView("Rahman Yuliansyah", 4),
                            ),
                          ),
                        ],
                      ),

                      // comment because overflow (1)
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   mainAxisSize: MainAxisSize.min,
                      //   children: [
                      //     Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Container(
                      //           child: TextView("", 4),
                      //         ),
                      //         Padding(
                      //           padding: EdgeInsets.symmetric(vertical: 10),
                      //           child: Container(
                      //             child: TextView("Kepala Gudang", 4),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //     SizedBox(width: 30),
                      //     Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Container(
                      //           child: TextView("", 4),
                      //         ),
                      //         Padding(
                      //           padding: EdgeInsets.symmetric(vertical: 10),
                      //           child: Container(
                      //             child: TextView(":", 4),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //     SizedBox(width: 30),
                      //     Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Container(
                      //           child: TextView("", 4),
                      //         ),
                      //         Padding(
                      //           padding: EdgeInsets.symmetric(vertical: 10),
                      //           child: Container(
                      //             child: TextView("Rahman Yuliansyah", 4),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ],
                      // ),
                      
                      // comment because overflow (2)
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   mainAxisSize: MainAxisSize.min,
                      //   children: [
                      //     Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Padding(
                      //           padding: EdgeInsets.symmetric(vertical: 10),
                      //           child: Container(
                      //             child: TextView("Tipe Data", 4),
                      //           ),
                      //         ),
                      //         Container(
                      //           child: TextView("Kepala Gudang", 4, color: Colors.transparent),
                      //         ),
                      //       ],
                      //     ),
                      //     SizedBox(width: 30),
                      //     Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Padding(
                      //           padding: EdgeInsets.symmetric(vertical: 10),
                      //           child: Container(
                      //             child: TextView(":", 4),
                      //           ),
                      //         ),
                      //         Container(
                      //           child: TextView(":", 4, color: Colors.transparent),
                      //         ),
                      //       ],
                      //     ),
                      //     SizedBox(width: 30),
                      //     Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Padding(
                      //           padding: EdgeInsets.symmetric(vertical: 10),
                      //           child: Container(
                      //             height: 40,
                      //             child: DropdownButtonHideUnderline(
                      //               child: ButtonTheme(
                      //                 alignedDropdown: true,
                      //                 child: DropdownButton<String>(
                      //                   dropdownColor: Colors.white,
                      //                   value: selectedDataType,
                      //                   icon: Icon(Icons.keyboard_arrow_down, color: config.grayColor),
                      //                   onChanged: (newValue) {
                      //                     setState(() {
                      //                       selectedDataType = newValue;
                      //                     });
                      //                   },
                      //                   items: <String>['Stock Opname','Stock Opname Difference']
                      //                   .map<DropdownMenuItem<String>>((String value) {
                      //                     return DropdownMenuItem<String>(
                      //                       value: value,
                      //                       child: TextView(value, 4),
                      //                     );
                      //                   }).toList(),
                      //                 ),
                      //               ),
                      //             ),
                      //             decoration: BoxDecoration(
                      //               border: Border.all(color: config.darkOpacityBlueColor, width: 1.5),
                      //               borderRadius: BorderRadius.all(Radius.circular(8)),
                      //             ),
                      //           ),
                      //         ),
                      //         Container(
                      //           child: TextView("Rahman Yuliansyah", 4, color: Colors.transparent),
                      //         ),
                      //       ],
                      //     ),
                      //   ],
                      // ),

                      SizedBox(height: 30),
                      Center(
                        child: Button(
                          disable: false,
                          child: TextView('Pilih Helper', 3, color: Colors.white, caps: false),
                          onTap: () async {
                            await getHelperList();
                            showHelperList();
                            setState(() {
                              isSubmitHelper = false;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Divider(thickness: 3),
                      ),
                      //pic section
                      isSubmitHelper ?
                      selectedHelperList.length > 0 ?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(selectedHelperList.length,(index){
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.ideographic,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  child: TextView("Helper "+(index+1).toString(), 4),
                                ),
                                SizedBox(width: 30),
                                Container(
                                  child: TextView(":", 4),
                                ),
                                SizedBox(width: 30),
                                Expanded(
                                  // flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        child: TextView(selectedHelperList[index], 4),
                                      ),
                                    ],
                                  ),
                                ),
                                // Expanded(
                                //   child: Column(
                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                //     mainAxisSize: MainAxisSize.min,
                                //     children: [
                                //       RawMaterialButton(
                                //         onPressed: () {
                                //           setState(() {
                                //             helperList.removeAt(index);
                                //           });
                                //         },
                                //         elevation: 2.0,
                                //         fillColor: config.darkOpacityBlueColor,
                                //         child: Icon(Icons.close, color: Colors.white),
                                //         padding: EdgeInsets.all(3),
                                //         shape: CircleBorder(),
                                //       )
                                //     ],
                                //   ),
                                // ),
                                // Expanded(child: Container())
                              ],
                            ),
                          );
                        }),
                      )

                      // comment because overflow (3)
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: List.generate(selectedHelperList.length,(index){
                      //     return Padding(
                      //       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      //       child: Row(
                      //         crossAxisAlignment: CrossAxisAlignment.baseline,
                      //         textBaseline: TextBaseline.ideographic,
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         mainAxisSize: MainAxisSize.min,
                      //         children: [
                      //           // TextView("Helper "+(index+1).toString(), 4),
                      //           // SizedBox(width: 30),
                      //           // TextView(":", 4),
                      //           // SizedBox(width: 30),
                      //           // Expanded(
                      //           //   flex: 2,
                      //           //   child: TextView(selectedHelperList[index]+"Imanuel Putra Radja Arigagaadasdasdadsdadsdadsfsfsfsfsfsfsfsfsdaweqweasdadh", 4)
                      //           // ),
                      //           // Container(
                      //           //   decoration: BoxDecoration(
                      //           //     border: Border.all(color: Colors.red[500]),
                      //           //     borderRadius: BorderRadius.all(Radius.circular(20))
                      //           //   ),
                      //           //   child: Icon(Icons.close, color: Colors.redAccent),
                      //           // ),
                      //           // Expanded(child: Container())
                                
                      //           Column(
                      //             crossAxisAlignment: CrossAxisAlignment.start,
                      //             mainAxisSize: MainAxisSize.min,
                      //             children: [
                      //               Container(
                      //                 child: TextView("Helper "+(index+1).toString(), 4),
                      //               ),
                      //               Container(
                      //                 child: TextView("Kepala Gudang", 4, color: Colors.transparent),
                      //               ),
                      //             ],
                      //           ),
                      //           SizedBox(width: 30),
                      //           Column(
                      //             crossAxisAlignment: CrossAxisAlignment.start,
                      //             mainAxisSize: MainAxisSize.min,
                      //             children: [
                      //               Container(
                      //                 child: TextView(":", 4),
                      //               ),
                      //             ],
                      //           ),
                      //           SizedBox(width: 30),
                      //           Expanded(
                      //             flex: 2,
                      //             child: Column(
                      //               crossAxisAlignment: CrossAxisAlignment.start,
                      //               mainAxisSize: MainAxisSize.min,
                      //               children: [
                      //                 Container(
                      //                   child: TextView(selectedHelperList[index], 4),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //           Column(
                      //             crossAxisAlignment: CrossAxisAlignment.start,
                      //             mainAxisSize: MainAxisSize.min,
                      //             children: [
                      //               RawMaterialButton(
                      //                 onPressed: () {},
                      //                 elevation: 2.0,
                      //                 fillColor: config.darkOpacityBlueColor,
                      //                 child: Icon(Icons.close, color: Colors.white),
                      //                 padding: EdgeInsets.all(3),
                      //                 shape: CircleBorder(),
                      //               )
                      //               // ClipOval(
                      //               //   child: Material(
                      //               //     color: config.darkOpacityBlueColor,
                      //               //     child: InkWell(
                      //               //       splashColor: Colors.white,
                      //               //       onTap: () {},
                      //               //       child: Icon(Icons.close),
                      //               //     ),
                      //               //   ),
                      //               // )  
                                      
                      //               // InkWell(
                      //               //   child: Container(
                      //               //     decoration: BoxDecoration(
                      //               //       border: Border.all(color: Colors.red[500]),
                      //               //       borderRadius: BorderRadius.all(Radius.circular(20))
                      //               //     ),
                      //               //     child: Icon(Icons.close, color: Colors.redAccent),
                      //               //   ),
                      //               // ),
                      //             ],
                      //           ),
                      //           Expanded(child: Container())
                      //         ],
                      //       ),
                      //     );
                      //   }),
                      // )
                      :
                      Center(
                        child: Column(
                          children: [
                            Container(
                              child: TextView("Belum ada Helper yang dipilih", 4)
                            ),
                          ],
                        ),
                      )
                      :
                      selectedHelperList.length > 0 ?
                      Container()
                      :
                      Center(
                        child: Column(
                          children: [
                            Container(
                              child: TextView("Belum ada Helper yang dipilih", 4)
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class Helper {
  String helperName;
  bool isCheck;

  Helper({this.helperName, this.isCheck});
}

class HelperListWidget extends StatefulWidget {
  final List<String> helperList;
  final List<String> helperSelectedList;
  final Function(List<String>) onSelectionChanged;

  HelperListWidget(this.helperList, {this.helperSelectedList, this.onSelectionChanged});

  @override
  HelperListWidgetState createState() => HelperListWidgetState();
}

class HelperListWidgetState extends State<HelperListWidget> {
  List<String> selectedChoices = [];

  _buildChoiceList() {
    List<Widget> choices = [];
    widget.helperList.forEach((item) {
      choices.add(
        Container(
          padding: EdgeInsets.all(7),
          child: CheckboxListTile(
            activeColor: Colors.pink[300],
            dense: true,
            //font change
            title: new TextView(item, 4),
            value: selectedChoices.contains(item),
            // secondary: Container(
            //   height: 50,
            //   width: 50,
            //   child: Image.asset(
            //     checkBoxListTileModel[index].img,
            //     fit: BoxFit.cover,
            //   ),
            // ),
            onChanged: (bool val) {
              setState(() {
                // checkBoxListTileModel[index].isCheck = val;
                selectedChoices.contains(item)
                    ? selectedChoices.remove(item)
                    : selectedChoices.add(item);
                widget.onSelectionChanged(selectedChoices);
              });
            })
          
          // ChoiceChip(
          //   label: TextView(item, 4),
          //   selected: selectedChoices.contains(item),
          //   onSelected: (selected) {
          //     setState(() {
          //       selectedChoices.contains(item)
          //           ? selectedChoices.remove(item)
          //           : selectedChoices.add(item);
          //       widget.onSelectionChanged(selectedChoices);

          //       // selectedChoices.contains(item)
          //       //     ? selectedChoices.remove(item)
          //       //     : selectedChoices.add(item);
          //       // widget.onSelectionChanged(selectedChoices);
          //     });
          //   },
          // ),

        )
      );
    });

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}

class HelperItem {
  final int id;
  final String name;
  bool isSelected;

  HelperItem(this.id, this.name, this.isSelected);
}

class ChipWidget extends StatefulWidget {
  final List<String> helperList;
  final List<String> helperSelectedList;
  final Function(List<String>) onSelectionChanged;

  ChipWidget(this.helperList, {this.helperSelectedList, this.onSelectionChanged});

  @override
  ChipWidgetState createState() => ChipWidgetState();
}

class ChipWidgetState extends State<ChipWidget> {
  List<String> selectedChoices = [];

  _buildChoiceList() {
    List<Widget> choices = [];
    widget.helperList.forEach((item) {
      choices.add(Container(
        padding: EdgeInsets.all(7),
        child: ChoiceChip(
          label: TextView(item, 4),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices);

              // selectedChoices.contains(item)
              //     ? selectedChoices.remove(item)
              //     : selectedChoices.add(item);
              // widget.onSelectionChanged(selectedChoices);
            });
          },
        ),
      ));
    });

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}