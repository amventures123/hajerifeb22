// // import 'dart:developer';
// // // import 'dart:html';
// // import 'dart:io';
// // import 'dart:isolate';
// // import 'dart:ui';

// // import 'package:flutter/material.dart';
// // import 'package:flutter_downloader/flutter_downloader.dart';
// // import 'package:path_provider/path_provider.dart';

// // void main() {
// //   _initializeFlutterDownloader();
// //   runApp(MyDownloadingApp());
// // }

// // _initializeFlutterDownloader() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await FlutterDownloader.initialize();
// // }

// // class MyDownloadingApp extends StatelessWidget {
// //   // This widget is the root of your application.
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Flutter Downloader Example',
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //       ),
// //       home: MyHomePage(title: 'Flutter Downloader Example'),
// //     );
// //   }
// // }

// // class MyHomePage extends StatefulWidget {
// //   MyHomePage({Key key, this.title}) : super(key: key);
// //   final String title;

// //   @override
// //   _MyHomePageState createState() => _MyHomePageState();
// // }

// // class _MyHomePageState extends State<MyHomePage> {
// //   ReceivePort _port = ReceivePort();

// //   @override
// //   void initState() {
// //     super.initState();
// //     _downloadListener();
// //   }

// //   static void downloadCallback(
// //       String id, DownloadTaskStatus status, int progress) {
// //     final SendPort send =
// //         IsolateNameServer.lookupPortByName('downloader_send_port');
// //     send.send([id, status, progress]);
// //   }

// //   _downloadListener() {
// //     IsolateNameServer.registerPortWithName(
// //         _port.sendPort, 'downloader_send_port');
// //     _port.listen((dynamic data) {
// //       String id = data[0];
// //       DownloadTaskStatus status = data[1];
// //       if (status.toString() == "DownloadTaskStatus(3)") {
// //         FlutterDownloader.open(taskId: id);
// //       }
// //     });
// //     FlutterDownloader.registerCallback(downloadCallback);
// //   }

// //   void _download() async {
// //     final dir = await getExternalStorageDirectory();
// //     String _localPath = dir.path;
// //     log("Local path: " + _localPath);
// //     // (await findLocalPath()) + Platform.pathSeparator + 'Example_Downloads';

// //     final savedDir = Directory(_localPath);
// //     bool hasExisted = await savedDir.exists();
// //     if (!hasExisted) {
// //       savedDir.create();
// //     }
// //     String _url =
// //         "https://www.colonialkc.org/wp-content/uploads/2015/07/Placeholder.png";
// //     final download = await FlutterDownloader.enqueue(
// //       url: _url,
// //       savedDir: _localPath,
// //       showNotification: true,
// //       openFileFromNotification: true,
// //     );
// //   }

// //   Future<String> findLocalPath() async {
// //     final directory =
// //         // (MyGlobals.platform == "android")
// //         // ?
// //         await getExternalStorageDirectory();
// //     // : await getApplicationDocumentsDirectory();
// //     return directory.path;
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(widget.title),
// //       ),
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: <Widget>[],
// //         ),
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: _download,
// //         child: Icon(Icons.file_download),
// //       ), // This trailing comma makes auto-formatting nicer for build methods.
// //     );
// //   }
// // }
// import 'dart:developer';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:path_provider/path_provider.dart' as path;

// class MyDownloadingApp extends StatefulWidget {
//   const MyDownloadingApp({Key key}) : super(key: key);

//   @override
//   _MyDownloadingAppState createState() => _MyDownloadingAppState();
// }

// class _MyDownloadingAppState extends State<MyDownloadingApp> {
//   // var dio;
//   var taskId;

//   download() async {
//     Directory dir = await path.getExternalStorageDirectory();
//     taskId = await FlutterDownloader.enqueue(
//       url:
//           'https://www.colonialkc.org/wp-content/uploads/2015/07/Placeholder.png',
//       savedDir: dir.path,
//       showNotification:
//           true, // show download progress in status bar (for Android)
//       openFileFromNotification:
//           true, // click on notification to open downloaded file (for Android)
//     );

//     log("Download Status:" + taskId.toString());
//     //   Directory dir = await path.getExternalStorageDirectory();
//     //   dio = Dio();
//     //   final res = await dio.download(
//     //     "https://www.colonialkc.org/wp-content/uploads/2015/07/Placeholder.png",dir,dio
//     //   );
//     //   final response = dio.DownloadTaskStatus.toString();
//     //   // final response = await dio.get(
//     //   //     "https://www.colonialkc.org/wp-content/uploads/2015/07/Placeholder.png");
//     //   log("response: " + res.data.toString());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: ElevatedButton(
//             onPressed: () {
//               download();
//             },
//             child: Text("Download Now")),
//       ),
//     );
//   }
// }

// /// More examples see https://github.com/flutterchina/dio/tree/master/example
// // void main() async {
// //   var dio = Dio();
// //   final response = await dio.get('https://google.com');
// //   print(response.data);
// // }
