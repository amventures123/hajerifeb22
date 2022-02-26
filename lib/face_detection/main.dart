import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hajeri/face_detection/Pages/last_step.dart';
import '../main.dart';
// import './Pages/landing.dart';
// import './Pages/scanner.dart';
import './Pages/sign_up.dart';
import 'package:shared_preferences/shared_preferences.dart';

// SharedPreferences prefs;

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
    debug: false,
  );

  prefs = await SharedPreferences.getInstance();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  runApp(
    MyApp(),
  );
}

class FaceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Comfortaa',
      ),
      home: SignUp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      routes: {
        SignUp.id: (_) => SignUp(),
        LastStep.id: (_) => LastStep(),
      },
      theme: ThemeData(
        fontFamily: 'Comfortaa',
        cardTheme: CardTheme(
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              10.0,
            ),
          ),
          elevation: 2,
          shadowColor: Colors.grey,
        ),
        dataTableTheme: DataTableThemeData(
          dataRowColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected))
              return Theme.of(context).colorScheme.primary.withOpacity(0.08);
            if (states.contains(MaterialState.pressed))
              return Colors.purpleAccent.withOpacity(0.08);

            return null;
          }),
          dividerThickness: 1.5,
        ),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isWait = true;
  String userStatusCheck = "no result";
  String hajeriLevel;
  String mainBankId;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Builder(
        builder: (context) {
          return SignUp();
        },
      ),
    );
  }
}
