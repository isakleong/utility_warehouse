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
  @override
  _PickPageVerticalState createState() => _PickPageVerticalState();
}

class _PickPageVerticalState extends State<PickPageVertical> {
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

  String gudang = "";
  String source = "";
  String tanggal = "";
  String berat = "";
  String userId = "";
  String wsNo = "";
  String sales = "";
  String selectedDropdownValue = "Pilih nomor pick";
  String pickChangedNoPick = "";

  String choosenPick = "";
  String tempChoosenPick = "";
  String branchId = encryptData("17A");

  static const int sortName = 0;
  static const int sortStatus = 1;
  bool isAscending = true;
  int sortType = sortName;

  final DataTableSource _data = MyData();
  Future<String> getDatabasesPath() => databaseFactory.getDatabasesPath();

  Configuration configuration;
  void initState() {
    detailPicks = [];
    detailPicksChoosen = [];
    super.initState();
    const tenSec = Duration(seconds: 10);
    Timer.periodic(tenSec, (Timer t) => getNomorPick());
    // Alert(
    //     context: context,
    //     title: "Anda belum memilih nomor pick,",
    //     content: Text("Pilih nomor pick terlebih dahulu"),
    //     cancel: false,
    //     type: "error"
    //   );
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
    String path = '/storage/emulated/0/Android/data/com.example.utility_warehouse/files/deviceconfig.xml';

    File file = File(path);

    if(FileSystemEntity.typeSync(path) != FileSystemEntityType.notFound){
      final document = XmlDocument.parse(file.readAsStringSync());
      final url_address_1 = document.findAllElements('url_address_1').map((node) => node.text);
      final url_address_2 = document.findAllElements('url_address_2').map((node) => node.text);
      configuration.setUrlPath = url_address_1.first;
      configuration.setUrlPathAlt = url_address_2.first;
      // print(document.toString());
      // print(document.toXmlString(pretty: true, indent: '\t'));
    } else {
      configuration.setUrlPath = "http://203.142.77.243/NewUtilityWarehouseDev";
      configuration.setUrlPathAlt = "http://103.76.27.124/NewUtilityWarehouseDev";

      final builder = XmlBuilder();
      builder.processing('xml', 'version="1.0" encoding="UTF-8" standalone="yes"');
      builder.element('deviceconfig', nest: () {
        builder.element('url_address_1', nest: "http://203.142.77.243/NewUtilityWarehouseDev");
        builder.element('url_address_2', nest: "http://103.76.27.124/NewUtilityWarehouseDev");
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
    if (choosenPick.contains("Pilih nomor pick")) {
      tempChoosenPick = "";
    } else {
      tempChoosenPick = await PickAPIs.getPickInserted(context, choosenPick);
      // print("print temp choosenpick " + tempChoosenPick);
    }

    Configuration config = Configuration.of(context);
    List<Pick> temp_pickNos = [];
    pickNos = [];
    temp_pickNos = await PickAPIs.getPickNo(context, branchId);

    // temp_pickNos = await PickAPIs.getPickNo(context);

    pickNos.add(Pick(pickNo: "Pilih nomor pick"));
    pickNos.addAll(temp_pickNos);

    // print("debug ye " + pickNos[0].pickNo);

    final pickNosLength = pickNos.length;

    if (tempChoosenPick.contains("1")) {
      choosenPick = "Pilih nomor pick";
      // printHelp("print ye");
      changedPick("Pilih nomor pick");
      await Alert(
          context: context,
          title: "Maaf,",
          content:
              Text("Ada helper lain yang sedang mengerjakan nomor pick ini."),
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

    printHelp("nomor pick data "+nomorPick);
    printHelp("branch id data "+branchId);

    detailPicks = await PickAPIs.getPickDetail(context, branchId, nomorPick);
    // Result result = await PickAPIs.getPickDetail(context, branchId, nomorPick);

    // String res = result.data;

    // print("decryptt " + res);
    // final decryptResponse = decryptData(result.data);
    // print(decryptResponse);

    // var parsedJson = jsonDecode(decryptResponse);
    // result.data = parsedJson;

    // result.data.map((item) {
    //   detailPicks.add(DetailPick.fromJson(item));
    // }).toList();

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

    Result result =
        await PickAPIs.insertPick(context, picksChoosen, detailPicksChoosen);
    setState(() {
      result = result;
    });
    if (result.code == 1) {
      print("sudah insertttt " + result.message.toString());
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
    } else {
      print("error insertttt " + result.message.toString());
      if (result.code == -1) {
        Alert(
            context: context,
            title: "Maaf,",
            content: Text("Gagal terhubung dengan server"),
            cancel: false,
            type: "error");
      } else if (result.code == 0) {
        Alert(
            context: context,
            title: "Gagal,",
            content: Text("Data pick sudah pernah diinput"),
            cancel: false,
            type: "error");
      } else {
        Alert(
            context: context,
            title: "Maaf,",
            content: Text("Data gagal diupdate"),
            cancel: false,
            type: "error");
      }
    }
    await refresh();
  }

  insertOnchangePick(pickChanged) async {
    Configuration config = Configuration.of(context);

    Result result =
        await PickAPIs.insertPickSelected(context, pickChanged);
    setState(() {
      result = result;
    });
    if (result.code == 1) {
      print("sudah insertttt " + result.message.toString());
    } else {
      print("error insertttt " + result.message.toString());
    }
    await refresh();
  }

  deleteOnchangePick(pickChanged) async {
    Configuration config = Configuration.of(context);

    printHelp("pickChanged DATA "+ pickChanged);
    if(pickChanged != ""){
      final pickChangedEncrypted = encryptData(pickChanged);
      printHelp("pickChangedEncrypted DATA "+ pickChangedEncrypted);

      Result result =
          await PickAPIs.deletePickChanged(context, pickChangedEncrypted);
      setState(() {
        result = result;
      });
      if (result.code == 1) {
        print("sudah deletee " + result.message.toString());
      } else {
        print("error deletee " + result.message.toString());
      }
    }

    await refresh();
  }
// textfield or checkbox onchange
  void onchangedData() {
    try {
        // printHelp("this is choosenpick "+choosenPick);
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
            pickChangedNoPick = pickNos[i].pickNo;
            print('set val pickchanged'+ pickChangedNoPick);
          });
          

          insertOnchangePick(pickChanged);

          // print("pick choosen piro : " + picksChoosen.length.toString());
        }
      }
    } catch (e) {
      print("catch" + e);
    }
  }

  submitted() async {
    refresh();
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
                      padding: EdgeInsets.only(right: 10),
                      child: ElevatedButton(
                          onPressed: () {
                            refresh();
                          },
                          child: const Text('Refresh')),
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
                                    TextView(city + ", " + postcode, 3,
                                        fontSize: 17),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
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
                            Column(
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
                            Column(
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
                                        TextView(berat + " KG", 3,
                                            fontSize: 17),
                                        TextView(userId, 3, fontSize: 17),
                                        TextView(wsNo, 3, fontSize: 17),
                                      ])),
                                ),
                              ],
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

  void submitValidation()async {
    bool isDataValid = true;
    print("yaaa");
    printHelp(choosenPick);
    await deleteOnchangePick(choosenPick);

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
            
        // for (int i = 0; i < pickNos.length; i++) {
        //   if (pickNos[i].pickNo.contains(choosenPick)) {
        //     printHelp("???????? ");
        //     picksChoosen = [];
        //     Pick temp;
        //     temp = pickNos[i];
        //     picksChoosen.add(Pick(
        //         pickNo: pickNos[i].pickNo,
        //         custName: pickNos[i].custName,
        //         contactName: pickNos[i].contactName,
        //         city: pickNos[i].city,
        //         county: pickNos[i].county,
        //         postcode: pickNos[i].postcode,
        //         province: pickNos[i].province,
        //         gudang: pickNos[i].gudang,
        //         source: pickNos[i].source,
        //         date: pickNos[i].date,
        //         weight: pickNos[i].weight,
        //         userId: pickNos[i].userId,
        //         wsNo: pickNos[i].wsNo,
        //         sales: pickNos[i].sales));

        //     // print("pick choosen piro : " + picksChoosen.length.toString());
        //   }
        // }

        //submit data
        
          detailPicksChoosen = [];
        for (int i = 0; i < detailPicks.length; i++) {
          print(detailPicksChoosen.length);
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
        printHelp("isi det pick yg dipilih : " + detailPicksChoosen.length.toString());
        insertPick(pickChanged, detailPicksChoosen);
      } catch (e) {
        print("catch" + e);
      }
    }
  }

  void changedPick(data) async {
    await getNomorPick();

    // kalo pilih iya
    setState(() {
      choosenPick = data;
      selectedDropdownValue = data;
      // printHelp("ini choosenpick " +
      //     choosenPick +
      //     "dan selected dropdown val " +
      //     selectedDropdownValue);
    });

    if (data != "Pilih nomor pick") {
      getDetailPick(data);
      setState(() {
        for (int i = 0; i < isCheckboxSelected.length; i++) {
          qtyRealController[i].clear();
          isCheckboxSelected[i] = false;
          isQtyEnabled[i] = true;
        }
      });

      for (int i = 0; i < pickNos.length; i++) {
        if (pickNos[i].pickNo == data) {
          setState(() {
            //clear detail data

            custName = pickNos[i].custName;
            contactName = pickNos[i].contactName;
            city = pickNos[i].city;
            county = pickNos[i].county;
            postcode = pickNos[i].postcode;
            province = pickNos[i].province;

            gudang = pickNos[i].gudang;
            source = pickNos[i].source;
            tanggal = pickNos[i].date.toString();
            berat = pickNos[i].weight.toString();
            userId = pickNos[i].userId;
            wsNo = pickNos[i].wsNo;
            sales = pickNos[i].sales;
          });
        }
      }
    }
    // else pilih nomor pick
    else if (data == "Pilih nomor pick") {
      getNomorPick();
      detailPicks = [];
      custName = "";
      contactName = "";
      city = "";
      county = "";
      postcode = "";
      province = "";

      gudang = "";
      source = "";
      tanggal = "";
      berat = "";
      userId = "";
      wsNo = "";
      sales = "";
      dropdownSearch("Pilih nomor pick");
    }
  }

  showAlertDialog(BuildContext context, String data) {
    Widget cancelButton = TextButton(
      child: Text("TIDAK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        printHelp("ini choosenpick blkaba selected" + selectedDropdownValue);
        setState(() {
          changedPick(selectedDropdownValue);
          selectedDropdownValue = selectedDropdownValue;
        });
      },
    );
    Widget continueButton = TextButton(
      child: Text("YA"),
      onPressed: () {
        changedPick(data);
        Navigator.of(context, rootNavigator: true).pop();
        deleteOnchangePick(pickChangedNoPick);
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
    return Container(
      width: 250,
      height: 50,
      child: DropdownSearch<String>(
        mode: Mode.BOTTOM_SHEET,
        showSelectedItems: true,
        items: pickNos.map((list) => list.pickNo).toList(),
        onChanged: (data) {
          if (choosenPick.contains("Pilih nomor pick")) {
            changedPick(data);
            // kalo pilih iya
            setState(() {
              choosenPick = data;
              selectedDropdownValue = data;
              printHelp("ini choosenpick 2" + choosenPick);
            });
          } else if (choosenPick != "") {
            showAlertDialog(context, data);
            // selectedDropdownValue = data;
          } else {
            changedPick(data);
            // kalo pilih iya
            setState(() {
              choosenPick = data;
              selectedDropdownValue = data;
              printHelp("ini choosenpick 3" + choosenPick);
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
      leftHandSideColumnWidth: MediaQuery.of(context).size.width * 0.33,
      rightHandSideColumnWidth: MediaQuery.of(context).size.width * 0.66,
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
          'NAMA BARANG', MediaQuery.of(context).size.width * 0.23),
      _getTitleItemWidget(
          'KEMAS-\nAN', MediaQuery.of(context).size.width * 0.17),
      _getTitleItemWidget('BIN', MediaQuery.of(context).size.width * 0.15),
      _getTitleItemWidget('QTY', MediaQuery.of(context).size.width * 0.08),
      _getTitleItemWidget('QTY REAL', MediaQuery.of(context).size.width * 0.08),
      _getTitleItemWidget('UoM', MediaQuery.of(context).size.width * 0.08),
      _getTitleItemWidget('ADA', MediaQuery.of(context).size.width * 0.08),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(label,
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.left),
      width: width,
      height: 56,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Row(
      // mainAxisAlignment : MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          // color: Colors.orange,
          // child: TextView('12X0.075MMX10MX0.20G', 6),
          child: Align(child: TextView(detailPicks[index].ukuran, 6)),
          // child: TextView(detailPicks[index].ukuran, 6, align: TextAlign.center),
          width: MediaQuery.of(context).size.width * 0.17,
          height: 52,
          // padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          // child: TextView('1.24.14.1.1', 6),
          child: TextView(detailPicks[index].bincode, 6),
          width: MediaQuery.of(context).size.width * 0.15,
          height: 52,
          // padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          // color: Colors.orange,
          // child: TextView('1200', 6),
          child: Align(
              alignment: Alignment.centerRight,
              child: TextView(detailPicks[index].quantity, 6)),
          width: MediaQuery.of(context).size.width * 0.08,
          height: 52,
          // padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
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
              onchangedData();
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
          width: MediaQuery.of(context).size.width * 0.08,
          height: 52,
          // padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: TextView(detailPicks[index].uom, 6),
          width: MediaQuery.of(context).size.width * 0.08,
          height: 52,
          // padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Checkbox(
            value: isCheckboxSelected[index],
            onChanged: !isCheckboxEnabled[index]
                ? null
                : (bool value) {
                    onchangedData();
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
          // padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
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
