import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../url.dart';

String orgId;
String toggleMethod = 'emp';

class SendNotificationPage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SendNotificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _userEditTextController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _controller = TextEditingController();
  TextEditingController _controller2 = TextEditingController();

  String dropdownValue1;
  String branchData;
  String data;
  String mobileNum;

  DateTime selectedDate = DateTime.now();

  bool _isVisible = false;
  bool _isVisible2 = false;

  var formatedDate;

  Future<void> _expiryDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now().subtract(Duration(days: 0)),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        var f = DateFormat('dd-MM-yyyy');
        selectedDate = picked;
        formatedDate = f.format(selectedDate);
        // date = selectedDate;
        log("Date1:  " + formatedDate);
        // _selectDate2(context);
      });
  }

  Future<void> sendNotificationAll() async {
    String url =
        "http://175.100.138.233:8085/apidev/sendnotification/$orgId?type=$dropdownValue1&msgtitle=${_controller2.text}&msg=${_controller.text}&expiredate=${selectedDate.toString().substring(0, 10)}";
    log("sendNotificationAll Url:" + url);
    var response = await http.post(Uri.parse(url));
    if (response.statusCode == 200) {
      log("success");
    }
  }

  Future<void> sendNotificationSpecific() async {
    String url =
        "http://175.100.138.233:8085/apidev/sendnotification/$orgId?type=$dropdownValue1&empmobile='$mobileNum'&msgtitle=${_controller2.text}&msg=${_controller.text}&expiredate=${selectedDate.toString().substring(0, 10)}";
    log("sendNotificationSpecific Url:" + url);
    var response = await http.post(Uri.parse(url));
    if (response.statusCode == 200) {
      log("success");
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      orgId = prefs.getString("org_id");
      log("Org id: " + orgId);
    });
    var f = DateFormat('dd-MM-yyyy');
    formatedDate = f.format(selectedDate);

    branchData = prefs.getString('branchListData');
    log("branchListData: $data");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Send Notification"),
        backgroundColor: Colors.blue[800],
      ),
      body: SingleChildScrollView(
        child: Card(
          color: Colors.blue[50],
          // padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  // padding: EdgeInsets.all(4),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('SEND TO :'),
                          ),
                          Expanded(
                            child: DropdownSearch<UserModel3>(
                              mode: Mode.DIALOG,
                              maxHeight: 250,
                              isFilteredOnline: true,
                              showClearButton: true,
                              showSelectedItems: true,
                              compareFn: (item, selectedItem) =>
                                  item?.id == selectedItem?.id,
                              dropdownSearchDecoration: InputDecoration(
                                hintText: 'select',
                                border: OutlineInputBorder(),
                                filled: false,
                                fillColor: Theme.of(context)
                                    .inputDecorationTheme
                                    .fillColor,
                              ),
                              autoValidateMode: AutovalidateMode.disabled,
                              validator: (u) =>
                                  u == null ? "this field is required " : null,
                              onFind: (String filter) => getData(filter),
                              onChanged: (data) {
                                log(data.toString());
                                dropdownValue1 =
                                    data.toString().replaceAll('[', '');
                                dropdownValue1 = dropdownValue1
                                    .toString()
                                    .replaceAll(']', '');
                                log("dropdownValue1: " + dropdownValue1);

                                if (dropdownValue1 == 'Specific Department') {
                                  setState(() {
                                    _isVisible2 = true;
                                    _isVisible = false;
                                    toggleMethod = 'dept';
                                  });
                                }
                                if (dropdownValue1 == 'Specific Employee') {
                                  setState(() {
                                    _isVisible = true;
                                    _isVisible2 = false;
                                    toggleMethod = 'emp';
                                  });
                                }
                                if (dropdownValue1 == 'null') {
                                  setState(() {
                                    _isVisible = false;
                                    _isVisible2 = false;
                                  });
                                }
                              },
                              popupItemBuilder: _customPopupItemBuilderExample3,
                              popupSafeArea:
                                  PopupSafeAreaProps(top: true, bottom: true),
                              scrollbarProps: ScrollbarProps(
                                isAlwaysShown: true,
                                thickness: 7,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: _isVisible,
                      child: DropdownSearch<UserModel>.multiSelection(
                        searchFieldProps: TextFieldProps(
                          controller: _userEditTextController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                _userEditTextController.clear();
                              },
                            ),
                          ),
                        ),
                        mode: Mode.DIALOG,
                        maxHeight: 700,
                        isFilteredOnline: true,
                        showClearButton: true,
                        showSelectedItems: true,
                        compareFn: (item, selectedItem) =>
                            item?.id == selectedItem?.id,
                        showSearchBox: true,
                        dropdownSearchDecoration: InputDecoration(
                          labelText: 'User *',
                          border: OutlineInputBorder(),
                          // filled: true,
                          // fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                        ),
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        validator: (u) => u == null || u.isEmpty
                            ? "user field is required "
                            : null,
                        onFind: (String filter) => getEmpData(filter),
                        onChanged: (data) {
                          // print(data);
                          String jdata = data.toString().replaceAll('[', '');
                          jdata = jdata.replaceAll(']', '');
                          log("Data of Emp: " + jdata);
                          setState(() {
                            mobileNum = jdata;
                          });
                          log("Mno:" + mobileNum);

                          // log(data.toString().replaceAll('[', ''));
                        },
                        dropdownBuilder: _customDropDownExampleMultiSelection,
                        popupItemBuilder: _customPopupItemBuilderExample,
                        popupSafeArea:
                            PopupSafeAreaProps(top: true, bottom: true),
                        scrollbarProps: ScrollbarProps(
                          isAlwaysShown: true,
                          thickness: 7,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _isVisible2,
                      child: DropdownSearch<UserModel2>.multiSelection(
                        searchFieldProps: TextFieldProps(
                          controller: _userEditTextController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                _userEditTextController.clear();
                              },
                            ),
                          ),
                        ),
                        mode: Mode.DIALOG,
                        maxHeight: 700,
                        isFilteredOnline: true,
                        showClearButton: true,
                        showSelectedItems: true,
                        compareFn: (item, selectedItem) =>
                            item?.id == selectedItem?.id,
                        showSearchBox: true,
                        dropdownSearchDecoration: InputDecoration(
                          labelText: 'User *',
                          border: OutlineInputBorder(),
                        ),
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        validator: (u) => u == null || u.isEmpty
                            ? "user field is required "
                            : null,
                        onFind: (String filter) => getDeptData(filter),
                        onChanged: (data) {
                          print(data);
                          log(data.toString());
                        },
                        dropdownBuilder: _customDropDownExampleMultiSelection2,
                        popupItemBuilder: _customPopupItemBuilderExample2,
                        popupSafeArea:
                            PopupSafeAreaProps(top: true, bottom: true),
                        scrollbarProps: ScrollbarProps(
                          isAlwaysShown: true,
                          thickness: 7,
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.grey[800],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("EXPIRY :"),
                          ),
                          // Text("${selectedDate.toLocal()}".split(' ')[0]),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: MediaQuery.of(context).size.height * 0.07,
                            child: TextFormField(
                              controller: _dateController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '$formatedDate',
                                  prefixIcon: Icon(Icons.date_range)),
                              onTap: () {
                                _expiryDate(context);
                                // Below line stops keyboard from appearing
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey[800],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _controller2,
                        decoration: InputDecoration(
                            hintText: 'Message TItle',
                            border: OutlineInputBorder()),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Required*';
                          }
                          return null;
                        },
                        minLines: 1,
                        keyboardType: TextInputType.multiline,
                        maxLines: 2,
                        // focusNode: FocusScopeNode(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _controller,
                        decoration: InputDecoration(
                            hintText: 'Write your message here...',
                            border: OutlineInputBorder()),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Required*';
                          }
                          return null;
                        },
                        minLines: 5,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        // focusNode: FocusScopeNode(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.09,
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              primary: Colors.blue[800],
                            ),
                            onPressed: () async {
                              log("clicked");
                              if (_formKey.currentState.validate()) {
                                log('form validation successful');

                                if (dropdownValue1 == 'Specific Department' ||
                                    dropdownValue1 == 'Specific Employee') {
                                  sendNotificationSpecific();
                                } else if (dropdownValue1 == 'All Employee' ||
                                    dropdownValue1 == 'All Department') {
                                  sendNotificationAll();
                                }

                                FocusScope.of(context)
                                    .requestFocus(FocusNode());

                                await SystemChannels.textInput
                                    .invokeMethod('TextInput.hide');
                              } else {
                                log("Error");
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Send",
                                  style: TextStyle(fontSize: 25),
                                ),
                                Icon(Icons.send)
                              ],
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _customDropDownExampleMultiSelection(
      BuildContext context, List<UserModel> selectedItems) {
    if (selectedItems.isEmpty) {
      return ListTile(
        contentPadding: EdgeInsets.all(0),
        // leading: CircleAvatar(),
        title: Text("No item selected"),
      );
    }

    return Wrap(
      children: selectedItems.map((e) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            child: ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: CircleAvatar(
                  child: Text(e?.nameofworker.toString().substring(0, 1))),
              title: Text(e?.nameofworker ?? ''),
              subtitle: Text(
                e?.mobileno.toString() ?? '',
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _customDropDownExampleMultiSelection2(
      BuildContext context, List<UserModel2> selectedItems) {
    if (selectedItems.isEmpty) {
      return ListTile(
        contentPadding: EdgeInsets.all(0),
        // leading: CircleAvatar(),
        title: Text("No item selected"),
      );
    }

    return Wrap(
      children: selectedItems.map((e) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            child: ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: CircleAvatar(
                child: Text(e?.nameoforganization.toString().substring(0, 1)),
              ),
              title: Text(e?.nameoforganization ?? ''),
              subtitle: Text(
                e?.mobile.toString() ?? '',
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _customPopupItemBuilderExample(
      BuildContext context, UserModel item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item?.nameofworker ?? ''),
        subtitle: Text(item?.mobileno?.toString() ?? ''),
        leading: CircleAvatar(
          child: Text(item?.nameofworker.toString().substring(0, 1)),
        ),
      ),
    );
  }

  Widget _customPopupItemBuilderExample2(
      BuildContext context, UserModel2 item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item?.nameoforganization ?? ''),
        subtitle: Text(item?.mobile?.toString() ?? ''),
        leading: CircleAvatar(
          child: Text(item?.nameoforganization.toString().substring(0, 1)),
        ),
      ),
    );
  }

  Widget _customPopupItemBuilderExample3(
      BuildContext context, UserModel3 item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item?.type ?? ''),
        leading: CircleAvatar(
          child: Text(item?.type.toString().substring(0, 1)),
        ),
      ),
    );
  }

  Future<List<UserModel3>> getData(filter) async {
    var response = await Dio().get(
      "$kNotificationTypeList",
      queryParameters: {"filter": filter},
    );

    final data = response.data;
    if (data != null) {
      return UserModel3.fromJsonList(data);
    }

    return [];
  }

  Future<List<UserModel>> getEmpData(filter) async {
    var response = await Dio().get(
      "https://www.hajeri.in/apidev//org/employeelist/44",
      queryParameters: {"filter": filter},
    );

    final data = response.data;
    if (data != null) {
      return UserModel.fromJsonList(data);
    }

    return [];
  }

  Future<List<UserModel2>> getDeptData(filter) async {
    var response = await Dio().get(
      "https://www.hajeri.in/apidev//branch/listofbranch/44",
      queryParameters: {"filter": filter},
    );

    final data = response.data;
    if (data != null) {
      return UserModel2.fromJsonList(data);
    }

    return [];
  }
}

