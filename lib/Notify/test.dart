import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// import 'user_model.dart';

class MyDropDown extends StatefulWidget {
  @override
  _MyDropDownState createState() => _MyDropDownState();
}

class _MyDropDownState extends State<MyDropDown> {
  final _formKey = GlobalKey<FormState>();
  final _openDropDownProgKey = GlobalKey<DropdownSearchState<String>>();
  // final _multiKey = GlobalKey<DropdownSearchState<String>>();
  final _userEditTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("DropdownSearch Demo")),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: EdgeInsets.all(4),
            children: <Widget>[
              DropdownSearch<UserModel>.multiSelection(
                searchFieldProps: TextFieldProps(
                  controller: _userEditTextController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _userEditTextController.clear();
                      },
                    ),
                  ),
                ),
                mode: Mode.BOTTOM_SHEET,
                maxHeight: 700,
                isFilteredOnline: true,
                showClearButton: true,
                showSelectedItems: true,
                compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
                showSearchBox: true,
                dropdownSearchDecoration: InputDecoration(
                  labelText: 'User *',
                  filled: true,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                ),
                autoValidateMode: AutovalidateMode.onUserInteraction,
                validator: (u) =>
                    u == null || u.isEmpty ? "user field is required " : null,
                onFind: (String filter) => getData(filter),
                onChanged: (data) {
                  log(data.toString());
                },
                dropdownBuilder: _customDropDownExampleMultiSelection,
                popupItemBuilder: _customPopupItemBuilderExample,
                popupSafeArea: PopupSafeAreaProps(top: true, bottom: true),
                scrollbarProps: ScrollbarProps(
                  isAlwaysShown: true,
                  thickness: 7,
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
        leading: CircleAvatar(),
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
                  // this does not work - throws 404 error
                  // backgroundImage: NetworkImage(item.avatar ?? ''),
                  ),
              title: Text(e?.mobileno.toString() ?? ''),
              // subtitle: Text(
              //   e?.nameofworker.toString() ?? '',
              // ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // RenderBox _findBorderBox(RenderBox box) {
  //   RenderBox borderBox;

  //   box.visitChildren((child) {
  //     if (child is RenderCustomPaint) {
  //       borderBox = child;
  //     }

  //     final box = _findBorderBox(child as RenderBox);
  //     if (box != null) {
  //       borderBox = box;
  //     }
  //   });

  //   return borderBox;
  // }

  // Widget _customDropDownExample(BuildContext context, UserModel item) {
  //   if (item == null) {
  //     return Container();
  //   }

  //   return Container(
  //     child: (item.avatar == null)
  //         ? ListTile(
  //             contentPadding: EdgeInsets.all(0),
  //             leading: CircleAvatar(),
  //             title: Text("No item selected"),
  //           )
  //         : ListTile(
  //             contentPadding: EdgeInsets.all(0),
  //             leading: CircleAvatar(
  //                 // this does not work - throws 404 error
  //                 // backgroundImage: NetworkImage(item.avatar ?? ''),
  //                 ),
  //             title: Text(item.name),
  //             subtitle: Text(
  //               item.createdAt.toString(),
  //             ),
  //           ),
  //   );
  // }

  Widget _customPopupItemBuilderExample(
      BuildContext context, UserModel item, bool isSelected) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item?.mobileno.toString() ?? ''),
        // subtitle: Text(item?.nameofworker?.toString() ?? ''),
        leading: CircleAvatar(
            // this does not work - throws 404 error
            // backgroundImage: NetworkImage(item.avatar ?? ''),
            ),
      ),
    );
  }

//   Widget _customPopupItemBuilderExample2(
//       BuildContext context, UserModel item, bool isSelected) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 8),
//       decoration: !isSelected
//           ? null
//           : BoxDecoration(
//               border: Border.all(color: Theme.of(context).primaryColor),
//               borderRadius: BorderRadius.circular(5),
//               color: Colors.white,
//             ),
//       child: ListTile(
//         selected: isSelected,
//         title: Text(item?.name ?? ''),
//         subtitle: Text(item?.createdAt?.toString() ?? ''),
//         leading: CircleAvatar(
//             // this does not work - throws 404 error
//             // backgroundImage: NetworkImage(item.avatar ?? ''),
//             ),
//       ),
//     );
//   }

  Future<List<UserModel>> getData(filter) async {
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
}

class UserModel {
  final int id;
  final String nameoforganization;
  final String nameofworker;
  final String avatar;
  final String mobileno;

  UserModel(
      {this.id,
      this.nameoforganization,
      this.nameofworker,
      this.avatar,
      this.mobileno});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json["id"],
        nameoforganization: json["nameoforganization"].toString(),
        nameofworker: json["nameofworker"].toString(),
        mobileno: json['mobileno']
        // avatar: json["avatar"],
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
    return this.nameofworker?.toString().contains(filter);
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(UserModel model) {
    return this.id == model?.id;
  }

  @override
  String toString() => nameofworker;
}
