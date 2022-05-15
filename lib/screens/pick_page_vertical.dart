import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:utility_warehouse/models/detailPickModel.dart';
import 'package:utility_warehouse/models/pickModel.dart';
import 'package:utility_warehouse/models/result.dart';
import 'package:utility_warehouse/models/userModel.dart';
import 'package:utility_warehouse/resources/pickAPI.dart';
import 'package:utility_warehouse/resources/userAPI.dart';
import 'package:utility_warehouse/settings/configuration.dart';
import 'package:utility_warehouse/tools/function.dart';
import 'package:utility_warehouse/widget/button.dart';
import 'package:utility_warehouse/widget/textView.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart';

class PickPageVertical extends StatefulWidget {
  final User model;

  const PickPageVertical({Key key, this.model}) : super(key: key);

  @override
  _PickPageVerticalState createState() => _PickPageVerticalState();
}

class _PickPageVerticalState extends State<PickPageVertical> {
  User userModel;

  List<Pick> pickNos = [];
  List<DetailPick> detailPicks = [];

  bool valuefirst = false;
  List<bool> isCheckboxSelected = [];
  List<bool> isCheckboxEnabled = [];
  List<bool> isQtyEnabled = [];

  //detail data
  List<TextEditingController> qtyRealController = [];
  List<FocusNode> qtyRealFocusNode = [];

  List<DetailPick> detailPicksChoosen = [];
  List<Pick> picksChoosen = [];
  List<Pick> pickChanged = [];

  //header data
  String custName = "";
  String contactName = "";
  String city = "";
  String county = "";
  String province = "";
  String postcode = "";
  String cityPostcode = "";

  String gudang = "";
  String source = "";
  String tanggal = "";
  String berat = "";
  String beratKg = "";
  String userId = "";
  String wsNo = "";
  String sales = "";
  String selectedDropdownValue = "Pilih nomor pick";
  String selectedNoPick = "";
  int pickDone = 0;
  int pickInserted = 0;

  String choosenPick = ""; //pick yang dipilih
  String tempChoosenPick = "";
  // Result res;
  String branchId = "";

  static const int sortName = 0;
  static const int sortStatus = 1;
  bool isAscending = true;
  int sortType = sortName;

  final DataTableSource _data = MyData();
  Future<String> getDatabasesPath() => databaseFactory.getDatabasesPath();

  Configuration configuration;
  void initState() {
    userModel = widget.model;
    branchId = encryptData(userModel.userId.substring(0, 3));

    detailPicks = [];
    detailPicksChoosen = [];
    super.initState();
    // const tenSec = Duration(seconds: 10);
    // Timer.periodic(tenSec, (Timer t) => getNomorPick());
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeRight,
    //   // DeviceOrientation.landscapeLeft,
    // ]);
  }

  @override
  void didChangeDependencies() async {
    configuration = Configuration.of(context);
    await getDeviceConfig();
    await getNomorPick();
  }

  getDeviceConfig() async {
    // Directory dir = await getExternalStorageDirectory();
    // String path = '${dir.path}/deviceconfig.xml';
    String path =
        '/storage/emulated/0/Android/data/com.example.utility_warehouse/files/deviceconfig.xml';

    File file = File(path);

    if (FileSystemEntity.typeSync(path) != FileSystemEntityType.notFound) {
      final document = XmlDocument.parse(file.readAsStringSync());
      final url_address_1 =
          document.findAllElements('url_address_1').map((node) => node.text);
      final url_address_2 =
          document.findAllElements('url_address_2').map((node) => node.text);
      configuration.setUrlPath = url_address_1.first;
      configuration.setUrlPathAlt = url_address_2.first;
      // print(document.toString());
      // print(document.toXmlString(pretty: true, indent: '\t'));
    } else {
      configuration.setUrlPath = "http://203.142.77.243/NewUtilityWarehouseDev";
      configuration.setUrlPathAlt =
          "http://103.76.27.124/NewUtilityWarehouseDev";

      final builder = XmlBuilder();
      builder.processing(
          'xml', 'version="1.0" encoding="UTF-8" standalone="yes"');
      builder.element('deviceconfig', nest: () {
        builder.element('url_address_1',
            nest: "http://203.142.77.243/NewUtilityWarehouseDev");
        builder.element('url_address_2',
            nest: "http://103.76.27.124/NewUtilityWarehouseDev");
        builder.element('token_id', nest: '');
      });
      final document = builder.buildDocument();
      await file.writeAsString(document.toString());
      // print(document.toString());
      // print(document.toXmlString(pretty: true, indent: '\t'));
    }
    setState(() {
      configuration = configuration;
    });
  }

