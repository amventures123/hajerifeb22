import 'dart:convert';
import 'dart:developer';
// import 'dart:html';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hajeri/Settings%20model/payment_page.dart';
import 'package:toast/toast.dart';

import '../main.dart';

import 'package:http/http.dart' as http;

import '../url.dart';

class SettingsPage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SettingsPage> {
  // ignore: unused_field
  bool _toggled1 = false;
  // ignore: unused_field
  bool _toggled2 = false;
  // ignore: unused_field
  bool _toggled3 = false;
  String count1, mobile;

  List qrCodePointList = [];
  List data = [];

  int qrCount = 4;

  var countText;

  Future serviceList() async {
    String url = "$kServiceList" + "$mobile";
    log("Service list url :" + url);
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // List<dynamic> listData = json.decode(response.body);
    }
  }

//When toggle button action method
  Future postStatus() async {
    log("entered in post method::");
    try {
      var res = await http.get(Uri.parse(
          "https://d4d2-175-100-138-233.ngrok.io/apidev/hajeriservicelistforuser/$mobile"));
      if (res.statusCode == 200) {
        List<dynamic> serviceData = json.decode(res.body);

        data = serviceData;
        // String response = json.decode(res.body);

        log("data of service: " + data.toString());

        return serviceData.map((service) => Service.fromJson(service)).toList();
      }
      throw HttpException('${res.statusCode}');
    // ignore: unused_catch_clause
    } on SocketException catch (e) {
      return Toast.show("No internet", context);
    // ignore: unused_catch_clause
    } on Exception catch (e) {
      return Toast.show("error occured", context);
    }
  }

  // ignore: missing_return
  Future<String> qrCodeCount() async {
    String orgId = prefs.getString("worker_id");
    String mobile = prefs.getString("mobile");
    log('$kQRPointList$orgId/$mobile');
    var response = await http.get(Uri.parse('$kQRPointList$orgId/$mobile'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      qrCodePointList = data;

      int count = qrCodePointList.length;

      log(data.toString());

      setState(() {
        count1 = count.toString();
        countText = Text(
          count1,
          style: TextStyle(color: Colors.green),
        );
        prefs.setString("count", count1);
        log("Set Count :  => " + count1);
      });

      // return "success";
    }
  }

  missedCallService() {
    AwesomeDialog(
        dismissOnTouchOutside: false,
        headerAnimationLoop: true,
        animType: AnimType.BOTTOMSLIDE,
        title: "Missed call Service",
        desc: "Dou you want to activate Missed call service?",
        btnCancelText: "No",
        btnCancelOnPress: () {},
        btnOkText: "Yes",
        btnOkOnPress: () {},
        context: context)
      ..show();
  }

  notificationDialog() {
    AwesomeDialog(
      dismissOnTouchOutside: false,
      context: context,
      headerAnimationLoop: true,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Notification Service',
      desc: "Do you want to on Notification service?",
      btnCancelText: "No",
      btnCancelOnPress: () {},
      btnOkText: "Yes",
      btnOkOnPress: () {},
    )..show();
  }

  faceServiceDialog() {
    AwesomeDialog(
        dismissOnTouchOutside: false,
        headerAnimationLoop: true,
        animType: AnimType.LEFTSLIDE,
        // title: 'Face scan',
        body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.18,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Face scan activation",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                    textAlign: TextAlign.center,
                  ),
                  Divider(),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    // Text("You have "),
                    Text(
                      " Active QR codes: ",
                      textAlign: TextAlign.justify,
                    ),
                    Text(
                      count1,
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ]),
                  Divider(),
                  // Text(
                  //   "Pricing: 300 + GST/QR code",
                  //   textAlign: TextAlign.center,
                  // ),
                  Text(
                    "To activate face scan system, Payment due Rs. 300+GST per QR code.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(),
                  )
                ]),
          ),
        ),
        btnOkText: "Pay",
        btnOkOnPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => RazorPay()),
          );
          setState(() {
            _toggled1 = true;
          });
        },
        btnCancelText: 'Cancel',
        btnCancelOnPress: () {
          setState(() {
            _toggled1 = false;
          });
          // Navigator.pop(context);
        },
        context: context)
      ..show();
  }

  @override
  void initState() {
    setState(() {
      mobile = prefs.getString("mobile");
    });
    serviceList();
    postStatus();
    qrCodeCount();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        centerTitle: true,
        title: Text(
          "Services",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
          child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return SwitchListTile(
                    title: Text(data[index]['servicename']),
                    // subtitle: Text(data[index]['servicecharges']),
                    value: data[index]['isserviceactivated'],
                    onChanged: (value) {});
              })
          // ListView(
          //   children: [
          //     SwitchListTile(
          //       value: _toggled1,
          //       onChanged: (value) {
          //         setState(() {
          //           _toggled1 = value;
          //           log("_toggled1: " + _toggled1.toString());
          //           if (_toggled1 == true) {
          //             faceServiceDialog();
          //           }
          //         });
          //       },
          //       secondary: Icon(Icons.face_retouching_natural_sharp),
          //       title: Text("Face scan attendance"),
          //     ),
          //     SwitchListTile(
          //       value: _toggled2,
          //       onChanged: (value) {
          //         setState(() {
          //           _toggled2 = value;
          //           missedCallService();
          //         });
          //       },
          //       secondary: Icon(Icons.phone_missed_outlined),
          //       title: Text("Missed call Attendance"),
          //     ),
          //     SwitchListTile(
          //       value: _toggled3,
          //       onChanged: (value) {
          //         setState(() {
          //           _toggled3 = value;
          //           notificationDialog();
          //         });
          //       },
          //       secondary: Icon(Icons.notifications),
          //       title: Text("Notifications"),
          //     ),
          //   ],
          // ),
          ),
    );
  }
}

class Service {
  final String servicename;
  final String servicecharges;
  final bool isactive;

  Service({this.servicename, this.servicecharges, this.isactive});

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
        servicename: json['servicename'],
        servicecharges: json['servicecharges'],
        isactive: json['isactive']);
  }
}