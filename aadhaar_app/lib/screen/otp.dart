import 'dart:convert';

import 'package:aadhaar_app/screen/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
// import 'package:xml/xml_events.dart';
import 'package:xml2json/xml2json.dart';

class otp extends StatefulWidget {
  String uid;

  otp(this.uid);

  @override
  _otpState createState() => _otpState();
}

class eKYC {
  var status;
  var eKycString;
  var errCode;

  eKYC({required this.status, required this.eKycString, required this.errCode});

  factory eKYC.fromJson(Map<String, dynamic> json) {
    return eKYC(
        status: json['status'],
        eKycString: json['eKycString'],
        errCode: json['errCode']);
  }
}

class _otpState extends State<otp> {
  Future<eKYC>? _futureeKYC;
  var temp2;

  Future<eKYC> eKYC_func(code) async {
    final response = await http.post(
      Uri.parse('https://stage1.uidai.gov.in/onlineekyc/getEkyc/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "uid": widget.uid,
        "txnId": "0acbaa8b-b3ae-433d-a5d2-51250ea8e970",
        "otp": code
      }),
    );
    return eKYC.fromJson(jsonDecode(response.body));
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
                    children: [
                      Text(
                        'Enter OTP',
                        style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black38),
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 15),
                          child: Column(
                            children: [
                              OtpTextField(
                                numberOfFields: 6,
                                borderColor: Colors.white54,
                                focusedBorderColor: Colors.grey,
                                showFieldAsBox: false,
                                // obscureText: true,
                                autoFocus: true,
                                onSubmit: (String verificationCode) async {
                                  print(widget.uid);
                                  print(verificationCode);
                                  _futureeKYC =
                                      eKYC_func(verificationCode.toString());
                                },
                              ),
                              FutureBuilder<eKYC>(
                                future: _futureeKYC,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data!.status == 'y' ||
                                        snapshot.data!.status == 'Y') {
                                      print(snapshot.data!.errCode);
                                      print(snapshot.data!.status);

                                      final document = XmlDocument.parse(
                                          snapshot.data!.eKycString);

                                      final titles =
                                          document.findAllElements('UidData');

                                      print(titles.first);

                                      final Xml2Json xml2Json = Xml2Json();
                                      xml2Json.parse(titles.first.toString());
                                      var jsondata = xml2Json.toGData();

                                      var data = jsonDecode(jsondata);

                                      print(data['UidData']['Poi']);
                                      print(data['UidData']['Poa']);

                                      String add = '';

                                      if (data['UidData']['Poa']['loc'] !=
                                          null) {
                                        add = data['UidData']['Poa']
                                                ['house'] +
                                            ', ' +
                                            data['UidData']['Poa']['lm'] +
                                            ', ' +
                                            data['UidData']['Poa']['loc'] +
                                            ', ' +
                                            data['UidData']['Poa']['street'] +
                                            ', ' +
                                            data['UidData']['Poa']['dist'] +
                                            ', ' +
                                            data['UidData']['Poa']['vtc'] +
                                            ', ' +
                                            data['UidData']['Poa']['pc'] +
                                            ', ' +
                                            data['UidData']['Poa']['state'] +
                                            ', ' +
                                            data['UidData']['Poa']['country'];
                                      } else {
                                        add = data['UidData']['Poa']['house'] +
                                            ', ' +
                                            data['UidData']['Poa']['lm'] +
                                            ', ' +
                                            data['UidData']['Poa']['street'] +
                                            ', ' +
                                            data['UidData']['Poa']['dist'] +
                                            ', ' +
                                            data['UidData']['Poa']['vtc'] +
                                            ', ' +
                                            data['UidData']['Poa']['pc'] +
                                            ', ' +
                                            data['UidData']['Poa']['state'] +
                                            ', ' +
                                            data['UidData']['Poa']['country'];
                                      }

                                      print(add);

                                      WidgetsBinding.instance!
                                          .addPostFrameCallback((_) {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  homepage(add)),
                                          (Route<dynamic> route) => false,
                                        );
                                      });
                                    }
                                    
                                    return Text('');
                                  } else if (snapshot.hasError) {
                                    return Text('${snapshot.error}');
                                  }
                                  return Text('');
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
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