  getNomorPick() async {
    List<Pick> temp_pickNos = [];
    pickNos = [];
    Result res;

    Configuration config = Configuration.of(context);
    Alert(context: context, loading: true, disableBackButton: true);
    Result result = await PickAPIs.getPickNo(context, branchId);
    // print("aaa " + result.code.toString());

    if (result.code == 1) {
      var parsedJson = jsonDecode(result.data);
      parsedJson["MF_PickNo"].map((item) {
        temp_pickNos.add(Pick.fromJson(item));
      }).toList();
      pickNos = [];
      pickNos.add(Pick(pickNo: "Pilih nomor pick"));
      pickNos.addAll(temp_pickNos);
      setPick(pickNos);
      Navigator.of(context, rootNavigator: true).pop();
      final pickNosLength = pickNos.length;
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      await Alert(
          context: context,
          title: "Error",
          content: Text(result.message),
          cancel: false,
          type: "error");
    }
    setState(() {
      pickNos = pickNos;
    });
  }

  getDetailPick(data) async {
    Configuration config = Configuration.of(context);

    final nomorPick = encryptData(data);
    // final nomorPick = data;

    printHelp("nomor pick data " + nomorPick);
    printHelp("branch id data " + branchId);
    Alert(context: context, loading: true, disableBackButton: true);
    Result result = await PickAPIs.getPickDetail(context, branchId, nomorPick);
    detailPicks = [];
    // printHelp("print result.dataa1 : " + result.data.toString());

    if (result.code == 0) {
      Navigator.of(context, rootNavigator: true).pop();
      await Alert(
          context: context,
          title: "Error",
          content: Text(result.message),
          cancel: false,
          type: "error");
    } else if (result.code == 1) {
      var parsedJson = jsonDecode(result.data);
      parsedJson["MF_PickDetail"].map((item) {
        detailPicks.add(DetailPick.fromJson(item));
      }).toList();
      Navigator.of(context, rootNavigator: true).pop();
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      await Alert(
          context: context,
          title: "Error",
          content: Text(result.message),
          cancel: false,
          type: "error");
    }

    if (detailPicks.length > 0) {}
    setState(() {
      detailPicks = detailPicks;

      isCheckboxSelected = [];
      isCheckboxEnabled = [];
      isQtyEnabled = [];
      qtyRealController = [];
      qtyRealFocusNode = [];

      for (int i = 0; i < detailPicks.length; i++) {
        TextEditingController tempTextController = new TextEditingController();
        FocusNode tempFocusNode = new FocusNode();

        qtyRealController.add(tempTextController);
        qtyRealFocusNode.add(tempFocusNode);

        isCheckboxSelected.add(false);
        isCheckboxEnabled.add(true);
        isQtyEnabled.add(true);
      }
      isCheckboxSelected = isCheckboxSelected;
    });
  }

  insertPick(picksChoosen, detailPicksChoosen) async {
    Configuration config = Configuration.of(context);

    Alert(context: context, loading: true, disableBackButton: true);
    Result result =
        await PickAPIs.insertPick(context, picksChoosen, detailPicksChoosen);
    setState(() {
      result = result;
    });
    if (result.code == 1) {
      print("sudah insertttt pick " + result.message.toString());
      Navigator.of(context, rootNavigator: true).pop();
      setState(() {
        pickDone = 1;
      });
      Alert(
        context: context,
        title: "Berhasil!",
        content: Text("Data sudah berhasil diupdate"),
        cancel: false,
        type: "success",
        defaultAction: () {
          setState(() {
            selectedDropdownValue = "Pilih nomor pick";
          });
        },
      );
      changedPick("Pilih nomor pick");
    } else if (result.code == 2) {
      Navigator.of(context, rootNavigator: true).pop();
      setState(() {
        pickDone = 1;
        pickInserted = 1;
      });
      Alert(
          context: context,
          title: "Maaf ,",
          content: Text(result.message),
          cancel: false,
          type: "error");
      
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      print("error insertttt pick " + result.message.toString());
      Alert(
          context: context,
          title: "Error ,",
          content: Text(result.message),
          cancel: false,
          type: "error");
    }

    // await refresh();
  }

