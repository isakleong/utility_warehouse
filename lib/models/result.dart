class Result {
  int code;
  String message;
  var data; 

  Result({
    this.code,
    this.message,
    this.data
  });

  factory Result.fromJson(Map<String, dynamic> parsedJson){
    return Result(
      code: parsedJson["code"] ?? 0,
      message: parsedJson["message"] ?? "",
      data: parsedJson["data"] ?? "",
    );
  }
}