
import 'package:flutter/material.dart';
import 'package:utility_warehouse/settings/configuration.dart';
import 'package:utility_warehouse/widget/textView.dart';

class Dashboard extends StatefulWidget {
  // final String userId;

  const Dashboard({Key key}) : super(key: key);

  @override
  DashboardState createState() => DashboardState();
}


class DashboardState extends State<Dashboard> {
  String userId;
  DateTime currentBackPressTime;

  @override
  void initState() {
    super.initState();
    // userId = widget.userId;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // if(userId.toLowerCase()=="warehouse manager") {

    // }
  }
  
  @override
  Widget build(BuildContext context) {
    Configuration config = Configuration.of(context);
    
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      body: WillPopScope(
        onWillPop: willPopScope,
        child: Stack(
          children: [
            Container(
              height: mediaHeight,
              width: mediaWidth,
              // color: Colors.white,
              child: Image.asset("assets/illustration/bg3.png", fit: BoxFit.fill),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  margin: EdgeInsets.all(20),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.pushNamed(context, "processOpnameData");
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
                            child: TextView("Process Opname Data", 1)
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Card(
                  margin: EdgeInsets.all(20),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            child: Icon(Icons.padding, size: 100, color: config.darkOpacityBlueColor)
                          ),
                          SizedBox(width: 30),
                          Expanded(
                            child: TextView("Stock Opname Difference", 1)
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
      
            
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //      InkWell(
            //          onTap: () {},
            //          child: Center(
            //            child: Row(
            //              mainAxisAlignment: MainAxisAlignment.center,
            //              children: [
            //                Center(
            //                  child: Card(
            //                    shape: RoundedRectangleBorder(
            //                        borderRadius: BorderRadius.circular(100.0)),
            //                    elevation: 5,
            //                    child: Padding(
            //                      padding: const EdgeInsets.all(10.0),
            //                      child: Icon(Icons.padding, size: 80, color: config.darkOpacityBlueColor),
            //                    ),
            //                  ),
            //                ),
            //                SizedBox(width: 20),
            //                Padding(
            //                  padding: const EdgeInsets.all(10.0),
            //                  child: Container(
            //                    alignment: Alignment.bottomCenter,
            //                    child: TextView('Proses Opname Data', 1)
            //                  ),
            //                ),
            //              ],
            //            ),
            //          ),
            //       ),
            //   ],
            // ),

          ],
        )
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