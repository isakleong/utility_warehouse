class Result {
  int code;
  String message;
  var data;
  var error_message;

  Result({
    this.code,
    this.message,
    this.data,
    this.error_message
  });

  //{"code":400,"error":{"error_type":"login validation failed","error_message":"User ID atau Password salah, mohon dicek kembali"}}

  factory Result.fromJson(Map<String, dynamic> parsedJson){
    return Result(
      code: parsedJson["code"] ?? 0,
      message: parsedJson["message"] ?? "",
      data: parsedJson["data"] ?? "",
      error_message: parsedJson["error"] == null
        ? null : parsedJson["error"]["error_message"] ?? ""
    );
  }
}