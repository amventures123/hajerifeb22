// import 'package:flutter/material.dart';
// import '../Pages/scanner.dart';
// import 'package:permission_handler/permission_handler.dart';
// import '../constant.dart';
// import 'package:convex_bottom_bar/convex_bottom_bar.dart';
// import '../main.dart';

// class Landing extends StatefulWidget {
//   final initialPageIndex;
//   Landing({
//     this.initialPageIndex = 1,
//   });
//   static const id = "landing_page";

//   @override
//   _LandingState createState() => _LandingState();
// }

// class _LandingState extends State<Landing>
//     with
//         SingleTickerProviderStateMixin,
//         AutomaticKeepAliveClientMixin<Landing> {
//   TargetPlatform platform;
//   static List pageView;
//   bool isOrg;
//   PageController _pageController;
//   TabController _tabController;
//   @override
//   void initState() {
//     super.initState();
//     // isOrg = prefs.getBool('is_org');
//     pageView = [
//       Scanner(),
//     ];

//     _tabController = TabController(
//       length: 3,
//       initialIndex: widget.initialPageIndex,
//       vsync: this,
//     );
//     _pageController = PageController(
//       initialPage: widget.initialPageIndex,
//     );
//     _checkPermission();
//   }

//   @override
//   bool get wantKeepAlive => true;
//   @override
//   void dispose() {
//     _pageController.dispose();
//     _tabController.dispose();
//     super.dispose();
//   }

//   Future<bool> _checkPermission() async {
//     if (platform == TargetPlatform.android) {
//       final storageStatus = await Permission.storage.status;

//       if (storageStatus != PermissionStatus.granted) {
//         final result = await Permission.storage.request();
//         if (result == PermissionStatus.granted) {
//           return true;
//         }
//       } else {
//         return true;
//       }
//       final cameraStatus = await Permission.camera.status;

//       if (cameraStatus != PermissionStatus.granted) {
//         final result = await Permission.camera.request();
//         if (result == PermissionStatus.granted) {
//           return true;
//         }
//       } else {
//         return true;
//       }
//       final locationStatus = await Permission.location.status;

//       if (locationStatus != PermissionStatus.granted) {
//         final result = await Permission.locationWhenInUse.request();
//         if (result == PermissionStatus.granted) {
//           return true;
//         }
//       } else {
//         return true;
//       }
//     } else {
//       return true;
//     }
//     return false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: WillPopScope(
//         onWillPop: _onBackPressed,
//         child: Scaffold(
//           appBar: AppBar(
//             backgroundColor: Colors.blue[800],
//             title: Text("Title"),
//           ),
//           drawer: Drawer(
//               child: ListView(
//             children: [
//               // DrawerHeader(
//               //     decoration: BoxDecoration(color: Colors.blue),
//               //     child: Text("Menu")),
//               // ListTile(
//               //   title: Text("Face Detection"),
//               //   leading: Icon(Icons.face_retouching_natural),
//               //   onTap: () {
//               //     Navigator.push(
//               //         context, MaterialPageRoute(builder: (_) => FaceRoll()));
//               //   },
//               // )
//             ],
//           )),
//           body: PageView.builder(
//             physics: NeverScrollableScrollPhysics(),
//             controller: _pageController,
//             itemCount: 1,
//             itemBuilder: (context, index) {
//               return pageView[index];
//             },
//           ),
//           bottomNavigationBar: ConvexAppBar.badge(
//             null,
//             gradient: kGradient,
//             cornerRadius: 5.0,
//             height: 60,
//             elevation: 5,
//             curveSize: 85,
//             controller: _tabController,
//             style: TabStyle.fixedCircle,
//             items: <TabItem>[
//               TabItem(
//                 icon: Icons.qr_code_scanner,
//                 title: 'Scanner',
//               ),
//             ],
//             onTap: (int i) {
//               _pageController.jumpToPage(i);
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Future<bool> _onBackPressed() {
//     return showDialog(
//           context: context,
//           builder: (context) => new AlertDialog(
//             title: new Text('Are you sure?'),
//             content: new Text('Do you want to exit an App'),
//             actions: <Widget>[
//               new TextButton(
//                 onPressed: () => Navigator.of(context).pop(false),
//                 child: Text("NO"),
//               ),
//               SizedBox(height: 16),
//               new TextButton(
//                 onPressed: () => Navigator.of(context).pop(true),
//                 child: Text("YES"),
//               ),
//             ],
//           ),
//         ) ??
//         false;
//   }
// }
