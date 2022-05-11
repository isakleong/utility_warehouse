import 'dart:convert';
import 'dart:io';

import 'package:utility_warehouse/models/detailPickModel.dart';
import 'package:utility_warehouse/settings/configuration.dart';
import 'package:utility_warehouse/models/pickModel.dart';
import 'package:utility_warehouse/models/result.dart';
import 'package:http/http.dart' show Client;
import 'package:utility_warehouse/tools/function.dart';
import 'package:xml/xml.dart';

class PickAPI {
  Client client = Client();
  // get pick number only
  Future<Result> getPickNo(final context, branchId) async {
    Result result;
    List<Pick> picks = [];
    Pick pick;

    String url = "";

    bool isUrlAddress_1 = false, isUrlAddress_2 = false;

    Configuration configuration = await getUrlConfig(context);

    String url_address_1 = fetchAPI("object/pick.php?branchId="+ branchId, context, print: true);
    String url_address_2 = fetchAPI("object/pick.php?branchId="+ branchId, context, secondary: true, print: true);

    String getPickSuccess = "";

    try {
      final conn_1 = await connectionTest(url_address_1, context);
      printHelp("GET STATUS 1 getpickno" + conn_1);
      if (conn_1 == "OK") {
        isUrlAddress_1 = true;
      }
    } on SocketException {
      isUrlAddress_1 = false;
      result = new Result(code: 500, message: "Gagal terhubung dengan server");
    }

    if (isUrlAddress_1) {
      url = url_address_1;
    } else {
      try {
        final conn_2 = await connectionTest(url_address_2, context);
        printHelp("GET STATUS 2 getpickno" + conn_2);
        if (conn_2 == "OK") {
          isUrlAddress_2 = true;
        }
      } on SocketException {
        isUrlAddress_2 = false;
        result =
            new Result(code: 500, message: "Gagal terhubung dengan server");
      }
    }
    if (isUrlAddress_2) {
      url = url_address_2;
    }

    try {
      // printHelp("before");
      final response = await client.get(url);
      // print("after");
      // print("status code " + response.statusCode.toString());
      print("cek body " + response.body);
      final res = response.body;
      final decryptResponse_ = decryptData(res.trim());
      // print("cek body getpickno " + decryptResponse_);

      // String parsedJson = jsonDecode(res);

      if (decryptResponse_.contains("Error (sqlsrv_query)")) {
        result = new Result(
            code: 0, message: decryptResponse_, data: decryptResponse_);
      } else {
        result = new Result(
            code: 1, message: decryptResponse_, data: decryptResponse_);
        // result.data["MF_PickNo"].map((item) {
        //   picks.add(Pick.fromJson(item));
        // }).toList();
        // result.data = picks;
      }
    } catch (e) {
      result = new Result(code: 500, message: "Gagal terhubung dengan server");
      print(e);
    }
    return result;
  }

  Future<Result> getPickDetail(final context, branchId, noPick) async {
    Result result;
    List<DetailPick> picks = [];
    DetailPick dpick;
    String url = "";

    bool isUrlAddress_1 = false, isUrlAddress_2 = false;
    String url_address_1 = config.baseUrl +
        "/object/pickDetail.php?branchId=" +
        branchId +
        "&pickNo=" +
        noPick;
    String url_address_2 = config.baseUrlAlt +
        "/object/pickDetail.php?branchId=" +
        branchId +
        "&pickNo=" +
        noPick;

    String getPickSuccess = "";

    try {
      final conn_1 = await connectionTest(url_address_1, context);
      printHelp("GET STATUS 1 detailpick " + conn_1);
      if (conn_1 == "OK") {
        isUrlAddress_1 = true;
      }
    } on SocketException {
      isUrlAddress_1 = false;
      result = new Result(code: 500, message: "Gagal terhubung dengan server");
    }

    if (isUrlAddress_1) {
      url = url_address_1;
    } else {
      try {
        final conn_2 = await connectionTest(url_address_2, context);
        printHelp("GET STATUS 2 detailpick " + conn_2);
        if (conn_2 == "OK") {
          isUrlAddress_2 = true;
        }
      } on SocketException {
        isUrlAddress_2 = false;
        result =
            new Result(code: 500, message: "Gagal terhubung dengan server");
      }
    }
    if (isUrlAddress_2) {
      url = url_address_2;
    }

    try {
      final response = await client.get(url);

      print("status code " + response.statusCode.toString());

      final res = response.body;
      // printHelp("current decrypt (using response body)");
      final decryptResponse_ = decryptData(res.trim());
      // print("cek body detail " + decryptResponse_);

      if (decryptResponse_.contains("Error (sqlsrv_query)")) {
        result = new Result(
            code: 0, message: decryptResponse_, data: decryptResponse_);
      } else {
        result = new Result(
            code: 1, message: decryptResponse_, data: decryptResponse_);
      }
    } catch (e) {
      result = new Result(code: 500, message: "Gagal terhubung dengan server");
      print(e);
    }
    return result;
  }

