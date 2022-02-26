import 'dart:convert';
import 'dart:developer';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:flutter_face_api/face_api.dart' as Regula;
import 'package:hajeri/main.dart';

class CompareFaces extends StatefulWidget {
  const CompareFaces({Key key}) : super(key: key);

  @override
  _CompareFacesState createState() => _CompareFacesState();
}

class _CompareFacesState extends State<CompareFaces> {
  String _similarity = 'nil';

  var image1 = Regula.MatchFacesImage();
  var image2 = Regula.MatchFacesImage();

  var img2 = Image.asset('');

  // List<int> intList;

  matchFaces() {
    log("Entered in match function:");
    // if (image1 == null ||
    //     image1.bitmap == null ||
    //     image1.bitmap == "" ||
    //     image2 == null ||
    //     image2.bitmap == null ||
    //     image2.bitmap == "")
    // return;
    // setState(() => _similarity = "Processing...");
    setState(() {
      _similarity = "Processing...";
      log("_similarity = " + _similarity);
    });
    var request = new Regula.MatchFacesRequest();
    request.images = [image1, image2];

    Regula.FaceSDK.matchFaces(jsonEncode(request)).then((value) {
      var response = Regula.MatchFacesResponse.fromJson(json.decode(value));
      Regula.FaceSDK.matchFacesSimilarityThresholdSplit(
              jsonEncode(response.results), 0.75)
          .then((str) {
        var split = Regula.MatchFacesSimilarityThresholdSplit.fromJson(
            json.decode(str));

        // setState(() => _similarity =
        try {
          if (split.matchedFaces.length > 0) {
            setState(() {
              _similarity =
                  ((split.matchedFaces[0].similarity * 100).toStringAsFixed(2) +
                      "%");
            });
          } else {
            setState(() {
              _similarity = 'not matched';
            });
          }
        } catch (e) {
          log("exception:" + e);
        }
        // split.matchedFaces.length > 0
        //     ? ((split.matchedFaces[0].similarity * 100).toStringAsFixed(2) +
        //         "%")
        //     : "error");
      });
    });
  }

  setImage(List<int> imageFile, int type) {
    if (imageFile == null) return;
    setState(() => _similarity = "nil");
    // if (first) {
    //   image1.bitmap = base64Encode(imageFile);
    //   image1.imageType = type;
    //   setState(() {
    //     img1 = Image.memory(imageFile);
    //     _liveness = "nil";
    //   });
    // }
    // else {
    image2.bitmap = base64Encode(imageFile);
    image2.imageType = type;
    setState(() => img2 = Image.memory(imageFile));
  }

  @override
  void initState() {
    log("message");
    super.initState();
    setState(() {
      List<String> strList = prefs.getStringList("imageFile");
      // image1 = prefs.getString("imageFile");

      List<int> intList = strList.map((i) => int.parse(i)).toList();
      image1.bitmap = base64Encode(intList);
      log("Image 1 in compare face page:" + intList.toString());
    });
    Regula.FaceSDK.presentFaceCaptureActivity().then((result) => setImage(
        base64Decode(Regula.FaceCaptureResponse.fromJson(json.decode(result))
            .image
            .bitmap
            .replaceAll("\n", "")),
        Regula.ImageType.LIVE));
    // var img1 = Regula.MatchFacesImage();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comparing Faces"),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            createImage(img2.image),
            ElevatedButton(
                onPressed: () {
                  matchFaces();
                },
                child: Text("Compare")),
            Container(
                margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Similarity: " + _similarity,
                        style: TextStyle(fontSize: 18)),
                    Container(margin: EdgeInsets.fromLTRB(20, 0, 0, 0)),
                    // Text("Liveness: " + _liveness,
                    //     style: TextStyle(fontSize: 18))
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Widget createImage(image) => Material(
          child: InkWell(
        // onTap: onPress,
        child: Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image(height: 150, width: 150, image: image),
          ),
        ),
      ));
}