  insertOnchangePick(pickChanged) async {
    Configuration config = Configuration.of(context);
    // Alert(context: context, loading: true, disableBackButton: true);
    printHelp("prints" + pickChanged.length.toString());
    Result result = await PickAPIs.insertPickSelected(context, pickChanged);
    setState(() {
      result = result;
    });
    if (result.code == 1) {
      print("sudah insertttt " + result.message.toString());
      // Navigator.of(context, rootNavigator: true).pop();
    } else if (pickChanged != "Pilih nomor pick") {
      // Navigator.of(context, rootNavigator: true).pop();
      print("error insertttt " + result.message.toString());
      Alert(
          context: context,
          title: "Error,",
          content: Text(result.message),
          cancel: false,
          type: "error");
    }
    // await refresh();
  }

  deleteOnchangePick(pickChanged) async {
    Configuration config = Configuration.of(context);

    if(pickInserted == 1){
      pickInserted = 0;
    }else{
      printHelp("pickChanged DATA " + pickChanged);
      if (pickChanged != "") {
        final pickChangedEncrypted = encryptData(pickChanged);
        printHelp("pickChangedEncrypted DATA " + pickChanged);
        // Alert(context: context, loading: true, disableBackButton: true);
        Result result =
            await PickAPIs.deletePickChanged(context, pickChangedEncrypted);
        setState(() {
          result = result;
        });
        if (result.code == 1) {
          // Navigator.of(context, rootNavigator: true).pop();
          print("sudah deletee " + result.message.toString());
        } else {
          // Navigator.of(context, rootNavigator: true).pop();
          print("error deletee " + result.message.toString());
          Alert(
              context: context,
              title: "Error ,",
              content: Text(result.message),
              cancel: false,
              type: "error");
        }
      }
    }

    

    // await refresh();
  }

// textfield or checkbox onchange
  void onchangedData() {

    try {
      // printHelp("this is choosenpick " + choosenPick);

      for (int i = 0; i < pickNos.length; i++) {
        if (pickNos[i].pickNo.toString() == choosenPick.toString()) {
          pickChanged = [];
          Pick temp;
          temp = pickNos[i];
          pickChanged.add(Pick(
              pickNo: pickNos[i].pickNo,
              custName: pickNos[i].custName,
              contactName: pickNos[i].contactName,
              city: pickNos[i].city,
              county: pickNos[i].county,
              postcode: pickNos[i].postcode,
              province: pickNos[i].province,
              gudang: pickNos[i].gudang,
              source: pickNos[i].source,
              date: pickNos[i].date,
              weight: pickNos[i].weight,
              userId: pickNos[i].userId,
              wsNo: pickNos[i].wsNo,
              sales: pickNos[i].sales));

          setState(() {
            selectedNoPick = pickNos[i].pickNo;
            // print('set val pickchangedd ' + selectedNoPick);
          });
          printHelp("Aaaaaaa " + pickDone.toString());

          if (pickDone != 1) {
            insertOnchangePick(pickChanged);
          }
          // print("pick choosen piro : " + picksChoosen.length.toString());
        }
      }
    } catch (e) {
      print("catch" + e);
    }
  }

