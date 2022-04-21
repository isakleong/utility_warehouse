import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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

  // var helperList = <HelperItem>[
  //   HelperItem(1, 'Andi', false),
  //   HelperItem(2, 'Tommy', false),
  //   HelperItem(3, 'Jerry', false),
  //   HelperItem(4, 'Alex', false),
  //   HelperItem(5, 'Berto', false),
  // ];

  var helperList = <String>['Andi', 'Tommy', 'Jerry', 'Alex', 'Berto', 'Recca', 'Isak', 'Rudy'];
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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: TextView("Pilih Helper", 2),
                          ),
                          ChipWidget(
                            helperList,
                            helperSelectedList: selectedHelperList,
                            onSelectionChanged: (selectedList) {
                              setState(() {
                                selectedHelperList = selectedList;
                              });
                            },
                          ),
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
            
          //   Stack(
          //     overflow: Overflow.visible,
              
          //     children: [
          //       Container(
          //         padding: EdgeInsets.only(left: 5,top: 15, right: 5 ,bottom:5),
          //         margin: EdgeInsets.only(top: 10),
          //         decoration: BoxDecoration(
          //           shape: BoxShape.rectangle,
          //           color: Colors.white,
          //           borderRadius: BorderRadius.circular(5),
          //           boxShadow: [
          //             BoxShadow(color: Colors.black,offset: Offset(0,10),
          //             blurRadius: 10
          //             ),
          //           ]
          //         ),
          //         child: Column(
          //           mainAxisSize: MainAxisSize.min,
          //           children: [
          //             TextView("Pilih Helper", 3),
          //             SizedBox(height: 15,),
          //             TextView("Desc Pilih Helper", 3),
          //             SizedBox(height: 22),
          //             ChipWidget(
          //               helperList,
          //               helperSelectedList: selectedHelperList,
          //               onSelectionChanged: (selectedList) {
          //                 setState(() {
          //                   selectedHelperList = selectedList;
          //                 });
          //               },
          //             ),
          //             Align(
          //               alignment: Alignment.bottomRight,
          //               child:   Button(
          //                 child: TextView("Pilih", 4),
          //                 onTap: (){
          //                   setState(() {
          //                     isSubmitHelper = true;
          //                   });
          //                   Navigator.of(context).pop();
          //                 },
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //       Positioned(
          //         left: 5,
          //         right: 5,
          //         top: -60,
          //         child: CircleAvatar(
          //           backgroundColor: Colors.transparent,
          //           radius: 80,
          //           child: Lottie.asset('assets/illustration/helper.json', fit: BoxFit.contain),
          //         ),
          //       ),
          //     ],
          //   ),
          //   // content: ChipWidget(
          //   //   helperList,
          //   //   helperSelectedList: selectedHelperList,
          //   //   onSelectionChanged: (selectedList) {
          //   //     setState(() {
          //   //       selectedHelperList = selectedList;
          //   //     });
          //   //   },
          //   // ),
          //   // actions: <Widget>[
          //   //   Button(
          //   //     child: TextView("Pilih", 4),
          //   //     onTap: (){
          //   //       setState(() {
          //   //         isSubmitHelper = true;
          //   //       });
          //   //       Navigator.of(context).pop();
          //   //     },
          //   //   )
          //   // ],
          // );
        });
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
                    // Row(
                    //   children: [
                    //     Container(
                    //       child: TextView("Data Type", 2, color: Colors.white),
                    //     ),
                    //     SizedBox(width: 15),
                    //     Expanded(
                    //       child: Container(
                    //         padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    //         decoration: BoxDecoration(
                    //           color: Colors.white, borderRadius: BorderRadius.circular(10)
                    //         ),
                    //         child: DropdownButton<String>(
                    //           isExpanded: true,
                    //           value: selectedDataType,
                    //           onChanged: (String newValue) =>
                    //             setState(() => selectedDataType = newValue),
                    //           items: <String>['Stock Opname','Stock Opname Difference']
                    //               .map<DropdownMenuItem<String>>(
                    //                   (String value) => DropdownMenuItem<String>(
                    //                         value: value,
                    //                         child: TextView(value, 4, color: Colors.black),
                    //                       ))
                    //               .toList(),
                    //           icon: Icon(Icons.keyboard_arrow_down),
                    //           iconSize: 30,
                    //           underline: SizedBox(),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
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
                                    border: Border.all(color: config.darkOpacityBlueColor, width: 1.5),
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
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: TextView("Helper "+(index+1).toString(), 4),
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
                                    Container(
                                      child: TextView(":", 4),
                                    ),
                                    Container(
                                      child: TextView("", 4),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 30),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: TextView(selectedHelperList[index], 4),
                                    ),
                                    Container(
                                      child: TextView("", 4),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                      )
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