import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' show Client;
import 'package:utility_warehouse/models/result.dart';
import 'package:utility_warehouse/models/stockOpnameHeaderModel.dart';
import 'package:utility_warehouse/models/userModel.dart';
import 'package:utility_warehouse/settings/configuration.dart';
import 'package:utility_warehouse/tools/function.dart';

class StockOpnameAPI {
  Client client = Client();

  Future<Result> getHelperList(final context, String branchId) async {
    Result result;
    String url = "";

    Configuration configuration = await getUrlConfig(context);

    bool isUrlAddress_1 = false, isUrlAddress_2 = false, isUrlAddress_3 = false;
    String urlAddress_1 = "", urlAddress_2 = "", urlAddress_3 = "";

    urlAddress_1 = fetchAPI("config/test-ip.php", context);
    urlAddress_2 = fetchAPI("config/test-ip.php", context, public: true);
    urlAddress_3 = fetchAPI("config/test-ip.php", context, publicAlt: true);

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
      url = fetchAPI("stock-opname/helper-list.php", context, print: true, parameter: "branch-id="+branchId);
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
      url = fetchAPI("stock-opname/helper-list.php", context, public: true, parameter: "branch-id="+branchId, print: true);
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
      url = fetchAPI("stock-opname/helper-list.php", context, publicAlt: true, parameter: "branch-id="+branchId, print: true);
    }

    try {
      final response = await client.get(url);
      // var responseData = decryptData(response.body.toString());
      var parsedJson = jsonDecode(response.body.toString());
      result = Result.fromJson(parsedJson);
      
      if(result.code == 200) {
        result = new Result(code: result.code, message: result.message, data: result.data);
      }
    } catch (e) {
      result = new Result(code: 500, message: "Gagal terhubung dengan server");
      print(e);
    }

