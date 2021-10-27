import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';

class homepage extends StatefulWidget {
  homepage({Key key}) : super(key: key);

  @override
  _homepageState createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  TextEditingController street_controller = TextEditingController();
  TextEditingController district_controller = TextEditingController();
  TextEditingController subDistrict_controller = TextEditingController();
  TextEditingController original_controller = TextEditingController();
  TextEditingController new_controller = TextEditingController();

  final int _ocrCamera = FlutterMobileVision.CAMERA_BACK;
  String _text = "TEXT";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                  controller: new_controller,
                                  maxLines: 2,
                                  enabled:
                                      new_controller.text == "" ? false : true,
                                  decoration: const InputDecoration(
                                    labelText: 'Updated Address',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: ElevatedButton(
                                    style: raisedButtonStyle,
                                    onPressed: _read,
                                    child: const Text(
                                      'Scan',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                )
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
        camera: _ocrCamera,
        waitTap: true,
        showText: false,
      );

      setState(() {
        if (new_controller.text == "") {
          print("object");
        }
        original_controller.text = texts[0].value;
        new_controller.text = texts[0].value;
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
