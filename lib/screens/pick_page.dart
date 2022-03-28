import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:utility_warehouse/widgets/textView.dart';
import 'package:dropdown_search/dropdown_search.dart';

class PickPage extends StatefulWidget {
  @override
  _PickPageState createState() => _PickPageState();
}

class _PickPageState extends State<PickPage> {
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

//                            Column(
//                              crossAxisAlignment: CrossAxisAlignment.start,
//                              children: [
//                                Row(
//                                  children: [
//                                    TextView(text:'Pick No.', color: Colors.grey),
//                                    TextView(text:':'),
//                                    dropdownSearch(),
//                                  ],
//                                ),
//                                Row(
//                                  children: [
//                                    TextView(text:'Gudang', color: Colors.grey),
//                                    TextView(text:':'),
//                                    TextView(text:'16C-GDWMS'),
//                                  ],
//                                ),
//                                Row(
//                                  children: [
//                                    TextView(text:'Source', color: Colors.grey),
//                                    TextView(text:':'),
//                                    TextView(text:'SG-16C-2201-01329'),
//                                  ],
//                                ),
//                              ],
//                            ),

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
                                            dropdownSearch(),
                                            TextView(text:'16C-GDWMS'),
                                            TextView(text:'SG-16C-2201-01329'),
                                            TextView(text:'02/03/22	16CC2A0505'),
                                            TextView(text:'76.07 KG'),
                                            TextView(text:'TIRTAKENCANA\000-OP-SP2'),
                                            TextView(text:'WS-16C-2202-00001'),
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

            Padding(
              padding: EdgeInsets.only(left: 40, right: 40),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                child: Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      PaginatedDataTable(
                        source: _data,
//                        header: const Text('My Products'),
                        columns: const [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Price')),
                        ],
                        columnSpacing: 100,
                        horizontalMargin: 10,
                        rowsPerPage: 5,
                        showCheckboxColumn: false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
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

  Widget dropdownSearch(){
    return Container(
      width: 250,
      height: 50,
      child: ///BottomSheet Mode with no searchBox
      DropdownSearch<String>(
        mode: Mode.BOTTOM_SHEET,
        items: [
          "Brazil",
          "Italia",
          "Tunisia",
          'Canada',
          'Zraoua',
          'France',
          'Belgique'
        ],
//        dropdownSearchDecoration: InputDecoration(
//          labelText: "Custom BottomShet mode",
//          contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
//          border: OutlineInputBorder(),
//        ),
        onChanged: print,
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
            labelText: "Search a country",
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
              'Country',
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
    final columns = ['NAMA BARANG', 'KEMASAN', 'BIN', 'QTY', 'UoM', 'ADA'];
    return DataTable(
      columns: getColumns(columns),
      rows: [
        DataRow(cells: [
          DataCell(Text('NO DROP 001')),
          DataCell(Text('1 KG')),
          DataCell(Text('2.14.1.7')),
          DataCell(Text('6')),
          DataCell(Text('KL')),
          DataCell(Text('aa')),
        ]),
        DataRow(cells: [
          DataCell(Text('NO DROP 002')),
          DataCell(Text('1 KG')),
          DataCell(Text('2.14.1.7')),
          DataCell(Text('9')),
          DataCell(Text('Dus')),
          DataCell(Text('Dus')),
        ]),
        DataRow(cells: [
          DataCell(Text('NO DROP 009')),
          DataCell(Text('1 KG')),
          DataCell(Text('2.14.1.7')),
          DataCell(Text('8')),
          DataCell(Text('Dus')),
          DataCell(Text('Dus')),
        ]),
        DataRow(cells: [
          DataCell(Text('NO DROP 017')),
          DataCell(Text('1 KG')),
          DataCell(Text('2.14.1.7')),
          DataCell(Text('8')),
          DataCell(Text('KL')),
          DataCell(Text('KL')),
        ]),
        DataRow(cells: [
          DataCell(Text('NO DROP 021')),
          DataCell(Text('1 KG')),
          DataCell(Text('1.15.24.1')),
          DataCell(Text('8')),
          DataCell(Text('ID')),
          DataCell(Checkbox(
            checkColor: Colors.greenAccent,
            activeColor: Colors.red,
            value: valuefirst,
            onChanged: (bool value) {
              setState(() {
                this.valuefirst = value;
              });
            },
          ),),
        ]),
        DataRow(cells: [
          DataCell(Text('SUZUKA Lacquer 470')),
          DataCell(Text('1 KG')),
          DataCell(Text('1.15.24.1')),
          DataCell(Text('8')),
          DataCell(Text('ID')),
          DataCell(Text('ID')),
        ]),
        DataRow(cells: [
          DataCell(Text('SUZUKA Lacquer 470')),
          DataCell(Text('1 KG')),
          DataCell(Text('1.15.24.1')),
          DataCell(Text('8')),
          DataCell(Text('ID')),
          DataCell(Text('ID')),
        ]),
        DataRow(cells: [
          DataCell(Text('SUZUKA Lacquer 470')),
          DataCell(Text('1 KG')),
          DataCell(Text('1.15.24.1')),
          DataCell(Text('8')),
          DataCell(Text('ID')),
          DataCell(Text('ID')),
        ]),
      ],
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