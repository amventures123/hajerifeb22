import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hajeri/url.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:intl/intl.dart';

class DepartmentWiseAbsentList extends StatefulWidget {
  DepartmentWiseAbsentList(
      {Key key, @required this.orgId, this.department, this.appbarShow})
      : super(key: key);

  final String orgId;
  final String department;
  final String appbarShow;

  @override
  _DepartmentWiseAbsentListState createState() =>
      _DepartmentWiseAbsentListState();
}

class _DepartmentWiseAbsentListState extends State<DepartmentWiseAbsentList> {
  var department;
  var orgId;
  var appbarShow;

  @override
  void initState() {
    super.initState();
    department = widget.department;
    orgId = widget.orgId;
    appbarShow = widget.appbarShow;
  }

  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: appbarShow == "Dashboard" ?
      AppBar(
        centerTitle: true,
        // automaticallyImplyLeading: false,
        backgroundColor: Colors.blue[800],
        title: Text("$department"),
      ) : null
      ,
      body: Card(
        child: Container(
          child: FutureBuilder(
            future: getProductDataSource(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return snapshot.hasData
                  ? SfDataGridTheme(
                      data: SfDataGridThemeData(headerColor: Colors.blue[800]),
                      child: SfDataGrid(
                          navigationMode: GridNavigationMode.cell,
                          selectionMode: SelectionMode.single,
                          frozenColumnsCount: 1,
                          source: snapshot.data,
                          columns: getColumns()))
                  : Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                      ),
                    );
            },
          ),
        ),
      ),
    ));
  }

  Future<ProductDataGridSource> getProductDataSource() async {
    var productList = await generateProductList();
    return ProductDataGridSource(productList);
  }

  List<GridColumn> getColumns() {
    return <GridColumn>[
      GridTextColumn(
          columnName: 'nameofworker',
          columnWidthMode: ColumnWidthMode.fill,
          // width: 150,
          label: Container(
              // color: Colors.blue[800],
              padding: EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: Text('Name',
                  style: TextStyle(color: Colors.white),
                  overflow: TextOverflow.clip,
                  softWrap: true))),
      GridTextColumn(
          columnName: 'mobileno',
          // width: 150,
          columnWidthMode: ColumnWidthMode.fill,
          label: Container(
              // color: Colors.blue[800],
              padding: EdgeInsets.all(8),
              alignment: Alignment.center,
              child: Text('Mobile',
                  style: TextStyle(color: Colors.white),
                  overflow: TextOverflow.clip,
                  softWrap: true))),
    ];
  }

  Future<List<Product>> generateProductList() async {
    String url = '$kTodayAbsentEmpList$orgId';
    log("in Absent emp Page url:" + url);
    var response = await http.get(Uri.parse(url));
    var decodedProducts =
        json.decode(response.body).cast<Map<String, dynamic>>();
    List<Product> productList = await decodedProducts
        .map<Product>((json) => Product.fromJson(json))
        .toList();
    return productList;
  }
}

class ProductDataGridSource extends DataGridSource {
  ProductDataGridSource(this.productList) {
    buildDataGridRow();
  }
  List<DataGridRow> dataGridRows;
  List<Product> productList;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      GestureDetector(
        onTap: () {
          log("Clicked cell");
        },
        child: Container(
          child: Text(
            row.getCells()[0].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(8.0),
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[1].value,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ]);
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  void buildDataGridRow() {
    dataGridRows = productList.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell(
            columnName: 'nameofworker', value: dataGridRow.nameofworker),
        DataGridCell<String>(
            columnName: 'mobileno', value: dataGridRow.mobileno),
      ]);
    }).toList(growable: false);
  }
}

class Product {
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      nameofworker: json['nameofworker'],
      mobileno: json['mobileno'],
    );
  }
  Product({
    @required this.nameofworker,
    @required this.mobileno,
  });
  final String nameofworker;
  final String mobileno;
}
