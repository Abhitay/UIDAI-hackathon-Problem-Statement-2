import 'package:aadhaar_app/screen/otp.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../global/globals.dart' as global;

class landing extends StatefulWidget {
  landing({Key? key}) : super(key: key);

  @override
  _landingState createState() => _landingState();
}

class Album {
  var status;
  var errCode;

  Album({required this.status, required this.errCode});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      status: json['status'],
      errCode: json['errCode'],
    );
  }
}

class _landingState extends State<landing> {
  TextEditingController uid = TextEditingController();

  Future<Album>? _futureAlbum;

  Future<Album> createAlbum() async {
    final response = await http.post(
      Uri.parse('https://stage1.uidai.gov.in/onlineekyc/getOtp/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "uid": uid.text,
        "txnId": "0acbaa8b-b3ae-433d-a5d2-51250ea8e970"
      }),
    );
    return Album.fromJson(jsonDecode(response.body));
  }

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 350,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                margin: const EdgeInsets.only(
                    top: 50, bottom: 20, left: 5, right: 5),
                elevation: 10,
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enter aadhaar number',
                        style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black38),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: TextField(
                          cursorColor: Colors.black,
                          controller: uid,
                          autofocus: true,
                          decoration: const InputDecoration(
                            labelText: 'UID',
                            labelStyle: TextStyle(color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: ElevatedButton(
                            style: raisedButtonStyle,
                            onPressed: () {
                              setState(() {
                                global.uid = uid.text;
                                _futureAlbum = createAlbum();
                              });
                            },
                            child: const Text(
                              'Send OTP',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      FutureBuilder<Album>(
                        future: _futureAlbum,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!.status == 'y' ||
                                snapshot.data!.status == 'Y') {
                              WidgetsBinding.instance!
                                  .addPostFrameCallback((_) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => otp(uid.text)), (Route<dynamic> route) => false,);
                              });
                            }
                            return Text("");
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }
                          return Container();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.white,
    primary: Colors.black,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  );
}