class UserModel {
  final int id;
  // final String nameoforganization;
  final String type;
  final String nameofworker;
  final String mobileno;

  UserModel({this.id, this.type, this.nameofworker, this.mobileno});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      type: json['type'],
      nameofworker: json["nameofworker"],
      mobileno: json["mobileno"],
    );
  }

  static List<UserModel> fromJsonList(List list) {
    return list.map((item) => UserModel.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.nameofworker}';
  }

  ///this method will prevent the override of toString
  bool userFilterByCreationDate(String filter) {
    return this.nameofworker?.toString()?.contains(filter);
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(UserModel model) {
    return this.id == model?.id;
  }

  @override
  String toString() => mobileno;
}

class UserModel2 {
  final int id;
  final String nameoforganization;
  // final String nameofworker;
  final String mobile;

  UserModel2({this.id, this.nameoforganization, this.mobile});

  factory UserModel2.fromJson(Map<String, dynamic> json) {
    return UserModel2(
      id: json["id"],
      nameoforganization: json["nameoforganization"],
      // nameofworker: json["nameofworker"],
      mobile: json["mobile"],
    );
  }

  static List<UserModel2> fromJsonList(List list) {
    return list.map((item) => UserModel2.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.nameoforganization}';
  }

  ///this method will prevent the override of toString
  bool userFilterByCreationDate(String filter) {
    return this.nameoforganization?.toString()?.contains(filter);
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(UserModel2 model) {
    return this.id == model?.id;
  }

  @override
  String toString() => mobile;
}

class UserModel3 {
  final int id;
  // final String nameoforganization;
  final String type;
  // final String nameofworker;
  // final String mobileno;

  UserModel3({this.id, this.type});

  factory UserModel3.fromJson(Map<String, dynamic> json) {
    return UserModel3(
      id: json["id"],
      type: json['type'],
    );
  }

  static List<UserModel3> fromJsonList(List list) {
    return list.map((item) => UserModel3.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id}';
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(UserModel3 model) {
    return this.id == model?.id;
  }

  @override
  String toString() => type;
}
