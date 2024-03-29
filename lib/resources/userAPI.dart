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

    Configuration configuration = await getUrlConfig(context);

    bool isUrlAddress_1 = false, isUrlAddress_2 = false, isUrlAddress_3 = false;
    String urlAddress_1 = "", urlAddress_2 = "", urlAddress_3 = "";
    urlAddress_1 = fetchAPI("config/test-ip.php", context);
    urlAddress_2 = fetchAPI("config/test-ip.php", context, public: true);
    urlAddress_3 = fetchAPI("config/test-ip.php", context, publicAlt: true);

    // final body = jsonEncode({
    //   "userID":username,
    //   "password":password
    // });

    final body =  <String, String>{
      'userID' : username,
      'password' : password
    };

    try {
		  final conn_1 = await connectionTest(urlAddress_1, context);
      printHelp("GET STATUS 1 "+conn_1);
      if(conn_1 == "OK"){
        isUrlAddress_1 = true;
      }
	  } on SocketException {
      isUrlAddress_1 = false;
      result = new Result(code: 500, message: "Gagal terhubung dengan server");
    }

    if(isUrlAddress_1) {
      url = fetchAPI("users/login.php", context, print: true);
    } else {
      try {
        final conn_2 = await connectionTest(urlAddress_2, context);
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
      url = fetchAPI("users/login.php", context, public: true, print: true);
    } else {
      try {
        final conn_3 = await connectionTest(urlAddress_3, context);
        printHelp("GET STATUS 3 "+conn_3);
        if(conn_3 == "OK"){
          isUrlAddress_3 = true;
        }
      } on SocketException {
        isUrlAddress_3 = false;
        result = new Result(code: 500, message: "Gagal terhubung dengan server");
      }
    }
    if(isUrlAddress_3){
      url = fetchAPI("users/login.php", context, publicAlt: true, print: true);
    }

    try {
      final response = await client.post(url, headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body);
      var responseData = decryptData(response.body.toString());
      var parsedJson = jsonDecode(responseData);
      result = Result.fromJson(parsedJson);
      
      if(result.code == 200) {
        var parsedResult = jsonDecode(result.data.toString());
        User user = User.fromJson(parsedResult[0]);
        result = new Result(code: result.code, message: result.message, data: user);
      }
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

    bool isUrlAddress_1 = false, isUrlAddress_2 = false, isUrlAddress_3 = false;
    String urlAddress_1 = "", urlAddress_2 = "", urlAddress_3 = "";
    urlAddress_1 = fetchAPI("config/test-ip.php", context);
    urlAddress_2 = fetchAPI("config/test-ip.php", context, public: true);
    urlAddress_3 = fetchAPI("config/test-ip.php", context, publicAlt: true);

    final body =  <String, String>{
      'userID' : username,
      'tokenID' : token
    };

    try {
		  final conn_1 = await connectionTest(urlAddress_1, context);
      printHelp("GET STATUS 1 "+conn_1);
      if(conn_1 == "OK"){
        isUrlAddress_1 = true;
      }
	  } on SocketException {
      isUrlAddress_1 = false;
      result = new Result(code: 500, message: "Gagal terhubung dengan server");
    }

    if(isUrlAddress_1) {
      url = fetchAPI("users/auth_validation.php", context);;
    } else {
      try {
        final conn_2 = await connectionTest(urlAddress_2, context);
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
      url = fetchAPI("users/auth_validation.php", context, public: true);
    } else {
      try {
        final conn_3 = await connectionTest(urlAddress_3, context);
        printHelp("GET STATUS 3 "+conn_3);
        if(conn_3 == "OK"){
          isUrlAddress_3 = true;
        }
      } on SocketException {
        isUrlAddress_3 = false;
        result = new Result(code: 500, message: "Gagal terhubung dengan server");
      }
    }
    if(isUrlAddress_3){
      url = fetchAPI("users/auth_validation.php", context, publicAlt: true);
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

  Future<Result> nikValidation(final context, String nik) async {
    Result result;
    User user;
    String url = "";

    bool isUrlAddress_1 = false, isUrlAddress_2 = false, isUrlAddress_3 = false;
    String urlAddress_1 = "", urlAddress_2 = "", urlAddress_3 = "";
    urlAddress_1 = fetchAPI("config/test-ip.php", context);
    urlAddress_2 = fetchAPI("config/test-ip.php", context, public: true);
    urlAddress_3 = fetchAPI("config/test-ip.php", context, publicAlt: true);

    final body =  <String, String>{
      'nik' : nik
    };

    try {
		  final conn_1 = await connectionTest(urlAddress_1, context);
      printHelp("GET STATUS 1 "+conn_1);
      if(conn_1 == "OK"){
        isUrlAddress_1 = true;
      }
	  } on SocketException {
      isUrlAddress_1 = false;
      result = new Result(code: 500, message: "Gagal terhubung dengan server");
    }

    if(isUrlAddress_1) {
      url = fetchAPI("users/check_nik_validation.php", context);
    } else {
      try {
        final conn_2 = await connectionTest(urlAddress_2, context);
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
      url = fetchAPI("users/check_nik_validation.php", context, public: true);
    } else {
      try {
        final conn_3 = await connectionTest(urlAddress_3, context);
        printHelp("GET STATUS 3 "+conn_3);
        if(conn_3 == "OK"){
          isUrlAddress_3 = true;
        }
      } on SocketException {
        isUrlAddress_3 = false;
        result = new Result(code: 500, message: "Gagal terhubung dengan server");
      }
    }
    if(isUrlAddress_3){
      url = fetchAPI("users/check_nik_validation.php", context, publicAlt: true);
    }

    try {
      final response = await client.post(url, headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body);
      var parsedJson = jsonDecode(response.body);
      result = Result.fromJson(parsedJson);
    } catch (e) {
      result = new Result(code: 500, message: "Gagal terhubung dengan server");
      print(e);
    }

    return result;
  }

  Future<Result> generateOTP(final context, String phoneNumber) async {
    Result result;
    User user;
    String url = "";

    bool isUrlAddress_1 = false, isUrlAddress_2 = false, isUrlAddress_3 = false;
    String urlAddress_1 = "", urlAddress_2 = "", urlAddress_3 = "";
    urlAddress_1 = fetchAPI("config/test-ip.php", context);
    urlAddress_2 = fetchAPI("config/test-ip.php", context, public: true);
    urlAddress_3 = fetchAPI("config/test-ip.php", context, publicAlt: true);

    final body =  <String, String>{
      'phoneNumber' : phoneNumber
    };

    try {
		  final conn_1 = await connectionTest(urlAddress_1, context);
      printHelp("GET STATUS 1 "+conn_1);
      if(conn_1 == "OK"){
        isUrlAddress_1 = true;
      }
	  } on SocketException {
      isUrlAddress_1 = false;
      result = new Result(code: 500, message: "Gagal terhubung dengan server");
    }

    if(isUrlAddress_1) {
      url = fetchAPI("users/generate_otp.php", context);
    } else {
      try {
        final conn_2 = await connectionTest(urlAddress_2, context);
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
      url = fetchAPI("users/generate_otp.php", context, public: true);
    } else {
      try {
        final conn_3 = await connectionTest(urlAddress_3, context);
        printHelp("GET STATUS 3 "+conn_3);
        if(conn_3 == "OK"){
          isUrlAddress_3 = true;
        }
      } on SocketException {
        isUrlAddress_3 = false;
        result = new Result(code: 500, message: "Gagal terhubung dengan server");
      }
    }
    if(isUrlAddress_3){
      url = fetchAPI("users/generate_otp.php", context, publicAlt: true);
    }

    try {
      final response = await client.post(url, headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body);
      var parsedJson = jsonDecode(response.body);
      result = Result.fromJson(parsedJson);
    } catch (e) {
      result = new Result(code: 500, message: "Gagal terhubung dengan server");
      print(e);
    }

    return result;
  }

  Future<Result> signUp(final context, String username, String token, String nik) async {
    Result result;
    User user;
    String url = "";

    bool isUrlAddress_1 = false, isUrlAddress_2 = false, isUrlAddress_3 = false;
    String urlAddress_1 = "", urlAddress_2 = "", urlAddress_3 = "";
    urlAddress_1 = fetchAPI("config/test-ip.php", context);
    urlAddress_2 = fetchAPI("config/test-ip.php", context, public: true);
    urlAddress_3 = fetchAPI("config/test-ip.php", context, publicAlt: true);

    print("DATA FETCH 1 "+username);
    print("DATA FETCH 2 "+token);
    print("DATA FETCH 3 "+nik);

    final body =  <String, String>{
      'userID' : username,
      'tokenID' : token,
      'nik' : nik
    };

    try {
		  final conn_1 = await connectionTest(urlAddress_1, context);
      printHelp("GET STATUS 1 "+conn_1);
      if(conn_1 == "OK"){
        isUrlAddress_1 = true;
      }
	  } on SocketException {
      isUrlAddress_1 = false;
      result = new Result(code: 500, message: "Gagal terhubung dengan server");
    }

    if(isUrlAddress_1) {
      url = fetchAPI("users/registration.php", context);
    } else {
      try {
        final conn_2 = await connectionTest(urlAddress_2, context);
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
      url = fetchAPI("users/registration.php", context, public: true);
    } else {
      try {
        final conn_3 = await connectionTest(urlAddress_3, context);
        printHelp("GET STATUS 3 "+conn_3);
        if(conn_3 == "OK"){
          isUrlAddress_3 = true;
        }
      } on SocketException {
        isUrlAddress_3 = false;
        result = new Result(code: 500, message: "Gagal terhubung dengan server");
      }
    }
    if(isUrlAddress_3){
      url = fetchAPI("users/registration.php", context, publicAlt: true);
    }

    try {
      final response = await client.post(url, headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body);
      var parsedJson = jsonDecode(response.body);
      result = Result.fromJson(parsedJson);
    } catch (e) {
      result = new Result(code: 500, message: "Gagal terhubung dengan server");
      print(e);
    }

    return result;
  }

  Future<Result> updatePassword(final context, String username, String password) async {
    Result result;
    User user;
    String url = "";

    bool isUrlAddress_1 = false, isUrlAddress_2 = false, isUrlAddress_3 = false;
    String urlAddress_1 = "", urlAddress_2 = "", urlAddress_3 = "";
    urlAddress_1 = fetchAPI("config/test-ip.php", context);
    urlAddress_2 = fetchAPI("config/test-ip.php", context, public: true);
    urlAddress_3 = fetchAPI("config/test-ip.php", context, publicAlt: true);

    final body =  <String, String>{
      'userID' : username,
      'password' : password
    };

    try {
		  final conn_1 = await connectionTest(urlAddress_1, context);
      printHelp("GET STATUS 1 "+conn_1);
      if(conn_1 == "OK"){
        isUrlAddress_1 = true;
      }
	  } on SocketException {
      isUrlAddress_1 = false;
      result = new Result(code: 500, message: "Gagal terhubung dengan server");
    }

    if(isUrlAddress_1) {
      url = fetchAPI("users/update_password.php", context);
    } else {
      try {
        final conn_2 = await connectionTest(urlAddress_2, context);
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
      url = fetchAPI("users/update_password.php", context, public: true);
    } else {
      try {
        final conn_3 = await connectionTest(urlAddress_3, context);
        printHelp("GET STATUS 3 "+conn_3);
        if(conn_3 == "OK"){
          isUrlAddress_3 = true;
        }
      } on SocketException {
        isUrlAddress_3 = false;
        result = new Result(code: 500, message: "Gagal terhubung dengan server");
      }
    }
    if(isUrlAddress_3){
      url = fetchAPI("users/update_password.php", context, publicAlt: true);
    }

    try {
      final response = await client.post(url, headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: body);
      var parsedJson = jsonDecode(response.body);
      result = Result.fromJson(parsedJson);
    } catch (e) {
      result = new Result(code: 500, message: "Gagal terhubung dengan server");
      print(e);
    }

    return result;
  }



  // Future<String> login(final context, {String parameter=""}) async {
  //   String isLoginSuccess = "";
  //   User user;
  //   String url = "";

  //   bool isUrlAddress_1 = false, isUrlAddress_2 = false;
  //   String url_address_1 = fetchAPI("users/getUserCoba.php", context, parameter: parameter);
  //   String url_address_2 = fetchAPI("users/getUserCoba.php", context, secondary: true, parameter: parameter);

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