import 'package:flutter/material.dart';
import 'package:utility_warehouse/settings/configuration.dart';
import 'package:utility_warehouse/tools/function.dart';
import 'package:utility_warehouse/widget/button.dart';
import 'package:utility_warehouse/widget/textView.dart';

class ProcessOpnameData extends StatefulWidget {

  const ProcessOpnameData({Key key}) : super(key: key);

  @override
  ProcessOpnameDataState createState() => ProcessOpnameDataState();
}


class ProcessOpnameDataState extends State<ProcessOpnameData> {
  String selectedDaySequence = "1";
  String selectedCountPIC = "1";
  String selectedDataType = "Stock Opname";
  
  // String selectedPIC = "Andi";
  List<String> selectedPIC = ["Andi", "Andi"];
  List<List<String>> selectedListPIC = [];

  int totalItem = 200;

  List<Color> selectedDay = [];

  var helperList = <HelperItem>[
    HelperItem(1, 'Andi', false),
    HelperItem(2, 'Tommy', false),
    HelperItem(3, 'Jerry', false),
    HelperItem(4, 'Alex', false),
    HelperItem(5, 'Berto', false),
  ];

  // static final List<GlobalKey> _key = List.generate(20, (index) => GlobalKey());
  final List<GlobalObjectKey<FormState>> _key = List.generate(20, (index) => GlobalObjectKey<FormState>(index));

  StateSetter _setState;

  @override
  void initState() {
    super.initState();
    selectedListPIC = new List.generate(2, (i) => ["Andi", "Tommy", "Jerry"]);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    // for(int i = 0; i < 20; i ++) {
    //   selectedDay.add
    // }
    await initColorWidget();
  }

  void initColorWidget() {
    selectedDay.add(Color(0xFFFFFFFF));
    for(int i = 0; i < 19; i++){
      selectedDay.add(Color(0xFF0066ff));
    }
  }
  
