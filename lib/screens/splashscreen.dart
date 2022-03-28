import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:http/http.dart' show Client, Request;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:utility_warehouse/screens/login.dart';
import 'package:utility_warehouse/settings/configuration.dart';
import 'package:utility_warehouse/tools/function.dart';
import 'package:utility_warehouse/widget/button.dart';
import 'package:utility_warehouse/widget/textView.dart';

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

  @override
  void initState() {
    super.initState();
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeRight,
    // ]);
  }

  didChangeDependencies() async {
    super.didChangeDependencies();

    await getAppsReady();

    // startTimer();
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

  getAppsReady() async {
    var isNeedOpenSetting = false;
    isPermissionPermanentlyDenied = false;
    final isPermissionStatusGranted = await checkAppsPermission();
    
    if(isPermissionStatusGranted) {
      doCheckVersion();
    } else {
      var isPermissionStatusGranted = false;
      

      while(!isPermissionStatusGranted) {
        if(!isPermissionPermanentlyDenied) {
          isPermissionStatusGranted = await checkAppsPermission();
        } else {
          // isPermissionStatusGranted = await checkAppsPermission();
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
      if(getCheckVersion != config.apkVersion) {
        if(!toInstall) {
          printHelp("getcheckversion "+getCheckVersion);
          printHelp("apkVersion "+config.apkVersion);
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
          String downloadPath = await getFilePath(config.apkName+".apk");
          await OpenFile.open(downloadPath);
        }        
      } else {
        startTimer();
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

  void preparingNewVersion() {
    setState(() {
      isLoadingVersion = false;
      isDownloadNewVersion = true;
    });
    downloadNewVersion();
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
                                  backgroundColor: config.darkOpacityBlueColor,
                                  child: TextView("Coba Lagi", 3, color: Colors.white),
                                  onTap: () {
                                    downloadNewVersion();
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

  Future<void> downloadNewVersion() async {
    setState(() {
      isRetryDownload = false;
    });

    String url = "";

    bool isUrlAddress_1 = false, isUrlAddress_2 = false;
    String url_address_1 = config.baseUrl + "/" + config.apkName+".apk";
    String url_address_2 = config.baseUrlAlt + "/" + config.apkName+".apk";

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
      final isPermissionStatusGranted = await checkAppsPermission();
      Client client = Client();

      if(isPermissionStatusGranted) {
        try {
          Dio dio = Dio(
            BaseOptions(
              baseUrl: url,
              connectTimeout: 3000,
              receiveTimeout: 300000,
            ),
          );

          String downloadPath = await getFilePath(config.apkName+".apk");

          printHelp("download path "+downloadPath);
          printHelp("url download "+ url);

          // final response = await client.get(url);
          // // Response response = await client.get(url);
          // printHelp("content length "+response.headers.toString());

          var fileSize=0;
          var totalDownloaded = 0;
          var totalProgress = 0;

          final request = new Request('HEAD', Uri.parse(url))..followRedirects = false;
          final response = await client.send(request).timeout(
            Duration(seconds: 5),
              onTimeout: () {
                return null;
              },
          );
          printHelp("full header "+response.headers.toString());
          printHelp("content length "+response.headers['content-length'].toString());

          fileDownloaded = isInCompleteDownload(downloadPath);
          printHelp("tes fileDownloaded "+fileDownloaded.toString());
          if(fileDownloaded > 0) {
            printHelp("masuk if");
            totalDownloaded = fileDownloaded;
            fileSize = fileDownloaded;
          }
          fileSize += int.parse(response.headers['content-length']);

          try {
            dio.download(url, downloadPath,
              onReceiveProgress: (rcv, total) {
                print(
                    'received: ${rcv.toStringAsFixed(0)} out of total WOI: ${total.toStringAsFixed(0)}');
                _setState(() {
                  progressValue = (rcv / total * 100)/100;
                  progressText = ((rcv / total) * 100).toStringAsFixed(0);
                });

                if (progressText == '100') {
                  _setState(() {
                    isDownloadNewVersion = true;
                  });
                } else if (double.parse(progressText) < 100) {}
              },
              deleteOnError: true,
            ). onError((error, stackTrace) {
              _setState(() {
                isRetryDownload = true;
              });
              throw('coba thro');
            }).then((_) async {
              _setState(() {
                if (progressText == '100') {
                  isDownloadNewVersion = true;
                }

                isDownloadNewVersion = false;
              });

              Navigator.of(context).pop();

              setState(() {
                isLoadingVersion = false;
                isDownloadNewVersion = false;
              });

              printHelp("MASUK SELESAI");
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              OpenFile.open(downloadPath);
              // exit(0);
              
            });
          } catch (e) {
            _setState(() {
              isRetryDownload = true;
            });
          }

        } catch (e) {
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

  Future<void> isReadyToInstall() async {
    setState(() {
      toInstall = false;
    });

    int downloadedSize = 0;
    int apkSize = 0;

    String url = "";
    bool isUrlAddress_1 = false, isUrlAddress_2 = false;
    String url_address_1 = config.baseUrl + "/" + config.apkName+".apk";
    String url_address_2 = config.baseUrlAlt + "/" + config.apkName+".apk";

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

  int isInCompleteDownload(String downloadPath) {
    if(FileSystemEntity.typeSync(downloadPath) != FileSystemEntityType.notFound){
      var file = File(downloadPath);
      printHelp("masuk exist "+file.lengthSync().toString());
      return file.lengthSync();
    }
    printHelp("masuk not exist");
    return 0;
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
    // String url_address_1 = config.baseUrl + "/config/" + "getVersion.php" + (parameter == "" ? "" : "?" + parameter);
    // String url_address_2 = config.baseUrlAlt + "/config/" + "getVersion.php" + (parameter == "" ? "" : "?" + parameter);

    String url_address_1 = fetchAPI("config/getVersion.php", context: context);
    String url_address_2 = fetchAPI("config/getVersion.php", context: context, secondary: true);

    printHelp(url_address_1);

    try {
		  final conn_1 = await connectionTest(url_address_1, context);
      printHelp("GET STATUS 1 "+conn_1);
      if(conn_1 == "OK"){
        isUrlAddress_1 = true;
      }
	  } on SocketException {
      isUrlAddress_1 = false;
      isGetVersionSuccess = "Gagal terhubung dengan server";
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
        isGetVersionSuccess = "Gagal terhubung dengan server";
      }
    }
    if(isUrlAddress_2){
      url = url_address_2;
    }

    var response;
    if(url != "") {
      try {
        response = await client.get(url);

        if(response.body.toString() != "false") {
          isGetVersionSuccess = "OK";
          setState(() {
            getCheckVersion = response.body.toString();
          });
        } else {
          isGetVersionSuccess = "Gagal terhubung dengan server";
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
      body: Center(
        child: Container(
          width: mediaWidth*0.75,
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
              SizedBox(height: 30),
              Container(
                child: Lottie.asset('assets/illustration/loading_6.json', fit: BoxFit.fitWidth)
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: Padding(
      //   padding: EdgeInsets.only(bottom: 15),
      //   child: Lottie.asset('assets/illustration/loading_2.json', fit: BoxFit.fitWidth),
      // ),
    );
  }

  startTimer() {
    var _duration = Duration(milliseconds: 2000);
    return Timer(_duration, navigate);
  }

  void navigate() async {
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            transitionDuration: Duration(seconds: 4),
            pageBuilder: (_, __, ___) => Login()));
  }

}