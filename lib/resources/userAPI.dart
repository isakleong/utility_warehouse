import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' show Client;
import 'package:utility_warehouse/models/result.dart';
import 'package:utility_warehouse/models/userModel.dart';
import 'package:utility_warehouse/settings/configuration.dart';
import 'package:utility_warehouse/tools/function.dart';

class UserAPI {
  Client client = Client();

  Future<Result> login(final context, String username, String password) async {
    Result result;
    User user;
    String url = "";

    bool isUrlAddress_1 = false, isUrlAddress_2 = false;
    String url_address_1 = fetchAPI("users/login.php", context: context);
    String url_address_2 = fetchAPI("users/login.php", context: context, secondary: true);

    // final body = jsonEncode({
    //   "userID":username,
    //   "password":password
    // });

    final body =  <String, String>{
      'userID':username,
      'password':password
    };

    try {
		  final conn_1 = await connectionTest(url_address_1, context);
      printHelp("GET STATUS 1 "+conn_1);
      if(conn_1 == "OK"){
        isUrlAddress_1 = true;
      }
	  } on SocketException {
      isUrlAddress_1 = false;
      result = new Result(code: 500, message: "Gagal terhubung dengan server");
    }

    if(isUrlAddress_1) {
      url = url_address_1;
    } else {
      try {
        final conn_2 = await connectionTest(url_address_2, context);
        printHelp("GET STATUS 2 "+conn_2);
        if(conn_2 == "OK"){
          isUrlAddress_2 = true;
        }
      } on SocketException {
        isUrlAddress_2 = false;
        result = new Result(code: 500, message: "Gagal terhubung dengan server");
      }
    }
    if(isUrlAddress_2){
      url = url_address_2;
    }

    try {
      final response = await client.post(url, headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body);
      var parsedJson = jsonDecode(response.body);
      result = Result.fromJson(parsedJson);

      // if(result.code == 200) {
      //   // User user = User.fromJson(result.data);
      //   result = new Result(code: result.code, message: result.message, data: result.data);
      // } else {
      //   printHelp("cek res "+result.error_message.toString());
      // }
    } catch (e) {
      result = new Result(code: 500, message: "Gagal terhubung dengan server");
      print(e);
    }

    return result;
  }

  Future<User> authValidation(final context, String username, String token) async {
    Result result;
    User user;
    String url = "";

    bool isUrlAddress_1 = false, isUrlAddress_2 = false;
    String url_address_1 = fetchAPI("users/auth_validation.php", context: context);
    String url_address_2 = fetchAPI("users/auth_validation.php", context: context, secondary: true);

    final body =  <String, String>{
      'userID':username,
      'tokenID':token
    };

    try {
		  final conn_1 = await connectionTest(url_address_1, context);
      printHelp("GET STATUS 1 "+conn_1);
      if(conn_1 == "OK"){
        isUrlAddress_1 = true;
      }
	  } on SocketException {
      isUrlAddress_1 = false;
      result = new Result(code: 500, message: "Gagal terhubung dengan server");
    }

    if(isUrlAddress_1) {
      url = url_address_1;
    } else {
      try {
        final conn_2 = await connectionTest(url_address_2, context);
        printHelp("GET STATUS 2 "+conn_2);
        if(conn_2 == "OK"){
          isUrlAddress_2 = true;
        }
      } on SocketException {
        isUrlAddress_2 = false;
        result = new Result(code: 500, message: "Gagal terhubung dengan server");
      }
    }
    if(isUrlAddress_2){
      url = url_address_2;
    }

    try {
      final response = await client.post(url, headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body);
      var parsedJson = jsonDecode(response.body);
      result = Result.fromJson(parsedJson);

      if(result.code == 200) {
        user = User.fromJson(result.data[0]);
      }

    } catch (e) {
      result = new Result(code: 500, message: "Gagal terhubung dengan server");
      print(e);
    }

    return user;
  }



  // Future<String> login(final context, {String parameter=""}) async {
  //   String isLoginSuccess = "";
  //   User user;
  //   String url = "";

  //   bool isUrlAddress_1 = false, isUrlAddress_2 = false;
  //   String url_address_1 = fetchAPI("users/getUserCoba.php", context: context, parameter: parameter);
  //   String url_address_2 = fetchAPI("users/getUserCoba.php", context: context, secondary: true, parameter: parameter);

  //   try {
	// 	  final conn_1 = await connectionTest(url_address_1, context);
  //     printHelp("GET STATUS 1 "+conn_1);
  //     if(conn_1 == "OK"){
  //       isUrlAddress_1 = true;
  //     }
	//   } on SocketException {
  //     isUrlAddress_1 = false;
  //     isLoginSuccess = "Gagal terhubung dengan server";
  //   }

  //   if(isUrlAddress_1) {
  //     url = url_address_1;
  //   } else {
  //     try {
  //       final conn_2 = await connectionTest(url_address_2, context);
  //       printHelp("GET STATUS 2 "+conn_2);
  //       if(conn_2 == "OK"){
  //         isUrlAddress_2 = true;
  //       }
  //     } on SocketException {
  //       isUrlAddress_2 = false;
  //       isLoginSuccess = "Gagal terhubung dengan server";
  //     }
  //   }
  //   if(isUrlAddress_2){
  //     url = url_address_2;
  //   }

  //   if(url != "") {
  //     try {
  //       final response = await client.get(url);
  //       var parsedJson = jsonDecode(response.body.toString());
  //       var result = Result.fromJson(parsedJson);

  //       if(result.code == 200) {
  //         isLoginSuccess = "OK";
  //         user = User.fromJson(parsedJson[0]);
  //         printHelp("CEK MOD "+user.ModuleId.toString());
          
  //         if(user.userID != ""){
  //           isLoginSuccess = "OK";
  //         }
  //       } else {
  //         isLoginSuccess = result.message;
  //       }
  //     } catch (e) {
  //       isLoginSuccess = "Gagal terhubung dengan server";
  //       printHelp(e);
  //     }
  //   } else {
  //     isLoginSuccess = "Gagal terhubung dengan server";
  //   }

  //   return isLoginSuccess;
  // }

}

final userAPI = UserAPI();