  @override
  Widget build(BuildContext context) {
    Configuration config = Configuration.of(context);
    
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      bottomNavigationBar: Button(
        disable: false,
        child: TextView('Process', 3, color: Colors.white, caps: true),
        onTap: () {
        },
      ),
      body: Stack(
        children: [
          Container(
            height: mediaHeight,
            width: mediaWidth,
            color: Color(0xFF1A2980),
          ),
          Container(
            height: mediaHeight*0.5,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 30),
                    Row(
                      children: [
                        Container(
                          child: TextView("Data Type", 2, color: Colors.white),
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
                                setState(() {
                                  for(int i = 0; i < 20; i++){
                                    if(i!=index) {
                                      selectedDay[i] = Color(0xFF0066ff);
                                    }
                                  }
                                  selectedDay[index] = Colors.white;
                                  Scrollable.ensureVisible(_key[index].currentContext);
                                });
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: TextView("", 4),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Container(
                                  child: TextView("Kepala Gudang", 4),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 30),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: TextView("", 4),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Container(
                                  child: TextView(":", 4),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 30),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: TextView("", 4),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Container(
                                  child: TextView("Rahman Yuliansyah", 4),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Container(
                                  child: TextView("Tipe Data", 4),
                                ),
                              ),
                              Container(
                                child: TextView("Kepala Gudang", 4, color: Colors.transparent),
                              ),
                            ],
                          ),
                          SizedBox(width: 30),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Container(
                                  child: TextView(":", 4),
                                ),
                              ),
                              Container(
                                child: TextView(":", 4, color: Colors.transparent),
                              ),
                            ],
                          ),
                          SizedBox(width: 30),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Container(
                                  height: 40,
                                  child: DropdownButtonHideUnderline(
                                    child: ButtonTheme(
                                      alignedDropdown: true,
                                      child: DropdownButton<String>(
                                        dropdownColor: Colors.white,
                                        value: selectedDataType,
                                        icon: Icon(Icons.keyboard_arrow_down, color: config.grayColor),
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedDataType = newValue;
                                          });
                                        },
                                        items: <String>['Stock Opname','Stock Opname Difference']
                                        .map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: TextView(value, 4),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.red, width: 1.5),
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                  ),
                                ),
                              ),
                              Container(
                                child: TextView("Rahman Yuliansyah", 4, color: Colors.transparent),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Center(
                        child: Button(
                          disable: false,
                          child: TextView('Pilih Helper', 3, color: Colors.white, caps: false),
                          onTap: () {
                            print("object");
                            showDialog (
                              context: context,
                              barrierDismissible: false,
                              builder: (context){
                                return WillPopScope(
                                  onWillPop: null,
                                  child: AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(7.5)),
                                    ),
                                    content: StatefulBuilder(
                                      builder: (BuildContext context, StateSetter setState) {
                                      _setState = setState;
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(bottom: 30),
                                            child: Container(
                                              child: TextView("Pilih Helper", 3),
                                            ),
                                          ),
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: List.generate(helperList.length,(index){
                                                var item = helperList[index];
                                                return Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                  child: FilterChip(
                                                    label: TextView(item.name, 4),
                                                    selected: item.isSelected,
                                                    onSelected: (_) {
                                                      _setState(() {
                                                        item.isSelected = !item.isSelected;
                                                      });
                                                    },
                                                    selectedColor: config.lightOpactityBlueColor,
                                                  ),
                                                );
                                              }),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 30),
                                            child: Align(
                                              alignment: Alignment.bottomRight,
                                              child: Container(
                                                child: Button(
                                                  disable: false,
                                                  child: TextView('OK', 3, color: Colors.white, caps: false),
                                                  onTap: (){
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                  )
                                );
                              }
                            );
                            // Alert(
                            //   context: context,
                            //   title: "Pilih Helper",
                            //   content: 
                            //   cancel: false,
                            //   type: "warning",
                            //   defaultAction: () {
                                
                            //   }
                            // );
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Divider(thickness: 3),
                      ),
                      //pic section
                      Container(
                        child: StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                          _setState = setState;
                          return Column(
                            children: List.generate(helperList.length,(index){
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      helperList[index].isSelected ?
                                      Container(
                                        child: TextView("Helper "+(index+1).toString(), 4),
                                      )
                                      :
                                      Container(),
                                      helperList[index].isSelected ?
                                      Container(
                                        child: TextView(helperList[index].name, 4),
                                      )
                                      :
                                      Container(),
                                    ],
                                  )
                                ],
                              );
                            }),
                          );
                        }),
                      ),

                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            child: TextView("Jumlah Helper", 4),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Container(
                              child: TextView(":", 4),
                            ),
                          ),
                          // Container(
                          //   height: 40,
                          //   child: DropdownButtonHideUnderline(
                          //     child: ButtonTheme(
                          //       alignedDropdown: true,
                          //       child: DropdownButton<String>(
                          //         dropdownColor: Colors.white,
                          //         value: selectedCountPIC,
                          //         icon: Icon(Icons.keyboard_arrow_down, color: config.grayColor),
                          //         onChanged: (newValue) {
                          //           setState(() {
                          //             selectedCountPIC = newValue;
                          //           });
                          //         },
                          //         items: <String>['1','2','3','4','5']
                          //         .map<DropdownMenuItem<String>>((String value) {
                          //           return DropdownMenuItem<String>(
                          //             value: value,
                          //             child: TextView(value, 4),
                          //           );
                          //         }).toList(),
                          //       ),
                          //     ),
                          //   ),
                          //   decoration: BoxDecoration(
                          //     border: Border.all(color: config.darkOpacityBlueColor, width: 1.5),
                          //     borderRadius: BorderRadius.all(Radius.circular(8)),
                          //   ),
                          // ),
                          // SizedBox(width: 15),
                          Button(
                            disable: false,
                            child: TextView('Pilih Helperxx', 3, color: Colors.white, caps: false),
                            onTap: () {
                              print("object");
                              Alert(
                                context: context,
                                title: "Info,",
                                content: Text("Pilih Helper"),
                                cancel: false,
                                type: "warning",
                                defaultAction: () {
                                  
                                }
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Container(
                        child: Column(
                          children: List.generate(int.parse(selectedCountPIC), (index){
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        child: TextView("PIC Helper "+(index+1).toString(), 4)
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 15),
                                        child: Container(
                                          child: TextView(":", 4),
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: DropdownButtonHideUnderline(
                                          child: ButtonTheme(
                                            alignedDropdown: true,
                                            child: DropdownButton<String>(
                                              dropdownColor: Colors.white,
                                              value: selectedPIC[index],
                                              icon: Icon(Icons.keyboard_arrow_down, color: config.grayColor),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  selectedPIC[index] = newValue;
                                                  // selectedListPIC = new List.generate(int.parse(newValue), (i) => ["Andi", "Tommy", "Jerry"]);
                                                });
                                              },
                                              items: selectedListPIC[index]
                                              .map<DropdownMenuItem<String>>((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: TextView(value, 4),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.red, width: 1.5),
                                          borderRadius: BorderRadius.all(Radius.circular(8)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                      

                      ////////////////
                      // SizedBox(height: 50),
                      // Center(
                      //   child: Column(
                      //     children: List.generate(int.parse(selectedCountPIC), (index){
                      //       return Padding(
                      //         padding: EdgeInsets.only(bottom: 30),
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //           mainAxisSize: MainAxisSize.min,
                      //           children: [
                      //             Container(
                      //               height: 40,
                      //               child: DropdownButtonHideUnderline(
                      //                 child: ButtonTheme(
                      //                   alignedDropdown: true,
                      //                   child: DropdownButton<String>(
                      //                     dropdownColor: Colors.white,
                      //                     value: selectedListPIC[index],
                      //                     icon: Icon(Icons.keyboard_arrow_down, color: config.grayColor),
                      //                     onChanged: (newValue) {
                      //                       int countValid = 0;
                      //                       for(int i = 0; i < int.parse(selectedCountPIC); i++){
                      //                         if(i!=index && newValue == selectedListPIC[i]) {
                      //                           print("TIDAK BOEL");
                      //                         }
                      //                       }
                      //                       setState(() {
                      //                         selectedListPIC[index] = newValue;
                      //                       });
                      //                     },
                      //                     items: listPIC
                      //                     .map<DropdownMenuItem<String>>((String value) {
                      //                       return DropdownMenuItem<String>(
                      //                         value: value,
                      //                         child: TextView(value, 4),
                      //                       );
                      //                     }).toList(),
                      //                   ),
                      //                 ),
                      //               ),
                      //               decoration: BoxDecoration(
                      //                 border: Border.all(color: config.darkOpacityBlueColor, width: 1.5),
                      //                 borderRadius: BorderRadius.all(Radius.circular(8)),
                      //               ),
                      //             ),
                      //             Padding(
                      //               padding: EdgeInsets.symmetric(horizontal: 15),
                      //               child: Container(
                      //                 child: TextView(":", 4),
                      //               ),
                      //             ),
                      //             TextView("Item 1 - 50", 4),
                      //           ],
                      //         ),
                      //       );
                      //     }),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      )
      
      
      
      // CustomScrollView(
      //   slivers: [
      //     SliverAppBar(
      //       pinned: false,
      //       snap: false,
      //       floating: false,
      //       expandedHeight: 480,
      //       title: Text("HEHEHE"),
      //       flexibleSpace: FlexibleSpaceBar(
      //         titlePadding: const EdgeInsetsDirectional.only(start: 16.0, bottom: 16.0),
      //         background: Container(
      //           padding: EdgeInsets.symmetric(horizontal: 30),
      //           color: Color(0xFF1A2980),
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               SizedBox(height: 30),
      //               Row(
      //                 children: [
      //                   Container(
      //                     child: TextView("Data Type", 2, color: Colors.white),
      //                   ),
      //                   SizedBox(width: 15),
      //                   Expanded(
      //                     child: Container(
      //                       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      //                       decoration: BoxDecoration(
      //                         color: Colors.white, borderRadius: BorderRadius.circular(10)
      //                       ),
      //                       child: DropdownButton<String>(
      //                         isExpanded: true,
      //                         value: selectedDataType,
      //                         onChanged: (String newValue) =>
      //                           setState(() => selectedDataType = newValue),
      //                         items: <String>['Stock Opname','Stock Opname Difference']
      //                             .map<DropdownMenuItem<String>>(
      //                                 (String value) => DropdownMenuItem<String>(
      //                                       value: value,
      //                                       child: TextView(value, 4, color: Colors.black),
      //                                     ))
      //                             .toList(),
      //                         icon: Icon(Icons.keyboard_arrow_down),
      //                         iconSize: 30,
      //                         underline: SizedBox(),
      //                       ),
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //               SizedBox(height: 30),
      //               Center(
      //                 child: Container(
      //                   child: TextView("Urutan Hari Ke", 2, color: Colors.white),
      //                 ),
      //               ),
      //               SingleChildScrollView(
      //                 scrollDirection: Axis.horizontal,
      //                 child: Row(
      //                   children: List.generate(20, (index){
      //                     return Container(
      //                       key: _key[index],
      //                       height: 200,
      //                       width: 100,
      //                       margin: EdgeInsets.only(top: 15, left: 10, right: 10),
      //                       decoration: new BoxDecoration(
      //                         color: selectedDay[index],
      //                         border: Border.all(color: Colors.black, width: 0.0),
      //                         borderRadius: new BorderRadius.all(Radius.elliptical(100, 100)),
      //                       ),
      //                       child: InkWell(
      //                         onTap: (){
      //                           setState(() {
      //                             for(int i = 0; i < 20; i++){
      //                               if(i!=index) {
      //                                 selectedDay[i] = Color(0xFF0066ff);
      //                               }
      //                             }
      //                             selectedDay[index] = Colors.white;
      //                             Scrollable.ensureVisible(_key[index].currentContext);
      //                           });
      //                         },
      //                         child: Column(
      //                           children: [
      //                             (index+1) >= 10 ? SizedBox(height: 7) : Container(),
      //                             Container(
      //                               padding: (index+1) >= 10 ? EdgeInsets.all(18) : EdgeInsets.all(20),
      //                               decoration: new BoxDecoration(
      //                                 color: Colors.white,
      //                                 shape: BoxShape.circle,
      //                                 border: Border.all(color: Colors.black, width: 0.0),
      //                               ),
      //                               child: Text((index+1).toString(), style: TextStyle(fontSize: (index+1) >= 10 ? 14 : 20)),
      //                             ),
      //                             // Container(
      //                             //   child: TextView("Sudah".toString(), 1, color: Colors.white)
      //                             // )
      //                           ],
      //                         ),
      //                       )
      //                     );
      //                   }),
      //                 ),
      //               )
      //             ],
      //           ),
      //         )
      //       ),
      //     ),

      //     SliverToBoxAdapter(
      //       child: Scrollbar(
      //         child: Container(
      //               // height: 300,
      //               color: Color(0xFF1A2980),
      //               child: Container(
      //                 decoration: BoxDecoration(
      //                   color: Colors.white,
      //                   borderRadius: BorderRadius.only(
      //                     topLeft: Radius.circular(80),
      //                     topRight: Radius.circular(80),
      //                   )
      //                 ),
      //                 child: Column(
      //                   children: [
      //                     Text("Hi modal sheet"),
      //                     Text("Hi modal sheet"),
      //                     Text("Hi modal sheet"),
      //                     Text("Hi modal sheet"),
      //                     Text("Hi modal sheet"),
      //                     Text("Hi modal sheet"),
      //                     Text("Hi modal sheet"),
      //                     Text("Hi modal sheet"),
      //                     Text("Hi modal sheet"),
      //                     Text("Hi modal sheet"),
      //                     Text("Hi modal sheet"),
      //                     Text("Hi modal sheet"),
      //                     Text("Hi modal sheet"),
      //                     Text("Hi modal sheet"),
      //                     Text("Hi modal sheet"),
      //                     Text("Hi modal sheet"),
      //                     Text("Hi modal sheet"),
      //                     Text("Hi modal sheet"),
      //                     Text("Hi modal sheet"),
      //                     Text("Hi modal sheet"),
      //                     Text("Hi modal sheet"),
      //                     Text("Hi modal sheet"),
      //                     Text("Hi modal sheet"),
      //                     Text("Hi modal sheet"),
      //                     Text("Hi modal sheet"),
      //                     Text("Hi modal sheet"),
      //                     Text("Hi modal sheet"),
      //                     Text("Hi modal sheet"),
      //                     Text("Hi modal sheet"),
      //                     Text("Hi modal sheet"),
      //                     Text("Hi modal sheet"),
      //                     Text("Hi modal sheet"),
      //                     Text("Hi modal sheet"),
      //                     Text("Hi modal sheet"),
      //                   ],
      //                 )
      //               ),
      //             ),
      //       ),
      //     )

      //     // SliverFillRemaining(
      //     //   hasScrollBody: false,
      //     //   child: Container(
      //     //     // height: 300,
      //     //     color: Color(0xFF1A2980),
      //     //     child: Container(
      //     //       decoration: BoxDecoration(
      //     //         color: Colors.white,
      //     //         borderRadius: BorderRadius.only(
      //     //           topLeft: Radius.circular(80),
      //     //           topRight: Radius.circular(80),
      //     //         )
      //     //       ),
      //     //       child: Column(
      //     //         children: [
      //     //           Text("Hi modal sheet"),
      //     //           Text("Hi modal sheet"),
      //     //           Text("Hi modal sheet"),
      //     //           Text("Hi modal sheet"),
      //     //           Text("Hi modal sheet"),
      //     //           Text("Hi modal sheet"),
      //     //           Text("Hi modal sheet"),
      //     //           Text("Hi modal sheet"),
      //     //           Text("Hi modal sheet"),
      //     //           Text("Hi modal sheet"),
      //     //           Text("Hi modal sheet"),
      //     //           Text("Hi modal sheet"),
      //     //           Text("Hi modal sheet"),
      //     //           Text("Hi modal sheet"),
      //     //           Text("Hi modal sheet"),
      //     //           Text("Hi modal sheet"),
      //     //           Text("Hi modal sheet"),
      //     //           Text("Hi modal sheet"),
      //     //           Text("Hi modal sheet"),
      //     //           Text("Hi modal sheet"),
      //     //           Text("Hi modal sheet"),
      //     //           Text("Hi modal sheet"),
      //     //           Text("Hi modal sheet"),
      //     //           Text("Hi modal sheet"),
      //     //           Text("Hi modal sheet"),
      //     //           Text("Hi modal sheet"),
      //     //           Text("Hi modal sheet"),
      //     //           Text("Hi modal sheet"),
      //     //           Text("Hi modal sheet"),
      //     //           Text("Hi modal sheet"),
      //     //           Text("Hi modal sheet"),
      //     //           Text("Hi modal sheet"),
      //     //           Text("Hi modal sheet"),
      //     //           Text("Hi modal sheet"),
      //     //         ],
      //     //       )
      //     //     ),
      //     //   ),
      //     // ),

      //   ],
      // )

      // Stack(
      //   children: [
      //     Container(
      //       height: mediaHeight,
      //       width: mediaWidth,
      //       // color: Colors.white,
      //       child: Image.asset("assets/illustration/bg3.png", fit: BoxFit.fill),
      //     ),
      //     SafeArea(
      //       child: Padding(
      //         padding: EdgeInsets.only(top: 60),
      //         child: Align(
      //           alignment: Alignment.topCenter,
      //           child: TextView("Process Opname Data", 1)
      //         ),
      //       ),
      //     ),
      //     Padding(
      //       padding: EdgeInsets.symmetric(horizontal: 30),
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               Expanded(
      //                 child: TextView("Kepala Gudang", 4),
      //               ),
      //               TextView(":", 4),
      //               SizedBox(width: 30),
      //               Expanded(
      //                 child: Column(
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   children: [
      //                     TextView("Rahman Yuliansyah", 4),
      //                   ],
      //                 ),
      //               )
      //             ],
      //           ),
      //           SizedBox(height: 20),
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               Expanded(child: TextView("Data Type", 4)),
      //               TextView(":", 4),
      //               SizedBox(width: 30),
      //               Expanded(
      //                 child: Column(
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   children: [
                          // Container(
                          //   height: 40,
                          //   child: DropdownButtonHideUnderline(
                          //     child: ButtonTheme(
                          //       alignedDropdown: true,
                          //       child: DropdownButton<String>(
                          //         dropdownColor: Colors.white,
                          //         value: selectedDataType,
                          //         icon: Icon(Icons.keyboard_arrow_down, color: config.grayColor),
                          //         onChanged: (newValue) {
                          //           setState(() {
                          //             selectedDataType = newValue;
                          //           });
                          //         },
                          //         items: <String>['Stock Opname','Stock Opname Difference']
                          //         .map<DropdownMenuItem<String>>((String value) {
                          //           return DropdownMenuItem<String>(
                          //             value: value,
                          //             child: TextView(value, 4),
                          //           );
                          //         }).toList(),
                          //       ),
                          //     ),
                          //   ),
                          //   decoration: BoxDecoration(
                          //     border: Border.all(color: config.darkOpacityBlueColor, width: 1.5),
                          //     borderRadius: BorderRadius.all(Radius.circular(8)),
                          //   ),
                          // ),
      //                   ],
      //                 ),
      //               )
      //             ],
      //           ),
      //           SizedBox(height: 20),
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               Expanded(
      //                 child: TextView("Urutan Hari", 4),
      //               ),
      //               TextView(":", 4),
      //               SizedBox(width: 30),
      //               Expanded(
      //                 child: Column(
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   children: [
      //                     Container(
      //                       height: 40,
      //                       child: DropdownButtonHideUnderline(
      //                         child: ButtonTheme(
      //                           alignedDropdown: true,
      //                           child: DropdownButton<String>(
      //                             dropdownColor: Colors.white,
      //                             value: selectedDaySequence,
      //                             icon: Icon(Icons.keyboard_arrow_down, color: config.grayColor),
      //                             onChanged: (newValue) {
      //                               setState(() {
      //                                 selectedDaySequence = newValue;
      //                               });
      //                             },
      //                             items: <String>['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20']
      //                             .map<DropdownMenuItem<String>>((String value) {
      //                               return DropdownMenuItem<String>(
      //                                 value: value,
      //                                 child: TextView(value, 4),
      //                               );
      //                             }).toList(),
      //                           ),
      //                         ),
      //                       ),
      //                       decoration: BoxDecoration(
      //                         border: Border.all(color: config.darkOpacityBlueColor, width: 1.5),
      //                         borderRadius: BorderRadius.all(Radius.circular(8)),
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               )
      //             ],
      //           ),
      //           SizedBox(height: 20),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Expanded(child: TextView("Pembagian Jumlah PIC", 4)),
                //     TextView(":", 4),
                //     SizedBox(width: 30),
                //     Expanded(
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Container(
                //             height: 40,
                //             child: DropdownButtonHideUnderline(
                //               child: ButtonTheme(
                //                 alignedDropdown: true,
                //                 child: DropdownButton<String>(
                //                   dropdownColor: Colors.white,
                //                   value: selectedCountPIC,
                //                   icon: Icon(Icons.keyboard_arrow_down, color: config.grayColor),
                //                   onChanged: (newValue) {
                //                     setState(() {
                //                       selectedCountPIC = newValue;
                //                     });
                //                   },
                //                   items: <String>['1','2','3','4','5']
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
                //         ],
                //       ),
                //     )
                //   ],
                // ),

      //           //pic section
      //           SizedBox(height: 30),
      //           Container(
      //             child: Column(
      //               children: List.generate(int.parse(selectedCountPIC), (index){
      //                 return Row(
      //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                   children: [
      //                     Container(
      //                       height: 40,
      //                       child: DropdownButtonHideUnderline(
      //                         child: ButtonTheme(
      //                           alignedDropdown: true,
      //                           child: DropdownButton<String>(
      //                             dropdownColor: Colors.white,
      //                             value: selectedListPIC[index],
      //                             icon: Icon(Icons.keyboard_arrow_down, color: config.grayColor),
      //                             onChanged: (newValue) {
      //                               int countValid = 0;
      //                               for(int i = 0; i < int.parse(selectedCountPIC); i++){
      //                                 if(newValue == selectedListPIC[i]) {
                                        
      //                                 }
      //                               }
      //                               setState(() {
      //                                 selectedListPIC[index] = newValue;
      //                               });
      //                             },
      //                             items: listPIC
      //                             .map<DropdownMenuItem<String>>((String value) {
      //                               return DropdownMenuItem<String>(
      //                                 value: value,
      //                                 child: TextView(value, 4),
      //                               );
      //                             }).toList(),
      //                           ),
      //                         ),
      //                       ),
      //                       decoration: BoxDecoration(
      //                         border: Border.all(color: config.darkOpacityBlueColor, width: 1.5),
      //                         borderRadius: BorderRadius.all(Radius.circular(8)),
      //                       ),
      //                     ),
      //                     Expanded(
      //                       child: TextView(listPIC[index], 4)
      //                     ),
      //                     // Container(                                                                        
      //                     //   margin: EdgeInsets.symmetric(vertical: 10),
      //                     //   child: Divider(
      //                     //     height: 20,
      //                     //     thickness: 4,
      //                     //     color: config.lighterGrayColor,
      //                     //   ),
      //                     // ),
      //                   ],
      //                 );
      //               }),
      //             ),
      //           ),
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               Expanded(child: TextView("Item 1-50", 4)), //
      //               TextView(":", 4),
      //               SizedBox(width: 30),
      //               Expanded(
      //                 child: Column(
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   children: [
      //                     Container(
      //                       height: 40,
      //                       child: DropdownButtonHideUnderline(
      //                         child: ButtonTheme(
      //                           alignedDropdown: true,
      //                           child: DropdownButton<String>(
      //                             dropdownColor: Colors.white,
      //                             value: selectedCountPIC,
      //                             icon: Icon(Icons.keyboard_arrow_down, color: config.grayColor),
      //                             onChanged: (newValue) {
      //                               setState(() {
      //                                 selectedCountPIC = newValue;
      //                               });
      //                             },
      //                             items: <String>['1','2','3','4','5']
      //                             .map<DropdownMenuItem<String>>((String value) {
      //                               return DropdownMenuItem<String>(
      //                                 value: value,
      //                                 child: TextView(value, 4),
      //                               );
      //                             }).toList(),
      //                           ),
      //                         ),
      //                       ),
      //                       decoration: BoxDecoration(
      //                         border: Border.all(color: config.darkOpacityBlueColor, width: 1.5),
      //                         borderRadius: BorderRadius.all(Radius.circular(8)),
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               )
      //             ],
      //           ),
            
      //         ],
      //       ),
      //     )
      
          
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
      // ),
    );
  }

}

class HelperItem {
  final int id;
  final String name;
  bool isSelected;

  HelperItem(this.id, this.name, this.isSelected);
}