  refresh() async {
    Alert(context: context, loading: true, disableBackButton: true);
    getNomorPick();
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 40),
          child: Column(children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    dropdownSearch("Pilih nomor pick"),
                    Padding(
                      padding: EdgeInsets.only(right: 10, left: 30),
                      child: Button(
                        disable: false,
                        child: TextView('Refresh', 3,
                            color: Colors.white, caps: true),
                        onTap: () {
                          refresh();
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            // Padding(
                            //   padding: EdgeInsets.only(right: 20),
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: <Widget>[
                            //       TextView('Nama Toko ', 4, fontSize: 17),
                            //       TextView('Nama Pemilik', 4, fontSize: 17),
                            //       TextView('Kota', 4, fontSize: 17),
                            //       TextView('Kabupaten', 4, fontSize: 17),
                            //       TextView('Provinsi', 4, fontSize: 17),
                            //     ],
                            //   ),
                            // ),
                            // Column(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: <Widget>[
                            //     TextView(':', 4, fontSize: 17),
                            //     TextView(':', 4, fontSize: 17),
                            //     TextView(':', 4, fontSize: 17),
                            //     TextView(':', 4, fontSize: 17),
                            //     TextView(':', 4, fontSize: 17),
                            //   ],
                            // ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.35,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    TextView(custName, 3, fontSize: 17),
                                    TextView(contactName, 3, fontSize: 17),
                                    TextView(cityPostcode, 3, fontSize: 17),
                                    TextView(county, 3, fontSize: 17),
                                    TextView(province, 3, fontSize: 17),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        // width: 40,
                        // height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.15,
                              height: MediaQuery.of(context).size.width * 0.29,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Container(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                          TextView('Gudang', 4, fontSize: 17),
                                          TextView('Source', 4, fontSize: 17),
                                          TextView('Tanggal', 4, fontSize: 17),
                                          TextView('Berat', 4, fontSize: 17),
                                          TextView('User ID', 4, fontSize: 17),
                                          TextView('WS No.', 4, fontSize: 17),
                                        ])),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.01,
                              height: MediaQuery.of(context).size.width * 0.29,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                        TextView(':', 4, fontSize: 17),
                                        TextView(':', 4, fontSize: 17),
                                        TextView(':', 4, fontSize: 17),
                                        TextView(':', 4, fontSize: 17),
                                        TextView(':', 4, fontSize: 17),
                                        TextView(':', 4, fontSize: 17),
                                      ])),
                                ],
                              ),
                            ),
                            Container(
                              width: 250,
                              height: MediaQuery.of(context).size.width * 0.29,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Container(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                          TextView(gudang, 3, fontSize: 17),
                                          TextView(source, 3, fontSize: 17),
                                          TextView(tanggal + " " + sales, 3,
                                              fontSize: 17),
                                          TextView(beratKg, 3, fontSize: 17),
                                          TextView(userId, 3, fontSize: 17),
                                          TextView(wsNo, 3, fontSize: 17),
                                        ])),
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
            const Divider(
              height: 20,
              thickness: 1,
              indent: 20,
              endIndent: 0,
              color: Colors.grey,
            ),
            Container(
              height: 400,
              width: MediaQuery.of(context).size.width * 0.98,
              child: horizontalDataTable(),
              // Scrollbar(
              //   child: SingleChildScrollView(
              //     physics: BouncingScrollPhysics(),
              //     scrollDirection: Axis.horizontal,
              //     child: SingleChildScrollView(
              //       physics: BouncingScrollPhysics(),
              //       scrollDirection: Axis.vertical,
              //       child: Padding(
              //         padding: EdgeInsets.only(top: 1),
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           children: <Widget>[
              //             // SizedBox(height: 20),
              //             // buildDataTable(),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ),
            SizedBox(height: 40),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Button(
                  disable: false,
                  child: TextView('Kirim Data', 3,
                      color: Colors.white, caps: true),
                  onTap: () {
                    submitValidation();
                  },
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  // // Insert a new journal to the database
  // Future<void> _addItem() async {
  //   await SQLHelper.createItem(
  //       _titleController.text, _descriptionController.text);
  //   // _refreshJournals();
  // }

  // // Update an existing journal
  // Future<void> _updateItem(int id) async {
  //   await SQLHelper.updateItem(
  //       id, _titleController.text, _descriptionController.text);
  //   // _refreshJournals();
  // }

  // // Delete an item
  // void _deleteItem(int id) async {
  //   await SQLHelper.deleteItem(id);
  //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //     content: Text('Successfully deleted a journal!'),
  //   ));
  //   // _refreshJournals();
  // }

  void submitValidation() async {
    if (choosenPick == "Pilih nomor pick") {
      Alert(
          context: context,
          title: "Maaf,",
          content: Text("Pilih nomor pick terlebih dahulu."),
          cancel: false,
          type: "error");
    } else {
      bool isDataValid = true;
      // await deleteOnchangePick(choosenPick);

      setState(() {
        for (int i = 0; i < qtyRealController.length; i++) {
          if (qtyRealController[i].text.isEmpty && !isCheckboxSelected[i]) {
            isDataValid = false;
            break;
          }
        }
      });

      if (!isDataValid) {
        Alert(
            context: context,
            title: "Maaf,",
            content: Text("Masih ada data yang kosong. Silahkan dicek kembali"),
            cancel: false,
            type: "error");
      } else {
        DateTime now = DateTime.now();
        String formattedDate = DateFormat('dd-MM-yyyy kk:mm:ss').format(now);
        try {
          for (int i = 0; i < pickNos.length; i++) {
            if (pickNos[i].pickNo.contains(choosenPick)) {
              pickChanged = [];
              Pick temp;
              temp = pickNos[i];
              pickChanged.add(Pick(
                  pickNo: pickNos[i].pickNo,
                  custName: pickNos[i].custName,
                  contactName: pickNos[i].contactName,
                  city: pickNos[i].city,
                  county: pickNos[i].county,
                  postcode: pickNos[i].postcode,
                  province: pickNos[i].province,
                  gudang: pickNos[i].gudang,
                  source: pickNos[i].source,
                  date: pickNos[i].date,
                  weight: pickNos[i].weight,
                  userId: pickNos[i].userId,
                  wsNo: pickNos[i].wsNo,
                  sales: pickNos[i].sales));

              setState(() {
                selectedNoPick = pickNos[i].pickNo;
                // print('set val pickchanged' + selectedNoPick);
              });

              // insertOnchangePick(pickChanged);

              // print("pick choosen piro : " + picksChoosen.length.toString());
            }
          }
          detailPicksChoosen = [];
          for (int i = 0; i < detailPicks.length; i++) {
            int pilih;
            if (isCheckboxSelected[i] == true) {
              pilih = 1;
            } else {
              pilih = 0;
            }
            detailPicksChoosen.add(DetailPick(
                description: detailPicks[i].description,
                ukuran: detailPicks[i].ukuran,
                bincode: detailPicks[i].bincode,
                quantity: detailPicks[i].quantity,
                qty_real: qtyRealController[i].text,
                uom: detailPicks[i].uom,
                ada: pilih));
          }
          printHelp("isi pick yg dipilih : " + pickChanged.length.toString());
          printHelp("isi det pick yg dipilih : " +
              detailPicksChoosen.length.toString());
          insertPick(pickChanged, detailPicksChoosen);
        } catch (e) {
          print("catch" + e);
        }
      }
    }
  }

  setPick(pickNos) {
    // printHelp("choosenpickkkkkk " + choosenPick);
    onchangedData();
    for (int i = 0; i < pickNos.length; i++) {
      if (pickNos[i].pickNo.toString() == choosenPick) {
        if (choosenPick != "Pilih nomor pick") {
          setState(() {
            //clear detail data
            custName = pickNos[i].custName;
            contactName = pickNos[i].contactName;
            city = pickNos[i].city;
            county = pickNos[i].county;
            postcode = pickNos[i].postcode;
            province = pickNos[i].province;
            cityPostcode = city + ", " + postcode;

            gudang = pickNos[i].gudang;
            source = pickNos[i].source;
            tanggal = pickNos[i].date.toString();
            berat = pickNos[i].weight.toString();
            beratKg = berat + " KG";
            userId = pickNos[i].userId;
            wsNo = pickNos[i].wsNo;
            sales = pickNos[i].sales;
          });
        }
      }
    }
    // printHelp("lengthnya picknoss " + pickNos.length.toString());
  }

  void changedPick(data) async {
    
    Result res;
    // await getNomorPick();
    setState(() {
      choosenPick = data;
      selectedDropdownValue = data;
      
      // printHelp("ini choosenpick " +
      //     choosenPick +
      //     "dan selected dropdown val " +
      //     selectedDropdownValue);
    });
    if (data.contains("Pilih nomor pick") || data == "") {
      tempChoosenPick = "";
      
    } else {
      pickDone = 0;
      print("choosenpick di getnomorpick" + choosenPick);
      // Alert(context: context, loading: true, disableBackButton: true);
      final choosenPickEncrypted = encryptData(choosenPick);
      res = await PickAPIs.getPickInserted(context, choosenPickEncrypted);
      // tempChoosenPick = res.data;
      print("tempchoosenpick " + choosenPick.toString());
      print("ini tempchoosenpickk " + res.data.toString());

      if (res.data == "1") {
        // Navigator.of(context, rootNavigator: true).pop();
        // choosenPick = "Pilih nomor pick";
        // changedPick("Pilih nomor pick");
        await Alert(
            context: context,
            title: "Maaf,",
            content: Text(
                "Helper lain sedang mengerjakan nomor pick ini. Silahkan memilih nomor pick lain."),
            cancel: false,
            type: "error",
            defaultAction: () {
              // changedPick("Pilih nomor pick");
              setState(() {
                detailPicks = [];
                custName = "";
                contactName = "";
                city = "";
                county = "";
                postcode = "";
                province = "";
                cityPostcode = "";

                gudang = "";
                source = "";
                tanggal = "";
                berat = "";
                beratKg = "";
                userId = "";
                wsNo = "";
                sales = "";
              });
            },
        );
        setState(() {
          pickInserted = 1;
        });
      } else if (res.code == 500 || res.code == 0) {
        // Navigator.of(context, rootNavigator: true).pop();
        await Alert(
            context: context,
            title: "Maaf,",
            content: Text(res.message),
            cancel: false,
            type: "error");
      }
    }

    // default value
    if (data.contains("Pilih nomor pick")) {
      // getNomorPick();
      detailPicks = [];
      custName = "";
      contactName = "";
      city = "";
      county = "";
      postcode = "";
      province = "";
      cityPostcode = "";

      gudang = "";
      source = "";
      tanggal = "";
      berat = "";
      beratKg = "";
      userId = "";
      wsNo = "";
      sales = "";
      // dropdownSearch("Pilih nomor pick");
    } else {
      print("length picknoss " + pickNos.length.toString());
      // if(pickDone != 1){
      deleteOnchangePick(selectedNoPick);
      // }
      getDetailPick(data);
      setState(() {
        for (int i = 0; i < isCheckboxSelected.length; i++) {
          qtyRealController[i].clear();
          isCheckboxSelected[i] = false;
          isQtyEnabled[i] = true;
        }
      });
      // print("ini data" + data);
      // print("ini length picknosss " + pickNos.length.toString());
    }

    getNomorPick();
  }

  showAlertDialog(BuildContext context, String data) {
    String temp = selectedDropdownValue;
    Widget cancelButton = TextButton(
      child: Text("TIDAK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        printHelp("ini choosenpick blkaba selected" +
            selectedDropdownValue +
            " dan ini temp " +
            temp);
        setState(() {
          selectedDropdownValue = temp;
          // dropdownSearch(selectedDropdownValue);
        });
        print("ini selecteddropdown val = " + selectedDropdownValue);
        // changedPick(selectedDropdownValue);
      },
    );
    Widget continueButton = TextButton(
      child: Text("YA"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        changedPick(data);
        choosenPick = data;
        pickDone = 0;
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Discard"),
      content: Text("Apakah anda ingin memilih pick lain?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget dropdownSearch(choosen) {
    selectedDropdownValue = choosen;
    return Container(
      width: 250,
      height: 50,
      child: DropdownSearch<String>(
        mode: Mode.BOTTOM_SHEET,
        showSelectedItems: true,
        items: pickNos.map((list) => list.pickNo).toList(),
        onChanged: (data) {
          printHelp("ini choosenpick " + choosenPick);
          printHelp("ini daata " + data);
          if (choosenPick.contains("Pilih nomor pick")) {
            changedPick(data);
            // kalo pilih iya
            setState(() {
              choosenPick = data;
              selectedDropdownValue = data;
              printHelp("ini choosenpick 2" + choosenPick);
            });
          } else if (choosenPick != "" && choosenPick != data) {
            showAlertDialog(context, data);
            // selectedDropdownValue = data;
          } else if(choosenPick == data){
            printHelp("masuk sni");
            selectedDropdownValue = data;
            // getNomorPick();
          }
          else {
            changedPick(data);
            // kalo pilih iya
            printHelp("ini choosenpick 3" + choosenPick);
            setState(() {
              choosenPick = data;
              selectedDropdownValue = data;
            });
          }
        },
        selectedItem: selectedDropdownValue,
        dropdownSearchDecoration: InputDecoration(
          labelText: "Nomor Pick",
          hintText: "Pilih nomor pick disini",
          contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
          border: OutlineInputBorder(),
        ),
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
            labelText: "Cari nomor pick",
          ),
        ),
        popupTitle: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorDark,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Center(
            child: Text(
              'Nomor Pick',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        popupShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
      ),
    );
  }

  Widget _verticalDivider = const VerticalDivider(
    color: Colors.black,
    thickness: 1,
  );

  Widget horizontalDataTable() {
    if (detailPicks.length == 0) {
      return Container(
        alignment: Alignment.center,
        child: TextView('Tidak ada data', 1),
      );
    }
    return HorizontalDataTable(
      leftHandSideColumnWidth: MediaQuery.of(context).size.width * 0.32,
      rightHandSideColumnWidth: MediaQuery.of(context).size.width * 0.65,
      isFixedHeader: true,
      headerWidgets: _getTitleWidget(),
      leftSideItemBuilder: _generateFirstColumnRow,
      rightSideItemBuilder: _generateRightHandSideColumnRow,
      itemCount: detailPicks.length,
      rowSeparatorWidget: const Divider(
        color: Colors.black54,
        height: 1.0,
        thickness: 0.0,
      ),
      horizontalScrollbarStyle: const ScrollbarStyle(
        thumbColor: Colors.red,
        isAlwaysShown: false,
        thickness: 4.0,
        radius: Radius.circular(5.0),
      ),
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget(
          'NAMA BARANG', MediaQuery.of(context).size.width * 0.23, 5),
      _getTitleItemWidget(
          'KEMASAN', MediaQuery.of(context).size.width * 0.17, 5),
      _getTitleItemWidget('BIN', MediaQuery.of(context).size.width * 0.15, 14),
      _getTitleItemWidget('QTY', MediaQuery.of(context).size.width * 0.07, 0),
      _getTitleItemWidget(
          'QTY REAL', MediaQuery.of(context).size.width * 0.08, 5),
      _getTitleItemWidget('UoM', MediaQuery.of(context).size.width * 0.08, 8),
      _getTitleItemWidget('ADA', MediaQuery.of(context).size.width * 0.08, 14),
    ];
  }

  Widget _getTitleItemWidget(String label, double width, double paddingLeft) {
    return Container(
      child: Text(label,
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.left),
      width: width,
      height: 56,
      padding: EdgeInsets.fromLTRB(paddingLeft, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          child: Align(
            alignment: Alignment.centerRight,
            // child: TextView('12X0.075MMX10MX0.20G', 6)
            child: TextView(detailPicks[index].ukuran, 6),
          ),
          width: MediaQuery.of(context).size.width * 0.18,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
        ),
        Container(
          child: TextView(detailPicks[index].bincode, 6),
          width: MediaQuery.of(context).size.width * 0.15,
          height: 52,
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Align(
              alignment: Alignment.centerRight,
              // child: TextView('696', 6)),
              child: TextView(detailPicks[index].quantity, 6)),
          width: MediaQuery.of(context).size.width * 0.07,
          height: 52,
          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: TextField(
            enabled: isQtyEnabled[index],
            focusNode: qtyRealFocusNode[index],
            controller: qtyRealController[index],
            maxLength: 3,
            textAlign: TextAlign.end,
            keyboardType: TextInputType.number,
            style: TextStyle(
                fontFamily: "Roboto",
                fontSize: 13,
                fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              counterText: "",
            ),
            onChanged: (value) {
              // onchangedData();
              if (value.isNotEmpty) {
                setState(() {
                  isCheckboxEnabled[index] = false;
                });
              } else {
                setState(() {
                  isCheckboxEnabled[index] = true;
                });
              }
            },
          ),
          width: MediaQuery.of(context).size.width * 0.07,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: TextView(detailPicks[index].uom, 6),
          width: MediaQuery.of(context).size.width * 0.08,
          height: 52,
          padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Checkbox(
            value: isCheckboxSelected[index],
            onChanged: !isCheckboxEnabled[index]
                ? null
                : (bool value) {
                    // onchangedData();
                    setState(() {
                      isCheckboxSelected[index] = value;
                      if (value == true) {
                        isQtyEnabled[index] = false;
                      } else {
                        isQtyEnabled[index] = true;
                      }
                    });
                  },
          ),
          width: MediaQuery.of(context).size.width * 0.08,
          height: 52,
          padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
      ],
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      // child: Text('AlPlastic Left Panel(Alum Plastic Left/Rightpanel)'),
      child: Text(detailPicks[index].description),
      width: MediaQuery.of(context).size.width * 0.25,
      height: 52,
      // padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  // Widget buildDataTable() {
  //   printHelp("DEBUG LIST LENGTH " + detailPicks.length.toString());
  //   if (detailPicks.length == 0) {
  //     return Container(
  //       child: TextView('Tidak ada data', 1),
  //     );
  //   }
  //   final columns = [
  //     'NAMA BARANG',
  //     'KEMASAN',
  //     'BIN',
  //     'QTY',
  //     'QTY REAL',
  //     'UoM',
  //     'ADA'
  //   ];
  //   var your_number_of_rows = 7;
  //   var rowHeight = (MediaQuery.of(context).size.width - 56) / your_number_of_rows;
  //   return DataTable(

  //     // dataRowHeight: rowHeight,
  //     // headingRowHeight: 56.0,

  //       // columns: getColumns(columns),
  //       columnSpacing: 5,
  //       columns: [
  //         DataColumn(label: Container(width: MediaQuery.of(context).size.width * 0.2, child: TextView('NAMA BARANG', 5))),
  //         // DataColumn(label: _verticalDivider),
  //         DataColumn(label: Container(width: MediaQuery.of(context).size.width * 0.15, child: TextView('KEMA-\nSAN', 5))),
  //         // DataColumn(label: _verticalDivider),
  //         DataColumn(label: Container(width: MediaQuery.of(context).size.width * 0.06, child: TextView('BIN', 5))),
  //         // DataColumn(label: _verticalDivider),
  //         DataColumn(label: TextView('QTY', 5)),
  //         // DataColumn(label: _verticalDivider),
  //         DataColumn(label: Container(
  //           width: MediaQuery.of(context).size.width * 0.1,
  //           height: MediaQuery.of(context).size.height * 0.1,
  //           child: TextView('QTY REAL',5))
  //         ),
  //         // DataColumn(label: _verticalDivider),
  //         DataColumn(label: TextView('UoM',5)),
  //         // DataColumn(label: _verticalDivider),
  //         DataColumn(label: Container(width: 40,child: TextView('ADA', 5)))
  //         ],
  //       rows: List.generate(detailPicks.length, (int index) {
  //         return DataRow(cells: [
  //           DataCell(Container(
  //             width: MediaQuery.of(context).size.width * 0.25,
  //             child: TextView(detailPicks[index].description, 6)
  //             )
  //           ),
  //           // DataCell(_verticalDivider),
  //           DataCell(Container(
  //             width: MediaQuery.of(context).size.width * 0.1,
  //             child: TextView(detailPicks[index].ukuran, 6)
  //             )
  //           ),
  //           // DataCell(_verticalDivider),
  //           DataCell(Container(
  //             width: MediaQuery.of(context).size.width * 0.12,
  //             child: TextView(detailPicks[index].bincode, 6))
  //           ),
  //           // DataCell(_verticalDivider),
  //           DataCell(Container(
  //             width: MediaQuery.of(context).size.width * 0.1,
  //             child: TextView(detailPicks[index].quantity, 6)
  //             )
  //           ),
  //           // DataCell(_verticalDivider),
  //           DataCell(Container(
  //             // width: MediaQuery.of(context).size.width * 0.1,
  //             child: TextField(
  //               enabled: isQtyEnabled[index],
  //               focusNode: qtyRealFocusNode[index],
  //               controller: qtyRealController[index],
  //               maxLength: 3,
  //               keyboardType: TextInputType.number,
  //               decoration: InputDecoration(
  //                 counterText: "",
  //               ),
  //               onChanged: (value) {
  //                 if (value.isNotEmpty) {
  //                   setState(() {
  //                     isCheckboxEnabled[index] = false;
  //                   });
  //                 } else {
  //                   setState(() {
  //                     isCheckboxEnabled[index] = true;
  //                   });
  //                 }
  //               },
  //             ),
  //           )),
  //           // DataCell(_verticalDivider),
  //           DataCell(Text(detailPicks[index].uom)),
  //           // DataCell(_verticalDivider),
  //           DataCell(
  //             Container(
  //             width: 40,
  //               child: Checkbox(
  //                 value: isCheckboxSelected[index],
  //                 onChanged: !isCheckboxEnabled[index]
  //                     ? null
  //                     : (bool value) {
  //                         setState(() {
  //                           isCheckboxSelected[index] = value;
  //                           if (value == true) {
  //                             isQtyEnabled[index] = false;
  //                           } else {
  //                             isQtyEnabled[index] = true;
  //                           }
  //                         });
  //                       },
  //               ),
  //             ),
  //           ),
  //         ]);
  //       }));
  // }

  List<DataColumn> getColumns(List<String> columns) {
    return columns.map((String column) {
      return DataColumn(
        label: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Text(column)),
      );
    }).toList();
  }
}

// The "soruce" of the table
class MyData extends DataTableSource {
  final List<Map<String, dynamic>> _data = List.generate(
      100,
      (index) => {
            "id": index,
            "title": "Item $index",
            "price": Random().nextInt(10000),
          });

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(_data[index]['id'].toString())),
      DataCell(Text(_data[index]["title"])),
      DataCell(Text(_data[index]["price"].toString())),
    ]);
  }
}

class ShowItem {
  String label;
  dynamic value;

  ShowItem({this.label, this.value});

  factory ShowItem.fromJson(Map<String, dynamic> json) {
    return ShowItem(label: json['label'], value: json['value']);
  }
}
