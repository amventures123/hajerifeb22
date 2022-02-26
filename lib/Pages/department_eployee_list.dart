import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:hajeri/components/department_details_data_grid_table.dart';
import 'package:hajeri/components/employee_data_grid.dart';
import 'package:hajeri/model/Employee.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:developer';
// import '../Pages/dashboard.dart';
// import '../Pages/monthly_attendance.dart';
// import '../Pages/employee_details.dart';
// import '../constant.dart';
// import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:http/http.dart' as http;
// import '../main.dart';
import '../url.dart';

class DepartmentEmployeeList extends StatefulWidget {
  static const id = "department_employee_list";
  final String departmentId;
  final String title;
  final String departmentName;
  DepartmentEmployeeList({
    this.departmentId,
    this.title,
    this.departmentName
  });
  @override
  _DepartmentEmployeeListState createState() => _DepartmentEmployeeListState();
}

class _DepartmentEmployeeListState extends State<DepartmentEmployeeList> {
  List pageView;
  bool showShimmer = true;
  String responseStatus;
  List<Employee> employees;
  String deptId;
  String departmentName;
  // PageController _pageController;
  @override
  void initState() {
    super.initState();
    deptId = widget.departmentId;
    departmentName = widget.departmentName;
    _getDepartmentEmployeeList().then((value) {
      showShimmer = false;
      responseStatus = value;
      log("value of dashboard is " + value);
    //  log("value of dashboard is 1 " + dashboardView);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //backgroundColor: Colors.blue[800],
        appBar: AppBar(
              backgroundColor: Colors.blue[800],
              title: Text(
                widget.title,
              ),
              centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.only(
            top: 8.0,
            left: 5,
            right: 5,
            bottom: 0.0,
          ),
          child: Column(
            children: [
              Expanded(
                  child: showShimmer
              ? Card(
                    margin: EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    child: Container(
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
                                  )
                                ]),
                          ),
                        ),
                      ),
                    ),
                  )
              : getBottomView())
            ],
          ),
        ),
      ),
    );
  }

 // ignore: missing_return
 Widget getBottomView() {
   switch (responseStatus) {
     case "no result":
       return Center(
         child: CircularProgressIndicator(),
       );
       break;
     case "error occurred":
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

 Future<String> _getDepartmentEmployeeList() async {
   log('$kEmployeeList$deptId');
  // log('$kEmployeeList$orgId/${departmentName.trim()}');
   try {
     var response = await http.get(Uri.parse("$kEmployeeList$deptId"));
     log("Response is ${response.toString()}", name: "Response is ");
     if (response.statusCode == 200) {
       List<dynamic> data = json.decode(response.body);
       log("Response is ${response.body}", name: "Response data is ");

       if (data.isNotEmpty) {
         employees = data
             .map<Employee>(
               (e) => Employee(
             name: e["nameofworker"].toString(),
             number: (e["mobileno"] == null ||
                 e["idcardno"].toString().trim().isEmpty)
                 ? 0
                 : int.parse(e["mobileno"]),
             idCardNumber: (e["idcardno"] == null ||
                 e["idcardno"].toString().trim().isEmpty ||
                 e["idcardno"]
                     .toString()
                     .trim()
                     .contains(new RegExp(r'[a-zA-Z]')))
                 ? 0
                 : int.parse(e["idcardno"]),
             organizationName: e["organizationname"].toString(),
             departmentName: e["departmentname"].toString(),
             city: e["city"].toString(),
             addressLine1: e["addressline1"].toString(),
             district: e["district"].toString(),
             state: e["state"].toString(),
           ),
         )
             .toList();
         return "success";
       } else {
         return 'no result';
       }
     } else {
       return 'server issue';
     }
   // ignore: unused_catch_clause
   } on SocketException catch (e) {
     return 'no internet';
   // ignore: unused_catch_clause
   } on Exception catch (e) {
     return 'error occurred';
   }
  }

  Widget getGridView() {
  /*  return DepartmentEmployeeListDataGrid
      (branchList: [],
      view: "Department Employee List",
      selectionModeDisabled: true,);*/
    return EmployeeDataGrid(
      employees: employees,
      view: "Employee List",
      selectionModeDisabled: true,
    );
  }

}



