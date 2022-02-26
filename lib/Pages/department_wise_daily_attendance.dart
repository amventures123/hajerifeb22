import 'dart:convert';
import 'dart:developer';
// import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:path_provider/path_provider.dart' as path;
import 'dart:async';
import 'dart:io';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:toast/toast.dart';
// import 'package:open_file/open_file.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
// import '../components/attendance_data_grid.dart';
import '../components/visitor_data_grid.dart';

// import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:flutter/material.dart';
// import '../components/side_bar.dart';
// import '../constant.dart';
import '../url.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
// import '../main.dart';

class DepartmentWiseTodaysAttendance extends StatefulWidget {
  static const id = 'monthly_attendance';
  final String orgId;
  final String department;
  const DepartmentWiseTodaysAttendance({Key key, this.orgId, this.department})
      : super(key: key);

  @override
  _DepartmentWiseTodaysAttendanceState createState() =>
      _DepartmentWiseTodaysAttendanceState();
}

class _DepartmentWiseTodaysAttendanceState
    extends State<DepartmentWiseTodaysAttendance> {
  bool isAnimationFinished = false;
  bool showShimmer = true;
  String attendanceStatus = "no result";
  // String _localPath;
  TargetPlatform platform = TargetPlatform.android;
  List<dynamic> visitors;
  DateTime today = DateTime.now();
  // DateTime _fromDate;

  TextEditingController search = new TextEditingController();

  List<DataRow> rows = [];
  int days = 28;
  List empList;
  var attendanceData;
  var department;
  String orgId;
  @override
  void initState() {
    super.initState();
    orgId = widget.orgId;
    department = widget.department;
    _getEmployeeList().then(
      (value) => setState(
        () {
          log("attendance status in setState $value",
              name: 'In dept attendence');
          attendanceStatus = value;
          showShimmer = false;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.blue[800],
        title: Text(
          "$department",
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
                child: showShimmer
                    ? Container(
                        width: double.maxFinite,
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[100],
                          enabled: true,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10,
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          5.0,
                                        ),
                                      ),
                                      color: Colors.white,
                                    ),
                                    width: 250,
                                    height: 40,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: 30.0,
                                    ),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: List.generate(
                                          10,
                                          (index) => Container(
                                            margin: EdgeInsets.only(
                                              right: 16.0,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                  5.0,
                                                ),
                                              ),
                                              color: Colors.white,
                                            ),
                                            width: 75,
                                            height: 35,
                                          ),
                                        ).toList(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 18.0,
                                  ),
                                  Column(
                                    children: List.generate(10, (index) {
                                      return Container(
                                        margin: EdgeInsets.only(
                                          bottom: 12.0,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                              5.0,
                                            ),
                                          ),
                                          color: Colors.white,
                                        ),
                                        width: double.maxFinite,
                                        height: 30,
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : getBottomView()),
          ],
        ),
      ),
    );
  }

  // ignore: missing_return
  Widget getBottomView() {
    log("attendance status $attendanceStatus", name: 'In visitor init');
    switch (attendanceStatus) {
      case "no result":
        return Center(
          child: CircularProgressIndicator(),
        );
        break;
      case "error":
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/vectors/notify.svg',
                width: 150,
                height: 150,
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'Error has occured',
              ),
            ],
          ),
        );
        break;
      case "no internet":
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/vectors/no_signal.svg',
                width: 150,
                height: 150,
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'Device not connected to internet',
              ),
            ],
          ),
        );
        break;
      case "server issue":
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/vectors/server_down.svg',
                width: 150,
                height: 150,
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'Server error',
              ),
            ],
          ),
        );
        break;
      case "success":
        return getGridView();
        break;
    }
  }

  Widget getGridView() {
    return (visitors).isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/vectors/notify.svg',
                  width: 150,
                  height: 150,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'No Visitor',
                ),
              ],
            ),
          )
        : Card(
            child: VisitorDataGrid(
              attendanceSheet: visitors,
            ),
          );
  }

  Future<String> _getEmployeeList() async {
    log("$kTodayPresentEmpList$orgId");
    try {
      var response = await http.get(Uri.parse("$kTodayPresentEmpList$orgId"));
      log("attendance response ${response.toString()}",
          name: 'In dept attendence');
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        // List<dynamic> data = getTodaysDummyData();
        log("attendance data $data", name: 'In dept attendence');
        // print("the _getTodayPresentEmployeeList data is " + data.toString());
        bool emptyData = data.isEmpty;
        //  log("attendance data ${data}", name: 'In dept attendence');
        if (!emptyData) {
          visitors = data;
          return 'success';
        } else {
          return 'error';
        }
      } else {
        return 'server issue';
      }
    // ignore: unused_catch_clause
    } on SocketException catch (e) {
      return 'no internet';
    } catch (e) {
      return 'error occurred';
    }
  }

  // Future<String> _getAbsentEmployeeList() async {
  //   log("$kTodayPresentEmpList$orgId");
  //   try {
  //     var response = await http.get(Uri.parse("$kTodayPresentEmpList$orgId"));
  //     log("attendance response ${response.toString()}",
  //         name: 'In dept attendence');
  //     if (response.statusCode == 200) {
  //       List<dynamic> data = json.decode(response.body);
  //       // List<dynamic> data = getTodaysDummyData();
  //       log("attendance data ${data}", name: 'In dept attendence');
  //       // print("the _getTodayPresentEmployeeList data is " + data.toString());
  //       bool emptyData = data.isEmpty;
  //       //  log("attendance data ${data}", name: 'In dept attendence');
  //       if (!emptyData) {
  //         visitors = data;
  //         return 'success';
  //       } else {
  //         return 'error';
  //       }
  //     } else {
  //       return 'server issue';
  //     }
  //   } on SocketException catch (e) {
  //     return 'no internet';
  //   } catch (e) {
  //     return 'error occurred';
  //   }
  // }

  List getTodaysDummyData() {
    return [
      {
        "id": 46825,
        "shopkeeperid": "50",
        "clientid": "1181",
        "date": 1641184702000,
        "visitingtime": null,
        "clientmobno": "8999320938",
        "type": null,
        "vechileno": null,
        "visitingcity": null,
        "age": null,
        "passavailableornot": null,
        "visitingcityto": null,
        "numberofpassenger": null,
        "personname": "Anandkumar Vishwakarma",
        "clientmobile": "8999320938",
        "nameofworker": "Anandkumar Vishwakarma",
        "departmentname": null,
        "clientaddress": null,
        "attendancedatefortransaction": null,
        "clientrole": "Employee",
        "ifsc": null,
        "branchid": null,
        "ismisscallornot": null,
        "suborgname": "IT DEPARTMENT",
        "orgidinsidercode": "50",
        "hajeriheadid": "44",
        "ismyemployee": "Yes",
        "ismymainbranchemployee": "Yes",
        "attendancedate": "10:08:22"
      },
      {
        "id": 46792,
        "shopkeeperid": "50",
        "clientid": "50",
        "date": 1641184166000,
        "visitingtime": null,
        "clientmobno": "8830328236",
        "type": "SubBranch",
        "vechileno": null,
        "visitingcity": null,
        "age": null,
        "passavailableornot": null,
        "visitingcityto": null,
        "numberofpassenger": null,
        "personname": "PRAVIN JOSHI",
        "clientmobile": "8830328236",
        "nameofworker": "PRAVIN JOSHI",
        "departmentname": null,
        "clientaddress": null,
        "attendancedatefortransaction": null,
        "clientrole": "Employee",
        "ifsc": null,
        "branchid": null,
        "ismisscallornot": null,
        "suborgname": "IT DEPARTMENT",
        "orgidinsidercode": "50",
        "hajeriheadid": "44",
        "ismyemployee": "Yes",
        "ismymainbranchemployee": "Yes",
        "attendancedate": "09:59:26"
      },
      {
        "id": 46909,
        "shopkeeperid": "50",
        "clientid": "58",
        "date": 1641202060000,
        "visitingtime": null,
        "clientmobno": "7709606288",
        "type": null,
        "vechileno": null,
        "visitingcity": null,
        "age": null,
        "passavailableornot": null,
        "visitingcityto": null,
        "numberofpassenger": null,
        "personname": "SIDDHANT WATWANI",
        "clientmobile": "7709606288",
        "nameofworker": "SIDDHANT WATWANI",
        "departmentname": null,
        "clientaddress": null,
        "attendancedatefortransaction": null,
        "clientrole": "Employee",
        "ifsc": null,
        "branchid": null,
        "ismisscallornot": null,
        "suborgname": "IT DEPARTMENT",
        "orgidinsidercode": "50",
        "hajeriheadid": "44",
        "ismyemployee": "Yes",
        "ismymainbranchemployee": "Yes",
        "attendancedate": "14:57:40,17:10:10,17:10:33"
      },
      {
        "id": 46994,
        "shopkeeperid": "50",
        "clientid": "656",
        "date": 1641215659000,
        "visitingtime": null,
        "clientmobno": "7028754387",
        "type": null,
        "vechileno": null,
        "visitingcity": null,
        "age": null,
        "passavailableornot": null,
        "visitingcityto": null,
        "numberofpassenger": null,
        "personname": "BAPU SULTANE",
        "clientmobile": "7028754387",
        "nameofworker": "BAPU SULTANE",
        "departmentname": null,
        "clientaddress": null,
        "attendancedatefortransaction": null,
        "clientrole": "Employee",
        "ifsc": null,
        "branchid": null,
        "ismisscallornot": null,
        "suborgname": "IT DEPARTMENT",
        "orgidinsidercode": "50",
        "hajeriheadid": "44",
        "ismyemployee": "Yes",
        "ismymainbranchemployee": "Yes",
        "attendancedate": "18:44:19,10:02:01"
      },
      {
        "id": 46993,
        "shopkeeperid": "50",
        "clientid": "969",
        "date": 1641215591000,
        "visitingtime": null,
        "clientmobno": "9767818177",
        "type": null,
        "vechileno": null,
        "visitingcity": null,
        "age": null,
        "passavailableornot": null,
        "visitingcityto": null,
        "numberofpassenger": null,
        "personname": "SAGAR HAPAT",
        "clientmobile": "9767818177",
        "nameofworker": "SAGAR HAPAT",
        "departmentname": null,
        "clientaddress": null,
        "attendancedatefortransaction": null,
        "clientrole": "Employee",
        "ifsc": null,
        "branchid": null,
        "ismisscallornot": null,
        "suborgname": "IT DEPARTMENT",
        "orgidinsidercode": "50",
        "hajeriheadid": "44",
        "ismyemployee": "Yes",
        "ismymainbranchemployee": "Yes",
        "attendancedate": "18:43:11,10:00:52"
      }
    ];
  }
}
