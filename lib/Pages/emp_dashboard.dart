import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hajeri/main.dart';
import 'package:hajeri/pages/emp_attendance.dart';
import 'package:hajeri/components/box_tile.dart';
import 'package:hajeri/constant.dart';
import 'package:hajeri/url.dart';
// import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:intl/intl.dart';

class DataTableEx extends StatefulWidget {
  DataTableEx({Key key, @required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<DataTableEx> {
  int presentCount, abbsentCount;
  int i;

  String mobNo = prefs.getString("mobile");
  String pCount = '', aCount = '';
  String mainBankId, typeSelectValue;

  DateTime _fromDate;

  var userStatus = <bool>[];

  // ignore: missing_return
  Future<Album> fetchAlbum() async {
    String url = "$kEmployeeHistory/$mobNo";
    final response = await http.get(Uri.parse(url));

    log("url message" + url);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      var decodedEmp = json.decode(response.body).cast<Map<String, dynamic>>();
      List<Album> empList1 =
          await decodedEmp.map<Album>((json) => Album.fromJson(json)).toList();

      setState(() {});
      presentCount = (empList1.length) + 1;
      int sub = 31 - presentCount;
      pCount = presentCount.toString();
      aCount = sub.toString();
      // abbsentCount =
      log("empList1.length " + pCount);
      log("empList1.length " + aCount);
      // return empList1;
      // return Album.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

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

  @override
  void initState() {
    super.initState();
    setState(() {
      mainBankId = prefs.getString("main_bank_id");
      typeSelectValue = prefs.getString('mobile');
      _fromDate = DateTime.now();
    });
    fetchAlbum();
    _getUsers();
  }

  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(children: [
        Expanded(
          child: Card(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.15,
              // color: Colors.amber,
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BoxTile(
                      size: Size(150, 100),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: SingleChildScrollView(
                          child: Column(children: [
                            Text(
                              "Present Count",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800),
                            ),
                            // FutureBuilder(
                            //     future: fetchAlbum(),
                            //     builder: (context, snapshot) {
                            //       if (snapshot.hasData) {
                            //         return Text(
                            //           snapshot.data.id.toString(),
                            //           style: TextStyle(color: Colors.white),
                            //         );
                            //       } else if (snapshot.hasError) {
                            //         return Text("-");
                            //       }
                            //       return Text("");
                            //     })
                            Text(
                              pCount,
                              style: TextStyle(color: Colors.white),
                            )
                          ]),
                        ),
                      ),
                      onPressed: () {},
                      color: Colors.green,
                    ),
                    BoxTile(
                        size: Size(150, 100),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: SingleChildScrollView(
                            child: Column(children: [
                              Text(
                                "Absent Count\n (Incl. Sunday)",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800),
                              ),
                              Text(
                                aCount,
                                style: TextStyle(color: Colors.white),
                              )
                              // FutureBuilder(
                              //     future: fetchAlbum(),
                              //     // ignore: missing_return
                              //     builder: (context, snapshot) {
                              //       if (snapshot.hasData) {
                              //         return Text(
                              //           snapshot.data.id.toString(),
                              //           style: TextStyle(color: Colors.white),
                              //         );
                              //       } else if (snapshot.hasError) {
                              //         return Text("-");
                              //       }
                              //       return Text("-");
                              //     })
                            ]),
                          ),
                        ),
                        color: Colors.red,
                        onPressed: () {}),
                  ],
                ),
              ]),
            ),
          ),
        ),
        Card(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            child: EmpAttendance(),
          ),
        ),
      ]),
    ));
  }

  Future<EmployeeDataGridSource> getEmpDataSource() async {
    var empList = await generateEmpList();
    return EmployeeDataGridSource(empList);
  }

  List<GridColumn> getColumns() {
    return <GridColumn>[
      GridTextColumn(
          columnName: 'name',
          width: 170,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: Text('Dapartment',
                  style: kDataGridHeaderTextStyle,
                  overflow: TextOverflow.clip,
                  softWrap: true))),
      GridTextColumn(
          columnName: 'id',
          width: 130,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.center,
              child: Text('Date',
                  style: kDataGridHeaderTextStyle,
                  overflow: TextOverflow.clip,
                  softWrap: true))),
      GridTextColumn(
          columnName: 'mobile',
          width: 130,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.center,
              child: Text('Time',
                  style: kDataGridHeaderTextStyle,
                  overflow: TextOverflow.clip,
                  softWrap: true))),
    ];
  }

  Future<List<Employee>> generateEmpList() async {
    var response = await http.get(Uri.parse(
        'https://www.hajeri.in/apidev/org/attendance/50/7028754387/2021-12'));
    var decodedEmp = json.decode(response.body).cast<Map<String, dynamic>>();
    List<Employee> empList = await decodedEmp
        .map<Employee>((json) => Employee.fromJson(json))
        .toList();
    return empList;
  }
}

class EmployeeDataGridSource extends DataGridSource {
  EmployeeDataGridSource(this.empList) {
    buildDataGridRow();
  }
  List<DataGridRow> dataGridRows;
  List<Employee> empList;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      Container(
        child: Text(
          row.getCells()[0].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[1].value,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[2].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ]);
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  void buildDataGridRow() {
    dataGridRows = empList.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell(columnName: 'name', value: dataGridRow.nameofworker),
        DataGridCell<String>(columnName: 'id', value: dataGridRow.idcardno),
        DataGridCell<String>(columnName: 'mobile', value: dataGridRow.mobileno),
      ]);
    }).toList(growable: false);
  }
}

class Employee {
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      nameofworker: json['orgname'],
      idcardno: json['name'],
      mobileno: json['mobileno'],
      organizationname: json['organizationname'],
      state: json['state'],
    );
  }
  Employee({
    @required this.nameofworker,
    @required this.idcardno,
    @required this.mobileno,
    @required this.organizationname,
    @required this.state,
  });
  final String nameofworker;
  final String idcardno;
  final String mobileno;
  final String organizationname;
  final String state;
}

class Album {
  final int userId;
  final int id;
  final String title;

  Album({
    @required this.userId,
    @required this.id,
    @required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}
