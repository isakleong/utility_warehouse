import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

import 'package:utility_warehouse/screens/routing.dart';
import 'package:utility_warehouse/settings/configuration.dart';
import 'package:utility_warehouse/tools/function.dart';

void main() async {
  // testing mobile ui
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.portraitDown,
  //   ]);

  HttpOverrides.global = MyHttpOverrides();
  
  runApp(
    Configuration(
      child: MaterialApp (
        title: config.apkName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.black.withOpacity(0),
          )
        ),
        onGenerateRoute: (RouteSettings settings) {
          List<String> pages = [];
          int mode = 0;
          int id = 0;
    
          pages = settings.name.split("/");
    
          // contoh usagenya route/id/mode
          // optional : arguments
    
          // mode 0 = undefined (tidak dari mana2)
          // mode 1 = data from api resource
          // mode 2 = data from local storage
          // mode 3 = data from model

          // String route = "detailInfo/${item.id}/3";
          //Navigator.pushNamed(context, route, arguments: arguments);
          
          if (pages.length > 1) {
            id = int.tryParse(pages[1]);
          }
          if (pages.length > 2) {
            mode = int.tryParse(pages[2]);
          }
    
          return routing(mode, id, pages, settings);
        },
      ),
    )
  );

}
