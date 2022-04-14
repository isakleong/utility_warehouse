
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:utility_warehouse/settings/configuration.dart';
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
  
  List<String> selectedItemPIC = [];

  List<String> listPIC = ["Andi", "Tommy", "Jerry"];
  List<String> selectedListPIC = ["Andi", "Tommy", "Jerry"];

  int totalItem = 200;

  List<Color> selectedDay = [];

  @override
  void initState() {
    super.initState();
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
    for(int i = 0; i < 20; i++){
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: false,
            snap: false,
            floating: false,
            expandedHeight: 480,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsetsDirectional.only(start: 16.0, bottom: 16.0),
              background: Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                color: Color(0xFF1A2980),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: TextView("Kepala Gudang : Rahman Yuliansyah", 2, color: Colors.white)
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(20, (index){
                          return Container(
                            height: 200,
                            width: 100,
                            margin: EdgeInsets.only(top: 40, left: 15, right: 15),
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
                                });
                              },
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(20),
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.black, width: 0.0),
                                    ),
                                    child: AutoSizeText((index+1).toString(), style: TextStyle(fontSize: 20), maxLines: 2),
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
                    )
                  ],
                ),
              )
            ),
          ),

          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              // height: 300,
              color: Color(0xFF1A2980),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(80),
                    topRight: Radius.circular(80),
                  )
                ),
                child: Center(
                  child: Text("Hi modal sheet"),
                )
              ),
            ),
          ),

        ],
      )
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
      //                     Container(
      //                       height: 40,
      //                       child: DropdownButtonHideUnderline(
      //                         child: ButtonTheme(
      //                           alignedDropdown: true,
      //                           child: DropdownButton<String>(
      //                             dropdownColor: Colors.white,
      //                             value: selectedDataType,
      //                             icon: Icon(Icons.keyboard_arrow_down, color: config.grayColor),
      //                             onChanged: (newValue) {
      //                               setState(() {
      //                                 selectedDataType = newValue;
      //                               });
      //                             },
      //                             items: <String>['Stock Opname','Stock Opname Difference']
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
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               Expanded(child: TextView("Pembagian Jumlah PIC", 4)),
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
      //               Expanded(child: TextView("Item 1-50", 4)), //sdsd
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