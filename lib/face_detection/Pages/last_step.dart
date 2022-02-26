import 'dart:convert';
// import 'dart:html';
// import 'dart:developer';

import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_face_api/face_api.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:hajeri/Pages/landing.dart';
import 'package:hajeri/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
// import '../Pages/landing.dart';

import '../constant.dart';

class LastStep extends StatefulWidget {
  static String id = "last_step";
  final bool type;
  const LastStep({this.type, Key key}) : super(key: key);

  @override
  _LastStepState createState() => _LastStepState();
}

class _LastStepState extends State<LastStep> {
  // String name = '';

  // final TextEditingController _controller = TextEditingController(text: "");
  @override
  void initState() {
    super.initState();
    if (!widget.type) init();
    // buttonClick();
  }

  void init() async {
    try {
      final saver = await SharedPreferences.getInstance();
      final userDetails = saver.getString('enrolled_image').split('::::');
      final currentImage = saver.getString('current_image');
      final registeredImage = new MatchFacesImage();
      registeredImage.bitmap = userDetails[0];
      registeredImage.imageType = ImageType.LIVE;
      final loginImage = new MatchFacesImage();
      loginImage.bitmap = currentImage;
      loginImage.imageType = ImageType.LIVE;
      final request = new MatchFacesRequest();
      request.images = [registeredImage, loginImage];
      final res = await FaceSDK.matchFaces(json.encode(request));
      final response = MatchFacesResponse.fromJson(json.decode(res));
      FaceSDK.matchFacesSimilarityThresholdSplit(
              jsonEncode(response.results), 0.75)
          .then((str) {
        var split =
            MatchFacesSimilarityThresholdSplit.fromJson(json.decode(str));
        if (split.matchedFaces.length > 0) {
          if (split.matchedFaces[0].similarity * 100 > 80) {
            saver.setString('current_image', '');
            toHome();
          } else {
            Toast.show('invalid user', context, duration: 5);
            Navigator.pop(context);
            String invalid = 'invalid';
            prefs.setString("invalid", invalid);
          }
        } else {
          Toast.show('invalid user', context, duration: Toast.LENGTH_LONG);
          Navigator.pop(context);
        }
      });
    } catch (e) {
      Toast.show(e.toString(), context, duration: Toast.LENGTH_LONG);
    }
  }

  void toHome() async {
    Toast.show('Welcome ', context, duration: Toast.LENGTH_LONG);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => Landing()));
  }

  void buttonClick() async {
    final saver = await SharedPreferences.getInstance();
    final userImage = saver.getString('enrolled_image');
    saver.setString('enrolled_image', userImage + '::::');
    toHome();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue[800],
          centerTitle: true,
          title: Text(
            'Verifying please wait...',
            style: TextStyle(
              fontFamily: 'Comfortaa',
            ),
            textAlign: TextAlign.center,
          ),
        ),
        body: Container(
            child: widget.type
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Face Enrolled kindly click below button to proceed further.",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Comfortaa',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(
                      //     vertical: 10.0,
                      //     horizontal: 15.0,
                      //   ),
                      //   child: TextFormField(
                      //     controller: _controller,
                      //     onChanged: (value) => name = value,
                      //     decoration: InputDecoration(
                      //       border: OutlineInputBorder(),
                      //       labelText: 'Enter name',
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
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.zero,
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.transparent,
                              ),
                            ),
                            onPressed: buttonClick,
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
                                  'Proceed',
                                  style: kSignUpTextStyle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Please wait...'),
                      ],
                    ),
                  )),
      ),
    );
  }
}
