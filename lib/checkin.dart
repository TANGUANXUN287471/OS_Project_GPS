import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:os_project/result.dart';
import 'model/myconfig.dart';
import 'model/user.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _numcontroller = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _phonecontroller = TextEditingController();
  final TextEditingController _stateEditingController = TextEditingController();
  final TextEditingController _localEditingController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late Position _currentPosition;

  String curaddress = "";
  String curstate = "";
  String prlat = "";
  String prlong = "";

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white70,
        elevation: 0,
        title: const Text("Affandi.GPS Location"),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    "assets/images/42660.jpg",
                  ),
                  fit: BoxFit.cover),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(height: 330),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    elevation: 10,
                    child: Container(
                      margin: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            "Check-In Application",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  validator: (value) =>
                                      value!.isEmpty || (value.length < 5)
                                          ? "Name must longer than 5"
                                          : null,
                                  controller: _namecontroller,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    icon: Icon(Icons.person),
                                    label: Text("Name"),
                                    labelStyle: TextStyle(fontSize: 15),
                                    contentPadding: EdgeInsets.all(8),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.cyan, width: 2.0),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(24),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  validator: (value) => value!.isEmpty ||
                                          (value.length < 6)
                                      ? "Matric number must longer or equal 6"
                                      : null,
                                  controller: _numcontroller,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    icon: Icon(Icons.insert_drive_file),
                                    label: Text("Matric Number"),
                                    labelStyle: TextStyle(fontSize: 15),
                                    contentPadding: EdgeInsets.all(8),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.cyan, width: 2.0),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(24),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  validator: (value) => value!.isEmpty ||
                                          (value.length < 10)
                                      ? "Phone Number must longer than or equal 10"
                                      : null,
                                  keyboardType: TextInputType.phone,
                                  controller: _phonecontroller,
                                  decoration: const InputDecoration(
                                    labelText: "Phone",
                                    labelStyle: TextStyle(fontSize: 15),
                                    icon: Icon(Icons.phone),
                                    contentPadding: EdgeInsets.all(8),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.cyan, width: 2.0),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(24),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  validator: (value) => value!.isEmpty ||
                                          !value.contains("@") ||
                                          !value.contains(".")
                                      ? "Please enter a valid Email"
                                      : null,
                                  controller: _emailcontroller,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                    icon: Icon(Icons.email_rounded),
                                    label: Text("E-mail"),
                                    labelStyle: TextStyle(fontSize: 15),
                                    contentPadding: EdgeInsets.all(8),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.cyan, width: 2.0),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(24),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: _checkIn,
                            child: const Text("Check-In"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _checkIn() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your Input")));
      return;
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            title: const Text("Check In Your Location?"),
            content: const Text("Confirm to check-in ",
                style: TextStyle(fontSize: 14, color: Colors.black54)),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _userCheckin();
                },
                child: const Text("Yes"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("No"),
              ),
            ],
          );
        });
  }

  void _userCheckin() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Please Wait..."),
          content: Text("Checking in your location..."),
        );
      },
    );

    String name = _namecontroller.text;
    String num = _numcontroller.text;
    String phone = _phonecontroller.text;
    String email = _emailcontroller.text;
    String state = _stateEditingController.text;
    String city = _localEditingController.text;
    String lat = prlat;
    String long = prlong;

    http.post(
        Uri.parse("${MyConfig().server}/gps_location/php/user_checkin.php"),
        body: {
          "name": name,
          "num": num,
          "phone": phone,
          "email": email,
          "state":state,
          "city":city,
          "lat": lat,
          "long": long,
        }).then((response) {
      debugPrint(response.body);

      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);

        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Check-In Successful")));
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) => const ShowResult(),
            ),
          );
          Navigator.of(context).pop(User);
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Check-In Failed")));
        }
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Check-In Failed")));
        Navigator.of(context).pop();
      }
    });
  }

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }
    _currentPosition = await Geolocator.getCurrentPosition();

    _getAddress(_currentPosition);
    //return await Geolocator.getCurrentPosition();
  }

  _getAddress(Position pos) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);
    if (placemarks.isEmpty) {
      _localEditingController.text = "Changlun";
      _stateEditingController.text = "Kedah";
      prlat = "6.443455345";
      prlong = "100.05488449";
    } else {
      _localEditingController.text = placemarks[0].locality.toString();
      _stateEditingController.text =
          placemarks[0].administrativeArea.toString();
      prlat = _currentPosition.latitude.toString();
      prlong = _currentPosition.longitude.toString();
    }
  }
}
