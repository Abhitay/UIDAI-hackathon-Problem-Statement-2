import 'package:flutter/material.dart';
import './global/globals.dart' as global;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String userName = 'DazzledSoul';

  String name = 'Pratham';

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
      print('${global.subLocality}');
      print('${global.state}');
      print('${global.country}');
      print('${global.city}');
      print('${global.lat}');
      print('${global.long}');
    } catch (err) {}
  }

  @override
  void initState() {
    get_location();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: 75,
        title: Text(
          'Hello',
        ),
      ),
      body: Center(
        child: Container(
            child: Column(
          children: [
            Text('country : ${global.country}'),
            Text('State : ${global.state}'),
            Text('city : ${global.city}'),
            Text('sub locality : ${global.subLocality}'),
          ],
        )),
      ),
    );
  }
}
