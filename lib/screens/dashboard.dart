
import 'package:flutter/material.dart';
import 'package:utility_warehouse/models/userModel.dart';
import 'package:utility_warehouse/settings/configuration.dart';
import 'package:utility_warehouse/tools/function.dart';
import 'package:utility_warehouse/widget/button.dart';
import 'package:utility_warehouse/widget/textView.dart';

class Dashboard extends StatefulWidget {
  final User userModel;

  const Dashboard({Key key, this.userModel}) : super(key: key);

  @override
  DashboardState createState() => DashboardState();
}


class DashboardState extends State<Dashboard> {
  User userModel;
  
  DateTime currentBackPressTime;

  @override
  void initState() {
    super.initState();
    setState(() {
      userModel = widget.userModel;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    printHelp("cek ya "+userModel.userId);
    printHelp("cek ya "+userModel.moduleId[0]);
  }
  
  @override
  Widget build(BuildContext context) {
    Configuration config = Configuration.of(context);
    
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      body: WillPopScope(
        onWillPop: willPopScope,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: false,
              snap: false,
              floating: false,
              expandedHeight: 480,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(80), bottomRight: Radius.circular(80)),
            ),
            leading: Button(
              disable: false,
              colorUsed: Color(0xFFFFFFFF),
              child: Icon(Icons.arrow_back, color: Colors.black),
              onTap: () {
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
            ),
            flexibleSpace: FlexibleSpaceBar(
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
                child: Image.asset('assets/illustration/bg_process_opname_1.png', fit: BoxFit.fill),
              )),
            ),

            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: List.generate(userModel.moduleId.length,(index){
                  return Card(
                    margin: EdgeInsets.all(20),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        if(userModel.moduleId[index].toLowerCase().replaceAll(RegExp(r"\s+"), "")=="adjustmentstockopname") {

                        } else if(userModel.moduleId[index].toLowerCase().replaceAll(RegExp(r"\s+"), "")=="monitoringstockopname") {

                        } else if(userModel.moduleId[index].toLowerCase().replaceAll(RegExp(r"\s+"), "")=="downloadopnamedata") {

                        } else if(userModel.moduleId[index].toLowerCase().replaceAll(RegExp(r"\s+"), "")=="pick") {
                          Navigator.pushNamed(context, "pick");
                        } else if(userModel.moduleId[index].toLowerCase().replaceAll(RegExp(r"\s+"), "")=="processopnamedata") {
                          Navigator.pushNamed(context, "processOpnameData");
                        } else if(userModel.moduleId[index].toLowerCase().replaceAll(RegExp(r"\s+"), "")=="reportstockopname") {
                          // Navigator.pushNamed(context, "reportstockopname");
                        } else if(userModel.moduleId[index].toLowerCase().replaceAll(RegExp(r"\s+"), "")=="stockopname") {
                          // Navigator.pushNamed(context, "stockopname");
                        } else if(userModel.moduleId[index].toLowerCase().replaceAll(RegExp(r"\s+"), "")=="stockopnamedifference") {
                          // Navigator.pushNamed(context, "stockopnamedifference");
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