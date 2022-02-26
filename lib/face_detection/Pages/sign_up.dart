import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_face_api/face_api.dart';
import 'package:hajeri/face_detection/Pages/last_step.dart';
// import 'package:hajeri/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
// import '../Pages/landing.dart';
import 'package:hajeri/Pages/landing.dart' as landing;
import '../constant.dart';

class SignUp extends StatefulWidget {
  static String id = "sign_up";
  const SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // TextEditingController _cNumber;

  // var _formKey = GlobalKey<FormState>();
  SharedPreferences saver;
  String enroll = '';
  String btnText = '';

  @override
  void initState() {
    super.initState();
    // enroll = 'Enroll';
    // btnText = 'Go To Scanner';
    // decide();
    preferencesInit();
    // setState(() {
    //   // String val = prefs.getString("invalid");
    //   // enroll = 'invalid';
    //   // log("Value: "+val);
    // });

    // _cNumber = TextEditingController();

    Future.delayed(Duration(seconds: 0), () {
      pressButton();
    });
  }

  void preferencesInit() async {
    saver = await SharedPreferences.getInstance();
  }

  void decide() async {
    final shdFaceRec = saver.getBool('face_rec') ?? true;
    String userImage = '';
    if (shdFaceRec) {
      userImage = saver.getString('enrolled_image') ?? '';
      Toast.show(
          (userImage.isEmpty ? 'Register ' : 'Login') + ' process started...',
          context,
          duration: Toast.LENGTH_LONG);
      if (userImage.isEmpty) {
        setState(() {
          enroll = 'Enroll';
          btnText = 'Go To Scanner';
        });
      } else {
        setState(() {
          enroll = 'Verify';
          btnText = 'Verify';
        });
      }
      // Future.delayed(Duration(seconds: 0), () async {
      //   setState(() {
      //     enroll = 'Verify';
      //     btnText = 'Verify';
      //   });
      // });

      try {
        await detectAndSave(userImage.isEmpty);
      } catch (e) {
        // Toast.show(e.toString(), context, duration: Toast.LENGTH_LONG);
        return;
      }
      navigate(false, userImage.isEmpty);
    } else {
      navigate(true, false);
    }
  }

  Future<void> detectAndSave(bool type) async {
    final res = await FaceSDK.presentFaceCaptureActivity();
    final result = FaceCaptureResponse.fromJson(json.decode(res));
    saver.setString((type ? 'enrolled_image' : 'current_image'),
        result.image.bitmap.replaceAll("\n", ""));

    log("Capture image landmarks" + result.image.bitmap.replaceAll("\n", ""));
  }

  void navigate(bool toHome, bool type) {
    if (toHome) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => landing.Landing(
                    initialPageIndex: 1,
                  )));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => LastStep(type: type)));
    }
  }

  pressButton() {
    decide();
    // Future.delayed(Duration(seconds: 2), () {

    // });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue[800],
          centerTitle: true,
          title: Text(
            'Face Scan Sevice ($enroll)',
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  final saved = await SharedPreferences.getInstance();
                  saved.clear();
                },
                icon: Icon(Icons.delete))
          ],
        ),
        body: Column(
          children: [
            // Stack(
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.symmetric(
            //         vertical: 10.0,
            //       ),
            //     ),
            //   ],
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(
            //     vertical: 10.0,
            //     horizontal: 15.0,
            //   ),
            //   child: Form(
            //     key: _formKey,
            //     child: TextFormField(
            //       controller: _cNumber,
            //       keyboardType: TextInputType.number,
            //       onChanged: (value) {
            //         if (value.trim().length == 10) {
            //           FocusScope.of(context).requestFocus(
            //             new FocusNode(),
            //           );
            //         }
            //       },
            //       validator: (value) {
            //         if (value.trim().length == 0) {
            //           return "Please Enter Mobile Number";
            //         }
            //         if (value.trim().length > 10 ||
            //             value.trim().length < 10 ||
            //             value.trim().contains(new RegExp(r'[A-Za-z/@_-]'))) {
            //           return "Please Enter Valid Mobile Number";
            //         }
            //         if (value.trim().length == 10) {
            //           FocusScope.of(context).requestFocus(
            //             new FocusNode(),
            //           );
            //         }
            //         return null;
            //       },
            //       decoration: InputDecoration(
            //         prefixText: '+91',
            //         border: OutlineInputBorder(),
            //         labelText: 'Mobile Number',
            //         prefixIcon: Icon(
            //           Icons.phone_android_rounded,
            //         ),
            //         hintText: 'Can I have your number?',
            //       ),
            //     ),
            //   ),
            // ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  bottom: 10.0,
                ),
                child: ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.zero,
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.transparent,
                    ),
                  ),
                  onPressed: pressButton,
                  // onPressed: () async {
                  //   // ignore: null_aware_in_condition
                  //   // if (_formKey.currentState.validate()) {
                  //   //   log('form validation successful');
                  //   //   FocusScope.of(context).requestFocus(new FocusNode());
                  //   //   await SystemChannels.textInput.invokeMethod('TextInput.hide');

                  //   //   // Navigator.push(
                  //   //   //   context,
                  //   //   //   EnterExitRoute(
                  //   //   //     exitPage: widget,
                  //   //   //     enterPage: OtpVerify(
                  //   //   //       number: _cNumber.text,
                  //   //   //     ),
                  //   //   //   ),
                  //   //   // );
                  //   // } else {
                  //   //   log('Error');
                  //   // }
                  //   decide();
                  // },
                  child: Container(
                    width: width * 0.5,
                    padding: EdgeInsets.symmetric(
                      vertical: 20.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        5.0,
                      ),
                      gradient: kGradient,
                    ),
                    child: Center(
                      child: Text(
                        '$btnText',
                        style: kSignUpTextStyle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
