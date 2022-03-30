import 'dart:convert';

import 'package:utility_warehouse/models/detailPickModel.dart';
import 'package:utility_warehouse/settings/configuration.dart';
import 'package:utility_warehouse/models/pickModel.dart';
import 'package:utility_warehouse/models/result.dart';
import 'package:http/http.dart' show Client;
import 'package:utility_warehouse/tools/function.dart';

class PickAPI {
  Client client = Client( );
  Future<List<Pick>> getPickNo(final context) async {
    Result result;
    List<Pick> picks = [];
    Pick pick;
    String url_address;

    url_address = fetchAPI("object/pick.php", context: context, print: true);
    print("ini url "+ url_address);

    String getPickSuccess = "";
//    String url = "";

    if(url_address != ""){
      try {
        final response = await client.get(url_address);

        print("status code "+response.statusCode.toString());
        print("cek body "+response.body);

        var parsedJson = jsonDecode(response.body);

        if(response.body.toString() != "false") {
          print("masuk sini 1");

          printHelp("get data ");
          print(parsedJson['MF_Pick'][0]["Weight"]);

          result = new Result(code: 1, message: "OK", data: parsedJson);

          result.data["MF_Pick"].map((item) {
            picks.add(Pick.fromJson(item));
          }).toList();

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
      getPickSuccess = "Gagal terhubung dengan server";
      result = new Result(code: -1, message: "Gagal terhubung dengan server");
    }
    return picks;
  }

  Future<List<DetailPick>> getPickDetail(final context) async {
    Result result;
    List<DetailPick> picks = [];
    DetailPick dpick;
    String url_address;

    url_address = fetchAPI("object/pickDetail.php", context: context, print: true);
    print("ini url "+ url_address);

    String getPickSuccess = "";
//    String url = "";

    if(url_address != ""){
      try {
        final response = await client.get(url_address);

        print("status code "+response.statusCode.toString());
        print("cek body "+response.body);

        var parsedJson = jsonDecode(response.body);

        if(response.body.toString() != "false") {
          print("masuk sini 1");

          printHelp("get dataaaaa ");
          print(parsedJson['MF_PickDetail'][0]["Description"]);

          result = new Result(code: 1, message: "OK", data: parsedJson);

          result.data["MF_PickDetail"].map((item) {
            picks.add(DetailPick.fromJson(item));
          }).toList();

          print("cek list length "+ picks.length.toString());

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
      getPickSuccess = "Gagal terhubung dengan server";
      result = new Result(code: -1, message: "Gagal terhubung dengan server");
    }

    return picks;
  }
}

final PickAPIs = PickAPI();