    return result;
  }

  Future<Result> getProcessOpnameLog(final context, {String parameter}) async {
    Result result;
    String url = "";

    Configuration configuration = await getUrlConfig(context);

    bool isUrlAddress_1 = false, isUrlAddress_2 = false, isUrlAddress_3 = false;
    String urlAddress_1 = "", urlAddress_2 = "", urlAddress_3 = "";
    urlAddress_1 = fetchAPI("config/test-ip.php", context);
    urlAddress_2 = fetchAPI("config/test-ip.php", context, public: true);
    urlAddress_3 = fetchAPI("config/test-ip.php", context, publicAlt: true);

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
      url = fetchAPI("stock-opname/process-log.php", context, print: true, parameter: parameter);
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
      url = fetchAPI("stock-opname/process-log.php", context, public: true, parameter: parameter, print: true);
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
      url = fetchAPI("stock-opname/process-log.php", context, publicAlt: true, parameter: parameter, print: true);
    }

    try {
      final response = await client.get(url);
      // var responseData = decryptData(response.body.toString());
      var parsedJson = jsonDecode(response.body.toString());
      result = Result.fromJson(parsedJson);
      
      if(result.code == 200) {
        result = new Result(code: result.code, message: result.message, data: result.data);
      }
    } catch (e) {
      result = new Result(code: 500, message: "Gagal terhubung dengan server");
      print(e);
    }

    return result;
  }

  Future<Result> processOpnameData(final context, {String parameter}) async {
    Result result;
    String url = "";

    Configuration configuration = await getUrlConfig(context);

    bool isUrlAddress_1 = false, isUrlAddress_2 = false, isUrlAddress_3 = false;
    String urlAddress_1 = "", urlAddress_2 = "", urlAddress_3 = "";
    urlAddress_1 = fetchAPI("config/test-ip.php", context);
    urlAddress_2 = fetchAPI("config/test-ip.php", context, public: true);
    urlAddress_3 = fetchAPI("config/test-ip.php", context, publicAlt: true);

    try {
		  final conn_1 = await connectionTest(urlAddress_1, context);
      printHelp("GET STATUS 1 pr "+conn_1);
      if(conn_1 == "OK"){
        isUrlAddress_1 = true;
      }
	  } on SocketException {
      isUrlAddress_1 = false;
      result = new Result(code: 500, message: "Gagal terhubung dengan server");
    }

    if(isUrlAddress_1) {
      url = fetchAPI("stock-opname/process.php", context, print: true, parameter: parameter);
    } else {
      try {
        final conn_2 = await connectionTest(urlAddress_2, context);
        printHelp("GET STATUS 2 pr "+conn_2);
        if(conn_2 == "OK"){
          isUrlAddress_2 = true;
        }
      } on SocketException {
        isUrlAddress_2 = false;
        result = new Result(code: 500, message: "Gagal terhubung dengan server");
      }
    }
    if(isUrlAddress_2){
      url = url = fetchAPI("stock-opname/process.php", context, print: true, public: true, parameter: parameter);
    } else {
      try {
        final conn_3 = await connectionTest(urlAddress_3, context);
        printHelp("GET STATUS 3 pr "+conn_3);
        if(conn_3 == "OK"){
          isUrlAddress_3 = true;
        }
      } on SocketException {
        isUrlAddress_3 = false;
        result = new Result(code: 500, message: "Gagal terhubung dengan server");
      }
    }
    if(isUrlAddress_3){
      url = url = fetchAPI("stock-opname/process.php", context, print: true, publicAlt: true, parameter: parameter);
    }

    try {
      final response = await client.get(url);
      // var responseData = decryptData(response.body.toString());
      var parsedJson = jsonDecode(response.body.toString());
      result = Result.fromJson(parsedJson);
      
      if(result.code == 200) {
        result = new Result(code: result.code, message: result.message, data: result.data);
      }
    } catch (e) {
      result = new Result(code: 500, message: "Gagal terhubung dengan server");
      print(e);
    }

    return result;
  }

  Future<Result> getDownloadOpnameLog(final context, {String parameter}) async {
    Result result;
    String url = "";

    Configuration configuration = await getUrlConfig(context);

    bool isUrlAddress_1 = false, isUrlAddress_2 = false, isUrlAddress_3 = false;
    String urlAddress_1 = "", urlAddress_2 = "", urlAddress_3 = "";
    urlAddress_1 = fetchAPI("config/test-ip.php", context);
    urlAddress_2 = fetchAPI("config/test-ip.php", context, public: true);
    urlAddress_3 = fetchAPI("config/test-ip.php", context, publicAlt: true);

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
      url = fetchAPI("stock-opname/download-log.php", context, print: true, parameter: parameter);
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
      url = fetchAPI("stock-opname/download-log.php", context, public: true, parameter: parameter, print: true);
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
      url = fetchAPI("stock-opname/download-log.php", context, publicAlt: true, parameter: parameter, print: true);
    }

    try {
      final response = await client.get(url);
      // var responseData = decryptData(response.body.toString());
      var parsedJson = jsonDecode(response.body.toString());
      result = Result.fromJson(parsedJson);
      
      if(result.code == 200) {
        result = new Result(code: result.code, message: result.message, data: result.data);
      }
    } catch (e) {
      result = new Result(code: 500, message: "Gagal terhubung dengan server");
      print(e);
    }

    return result;
  }

  Future<Result> downloadOpnameDataHeader(final context, {String parameter}) async {
    Result result;
    String url = "";

    Configuration configuration = await getUrlConfig(context);

    bool isUrlAddress_1 = false, isUrlAddress_2 = false, isUrlAddress_3 = false;
    String urlAddress_1 = "", urlAddress_2 = "", urlAddress_3 = "";
    urlAddress_1 = fetchAPI("config/test-ip.php", context);
    urlAddress_2 = fetchAPI("config/test-ip.php", context, public: true);
    urlAddress_3 = fetchAPI("config/test-ip.php", context, publicAlt: true);

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
      // url = url_address_1;
      url = fetchAPI("stock-opname/download-header.php", context, print: true, parameter: parameter);
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
      // url = url_address_2;
      url = fetchAPI("stock-opname/download-header.php", context, print: true, parameter: parameter, public: true);
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
      // url = url_address_3;
      url = fetchAPI("stock-opname/download-header.php", context, print: true, parameter: parameter, publicAlt: true);
    } 

    try {
      final response = await client.get(url);
      // var responseData = decryptData(response.body.toString());
      printHelp("goto "+response.body.toString());
      var parsedJson = jsonDecode(response.body.toString());
      print("cek 1");
      result = Result.fromJson(parsedJson);
      
      if(result.code == 200) {
        var parsedResult = jsonDecode(result.data.toString());
        print("cek 2 " +parsedResult[0].toString());
        StockOpnameHeader stockOpnameHeader = StockOpnameHeader.fromJson(parsedResult[0]);
        print("cek 3");
        result = new Result(code: result.code, message: result.message, data: stockOpnameHeader);
      }
    } catch (e) {
      result = new Result(code: 500, message: "Gagal terhubung dengan server");
      print(e);
    }

    return result;
  }

  // Future<Result> downloadOpnameData(final context, String branchId, String username, String dayOf, String helper) async {
  //   Result result;
  //   String url = "";

  //   Configuration configuration = await getUrlConfig(context);

  //   bool isUrlAddress_1 = false, isUrlAddress_2 = false;
  //   // http://192.168.10.213/NewUtilityWarehouseDev/StockOpnameGadget/list_tbHK_StockOpnameHeader.php?Cabang=02A&TanggalTarikData=2022-05-12&Jenis=ALL&ProductGroupCode&Username=02A-KG&HariKe=1&Helper=coba helper&Parameter
  //   String url_address_1 = fetchAPI("StockOpnameGadget/list_tbHK_StockOpnameHeader.php?Cabang="+branchId+"&TanggalTarikData=2022-05-12&Jenis=ALL&ProductGroupCode&Username="+username+"&HariKe="+dayOf+"&Helper="+helper+"&Parameter", context, print: true);
  //   String url_address_2 = fetchAPI("StockOpnameGadget/list_tbHK_StockOpnameHeader.php?Cabang="+branchId+"&TanggalTarikData=2022-05-12&Jenis=ALL&ProductGroupCode&Username="+username+"&HariKe="+dayOf+"&Helper="+helper+"&Parameter", context, print: true, secondary: true);

  //   try {
	// 	  final conn_1 = await connectionTest(url_address_1, context);
  //     printHelp("GET STATUS 1 "+conn_1);
  //     if(conn_1 == "OK"){
  //       isUrlAddress_1 = true;
  //     }
	//   } on SocketException {
  //     isUrlAddress_1 = false;
  //     result = new Result(code: 500, message: "Gagal terhubung dengan server");
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
  //       result = new Result(code: 500, message: "Gagal terhubung dengan server");
  //     }
  //   }
  //   if(isUrlAddress_2){
  //     url = url_address_2;
  //   }

  //   try {
  //     final response = await client.get(url);
  //     // var responseData = decryptData(response.body.toString());
  //     var parsedJson = jsonDecode(response.body.toString());
  //     result = Result.fromJson(parsedJson);
      
  //     if(result.code == 200) {
  //       result = new Result(code: result.code, message: result.message, data: result.data);
  //     }
  //   } catch (e) {
  //     result = new Result(code: 500, message: "Gagal terhubung dengan server");
  //     print(e);
  //   }

  //   return result;
  // }

}

final stockOpnameAPI = StockOpnameAPI();