  Future<Result> insertPick(
      final context, List<Pick> lpick, List<DetailPick> ldetailPick) async {
    Result result;
    List<Pick> picks = [];
    Pick pick;

    List<DetailPick> dpicks = [];
    DetailPick dpick;
    // List<Map<String, dynamic>> body;
    String url = "";

    bool isUrlAddress_1 = false, isUrlAddress_2 = false;
    String url_address_1 = config.baseUrl + "/object/insertPick.php";
    String url_address_2 = config.baseUrlAlt + "/object/insertPick.php";

    try {
      final conn_1 = await connectionTest(url_address_1, context);
      printHelp("GET STATUS 1 insertpick " + conn_1);
      if (conn_1 == "OK") {
        isUrlAddress_1 = true;
      }
    } on SocketException {
      isUrlAddress_1 = false;
      result = new Result(code: 500, message: "Gagal terhubung dengan server");
    }

    if (isUrlAddress_1) {
      url = url_address_1;
    } else {
      try {
        final conn_2 = await connectionTest(url_address_2, context);
        printHelp("GET STATUS 2 insertpick " + conn_2);
        if (conn_2 == "OK") {
          isUrlAddress_2 = true;
        }
      } on SocketException {
        isUrlAddress_2 = false;
        result =
            new Result(code: 500, message: "Gagal terhubung dengan server");
      }
    }
    if (isUrlAddress_2) {
      url = url_address_2;
    }

    try {
      List<Map<String, dynamic>> post = [
        {
          "Pick": [
            {
              'pickNo': lpick[0].pickNo,
              'custName': lpick[0].custName,
              'contactName': lpick[0].contactName,
              'city': lpick[0].city,
              'county': lpick[0].county,
              'postcode': lpick[0].postcode,
              'gudang': lpick[0].gudang,
              'source': lpick[0].source,
              'date': lpick[0].date,
              'weight': lpick[0].weight,
              'userId': lpick[0].userId,
              'wsNo': lpick[0].wsNo,
              'province': lpick[0].province,
              'sales': lpick[0].sales
            },
          ],
        },
      ];
      jsonEncode(post);
      // printHelp("print location " + body[0]['Pick'][0]['dtmCreated']);

      for (int i = 0; i < ldetailPick.length; i++) {
        Map<String, dynamic> temp = {
          'description': ldetailPick[i].description,
          'ukuran': ldetailPick[i].ukuran,
          'bincode': ldetailPick[i].bincode,
          'quantity': ldetailPick[i].quantity,
          'qty_real': ldetailPick[i].qty_real,
          'uom': ldetailPick[i].uom,
          'ada': ldetailPick[i].ada
        };
        jsonEncode(temp);
        post.add(temp);
      }
      printHelp(jsonEncode(post));

      String getPickSuccess = "";

      // final response = await client.post(url);

      // print("status code " + response.statusCode.toString());
      // print("cek body " + response.body);

      // var parsedJson = jsonDecode(response.body);
      final encodes = jsonEncode(post);
      final jsonn = '{"MF_InsertPick":' + encodes + '}';

      final encryptedJsonn = encryptData(jsonn);

      final response = await client.post(url,
          headers: {"Content-Type": "application/json"}, body: encryptedJsonn);

      final res = response.body;
      // printHelp("boomsmsmsmms " + res);
      // printHelp("current decrypt (using response bodyyy)");
      final decryptResponse_ = decryptData(res.trim());
      // printHelp("print aaa  ");
      // print(decryptResponse_);

      // var parsedJson = jsonDecode(decryptResponse_);

      // printHelp("blbalblabl " + decryptResponse_);

      // if (decryptResponse_.contains("all data inserted successfully")) {
      //   result = new Result(code: 1, message: decryptResponse_);
      // } else if (decryptResponse_.contains("data already inserted")) {
      //   result = new Result(code: 0, message: "Data duplicate");
      // }

      if (decryptResponse_.contains("Error")) {
        result = new Result(
            code: 0, message: decryptResponse_, data: decryptResponse_);
      } else if (decryptResponse_.contains("all data inserted successfully")) {
        result = new Result(
            code: 1, message: decryptResponse_, data: decryptResponse_);
      } else if(decryptResponse_.contains("Helper lain sudah mengerjakan nomor pick ini")){
        result = new Result(
            code: 2, message: decryptResponse_, data: decryptResponse_);
      }else{
        result = new Result(
            code: -1, message: decryptResponse_, data: decryptResponse_);
      }
    } catch (e) {
      result = new Result(code: 500, message: "Gagal terhubung dengan server");
      print(e);
    }
    return result;
  }

