import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
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
import 'package:intl/intl.dart';

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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
    // Directory dir = await getExternalStorageDirectory();
    // String path = '${dir.path}/deviceconfig.xml';
    String path = '/storage/emulated/0/Android/data/com.example.utility_warehouse/files/deviceconfig.xml';

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
    setState(() {
      configuration = configuration;
    });
  }

  getAppsReady() async {
    var isNeedOpenSetting = false;
    isPermissionPermanentlyDenied = false;

    var androidInfo = await DeviceInfoPlugin().androidInfo;
    var sdkInt = androidInfo.version.sdkInt;

    if(sdkInt > 19) {
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
    } else {
      await getDeviceConfig();
      doCheckVersion();
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
      if(getCheckVersion != configuration.apkVersion) {
        printHelp("getcheckversion "+getCheckVersion);
        printHelp("apkVersion "+configuration.apkVersion);
        Alert(
          context: context,
          title: "Info,",
          content: Text("Terdapat pembaruan versi aplikasi. Otomatis mengunduh pembaruan aplikasi setelah tekan OK"),
          cancel: false,
          type: "warning",
          defaultAction: () async {
            await isReadyToInstall();
            if(toInstall) {
              String downloadPath = await getFilePath(configuration.apkName+".apk");
              await OpenFile.open(downloadPath);
            } else {
              preparingNewVersion();
            }
          }
        );
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

  int isInCompleteDownload(String downloadPath) {
    if(FileSystemEntity.typeSync(downloadPath) != FileSystemEntityType.notFound){
      var file = File(downloadPath);
      printHelp("masuk exist "+file.lengthSync().toString());
      return file.lengthSync();
    }
    printHelp("masuk not exist");
    return 0;
  }

  Future<void> downloadNewVersion() async {
    setState(() {
      isRetryDownload = false;
    });

    String url = "";

    bool isUrlAddress_1 = false, isUrlAddress_2 = false;
    String url_address_1 = configuration.getUrlPath + "/config/apk/" + config.apkName+".apk";
    String url_address_2 = configuration.getUrlPathAlt + "/config/apk/" + config.apkName+".apk";

    printHelp("print "+url_address_1);

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
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var sdkInt = androidInfo.version.sdkInt;

      if(sdkInt > 19) {
        try {
          OtaUpdate().execute(
            url,
            destinationFilename: configuration.apkName+".apk"
          ).listen(
            (OtaEvent event) async{
              _setState(() {
                  progressValue = double.parse(event.value)/100;
                  progressText = event.value;
              });
            },
            onDone: () => timer.cancel(),
          );
        } catch (e) {
            print('Failed to make OTA update. Details: $e');
            _setState(() {
              isRetryDownload = true;
            });
        }
      } else {
        Client client = Client();

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

  // Future<void> downloadApps() async {
  //   setState(() {
  //     isRetryDownload = false;
  //   });

  //   String url = "";

  //   bool isUrlAddress_1 = false, isUrlAddress_2 = false;
    
  //   String url_address_1 = configuration.getUrlPath + "/config/tes_ip.php";
  //   String url_address_2 = configuration.getUrlPathAlt + "/config/tes_ip.php";

  //   try {
	// 	  final conn_1 = await connectionTest(url_address_1, context);
  //     printHelp("GET STATUS 1 apps "+conn_1);
  //     if(conn_1 == "OK"){
  //       isUrlAddress_1 = true;
  //     }
	//   } on SocketException {
  //     isUrlAddress_1 = false;
  //   }

  //   if(isUrlAddress_1) {
  //     url = configuration.getUrlPath + "/config/apk/" + configuration.apkName + ".apk";
  //   } else {
  //     try {
  //       final conn_2 = await connectionTest(url_address_2, context);
  //       printHelp("GET STATUS 2 "+conn_2);
  //       if(conn_2 == "OK"){
  //         isUrlAddress_2 = true;
  //       }
  //     } on SocketException {
  //       isUrlAddress_2 = false;
  //     }
  //   }
  //   if(isUrlAddress_2){
  //     url = configuration.getUrlPathAlt + "/config/apk/" + configuration.apkName + ".apk";
  //   }

  //   if(url != "") {
  //     final isPermissionStatusGranted = await checkAppsPermission();
      
  //     Client client = Client();

  //     if(isPermissionStatusGranted) {
  //       try {
  //         OtaUpdate().execute(
  //           url,
  //           destinationFilename: configuration.apkName+".apk"
  //         ).listen(
  //           (OtaEvent event) async{
  //             print("status check "+ event.status.toString());
  //             _setState(() {
  //                   progressValue = double.parse(event.value)/100;
  //                   progressText = event.value;
  //               });
  //             // if(!isRetryDownload) {
  //             //   _setState(() {
  //             //       progressValue = double.parse(event.value)/100;
  //             //       progressText = event.value;
  //             //   });
  //             // }
  //           },
  //           onDone: () => timer.cancel(),
  //         );
  //       } catch (e) {
  //           print('Failed to make OTA update. Details: $e');
  //           _setState(() {
  //             isRetryDownload = true;
  //           });
  //       }
  //     }

  //   } else {
  //     //gagal terhubung
  //     _setState(() {
  //       isRetryDownload = true;
  //     });
  //   }
  // }

  void preparingNewVersion() async {
    setState(() {
      isLoadingVersion = false;
      isDownloadNewVersion = true;
    });
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    var sdkInt = androidInfo.version.sdkInt;
    if(sdkInt > 19) {
      timer = Timer.periodic(Duration(seconds: 5), (Timer t) => isInternet());
    }
    downloadNewVersion();
    showDialog (
      context: context,
      barrierDismissible: false,
      builder: (context){
        return WillPopScope(
          onWillPop: () async {
            if(isRetryDownload) {
              timer.cancel();
            }
            return false; 
          },
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextView("Mengunduh pembaruan aplikasi", 4, align: TextAlign.center),
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
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextView("Coba Lagi", 3, color: Colors.white),
                                    ],
                                  ),
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

  Future<void> isReadyToInstall() async {
    setState(() {
      toInstall = false;
    });

    int downloadedSize = 0;
    int apkSize = 0;

    String url = "";
    bool isUrlAddress_1 = false, isUrlAddress_2 = false;

    String url_address_1 = configuration.getUrlPath + "/config/apk/" + configuration.apkName + ".apk";
    String url_address_2 = configuration.getUrlPathAlt + "/config/apk/" + configuration.apkName + ".apk";

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
        String downloadPath = await getFilePath(configuration.apkName+".apk");

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
        String filename = configuration.apkName + ".apk";
        // Directory dir = await getExternalStorageDirectory();
        // path = '${dir.path}/$filename';
        path = '/storage/emulated/0/Android/data/com.example.utility_warehouse/files/$filename';

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

    // Directory dir = await getExternalStorageDirectory();

    // path = '${dir.path}/$filename';

    path = '/storage/emulated/0/Android/data/com.example.utility_warehouse/files/$filename';

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
      url = configuration.getUrlPath + "/config/getVersion.php";
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

      url = configuration.getUrlPathAlt + "/config/getVersion.php";
    }

    var response;
    if(url != "") {
      try {
        var parsedUrl = Uri.parse(url);
        response = await client.get(parsedUrl);
        var responseData = decryptData(response.body.toString());
        var parsedJson = jsonDecode(responseData);
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
        isGetVersionSuccess = "Gagal terhubung dengan server\nError message : " + e.toString();
        printHelp(e);
      }
    } else {
      isGetVersionSuccess = "Gagal terhubung dengan server, silahkan periksa kembali koneksi Anda atau cek pengaturan IP pada aplikasi.";
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
          Navigator.popAndPushNamed(context, "setting", arguments: "splashScreen");
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