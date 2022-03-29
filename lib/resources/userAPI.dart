// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' show Client;
// import 'package:utility_warehouse/models/userModel.dart';
// import 'package:utility_warehouse/settings/configuration.dart';
// import 'package:utility_warehouse/tools/function.dart';

// class UserAPI {
//  Client client = Client();

//  Future<String> login(final context, {String parameter=""}) async {
//    String isLoginSuccess = "";
//    User user;
//    String url = "";

//    bool isUrlAddress_1 = false, isUrlAddress_2 = false;
//    String url_address_1 = config.baseUrl + "/" + "getUserCoba.php" + (parameter == "" ? "" : "?" + parameter);
//    String url_address_2 = config.baseUrlAlt + "/" + "getUserCoba.php" + (parameter == "" ? "" : "?" + parameter);

//    try {
// 		  final conn_1 = await connectionTest(url_address_1, context);
//      printHelp("GET STATUS 1 "+conn_1);
//      if(conn_1 == "OK"){
//        isUrlAddress_1 = true;
//      }
// 	  } on SocketException {
//      isUrlAddress_1 = false;
//      isLoginSuccess = "Gagal terhubung dengan server";
//    }

//    if(isUrlAddress_1) {
//      url = url_address_1;
//    } else {
//      try {
//        final conn_2 = await connectionTest(url_address_2, context);
//        printHelp("GET STATUS 2 "+conn_2);
//        if(conn_2 == "OK"){
//          isUrlAddress_2 = true;
//        }
//      } on SocketException {
//        isUrlAddress_2 = false;
//        isLoginSuccess = "Gagal terhubung dengan server";
//      }
//    }
//    if(isUrlAddress_2){
//      url = url_address_2;
//    }

//    if(url != "") {
//      try {
//        final response = await client.get(url);

//        if(response.body.toString() == "restricted") {
//          isLoginSuccess = "Cabang Anda belum dapat menggunakan aplikasi ini";
//        } else {
//          if(response.body.toString() != "false") {
//            if(response.body.toString() == "autolimit") {
//              isLoginSuccess = "Untuk menaikkan limit dapat menggunakan Program Utility NAV";
//            } else {
//              var parsedJson = jsonDecode(response.body);

//              user = User.fromJson(parsedJson[0]);
//              printHelp("CEK MOD "+user.ModuleId.toString());

//              if(user.Id != ""){
//                isLoginSuccess = "OK";
//              }
//            }
//          } else {
//            isLoginSuccess = "Username atau Password salah";
//          }
//        }
//      } catch (e) {
//        isLoginSuccess = "Gagal terhubung dengan server";
//        printHelp(e);
//      }
//    } else {
//      isLoginSuccess = "Gagal terhubung dengan server";
//    }

//    return isLoginSuccess;
//  }

// }

// final userAPI = UserAPI();