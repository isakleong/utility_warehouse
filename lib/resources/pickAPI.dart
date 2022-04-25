import 'dart:convert';

import 'package:utility_warehouse/models/detailPickModel.dart';
import 'package:utility_warehouse/settings/configuration.dart';
import 'package:utility_warehouse/models/pickModel.dart';
import 'package:utility_warehouse/models/result.dart';
import 'package:http/http.dart' show Client;
import 'package:utility_warehouse/tools/function.dart';

class PickAPI {
  Client client = Client();
  // get pick number only
  Future<List<Pick>> getPickNo(final context, branchId) async {
    Result result;
    List<Pick> picks = [];
    Pick pick;
    String url_address;

    url_address = config.baseUrl + "/object/pick.php?branchId=" + branchId;
    print("ini url " + url_address);

    String getPickSuccess = "";
//    String url = "";

    if (url_address != "") {
      try {
        // printHelp("before");
        final response = await client.get(url_address);
        // print("after");
        // print("status code " + response.statusCode.toString());
        // print("cek body " + response.body);
        final String res = response.body;
        printHelp("current decrypt (using response body)");
        final decryptResponse_ = decryptData(res.trim());

        var parsedJson = jsonDecode(decryptResponse_);
        printHelp(parsedJson);
        result = new Result(code: 1, message: "OK", data: parsedJson);
        
        result.data["MF_PickNo"].map((item) {
          picks.add(Pick.fromJson(item));
        }).toList();
        
      } catch (e) {
        getPickSuccess = "Gagal terhubung dengan server";
        result = new Result(code: -1, message: "Gagal terhubung dengan server");
        print(e);
      }
    } else {
      print("masuk");
      getPickSuccess = "Gagal terhubung dengan server";
      result = new Result(code: -1, message: "Gagal terhubung dengan server");
    }
    return picks;
  }

  Future<List<DetailPick>> getPickDetail(final context, branchId, noPick) async {
    Result result;
    List<DetailPick> picks = [];
    DetailPick dpick;
    String url_address;

    url_address = url_address = config.baseUrl +
        "/object/pickDetail.php?branchId=" +
        branchId +
        "&pickNo=" +
        noPick;
    print("ini url get detail : " + url_address);

    String getPickSuccess = "";

    if (url_address != "") {
      try {
        final response = await client.get(url_address);

        print("status code " + response.statusCode.toString());
        print("cek body detail " + response.body.toString());

        final String res = response.body;
        printHelp("current decrypt (using response body)");
        final decryptResponse_ = decryptData(res.trim());

        var parsedJson = jsonDecode(decryptResponse_);

        print("masuk sini 1");

        result = new Result(code: 1, message: "OK", data: parsedJson);

        result.data["MF_PickDetail"].map((item) {
          picks.add(DetailPick.fromJson(item));
        }).toList();
        
      } catch (e) {
        getPickSuccess = "Gagal terhubung dengan server";
        result = new Result(code: -1, message: "Gagal terhubung dengan server");
        print(e);
      }
    } else {
      getPickSuccess = "Gagal terhubung dengan server";
      result = new Result(code: -1, message: "Gagal terhubung dengan server");
    }

    return picks;
  }

  Future<Result> insertPick(
      final context, List<Pick> lpick, List<DetailPick> ldetailPick) async {
    Result result;
    List<Pick> picks = [];
    Pick pick;

    List<DetailPick> dpicks = [];
    DetailPick dpick;
    String url_address;
    // List<Map<String, dynamic>> body;

    url_address = url_address = config.baseUrl + "/object/insertPick.php";
    print("ini url " + url_address);
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

    if (url_address != "") {
      try {
        // final response = await client.post(url_address);

        // print("status code " + response.statusCode.toString());
        // print("cek body " + response.body);

        // var parsedJson = jsonDecode(response.body);
        final encodes = jsonEncode(post);
        final jsonn = '{"MF_InsertPick":' + encodes + '}';

        final encryptedJsonn = encryptData(jsonn);
        
        final response = await client.post(url_address,
            headers: {"Content-Type": "application/json"},
            body: encryptedJsonn);
        
        final String res = response.body;
        printHelp("boomsmsmsmms "+res);
        printHelp("current decrypt (using response bodyyy)");
        final decryptResponse_ = decryptData(res.trim());
        printHelp("print aaa  "); 
        print(decryptResponse_);

        // var parsedJson = jsonDecode(decryptResponse_);

        printHelp("blbalblabl " + decryptResponse_);

        if (decryptResponse_.contains("all data inserted successfully")) {
          result = new Result(code: 1, message: "OK");
        } else if (decryptResponse_.contains("data already inserted")) {
          result = new Result(code: 0, message: "Data duplicate");
        }
      } catch (e) {
        getPickSuccess = "Gagal terhubung dengan server";
        result = new Result(code: -1, message: "Gagal terhubung dengan server");
        print(e);
      }
    } else {
      getPickSuccess = "Gagal terhubung dengan server";
      result = new Result(code: -1, message: "Gagal terhubung dengan server");
      print("masuk else");
    }

    return result;
  }

