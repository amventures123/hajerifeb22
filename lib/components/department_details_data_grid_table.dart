import 'package:flutter/material.dart';
import 'package:hajeri/constant.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

List _branchList = [];

DepartmentDataSource _employeeDataSource;

class DepartmentEmployeeListDataGrid extends StatefulWidget {
  final List branchList;
  final String view;
  final bool selectionModeDisabled;
  final String orgId;

  DepartmentEmployeeListDataGrid({
    @required this.branchList,
    this.view,
    this.selectionModeDisabled,
    this.orgId,
  });

  @override
  _DepartmentEmployeeListDataGridState createState() => _DepartmentEmployeeListDataGridState();
}

class _DepartmentEmployeeListDataGridState extends State<DepartmentEmployeeListDataGrid> {
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
          ],
          frozenColumnsCount: 1,
          selectionMode: widget.selectionModeDisabled
              ? SelectionMode.none
              : SelectionMode.singleDeselect,
          navigationMode: GridNavigationMode.row,
          onSelectionChanged:
              (List<DataGridRow> addedRows, List<DataGridRow> removedRows) {
            // // apply your logic
            //After First or Subsequent Select
            if (addedRows.isNotEmpty) {
              // var selectedEmployee = addedRows.first.getCells();
              setState(() {
              });
            }
            //After Deselect
            if (addedRows.isEmpty) {
              setState(() {
                isRowSelected = false;
              });
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
                            isRowSelected
                                ?
                                Container()
                                : Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
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
