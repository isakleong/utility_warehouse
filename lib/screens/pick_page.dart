import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:utility_warehouse/models/detailPickModel.dart';
import 'package:utility_warehouse/models/pickModel.dart';
import 'package:utility_warehouse/resources/pickAPI.dart';
import 'package:utility_warehouse/resources/userAPI.dart';
import 'package:utility_warehouse/settings/configuration.dart';
import 'package:utility_warehouse/tools/function.dart';
import 'package:utility_warehouse/widgets/textView.dart';
import 'package:dropdown_search/dropdown_search.dart';

class PickPage extends StatefulWidget {
  @override
  _PickPageState createState() => _PickPageState();
}

class _PickPageState extends State<PickPage> {
  List<Pick> picks = [];
  // Future<List<Pick>> picks;
  List<DetailPick> detailPicks = [];

  // TextEditingController gudang;

  // mocking a future that returns List of Objects
  // Future<List> fetchComplexData() async {
  //   List _list = new List();
  //   List _jsonList = [];
  //   for(int i =0; i < picks.length; i++){
  //     print(i);
  //     print(picks[i].pickNo);
  //     _jsonList.add(
  //       {'label' : picks[i].pickNo.toString(), 'value': i}
  //     );
  //   }
  //   for(int i = 0; i < _jsonList.length; i++){
  //     _list.add(new ShowItem.fromJson(_jsonList[i]));
  //   }

  //   return _list;
  // }

  bool valuefirst = false;

  final DataTableSource _data = MyData();

  

  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
//      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void didChangeDependencies() async {
    await getNomorPick();
    await getDetailPick();
  
  }

  getNomorPick() async {
    Configuration config = Configuration.of(context);

    picks = await PickAPIs.getPickNo(context);

    print("ini list ye : ");
    print("debug ye "+picks[0].weight);

    setState(() {
      picks = picks;
    });
  }

  getDetailPick() async {
    Configuration config = Configuration.of(context);

    detailPicks = await PickAPIs.getPickDetail(context);

    print("ini list : ");
    print("debug ye "+detailPicks[1].description);

    setState(() {
      detailPicks = detailPicks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 40, left: 40, right: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextView(text:'Sinar Surya', fontWeight:FontWeight.bold),
                          TextView(text:'BP. ANTONIUS', fontWeight:FontWeight.bold),
                          TextView(text:'Ruko Kebraon Selatan Fa-36', fontWeight:FontWeight.bold),
                          TextView(text:'Karang Pilang, 60221', fontWeight:FontWeight.bold),
                          TextView(text:'16C-SURABAYA'),
                          TextView(text:'JAWA TIMUR'),
                        ],
                      ),
                    ),
                    
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding : EdgeInsets.only(right: 20),
                                child: Container(
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          TextView(text:'Pick No.', color: Colors.grey),
                                          TextView(text:'Gudang', color: Colors.grey),
                                          TextView(text:'Source', color: Colors.grey),
                                          TextView(text:'Tanggal', color: Colors.grey),
                                          TextView(text:'Berat', color: Colors.grey),
                                          TextView(text:'User ID', color: Colors.grey),
                                          TextView(text:'WS No.', color: Colors.grey),
                                        ]
                                    )
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        TextView(text:':'),
                                        TextView(text:':'),
                                        TextView(text:':'),
                                        TextView(text:':'),
                                        TextView(text:':'),
                                        TextView(text:':'),
                                        TextView(text:':'),
                                      ]
                                  )
                              ),
                            ],
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding : EdgeInsets.only(left: 10),
                                child: Container(
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          // TextField(controller: gudang),
                                          dropdownSearch(),
                                          TextView(text:'16C-GDWMS'),
                                          TextView(text:'SG-16C-2201-01329'),
                                          TextView(text:'02/03/22	16CC2A0505'),
                                          TextView(text:'76.07 KG'),
                                          TextView(text:'TIRTAKENCANA\000-OP-SP2'),
                                          TextView(text:'WS-16C-2202-00001'),
                                          // TextField(controller: gudang),
                                            // Padding(
                                            //   padding: const EdgeInsets.all(15),
                                            //   child: TextField(
                                            //     decoration: InputDecoration(labelText: 'Title'),
                                                  
                                            //     controller: gudang,
                                                  
                                            //   ),
                                            // ),
                                        ]
                                    )
                                ),
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
            
//             Padding(
//               padding: EdgeInsets.only(left: 40, right: 40),
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
//                 child: Expanded(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       PaginatedDataTable(
//                         source: _data,
// //                        header: const Text('My Products'),
//                         columns: const [
//                           DataColumn(label: Text('ID')),
//                           DataColumn(label: Text('Name')),
//                           DataColumn(label: Text('Price')),
//                         ],
//                         columnSpacing: 100,
//                         horizontalMargin: 10,
//                         rowsPerPage: 5,
//                         showCheckboxColumn: false,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
          
          // Container(),
          Container(
            height: 300,
            child: Scrollbar(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child:
                  Padding(
                    padding: EdgeInsets.only(top: 1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 20),
                        buildDataTable(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
            Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: ElevatedButton(onPressed: () {}, child: Text('KIRIM'),
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(120, 50),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    textStyle:
                    const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ]
      ),
    ),
  );
  }

  void changedPick(data){
    // var total = picks.entries.where((e) => e.value == data).toList();
    // var country = picks.entries.firstWhere((entry) => entry.value == data).key;
    // gudang.text = data;
    getDetailPick();
    
  }

  Widget dropdownSearch(){
    return Container(
      width: 250,
      height: 50,
      child: DropdownSearch<String>(
        mode: Mode.BOTTOM_SHEET,
        items: picks.map((list) => list.pickNo).toList(),
        onChanged: (data) {
            print(data);
            changedPick(data);
        },
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

  Widget buildDataTable() {
    final columns = ['NAMA BARANG', 'KEMASAN', 'BIN', 'QTY', 'QTR REV',  'UoM', 'ADA'];
    return DataTable(
      columns: getColumns(columns),
      rows: detailPicks.map((list) => DataRow(cells: [
          DataCell(Text(list.description)),
          DataCell(Text(list.kemasan)),
          DataCell(Text(list.bincode)),
          DataCell(Text(list.quantity)),
          DataCell(TextField(maxLength: 3, keyboardType: TextInputType.number,)),
          // DataCell(TextField(maxLength: 3,)),
          DataCell(Text(list.uom)),
          DataCell(Checkbox(  
              value: this.valuefirst,  
              onChanged: (bool value) {  
                setState(() {  
                  this.valuefirst = value;  
                });  
              },  
            ),  
            ),
        ]),
        ).toList(),
    );
  }

  List<DataColumn> getColumns(List<String> columns) {
    return columns.map((String column) {
      return DataColumn(
        label: Text(column),
      );
    }).toList();
  }
}
// The "soruce" of the table
class MyData extends DataTableSource {
  final List<Map<String, dynamic>> _data = List.generate(
      100,
          (index) =>
      {
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