  Future<Result> insertPickSelected(final context, List<Pick> lpick) async {
    Result result;
    List<Pick> picks = [];
    Pick pick;

    List<DetailPick> dpicks = [];
    DetailPick dpick;
    // List<Map<String, dynamic>> body;
    String url = "";

    bool isUrlAddress_1 = false, isUrlAddress_2 = false;
    String url_address_1 = config.baseUrl + "/object/changedPick.php";
    String url_address_2 = config.baseUrlAlt + "/object/changedPick.php";

    try {
      final conn_1 = await connectionTest(url_address_1, context);
      printHelp("GET STATUS 1 insert selected" + conn_1);
      if (conn_1 == "OK") {
        isUrlAddress_1 = true;
      }
    } on SocketException {
      isUrlAddress_1 = false;
      result = new Result(code: 500, message: "Gagal terhubung dengan server");
    }

    if (isUrlAddress_1) {
      url = url_address_1;
    } else {
      try {
        final conn_2 = await connectionTest(url_address_2, context);
        printHelp("GET STATUS 2 insert selected " + conn_2);
        if (conn_2 == "OK") {
          isUrlAddress_2 = true;
        }
      } on SocketException {
        isUrlAddress_2 = false;
        result =
            new Result(code: 500, message: "Gagal terhubung dengan server");
      }
    }
    if (isUrlAddress_2) {
      url = url_address_2;
    }

    try {
      List<Map<String, dynamic>> post = [
        {
          "Pick": [
            {
              'pickNo': lpick[0].pickNo,
              'custName': lpick[0].custName,
              'contactName': lpick[0].contactName,
              'city': lpick[0].city,
              'county': lpick[0].county,
              'postcode': lpick[0].postcode,
              'gudang': lpick[0].gudang,
              'source': lpick[0].source,
              'date': lpick[0].date,
              'weight': lpick[0].weight,
              'userId': lpick[0].userId,
              'wsNo': lpick[0].wsNo,
              'province': lpick[0].province,
              'sales': lpick[0].sales
            },
          ],
        },
      ];
      jsonEncode(post);

      String getPickSuccess = "";

      try {
        // final response = await client.post(url);

        // print("status code " + response.statusCode.toString());
        // print("cek body " + response.body);

        // var parsedJson = jsonDecode(response.body);
        final encodes = jsonEncode(post);
        final jsonn = '{"MF_InsertPickSelected":' + encodes + '}';

        final encryptedJsonn = encryptData(jsonn);

        final response = await client.post(url,
            headers: {"Content-Type": "application/json"},
            body: encryptedJsonn);

        final res = response.body;
        // printHelp("current decrypt (using response bodyyy)");
        final decryptResponse_ = decryptData(res.trim());
        // printHelp("print aaa  ");
        // print(decryptResponse_);

        // var parsedJson = jsonDecode(decryptResponse_);

        // printHelp("blbalblabl " + decryptResponse_);

        // if (decryptResponse_.contains("Error (sqlsrv_query)")) {
        //   result =
        //       new Result(code: 0, message: decryptResponse_, data: decryptResponse_);
        // } else {
        //   result = new Result(code: 1, message: decryptResponse_, data: decryptResponse_);
        // }
        if (decryptResponse_.contains("Error (sqlsrv_query)")) {
          result = new Result(
              code: 0, message: decryptResponse_, data: decryptResponse_);
        } else {
          result = new Result(
              code: 1, message: decryptResponse_, data: decryptResponse_);
        }
      } catch (e) {
        getPickSuccess = "Gagal terhubung dengan server";
        result = new Result(code: -1, message: "Gagal terhubung dengan server");
        print(e);
      }
    } catch (e) {
      result = new Result(code: 500, message: "Gagal terhubung dengan server");
      print(e);
    }
    return result;
  }

