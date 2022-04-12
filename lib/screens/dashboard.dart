
import 'package:flutter/material.dart';
import 'package:utility_warehouse/settings/configuration.dart';
import 'package:utility_warehouse/widget/textView.dart';

class Dashboard extends StatefulWidget {

  const Dashboard({Key key}) : super(key: key);

  @override
  DashboardState createState() => DashboardState();
}


class DashboardState extends State<Dashboard> {
  DateTime currentBackPressTime;
  
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
            Material(
              color: Colors.yellow,
              child: InkWell(
                onTap: () {},
              )
            ),
            Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                
              )
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text('sdsd')
                  ),
                  Expanded(
                    child: Text('axax')
                  ),
                ],
              ),
            )
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