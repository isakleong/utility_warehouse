import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:http/http.dart' show Client, Request;
import 'package:open_file/open_file.dart';
import 'package:ota_update/ota_update.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:utility_warehouse/models/result.dart';
import 'package:utility_warehouse/screens/login.dart';
import 'package:utility_warehouse/settings/configuration.dart';
import 'package:utility_warehouse/tools/function.dart';
import 'package:utility_warehouse/widget/button.dart';
import 'package:utility_warehouse/widget/textView.dart';
import 'package:xml/xml.dart';

const debug = true;

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  String getCheckVersion = "";
  bool isLoadingVersion = false;

  bool isDownloadNewVersion = false;
  bool isRetryDownload = false;
  bool toInstall = false;
  bool isPermissionPermanentlyDenied = false;
  double progressValue = 0.0;
  String progressText = "";

  StateSetter _setState;

  var fileDownloaded = 0;

  Configuration configuration;

  Timer timer;
  @override
  void initState() {
    super.initState();
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeRight,
    // ]);
  }

  didChangeDependencies() async {
    super.didChangeDependencies();

    configuration = Configuration.of(context);

    await getAppsReady();
  }

  getDeviceConfig() async {
    // Configuration config = Configuration.of(context);
    Directory dir = await getExternalStorageDirectory();
    String path = '${dir.path}/deviceconfig.xml';
    File file = File(path);

    if(FileSystemEntity.typeSync(path) != FileSystemEntityType.notFound){
      final document = XmlDocument.parse(file.readAsStringSync());
      final url_address_1 = document.findAllElements('url_address_1').map((node) => node.text);
      final url_address_2 = document.findAllElements('url_address_2').map((node) => node.text);
      configuration.setUrlPath = url_address_1.first;
      configuration.setUrlPathAlt = url_address_2.first;
      // print(document.toString());
      // print(document.toXmlString(pretty: true, indent: '\t'));
    } else {
      configuration.setUrlPath = "http://203.142.77.243/NewUtilityWarehouseDev";
      configuration.setUrlPathAlt = "http://103.76.27.124/NewUtilityWarehouseDev";

      final builder = XmlBuilder();
      builder.processing('xml', 'version="1.0" encoding="UTF-8" standalone="yes"');
      builder.element('deviceconfig', nest: () {
        builder.element('url_address_1', nest: "http://203.142.77.243/NewUtilityWarehouseDev");
        builder.element('url_address_2', nest: "http://103.76.27.124/NewUtilityWarehouseDev");
        builder.element('token_id', nest: '');
      });
      final document = builder.buildDocument();
      await file.writeAsString(document.toString());
      // print(document.toString());
      // print(document.toXmlString(pretty: true, indent: '\t'));
    }
  }

  getAppsReady() async {
    var isNeedOpenSetting = false;
    isPermissionPermanentlyDenied = false;
    final isPermissionStatusGranted = await checkAppsPermission();
    
    if(isPermissionStatusGranted) {
      await getDeviceConfig();
      doCheckVersion();
    } else {
      var isPermissionStatusGranted = false;
      

      while(!isPermissionStatusGranted) {
        if(!isPermissionPermanentlyDenied) {
          isPermissionStatusGranted = await checkAppsPermission();
        } else {
          isNeedOpenSetting = true;
          break;
        }
      }
      if(isNeedOpenSetting) {
        Alert(
          context: context,
          title: "Info,",
          content: Text("Mohon izinkan aplikasi mengakses file di perangkat"),
          cancel: false,
          type: "error",
          errorBtnTitle: "Pengaturan",
          defaultAction: () async {
            isNeedOpenSetting = false;
            await getAppsReady();
            Navigator.of(context).pop();
          }
        );
      } else {
        getAppsReady();
      }
    }
  }

  Future<bool> checkAppsPermission() async {
    setState(() {
      isPermissionPermanentlyDenied = false;
    });
    var status = await Permission.storage.request();

    if(status != PermissionStatus.granted) {
      if(status == PermissionStatus.denied) {
        setState(() {
          isPermissionPermanentlyDenied = true;
        });
      } else {
        openAppSettings();
        return status == PermissionStatus.granted;
      }
    }
    return status == PermissionStatus.granted;
  }

  doCheckVersion() async {
    setState(() {
      isLoadingVersion = true;
    });
    
    //get apk version
    String checkVersion = await getVersion(context);

    setState(() {
      isLoadingVersion = false;
    });

    if(checkVersion == "OK") {
      await isReadyToInstall();
      if(getCheckVersion != configuration.apkVersion) {
        if(!toInstall) {
          printHelp("getcheckversion "+getCheckVersion);
          printHelp("apkVersion "+configuration.apkVersion);
          Alert(
            context: context,
            title: "Info,",
            content: Text("Terdapat pembaruan versi aplikasi. Otomatis mengunduh pembaruan aplikasi setelah tekan OK"),
            cancel: false,
            type: "warning",
            defaultAction: () {
              preparingNewVersion();
            }
          );   
        } else {
          String downloadPath = await getFilePath(configuration.apkName+".apk");
          await OpenFile.open(downloadPath);
        }        
      } else {
        // startTimer();
      }
    } else {
      Alert(
        context: context,
        title: "Maaf,",
        content: Text(checkVersion),
        cancel: false,
        type: "error",
        errorBtnTitle: "Coba Lagi",
        defaultAction: () {
          doCheckVersion();
        }
      );
    }
  }

  Future<bool> isInternet() async {
    printHelp("isinternet");
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // connected to mobile network
      if (await DataConnectionChecker().hasConnection) {
        // mobile data detected & internet connection confirmed.
        return true;
      } else {
        // mobile data detected but no internet connection found.
        _setState(() {
          isRetryDownload = true;
        });
        return false;
      }
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // connected to wifi network
      if (await DataConnectionChecker().hasConnection) {
        // wifi detected & internet connection confirmed.
        return true;
      } else {
        // wifi detected but no internet connection found.
        _setState(() {
          isRetryDownload = true;
        });
        return false;
      }
    } else {
      // neither mobile data or wifi detected, not internet connection found.
      _setState(() {
        isRetryDownload = true;
      });
      return false;
    }
  }

  Future<void> downloadApps() async {
    setState(() {
      isRetryDownload = false;
    });

    String url = "";

    bool isUrlAddress_1 = false, isUrlAddress_2 = false;
    String url_address_1 = config.baseUrl + "/" + config.apkName+".apk";
    String url_address_2 = config.baseUrlAlt + "/" + config.apkName+".apk";

    try {
		  final conn_1 = await connectionTest(url_address_1, context);
      printHelp("GET STATUS 1 apps "+conn_1);
      if(conn_1 == "OK"){
        isUrlAddress_1 = true;
      }
	  } on SocketException {
      isUrlAddress_1 = false;
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
      }
    }
    if(isUrlAddress_2){
      url = url_address_2;
    }

    if(url != "") {
      final isPermissionStatusGranted = await checkAppsPermission();
      Client client = Client();

      if(isPermissionStatusGranted) {
        try {
          OtaUpdate().execute(
            url,
            destinationFilename: config.apkName+".apk"
          ).listen(
            (OtaEvent event) async{
              _setState(() {
                  progressValue = double.parse(event.value)/100;
                  progressText = event.value;
              });
            }, onDone: () => timer.cancel()
          );
        } catch (e) {
            print('Failed to make OTA update. Details: $e');
            _setState(() {
              isRetryDownload = true;
            });
        }
      }

    } else {
      //gagal terhubung
      _setState(() {
        isRetryDownload = true;
      });
    }
  }

  void preparingNewVersion() {
    setState(() {
      isLoadingVersion = false;
      isDownloadNewVersion = true;
    });
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => isInternet());
    downloadApps();
    showDialog (
      context: context,
      barrierDismissible: false,
      builder: (context){
        return WillPopScope(
          onWillPop: null,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(7.5)),
            ),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
              _setState = setState;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: CircularPercentIndicator(
                      radius: 120.0,
                      lineWidth: 13.0,
                      animation: false,
                      percent: progressValue,
                      center: Text("${progressText}%", style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      footer: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            Text("Mengunduh pembaruan aplikasi", style: new TextStyle(fontWeight: FontWeight.bold)),
                            Visibility(
                              // maintainSize: true, 
                              // maintainAnimation: true,
                              // maintainState: true,
                              visible: isRetryDownload,
                              child: Container(
                                margin: EdgeInsets.only(top: 15),
                                width: MediaQuery.of(context).size.width,
                                child: Button(
                                  // loading: loginLoading,
                                  child: TextView("Coba Lagi", 3, color: Colors.white),
                                  onTap: () {
                                    downloadApps();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: Colors.blue,
                    ),
                  ),
                ],
              );
            }),
          )
        );
      }
    );
  }

  Future<void> isReadyToInstall() async {
    setState(() {
      toInstall = false;
    });

    int downloadedSize = 0;
    int apkSize = 0;

    String url = "";
    bool isUrlAddress_1 = false, isUrlAddress_2 = false;

    // String url_address_1 = fetchAPI("config/apk/"+config.apkName+".apk", context: context);
    // String url_address_2 = fetchAPI("config/apk/"+config.apkName+".apk", context: context, secondary: true);

    String url_address_1 = config.baseUrl + "config/apk/" + config.apkName + ".apk";
    String url_address_2 = config.baseUrlAlt + "config/apk/" + config.apkName + ".apk";

    try {
		  final conn_1 = await connectionTest(url_address_1, context);
      printHelp("GET STATUS 1 "+conn_1);
      if(conn_1 == "OK"){
        isUrlAddress_1 = true;
      }
	  } on SocketException {
      isUrlAddress_1 = false;
      // isGetVersionSuccess = "Gagal terhubung dengan server";
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
        // isGetVersionSuccess = "Gagal terhubung dengan server";
      }
    }
    if(isUrlAddress_2){
      url = url_address_2;
    }

    if(url != "") {
      Client client = Client();

      
      try {
        String downloadPath = await getFilePath(config.apkName+".apk");

        printHelp("download path "+downloadPath);
        printHelp("url download "+ url);

        final request = new Request('HEAD', Uri.parse(url))..followRedirects = false;
        final response = await client.send(request).timeout(
          Duration(seconds: 5),
            onTimeout: () {
              return null;
            },
        );
        printHelp("full header "+response.headers.toString());
        printHelp("content length "+response.headers['content-length'].toString());

        apkSize = int.parse(response.headers['content-length'].toString());
        
        String path = '';
        String filename = config.apkName + ".apk";
        Directory dir = await getExternalStorageDirectory();
        path = '${dir.path}/$filename';

        if(FileSystemEntity.typeSync(path) != FileSystemEntityType.notFound){
          var file = File(path);
          downloadedSize = file.lengthSync();
        }

        if(apkSize == downloadedSize) {
          setState(() {
            toInstall = true;
          });
        }

      } catch (e) {
        print(e);
      }

    } else {
      Alert(
        context: context,
        title: "Maaf,",
        content: Text("Gagal terhubung dengan server"),
        cancel: false,
        type: "error",
        errorBtnTitle: "Coba Lagi",
        defaultAction: () {
          getAppsReady();
        }
      );
    }
  }

  Future<String> getFilePath(filename) async {
    String path = '';

    Directory dir = await getExternalStorageDirectory();

    path = '${dir.path}/$filename';

    return path;
  }

  Future<String> getVersion(final context, {String parameter=""}) async {
    Client client = Client();
    String url = "";

    bool isUrlAddress_1 = false, isUrlAddress_2 = false;
    String isGetVersionSuccess = "";
    
    print("HSHSHSH "+configuration.getUrlPath.toString());
    
    String url_address_1 = configuration.getUrlPath + "/config/tes_ip.php";
    String url_address_2 = configuration.getUrlPathAlt + "/config/tes_ip.php";

    try {
		  final conn_1 = await connectionTest(url_address_1, context);
      printHelp("GET STATUS 11 "+conn_1);
      if(conn_1 == "OK"){
        isUrlAddress_1 = true;
      }
	  } on SocketException {
      isUrlAddress_1 = false;
      isGetVersionSuccess = "Gagal terhubung dengan server";
    }

    if(isUrlAddress_1) {
      // url = url_address_1;
      url = config.baseUrl + "config/getVersion.php";
    } else {
      try {
        final conn_2 = await connectionTest(url_address_2, context);
        printHelp("GET STATUS 2 "+conn_2);
        if(conn_2 == "OK"){
          isUrlAddress_2 = true;
        }
      } on SocketException {
        isUrlAddress_2 = false;
        isGetVersionSuccess = "Gagal terhubung dengan server";
      }
    }
    if(isUrlAddress_2){
      // url = url_address_2;
      url = config.baseUrlAlt + "config/getVersion.php";
    }

    var response;
    if(url != "") {
      try {
        var parsedUrl = Uri.parse(url);
        response = await client.get(parsedUrl);
        var parsedJson = jsonDecode(response.body.toString());
        var result = Result.fromJson(parsedJson);

        if(result.code == 200) {
          isGetVersionSuccess = "OK";
          setState(() {
            getCheckVersion = result.data;
          });
        } else {
          isGetVersionSuccess = result.message;
        }
      } catch (e) {
        isGetVersionSuccess = "Gagal terhubung dengan server";
        printHelp(e);
      }
    } else {
      isGetVersionSuccess = "Gagal terhubung dengan server";
    }

    return isGetVersionSuccess;
  }

  @override
  Widget build(BuildContext context) {

    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "setting");
        },
        child: Icon(Icons.settings),
        backgroundColor: configuration.darkOpacityBlueColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: mediaWidth*0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: "logo",
                      child: InkWell(
                        child: Image.asset(
                          "assets/illustration/logo.png", alignment: Alignment.center, fit: BoxFit.contain
                        ),
                      ),
                    ),
                    // Center(
                    //   child: CircularProgressIndicator(
                    //     valueColor: AlwaysStoppedAnimation<Color>(config.darkOpacityBlueColor),
                    //   ),
                    // ),
                  ],
                ),
              ),
              SizedBox(height: 60),
              Container(
                width: mediaWidth*0.5,
                child: Lottie.asset('assets/illustration/loading.json', fit: BoxFit.contain)
              ),
            ],
          ),
        ),
      ),
    );
  }

  startTimer() {
    var _duration = Duration(milliseconds: 3000);
    return Timer(_duration, navigate);
  }

  void navigate() async {
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            transitionDuration: Duration(seconds: 5),
            pageBuilder: (_, __, ___) => Login()));
  }

}