  Future<Result> deletePickChanged(final context, String noPick) async {
    Result result;
    List<Pick> picks = [];
    Pick pick;

    List<DetailPick> dpicks = [];
    DetailPick dpick;
    String url = "";

    bool isUrlAddress_1 = false, isUrlAddress_2 = false;
    String url_address_1 =
        config.baseUrl + "/object/changedPick.php?pickNo=" + noPick;
    String url_address_2 =
        config.baseUrlAlt + "/object/changedPick.php?pickNo=" + noPick;

    String getPickSuccess = "";

    try {
      final conn_1 = await connectionTest(url_address_1, context);
      printHelp("GET STATUS 1 delete selected " + conn_1);
      if (conn_1 == "OK") {
        isUrlAddress_1 = true;
      }
    } on SocketException {
      isUrlAddress_1 = false;
      result = new Result(code: 500, message: "Gagal terhubung dengan server");
    }

    if (isUrlAddress_1) {
      url = url_address_1;
    } else {
      try {
        final conn_2 = await connectionTest(url_address_2, context);
        printHelp("GET STATUS 2 delete selected " + conn_2);
        if (conn_2 == "OK") {
          isUrlAddress_2 = true;
        }
      } on SocketException {
        isUrlAddress_2 = false;
        result =
            new Result(code: 500, message: "Gagal terhubung dengan server");
      }
    }
    if (isUrlAddress_2) {
      url = url_address_2;
    }

    try {
      // printHelp("before deletepick");
      final response = await client.get(url);
      // print("after");

      print("status code get detail " + response.statusCode.toString());
      // print("cek body detail " + response.body);

      final res = response.body;
      final decryptResponse_ = decryptData(res.trim());

      // var parsedJson = jsonDecode(decryptResponse_);
      result = new Result(code: 1, message: decryptResponse_);

      if (decryptResponse_.contains("delete success")) {
        result = new Result(code: 1, message: "Delete success");
      } else if (decryptResponse_.contains("delete fail")) {
        result = new Result(code: 0, message: "Fail to Delete");
      }
    } catch (e) {
      result = new Result(code: 500, message: "Gagal terhubung dengan server");
      print(e);
    }

    return result;
  }

  Future<Result> getPickInserted(final context, String pickNo) async {
    Result result;
    List<Pick> picks = [];
    Pick pick;
    String res;
    String url = "";

    bool isUrlAddress_1 = false, isUrlAddress_2 = false;
    String url_address_1 = config.baseUrl + "/object/pick.php?pickNo=" + pickNo;
    String url_address_2 =
        config.baseUrlAlt + "/object/pick.php?pickNo=" + pickNo;

    try {
      final conn_1 = await connectionTest(url_address_1, context);
      printHelp("GET STATUS 1 getpick1" + conn_1);
      if (conn_1 == "OK") {
        isUrlAddress_1 = true;
      }
    } on SocketException {
      isUrlAddress_1 = false;
      result = new Result(code: 500, message: "Gagal terhubung dengan server");
    }

    if (isUrlAddress_1) {
      url = url_address_1;
    } else {
      try {
        final conn_2 = await connectionTest(url_address_2, context);
        printHelp("GET STATUS 2 getpick2" + conn_2);
        if (conn_2 == "OK") {
          isUrlAddress_2 = true;
        }
      } on SocketException {
        isUrlAddress_2 = false;
        result =
            new Result(code: 500, message: "Gagal terhubung dengan server");
      }
    }
    if (isUrlAddress_2) {
      url = url_address_2;
    }

    try {
      printHelp("before");
      final response = await client.get(url);
      print("after");

      print("status code " + response.statusCode.toString());
      final res = response.body;
      final decryptResponse_ = decryptData(res);
      print("cek body getpickInserted" + decryptResponse_);

      if (decryptResponse_.contains("Error")) {
        result = new Result(
            code: 0, message: decryptResponse_, data: decryptResponse_);
      } else {
        result = new Result(
            code: 1, message: decryptResponse_, data: decryptResponse_);
      }
    } catch (e) {
      result = new Result(code: 500, message: "Gagal terhubung dengan server");
      print(e);
    }
    return result;
  }
}

final PickAPIs = PickAPI();
