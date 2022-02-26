import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hajeri/Pages/hajeri_head1_dashboard.dart';
import '../Pages/dashboard.dart';
import '../Pages/monthly_attendance.dart';
import '../Pages/employee_details.dart';
import '../constant.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class BranchLanding extends StatefulWidget {
  static const id = "landing_page";
  final String orgId;
  final String role;
  String dashboardview = 'Hajeri-Head-1';
  BranchLanding({this.orgId, this.role, this.dashboardview});
  @override
  _BranchLandingState createState() => _BranchLandingState();
}

class _BranchLandingState extends State<BranchLanding> {
  List pageView;
  String orgId;
  PageController _pageController;
  @override
  void initState() {
    super.initState();
    orgId = widget.orgId;
    log("Org Id in Branch landing:  " + orgId);
    pageView = [
      HajeriHead1DashboardDashboard(
        orgId: widget.orgId,
      ),
      // Dashboard(
      //   orgId: widget.orgId,
      //   role: widget.role,
      // ),
      EmployeeDetails(
        orgId: widget.orgId,
      ),
      MonthlyAttendance(
        orgId: widget.orgId,
      ),
    ];
    _pageController = PageController(
      initialPage: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView.builder(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          itemCount: 3,
          itemBuilder: (context, index) {
            return pageView[index];
          },
        ),

        //  TabBarView(
        //   //No Scroll whence changing tab
        //   physics: NeverScrollableScrollPhysics(),
        //   children: [
        //     Dashboard(),
        //     // Scanner(),
        //     Text(
        //       'scanner',
        //     ),
        //     MonthlyAttendance(),
        //   ],
        // ),
        bottomNavigationBar: ConvexAppBar.badge(
          null,
          gradient: kGradient,
          cornerRadius: 5.0,
          height: 60,
          elevation: 5,
          curveSize: 85,
          style: TabStyle.fixedCircle,
          items: <TabItem>[
            for (final entry in kOrgPages.entries)
              TabItem(
                icon: entry.value,
                title: entry.key,
              ),
          ],
          onTap: (int i) {
            print('Click index=$i');
            _pageController.jumpToPage(i);
          },
        ),
      ),
    );
  }
}
