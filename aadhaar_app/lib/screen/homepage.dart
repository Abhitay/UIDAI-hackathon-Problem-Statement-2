import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_mobile_vision_2/flutter_mobile_vision_2.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../global/globals.dart' as global;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../api_call.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_easyloading/flutter_easyloading.dart';

class homepage extends StatefulWidget {
  homepage({Key? key}) : super(key: key);

  @override
  _homepageState createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  TextEditingController street_controller = TextEditingController();
  TextEditingController district_controller = TextEditingController();
  TextEditingController subDistrict_controller = TextEditingController();
  TextEditingController original_controller = TextEditingController();
  TextEditingController ocr_controller = TextEditingController();
  var Address = '';
  int upload = 0;
  int readyToUpload = 0;
  var url = "";

  final int _ocrCamera = FlutterMobileVision.CAMERA_BACK;
  String _text = "TEXT";
  @override
  void initState() {
    get_location();
    super.initState();
  }

  void get_location() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    global.lat = double.parse("${position.latitude}");
    global.long = double.parse("${position.longitude}");

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark placeMark = placemarks[0];

      setState(() {
        global.state = placeMark.administrativeArea;
        global.country = placeMark.country;
        global.city = placeMark.locality;
        global.subLocality = placeMark.subLocality;
      });
      print('${global.lat}');
      print('${global.long}');
    } catch (err) {}
  }

  _validate() async {
    EasyLoading.show(status: 'checking...');
    if (street_controller.text == "") {
      street_controller.text = " ";
    }
    if (subDistrict_controller.text == "") {
      subDistrict_controller.text = " ";
    }
    if (district_controller.text == "") {
      district_controller.text = " ";
    }
    if (original_controller.text == "") {
      original_controller.text = " ";
    }
    if (ocr_controller.text == "") {
      ocr_controller.text = " ";
    }
    if (global.lat == "") {
      global.lat = " ";
    }
    if (global.long == "") {
      global.long = " ";
    }
    var response = await http.get(Uri.parse(
        'https://cbada0.deta.dev/${street_controller.text}/${subDistrict_controller.text}/${district_controller.text}/${original_controller.text}/${ocr_controller.text}/${global.lat}/${global.long}'));
    //'http://10.0.2.2:8000/Sahakar Nagar/ / /1301, Swanlake/something Sahakar Nagar/18.4900796/73.8475301'));

    EasyLoading.dismiss();

    setState(() {
      Address = response.body;
    });
    print(Address);

    if (Address == '"Address Not Verified"') {
      EasyLoading.showError('cannot verify');
    } else {
      EasyLoading.showSuccess('address Verified');
      setState(() {
        readyToUpload = 1;
      });
    }
  }

  void uploadAudit() {
    // FINAL CHANGE UPLOAD TO 0
    if (upload == 0) {
      EasyLoading.showError('upload proof');
    } else {
      FirebaseFirestore.instance.collection("Audit").doc().set({
        'original address': original_controller.text,
        'new address': Address,
        'proof': url
      }).then((value) => EasyLoading.showSuccess('audit updated'));
    }
  }

  late File imageFile;

  // Future<void> uploadFile(String filePath) async {
  //   File file = File(filePath);
  //   await firebase_storage.FirebaseStorage.instance
  //       .ref('uploads/file-to-upload.png')
  //       .putFile(file);
  // }

  _imgFromCamera() async {
    PickedFile? image =
        await ImagePicker().getImage(source: ImageSource.camera);
    // File image = (await ImagePicker()
    //     .pickImage(source: ImageSource.camera, imageQuality: 50)) as File;

    setState(() async {
      if (image != null) {
        EasyLoading.show(status: 'checking...');
        // imageFile = File(image.path);
        imageFile = File(image.path);
        // uploadFile(imageFile);
        final Reference firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child(DateTime.now().millisecondsSinceEpoch.toString());

        final UploadTask task = firebaseStorageRef.putFile(imageFile);

        var downloadURL = await (await task).ref.getDownloadURL();
        url = downloadURL.toString();

        upload = 1;

        EasyLoading.showSuccess('complete');
      } else {
        print('No image selected.');
        return;
      }
      // imageFile = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _imgFromCamera();
          // Navigator.of(context).pop();
        },
        child: const Icon(Icons.camera_alt),
        backgroundColor: Colors.black87,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment(0.8, 0.0),
            colors: <Color>[
              Color(0xffc83d3d),
              Color(0xfff7b757),
              Color(0xfff7b757)
            ],
          ),
        ),
        padding: const EdgeInsets.all(5),
        child: ListView(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin:
                  const EdgeInsets.only(top: 50, bottom: 20, left: 5, right: 5),
              elevation: 10,
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Address update',
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black38),
                      ),
                    ),
                    Text(
                      'Welcome operator',
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                            fontSize: 23, color: Colors.black38),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - 220,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          margin: const EdgeInsets.only(
                              top: 50, bottom: 20, left: 5, right: 5),
                          elevation: 10,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                TextField(
                                  cursorColor: Colors.black,
                                  controller: street_controller,
                                  decoration: const InputDecoration(
                                    labelText: 'Street',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                  ),
                                ),
                                TextField(
                                  cursorColor: Colors.black,
                                  controller: district_controller,
                                  decoration: const InputDecoration(
                                    labelText: 'District',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                  ),
                                ),
                                TextField(
                                  cursorColor: Colors.black,
                                  controller: subDistrict_controller,
                                  decoration: const InputDecoration(
                                    labelText: 'Sub District',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                  ),
                                ),
                                TextField(
                                  cursorColor: Colors.black,
                                  controller: original_controller,
                                  maxLines: 2,
                                  decoration: const InputDecoration(
                                    labelText: 'Original Address',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                  ),
                                ),
                                TextField(
                                  cursorColor: Colors.black,
                                  controller: ocr_controller,
                                  maxLines: 2,
                                  // FINAL CHANGE REMOVE //
                                  enabled: ocr_controller.text == "" ||
                                          ocr_controller.text == " "
                                      ? false
                                      : true,
                                  decoration: const InputDecoration(
                                    labelText: 'Ocr Address',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                  ),
                                ),
                                readyToUpload == 1
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: ElevatedButton(
                                          style: raisedButtonStyle,
                                          onPressed: uploadAudit,
                                          child: const Text(
                                            'Upload',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15, right: 15),
                                            child: ElevatedButton(
                                              style: raisedButtonStyle,
                                              onPressed: _read,
                                              child: const Text(
                                                'Scan',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 15),
                                            child: ElevatedButton(
                                              style: raisedButtonStyle,
                                              onPressed: _validate,
                                              child: const Text(
                                                'Validate',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                // Text(Address),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }

  Future _read() async {
    List<OcrText> texts = [];
    try {
      texts = await FlutterMobileVision.read(
          flash: true,
          autoFocus: true,
          camera: _ocrCamera,
          waitTap: true,
          showText: false,
          fps: 2.0,
          scanArea: const Size(1900, 1060));

      setState(() {
        if (ocr_controller.text == "") {
          print("object");
        }
        // original_controller.text = texts[0].value;
        ocr_controller.text = texts[0].value;
        _text = texts[0].value;
      });
    } on Exception {
      texts.add(OcrText('Failed to recognize text'));
    }
  }

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.white,
    primary: Colors.black,
    // minimumSize: const Size(88, 36),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  );
}
