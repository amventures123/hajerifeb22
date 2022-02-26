import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
// import 'package:hajeri/Pages/department_wise_absent_list.dart';
import 'package:hajeri/url.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'dart:convert';

import '../main.dart';

class Summary {
  final String department;
  final String time;

  Summary({
    this.department,
    this.time,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      department: json['suborgname'],
      time: json['attendancedate'],
    );
  }
}

class EmpAttendance extends StatefulWidget {
  const EmpAttendance({Key key}) : super(key: key);

  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<EmpAttendance> {
  bool selected = false;
  var userStatus = <bool>[];
  int i;
  String dateIndex;
  int totalAmount = 0;
  String orgId;
  String typeSelectValue;
  String testUrl;
  DateTime _fromDate;
  String message = '';
  String mainBankId = prefs.getString("main_bank_id");
  String indexVal;

  List totalEmpAttendanceDetails = [];

  ScrollController _controller = ScrollController();

  Future<List<User>> _getUsers() async {
    String url = kMonthlyAttendance +
        '$mainBankId/$typeSelectValue/${_fromDate.toString().substring(0, 7)}';

    log("Monthly Attendance Url: " + url);
    var data = await http.get(Uri.parse(url));

    var jsonData = json.decode(data.body);
    String jdata = jsonData.toString();
    jdata = jdata.replaceAll("P", "");
    jdata = jdata.replaceAll("[", "");
    jdata = jdata.replaceAll("]", "");
    // jdata = jdata.replaceAll(":", "");

    log("Json Data: $jdata");

    List<User> users = [];

    for (i = 1; i <= 31; i++) {
      for (var u in jsonData) {
        User user = User(u[i.toString()], u['orgname']);
        log("i value: $i");

        users.add(user);
        userStatus.add(false);
      }
    }
    return users;
  }

  Future<List<Summary>> fetchSummary() async {
    String url =
        '$kTodaysPresentCompleteEmpList/$typeSelectValue/${_fromDate.toString().substring(0, 7)}-$dateIndex';
    log("Url in test: $url");
    final response = await http.get(Uri.parse(url));

    log("Response:" + response.body);

    if (response.statusCode == 200) {
      log("Entered");
      var parsed = json.decode(response.body);
      print(parsed.length);
      List jsonResponse = parsed as List;

      return jsonResponse.map((job) => new Summary.fromJson(job)).toList();
    } else {
      print('Error, Could not load Data.');
      throw Exception('Failed to load Data');
    }
  }

  buildTable() {
    return FutureBuilder(
      future: fetchSummary(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          log("Has Data");
          List<Summary> data = snapshot.data;
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              headingRowColor:
                  MaterialStateColor.resolveWith((states) => Colors.blue[800]),
              sortColumnIndex: 0,
              sortAscending: true,
              columns: [
                DataColumn(
                  label: Text(
                    'Department',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                  numeric: false,
                  tooltip: "Department",
                ),
                DataColumn(
                  label: Text(
                    'Time',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                  numeric: true,
                  tooltip: "Time",
                ),
              ],
              rows: data
                  .map(
                    (department) => DataRow(
                      cells: [
                        DataCell(
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  Center(
                                    child: Text(
                                      department.department,
                                      softWrap: true,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: Text(
                              department.time.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          );
        } else if (snapshot.hasError) {
          return AlertDialog(
            title: Text(
              'An Error Occured!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.redAccent,
              ),
            ),
            content: Text(
              "${snapshot.error}",
              style: TextStyle(
                color: Colors.blueAccent,
              ),
            ),
            actions: <Widget>[
              // ignore: deprecated_member_use
              FlatButton(
                child: Text(
                  'Go Back',
                  style: TextStyle(
                    color: Colors.redAccent,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
        // By default, show a loading spinner.
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Text('Please wait ...\nWe are almost there'),
              CircularProgressIndicator(),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  showSheet() {
    showBarModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: buildTable());
        });
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        message = "reach the bottom";
      });
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        message = "reach the top";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_scrollListener);
    orgId = prefs.getString('org_id');
    log("Org Id:>>> " + orgId);

    String workerId = prefs.getString('worker_id');
    log("Worker Id : " + workerId);

    typeSelectValue = prefs.getString('mobile');
    log("Mobile no:  " + typeSelectValue);

    _fromDate = DateTime.now();
    log("Date from initstate:  $_fromDate");
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Stack(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 50,
                color: Colors.blue[800],
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 60),
                        child: Text(
                          "Date",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 60),
                        child: Text(
                          "Time",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Container(
              child: FutureBuilder(
                future: _getUsers(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  print(snapshot.data);
                  if (snapshot.data == null) {
                    return Container(
                        child: const Center(
                            child: CircularProgressIndicator(
                      strokeWidth: 5,
                    )));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, index) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    indexVal = '${index + 1}';
                                    dateIndex = indexVal;
                                    log("set current date:" + dateIndex);
                                    // fetchSummary();
                                    showSheet();
                                  });
                                },
                                child: Container(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width,
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 50),
                                              child: Text(
                                                (index + 1).toString() +
                                                    '-'
                                                        '${_fromDate.toString().substring(5, 7)}'
                                                        '-'
                                                        '${_fromDate.toString().substring(0, 4)}',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Positioned.fill(
                                        //   child: Align(
                                        //     alignment: Alignment.lerp(
                                        //         Alignment.centerLeft,
                                        //         Alignment.center,
                                        //         0.9),
                                        //     child: Container(
                                        //       width: 140,
                                        //       child: Scrollbar(
                                        //         child: ListView(
                                        //             scrollDirection:
                                        //                 Axis.horizontal,
                                        //             children: [
                                        //               Padding(
                                        //                 padding:
                                        //                     const EdgeInsets
                                        //                         .only(right: 0),
                                        //                 child: Center(
                                        //                   child: Text(
                                        //                     snapshot.data[index]
                                        //                         .orgname,
                                        //                   ),
                                        //                 ),
                                        //               ),
                                        //             ]),
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                        GestureDetector(
                                          onTap: () {
                                            log("Clicked");

                                            log("index value: $indexVal");
                                            setState(() {
                                              indexVal = '${index + 1}';
                                              dateIndex = indexVal;
                                              log("set current date:" +
                                                  dateIndex);
                                              showSheet();
                                            });
                                          },
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Material(
                                              elevation: 0,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 20),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: Colors.grey)),
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .height,
                                                  width: 100,
                                                  child: Scrollbar(
                                                    isAlwaysShown: true,
                                                    controller: _controller,
                                                    child: ListView(
                                                      // controller: _controller,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      children: [
                                                        Center(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 5),
                                                            child: Text(
                                                              snapshot
                                                                  .data[index]
                                                                  .time
                                                                  .toString()
                                                                  .replaceAll(
                                                                      "P", "")
                                                                  .replaceAll(
                                                                      "[", "")
                                                                  .replaceAll(
                                                                      "]", ""),
                                                              style: TextStyle(
                                                                  fontSize: 14),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.blue))),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            )
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class User {
  final String time;
  final String orgname;

  User(this.time, this.orgname);
}

class User1 {
  final String time1;
  final String orgname1;

  User1(this.time1, this.orgname1);
}
