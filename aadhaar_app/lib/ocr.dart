import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';


class ocr extends StatefulWidget {
  ocr({Key key}) : super(key: key);

  @override
  _ocrState createState() => _ocrState();
}

class _ocrState extends State<ocr> {
  final int _ocrCamera = FlutterMobileVision.CAMERA_BACK;
  String _text = "TEXT";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Heisenberg 2002'),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _text,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Center(
              child: RaisedButton(
                onPressed: _read,
                child: const Text(
                  'Scanning',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
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
        autoFocus: true,
        fps: 2.0,
        showText: false,
      );

      setState(() {
        _text = texts[0].value;
      });
    } on Exception {
      texts.add( OcrText('Failed to recognize text'));
    }
  }
}
