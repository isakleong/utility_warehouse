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
  Future<Result> getCity(final context, branchId) async {
    Result result;
    List<Pick> picks = [];
    Pick pick;

    String url = "";

    bool isUrlAddress_1 = false, isUrlAddress_2 = false, isUrlAddress_3 = false;
    String urlAddress_1 = "", urlAddress_2 = "", urlAddress_3 = "";
    urlAddress_1 = fetchAPI("config/test-ip.php", context);
    urlAddress_2 = fetchAPI("config/test-ip.php", context, public: true);
    urlAddress_3 = fetchAPI("config/test-ip.php", context, publicAlt: true);

    String getPickSuccess = "";

    try {
      final conn_1 = await connectionTest(urlAddress_1, context);
      printHelp("GET STATUS 1 getpickno" + conn_1);
      if (conn_1 == "OK") {
        isUrlAddress_1 = true;
      }
    } on SocketException {
      isUrlAddress_1 = false;
      result = new Result(code: 500, message: "Gagal terhubung dengan server");
    }

    if (isUrlAddress_1) {
      url = fetchAPI("object/pick.php?branchId=" + branchId, context, print: true);
    } else {
      try {
        final conn_2 = await connectionTest(urlAddress_2, context);
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
      url = fetchAPI(
        "object/pick.php?branchId=" + branchId, context,
        public: true, print: true);
    } else {
      try {
        final conn_3 = await connectionTest(urlAddress_3, context);
        printHelp("GET STATUS 3 getpickno" + conn_3);
        if (conn_3 == "OK") {
          isUrlAddress_3 = true;
        }
      } on SocketException {
        isUrlAddress_3 = false;
        result =
            new Result(code: 500, message: "Gagal terhubung dengan server");
      }
    }
    if (isUrlAddress_3) {
      url = fetchAPI(
        "object/pick.php?branchId=" + branchId, context,
        publicAlt: true, print: true);
    }

    try {
      // printHelp("before");
      final response = await client.get(url);
      // print("after");
      print("status code " + response.statusCode.toString());
      print("cek body city " + response.body);
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

  Future<Result> getCustomer(final context, branchId, city) async {
    Result result;
    List<Pick> picks = [];
    Pick pick;

    String url = "";

    bool isUrlAddress_1 = false, isUrlAddress_2 = false, isUrlAddress_3 = false;
    String urlAddress_1 = "", urlAddress_2 = "", urlAddress_3 = "";
    urlAddress_1 = fetchAPI("config/test-ip.php", context);
    urlAddress_2 = fetchAPI("config/test-ip.php", context, public: true);
    urlAddress_3 = fetchAPI("config/test-ip.php", context, publicAlt: true);

    String getPickSuccess = "";

    try {
      final conn_1 = await connectionTest(urlAddress_1, context);
      printHelp("GET STATUS 1 getpickno" + conn_1);
      if (conn_1 == "OK") {
        isUrlAddress_1 = true;
      }
    } on SocketException {
      isUrlAddress_1 = false;
      result = new Result(code: 500, message: "Gagal terhubung dengan server");
    }

    if (isUrlAddress_1) {
      url = fetchAPI("object/pick.php?branchId=" + branchId+"&city="+city, context, print: true);
    } else {
      try {
        final conn_2 = await connectionTest(urlAddress_2, context);
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
      url = fetchAPI(
        "object/pick.php?branchId=" + branchId+"&city="+city, context,
        public: true, print: true);
    } else {
      try {
        final conn_3 = await connectionTest(urlAddress_3, context);
        printHelp("GET STATUS 2 getpickno" + conn_3);
        if (conn_3 == "OK") {
          isUrlAddress_3 = true;
        }
      } on SocketException {
        isUrlAddress_3 = false;
        result =
            new Result(code: 500, message: "Gagal terhubung dengan server");
      }
    }
    if (isUrlAddress_3) {
      url = fetchAPI(
        "object/pick.php?branchId=" + branchId+"&city="+city, context,
        publicAlt: true, print: true);
    }

    try {
      // printHelp("before");
      final response = await client.get(url);
      // print("after");
      print("status code " + response.statusCode.toString());
      print("cek body cust " + response.body);
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
  
  Future<Result> getPickNo(final context, branchId, customerId) async {
    Result result;
    List<Pick> picks = [];
    Pick pick;

    String url = "";

    bool isUrlAddress_1 = false, isUrlAddress_2 = false, isUrlAddress_3 = false;
    String urlAddress_1 = "", urlAddress_2 = "", urlAddress_3 = "";
    urlAddress_1 = fetchAPI("config/test-ip.php", context);
    urlAddress_2 = fetchAPI("config/test-ip.php", context, public: true);
    urlAddress_3 = fetchAPI("config/test-ip.php", context, publicAlt: true);

    String getPickSuccess = "";

    try {
      final conn_1 = await connectionTest(urlAddress_1, context);
      printHelp("GET STATUS 1 getpickno" + conn_1);
      if (conn_1 == "OK") {
        isUrlAddress_1 = true;
      }
    } on SocketException {
      isUrlAddress_1 = false;
      result = new Result(code: 500, message: "Gagal terhubung dengan server");
    }

    if (isUrlAddress_1) {
      url = fetchAPI("object/pick.php?branchId=" + branchId + "&customerId=" + customerId, context, print: true);
    } else {
      try {
        final conn_2 = await connectionTest(urlAddress_2, context);
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
      url = fetchAPI(
        "object/pick.php?branchId=" + branchId + "&customerId=" + customerId, context,
        public: true, print: true);
    } else {
      try {
        final conn_3 = await connectionTest(urlAddress_2, context);
        printHelp("GET STATUS 3 getpickno" + conn_3);
        if (conn_3 == "OK") {
          isUrlAddress_3 = true;
        }
      } on SocketException {
        isUrlAddress_3 = false;
        result =
            new Result(code: 500, message: "Gagal terhubung dengan server");
      }
    }
    if (isUrlAddress_3) {
      url = fetchAPI(
        "object/pick.php?branchId=" + branchId + "&customerId=" + customerId, context,
        publicAlt: true, print: true);
    }

    try {
      // printHelp("before");
      final response = await client.get(url);
      // print("after");
      print("status code " + response.statusCode.toString());
      print("cek body pickno " + response.body);
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

    bool isUrlAddress_1 = false, isUrlAddress_2 = false, isUrlAddress_3 = false;
    String urlAddress_1 = "", urlAddress_2 = "", urlAddress_3 = "";
    urlAddress_1 = fetchAPI("config/test-ip.php", context);
    urlAddress_2 = fetchAPI("config/test-ip.php", context, public: true);
    urlAddress_3 = fetchAPI("config/test-ip.php", context, publicAlt: true);

    String getPickSuccess = "";

    try {
      final conn_1 = await connectionTest(urlAddress_1, context);
      printHelp("GET STATUS 1 detailpick " + conn_1);
      if (conn_1 == "OK") {
        isUrlAddress_1 = true;
      }
    } on SocketException {
      isUrlAddress_1 = false;
      result = new Result(code: 500, message: "Gagal terhubung dengan server");
    }

    if (isUrlAddress_1) {
      url = fetchAPI(
        "/object/pickDetail.php?branchId=" + branchId + "&pickNo=" + noPick, context, print: true);
    } else {
      try {
        final conn_2 = await connectionTest(urlAddress_2, context);
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
      url = fetchAPI(
        "/object/pickDetail.php?branchId=" + branchId + "&pickNo=" + noPick, context, public: true, print: true);
    } else {
      try {
        final conn_3 = await connectionTest(urlAddress_3, context);
        printHelp("GET STATUS 3 detailpick " + conn_3);
        if (conn_3 == "OK") {
          isUrlAddress_3 = true;
        }
      } on SocketException {
        isUrlAddress_3 = false;
        result =
            new Result(code: 500, message: "Gagal terhubung dengan server");
      }
    }
    if (isUrlAddress_3) {
      url = fetchAPI(
        "/object/pickDetail.php?branchId=" + branchId + "&pickNo=" + noPick, context, publicAlt: true, print: true);
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

    bool isUrlAddress_1 = false, isUrlAddress_2 = false, isUrlAddress_3 = false;
    String urlAddress_1 = "", urlAddress_2 = "", urlAddress_3 = "";
    urlAddress_1 = fetchAPI("config/test-ip.php", context);
    urlAddress_2 = fetchAPI("config/test-ip.php", context, public: true);
    urlAddress_3 = fetchAPI("config/test-ip.php", context, publicAlt: true);

    try {
      final conn_1 = await connectionTest(urlAddress_1, context);
      printHelp("GET STATUS 1 insertpick " + conn_1);
      if (conn_1 == "OK") {
        isUrlAddress_1 = true;
      }
    } on SocketException {
      isUrlAddress_1 = false;
      result = new Result(code: 500, message: "Gagal terhubung dengan server");
    }

    if (isUrlAddress_1) {
      url = fetchAPI("/object/insertPick.php", context, print: true);
    } else {
      try {
        final conn_2 = await connectionTest(urlAddress_2, context);
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
      url = fetchAPI("/object/insertPick.php", context, public: true, print: true);
    } else {
      try {
        final conn_3 = await connectionTest(urlAddress_3, context);
        printHelp("GET STATUS 3 insertpick " + conn_3);
        if (conn_3 == "OK") {
          isUrlAddress_3 = true;
        }
      } on SocketException {
        isUrlAddress_3 = false;
        result =
            new Result(code: 500, message: "Gagal terhubung dengan server");
      }
    }
    if (isUrlAddress_3) {
      url = fetchAPI("/object/insertPick.php", context, publicAlt: true, print: true);
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

      // print("cek body " + response.body);

      // var parsedJson = jsonDecode(response.body);
      final encodes = jsonEncode(post);
      final jsonn = '{"MF_InsertPick":' + encodes + '}';

      final encryptedJsonn = encryptData(jsonn);

      printHelp("json nya " + encryptedJsonn);

      final response = await client.post(url,
          headers: {"Content-Type": "application/json"}, body: encryptedJsonn);

      print("status code " + response.statusCode.toString());

      final res = response.body;
      // printHelp("boomsmsmsmms " + res);
      // printHelp("current decrypt (using response bodyyy)");
      final decryptResponse_ = decryptData(res.trim());
      printHelp("result nya " + decryptResponse_);
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
      } else if (decryptResponse_.contains(
          "Helper lain sudah mengerjakan nomor pick ini. Silahkan memilih nomor pick lain.")) {
        result = new Result(
            code: 2, message: decryptResponse_, data: decryptResponse_);
      } else {
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

    bool isUrlAddress_1 = false, isUrlAddress_2 = false, isUrlAddress_3 = false;
    String urlAddress_1 = "", urlAddress_2 = "", urlAddress_3 = "";
    urlAddress_1 = fetchAPI("config/test-ip.php", context);
    urlAddress_2 = fetchAPI("config/test-ip.php", context, public: true);
    urlAddress_3 = fetchAPI("config/test-ip.php", context, publicAlt: true);

    try {
      final conn_1 = await connectionTest(urlAddress_1, context);
      printHelp("GET STATUS 1 insert selected" + conn_1);
      if (conn_1 == "OK") {
        isUrlAddress_1 = true;
      }
    } on SocketException {
      isUrlAddress_1 = false;
      result = new Result(code: 500, message: "Gagal terhubung dengan server");
    }

    if (isUrlAddress_1) {
      url = fetchAPI("/object/changedPick.php", context, print: true);
    } else {
      try {
        final conn_2 = await connectionTest(urlAddress_2, context);
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
      url = fetchAPI("/object/changedPick.php", context, public: true, print: true);
    } else {
      try {
        final conn_3 = await connectionTest(urlAddress_3, context);
        printHelp("GET STATUS 3 insert selected " + conn_3);
        if (conn_3 == "OK") {
          isUrlAddress_3 = true;
        }
      } on SocketException {
        isUrlAddress_3 = false;
        result =
            new Result(code: 500, message: "Gagal terhubung dengan server");
      }
    }
    if (isUrlAddress_3) {
      url = fetchAPI("/object/changedPick.php", context, publicAlt: true, print: true);
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

        // print("cek body " + response.body);

        // var parsedJson = jsonDecode(response.body);
        final encodes = jsonEncode(post);
        final jsonn = '{"MF_InsertPickSelected":' + encodes + '}';

        final encryptedJsonn = encryptData(jsonn);

        final response = await client.post(url,
            headers: {"Content-Type": "application/json"},
            body: encryptedJsonn);

        print("status code " + response.statusCode.toString());
        final res = response.body;
        printHelp("current decrypt (using response bodyyy)" + res);
        final decryptResponse_ = decryptData(res.trim());
        printHelp("print aaa  ");
        print(decryptResponse_);

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

    bool isUrlAddress_1 = false, isUrlAddress_2 = false, isUrlAddress_3 = false;
    String urlAddress_1 = "", urlAddress_2 = "", urlAddress_3 = "";
    urlAddress_1 = fetchAPI("config/test-ip.php", context);
    urlAddress_2 = fetchAPI("config/test-ip.php", context, public: true);
    urlAddress_3 = fetchAPI("config/test-ip.php", context, publicAlt: true);

    String getPickSuccess = "";

    try {
      final conn_1 = await connectionTest(urlAddress_1, context);
      printHelp("GET STATUS 1 delete selected " + conn_1);
      if (conn_1 == "OK") {
        isUrlAddress_1 = true;
      }
    } on SocketException {
      isUrlAddress_1 = false;
      result = new Result(code: 500, message: "Gagal terhubung dengan server");
    }

    if (isUrlAddress_1) {
      url = fetchAPI("/object/changedPick.php?pickNo=" + noPick, context, print: true);
    } else {
      try {
        final conn_2 = await connectionTest(urlAddress_2, context);
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
      url = fetchAPI("/object/changedPick.php?pickNo=" + noPick, context, public: true, print: true);
    } else {
      try {
        final conn_3 = await connectionTest(urlAddress_3, context);
        printHelp("GET STATUS 3 delete selected " + conn_3);
        if (conn_3 == "OK") {
          isUrlAddress_3 = true;
        }
      } on SocketException {
        isUrlAddress_3 = false;
        result =
            new Result(code: 500, message: "Gagal terhubung dengan server");
      }
    }
    if (isUrlAddress_3) {
      url = fetchAPI("/object/changedPick.php?pickNo=" + noPick, context, publicAlt: true, print: true);
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
    
    bool isUrlAddress_1 = false, isUrlAddress_2 = false, isUrlAddress_3 = false;
    String urlAddress_1 = "", urlAddress_2 = "", urlAddress_3 = "";
    urlAddress_1 = fetchAPI("config/test-ip.php", context);
    urlAddress_2 = fetchAPI("config/test-ip.php", context, public: true);
    urlAddress_3 = fetchAPI("config/test-ip.php", context, publicAlt: true);

    try {
      final conn_1 = await connectionTest(urlAddress_1, context);
      printHelp("GET STATUS 1 getpick1" + conn_1);
      if (conn_1 == "OK") {
        isUrlAddress_1 = true;
      }
    } on SocketException {
      isUrlAddress_1 = false;
      result = new Result(code: 500, message: "Gagal terhubung dengan server");
    }

    if (isUrlAddress_1) {
      url = fetchAPI("/object/pick.php?pickNo=" + pickNo, context, print: true);;
    } else {
      try {
        final conn_2 = await connectionTest(urlAddress_2, context);
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
      url = fetchAPI("/object/pick.php?pickNo=" + pickNo, context, public: true, print: true);
    } else {
      try {
        final conn_3 = await connectionTest(urlAddress_3, context);
        printHelp("GET STATUS 3 getpick2" + conn_3);
        if (conn_3 == "OK") {
          isUrlAddress_3 = true;
        }
      } on SocketException {
        isUrlAddress_3 = false;
        result =
            new Result(code: 500, message: "Gagal terhubung dengan server");
      }
    }
    if (isUrlAddress_3) {
      url = fetchAPI("/object/pick.php?pickNo=" + pickNo, context, publicAlt: true, print: true);
    }

    try {
      printHelp("before");
      final response = await client.get(url);
      print("after");

      print("status code " + response.statusCode.toString());
      final String res = response.body;
      printHelp("print..." + res);
      final decryptResponse_ = decryptData(res.trim());
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