  Future<Result> insertPickSelected(
      final context, List<Pick> lpick) async {
    Result result;
    List<Pick> picks = [];
    Pick pick;

    List<DetailPick> dpicks = [];
    DetailPick dpick;
    String url_address;
    // List<Map<String, dynamic>> body;

    url_address = url_address = config.baseUrl + "/object/changedPick.php";
    print("ini url " + url_address);
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

    if (url_address != "") {
      try {
        // final response = await client.post(url_address);

        // print("status code " + response.statusCode.toString());
        // print("cek body " + response.body);

        // var parsedJson = jsonDecode(response.body);
        final encodes = jsonEncode(post);
        final jsonn = '{"MF_InsertPickSelected":' + encodes + '}';

        final encryptedJsonn = encryptData(jsonn);
        
        final response = await client.post(url_address,
            headers: {"Content-Type": "application/json"},
            body: encryptedJsonn);
        
        final String res = response.body;
        printHelp("boomsmsmsmms "+res);
        printHelp("current decrypt (using response bodyyy)");
        final decryptResponse_ = decryptData(res.trim());
        printHelp("print aaa  ");
        print(decryptResponse_);

        // var parsedJson = jsonDecode(decryptResponse_);

        printHelp("blbalblabl " + decryptResponse_);

        if (decryptResponse_.contains("all data inserted successfully")) {
          result = new Result(code: 1, message: "OK");
        } else if (decryptResponse_.contains("data already inserted")) {
          result = new Result(code: 0, message: "Data duplicate");
        }
      } catch (e) {
        getPickSuccess = "Gagal terhubung dengan server";
        result = new Result(code: -1, message: "Gagal terhubung dengan server");
        print(e);
      }
    } else {
      getPickSuccess = "Gagal terhubung dengan server";
      result = new Result(code: -1, message: "Gagal terhubung dengan server");
      print("masuk else");
    }

    return result;
  }

  Future<Result> deletePickChanged(final context, String noPick) async {
    Result result;
    List<Pick> picks = [];
    Pick pick;

    List<DetailPick> dpicks = [];
    DetailPick dpick;
    String url_address;

    url_address =
        config.baseUrl + "/object/changedPick.php?pickNo=" + noPick;
    print("ini url " + url_address);

    String getPickSuccess = "";

    if (url_address != "") {
      try {
        printHelp("before");
        final response = await client.get(url_address);
        print("after");

        print("status code get detail " + response.statusCode.toString());
        print("cek body detail " + response.body);

        final String res = response.body;
        final decryptResponse_ = decryptData(res.trim());

        // var parsedJson = jsonDecode(decryptResponse_);


        result = new Result(code: 1, message: "OK");

        if (res.contains("delete success")) {
          result = new Result(code: 1, message: "Delete success");
        } else if (res.contains("delete fail")) {
          result = new Result(code: 0, message: "Fail to Delete");
        }
        
      } catch (e) {
        getPickSuccess = "Gagal terhubung dengan server";
        result = new Result(code: -1, message: "Gagal terhubung dengan server");
        print(e);
      }
    } else {
      getPickSuccess = "Gagal terhubung dengan server";
      result = new Result(code: -1, message: "Gagal terhubung dengan server");
      print("masuk else");
    }

    return result;
  }

  Future<String> getPickInserted(final context, String pickNo) async {
    Result result;
    List<Pick> picks = [];
    Pick pick;
    String url_address;
    String res;

    url_address = config.baseUrl + "/object/pick.php?pickNo=" + pickNo;
    print("ini url " + url_address);

    String getPickSuccess = "";
    if (url_address != "") {
      try {
        printHelp("before");
        final response = await client.get(url_address);
        print("after");

        print("status code " + response.statusCode.toString());
        print("cek body " + response.body);
        res = response.body;

        if (response.body.toString() != "false") {
          print("masuk sini 1");

          result = new Result(code: 1, message: "OK", data: response.body);
        } else {
          getPickSuccess = "Data tidak ditemukan";
          result = new Result(code: 0, message: "Data tidak ditemukan");
        }
      } catch (e) {
        getPickSuccess = "Gagal terhubung dengan server";
        result = new Result(code: -1, message: "Gagal terhubung dengan server");
        print(e);
      }
    } else {
      print("masuk");
      getPickSuccess = "Gagal terhubung dengan server";
      result = new Result(code: -1, message: "Gagal terhubung dengan server");
    }
    return res;
  }
}

final PickAPIs = PickAPI();
