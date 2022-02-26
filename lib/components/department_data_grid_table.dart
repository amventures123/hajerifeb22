import 'dart:developer' as dev;

import 'package:flutter/material.dart';
// import 'package:hajeri/Notify/notice.dart';
import 'package:hajeri/Pages/department_eployee_list.dart';
// import 'package:hajeri/Pages/department_wise_absent_list.dart';
import 'package:hajeri/Pages/department_wise_daily_attendance.dart';
// import 'package:hajeri/Pages/monthly_attendance.dart';
import 'package:hajeri/Pages/department_wise_absent_list.dart';
import 'package:hajeri/constant.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

// import '../main.dart';

List _branchList = [];

DepartmentDataSource _employeeDataSource;

class DepartmentDataGrid extends StatefulWidget {
  final List branchList;
  final String view;
  final bool selectionModeDisabled;
  final String orgId;

  DepartmentDataGrid({
    @required this.branchList,
    this.view,
    this.selectionModeDisabled,
    this.orgId,
  });

  @override
  _DepartmentDataGridState createState() => _DepartmentDataGridState();
}

class _DepartmentDataGridState extends State<DepartmentDataGrid> {
  final DataGridController _dataGridController = DataGridController();
  bool isRowSelected = false;

  @override
  void initState() {
    super.initState();
    _branchList = widget.branchList;
    _employeeDataSource = DepartmentDataSource();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SfDataGridTheme(
        data: SfDataGridThemeData(
          gridLineColor: Colors.grey,
          gridLineStrokeWidth: 0.5,
          headerColor: Colors.blue[800],
          selectionColor: Colors.blue[100],
          frozenPaneElevation: 1,
          sortIconColor: Colors.white,
        ),
        child: SfDataGrid(
          headerGridLinesVisibility: GridLinesVisibility.both,
          gridLinesVisibility: GridLinesVisibility.both,
          controller: _dataGridController,
          allowSorting: true,
          source: _employeeDataSource,
          isScrollbarAlwaysShown: true,
          columnWidthMode: ColumnWidthMode.fill,
          columns: [
            GridTextColumn(
              columnName: 'departmentName',
              label: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  'Department Name',
                  style: kDataGridHeaderTextStyle,
                ),
              ),
              width: 175.0,
            ),
            GridTextColumn(
              columnName: 'personName',
              label: Container(
                alignment: Alignment.center,
                child: Text(
                  'Name',
                  style: kDataGridHeaderTextStyle,
                ),
              ),
              width: 150,
            ),
            GridTextColumn(
              // columnWidthMode: ColumnWidthMode.auto,
              columnName: 'number',
              label: Container(
                alignment: Alignment.center,
                child: Text(
                  'Number',
                  style: kDataGridHeaderTextStyle,
                ),
              ),
              width: 150,
            ),
            GridTextColumn(
              columnName: 'id',
              label: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  'ID',
                  style: kDataGridHeaderTextStyle,
                ),
              ),
              visible:
                  false, // Intentionally making it invisible can be changed later
            ),
          ],
          frozenColumnsCount: 1,
          selectionMode: SelectionMode.none,
          navigationMode: GridNavigationMode.row,
          onCellTap: (details) {
            dev.log(
                "onTap details ${_employeeDataSource.dataGridRows[details.rowColumnIndex.rowIndex - 1].getCells()[details.rowColumnIndex.columnIndex].value.toString()}",
                name: "OnCellTap");
            var cell = _employeeDataSource
                .dataGridRows[details.rowColumnIndex.rowIndex - 1]
                .getCells();
            dev.log(
                "onTap ${cell[details.rowColumnIndex.columnIndex].toString()}",
                name: "OnCellTap");
            /*   dev.log("onTap1 ${cell[0].value}", name:"OnCellTap");
            dev.log("onTap1 ${cell[1].value}", name:"OnCellTap");
            dev.log("onTap1 ${cell[2].value}", name:"OnCellTap");
            dev.log("onTap1 ${cell[3].value}", name:"OnCellTap");*/
            dev.log("onTap view ${widget.view}", name: "OnCellTap view is");
            if (widget.view.contains("Department List")) {
              dev.log("onTap view in if department list",
                  name: "OnCellTap view is");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return DepartmentEmployeeList(
                      departmentId: cell[3].value.toString(),
                      title: cell[0].value,
                      departmentName: cell[0].value,
                    );
                  },
                ),
              );
            } else if (widget.view.contains("Today's Absent count")) {
              dev.log("Entered in Todays absent ");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => DepartmentWiseAbsentList(
                            orgId: cell[3].value.toString(),
                            department: cell[0].value,
                            appbarShow: 'Dashboard',
                          )));
            } else {
              dev.log("onTap view in else todays attendance",
                  name: "OnCellTap view is");
              /*   Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return MonthlyAttendance(
                      orgId: cell[3].value.toString(),
                    );
                  },
                ),
              );*/
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return DepartmentWiseTodaysAttendance(
                      orgId: cell[3].value.toString(),
                      department: cell[0].value,
                    );
                  },
                ),
              );
            }
          },
          stackedHeaderRows: widget.selectionModeDisabled
              ? []
              : <StackedHeaderRow>[
                  StackedHeaderRow(
                    cells: [
                      StackedHeaderCell(
                        columnNames: [
                          'departmentName',
                          'personName',
                          'number',
                          'id'
                        ],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                widget.view ?? '',
                                style: kDataGridHeaderTextStyle,
                              ),
                            ),
                            /* isRowSelected
                                ?
                                Container()
                                :*/
                            Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // StackedHeaderCell(
                  //     columnNames: ['productId', 'product'],
                  //     child: Container(
                  //         color: const Color(0xFFF1F1F1),
                  //         child:
                  //             Center(child: Text('Product Details'))))
                ],
        ),
      ),
    );
  }
}

class DepartmentDataSource extends DataGridSource {
  DepartmentDataSource() {
    buildDataGridRows();
  }

  void buildDataGridRows() {
    dataGridRows = _branchList
        .map<DataGridRow>(
          (dataGridRow) => DataGridRow(
            cells: [
              DataGridCell<String>(
                columnName: 'departmentName',
                value: dataGridRow["nameoforganization"] ?? '',
              ),
              DataGridCell<String>(
                columnName: 'personName',
                value: dataGridRow["personaname"] ?? '',
              ),
              DataGridCell<String>(
                columnName: 'number',
                value: dataGridRow["userName"] ?? '',
              ),
              DataGridCell<int>(
                columnName: 'id',
                value: dataGridRow["id"] ?? 0,
              ),
            ],
          ),
        )
        .toList();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        alignment: dataGridCell.columnName.toString().contains('departmentName')
            ? Alignment.centerLeft
            : Alignment.center,
        padding: EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: Text(
          dataGridCell.value.toString(),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      );
    }).toList());
  }

  @override
  bool shouldRecalculateColumnWidths() {
    return true;
  }

  void updateDataGridSource() {
    notifyListeners();
  }
}
