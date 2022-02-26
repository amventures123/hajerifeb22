// import 'dart:developer';

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hajeri/Notify/send_notification.dart';
import 'package:hajeri/main.dart';
// import 'package:hajeri/Pages/multiple_branch.dart';
// import 'package:hajeri/constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

// ignore: must_be_immutable
class Notice extends StatefulWidget {
  String payload;

  Notice({
    @required this.payload,
  });
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Notice> {
  String data;
  String hajeriLevel;

  bool iconVisibility = false;

  // String Payload;

  var superherosLength;

  var status;

  int index = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      hajeriLevel = prefs.getString('hajeri_level');
      if (hajeriLevel == 'Hajeri-Head' || hajeriLevel == 'Hajeri-Head-1') {
        iconVisibility = true;
      }
    });

    log("Hajeri Level: " + hajeriLevel);
    getData();
  }

  void getData() async {
    http.Response response = await http.get(
        Uri.parse("https://protocoderspoint.com/jsondata/superheros.json"));

    if (response.statusCode == 200) {
      setState(() {
        status = 200;
      });
      data = response.body;

      setState(() {
        superherosLength = jsonDecode(data)['superheros'];

        print(superherosLength.length);
      });

      var venam = jsonDecode(data)['superheros'][4]['url'];

      print(venam);
      //notification auto click
      clickEvent(index);
    } else {
      print(response.statusCode);
    }
  }

  clickEvent(index) {
    showBarModalBottomSheet(
        enableDrag: true,
        context: context,
        builder: (context) => Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.blue[800],
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          jsonDecode(data)['superheros'][index]['name'],
                          // style: kNotificBottomsheetTextStyle
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      jsonDecode(data)['superheros'][index]['power'],
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text("Notifications"),
        centerTitle: true,
        actions: [
          Visibility(
            visible: iconVisibility,
            child: IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => SendNotificationPage()));
              },
              icon: Icon(Icons.add),
              iconSize: 30,
            ),
          ),
        ],
      ),
      body: status == 200
          ? ListView.builder(
              itemCount: superherosLength == null ? 0 : superherosLength.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    leading: Image.network(
                      jsonDecode(data)['superheros'][index]['url'],
                      fit: BoxFit.fill,
                      width: 100,
                      height: 500,
                      alignment: Alignment.center,
                    ),
                    title: Text(jsonDecode(data)['superheros'][index]['name']),
                    subtitle:
                        Text(jsonDecode(data)['superheros'][index]['power']),
                    onTap: () {
                      clickEvent(index);
                    },
                  ),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
