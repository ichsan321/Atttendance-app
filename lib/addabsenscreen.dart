import 'package:flutter/material.dart';
import 'package:my_project/mainscreen.dart';
import 'package:my_project/user.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'dart:convert';

String urlUpload =
    "https://myattendance-test.000webhostapp.com/php/add_absen.php";

String verify = "1";

String loc_latitude_wisma = "-6.175019394047249";
String loc_longitude_wisma = " 106.81996316318025";

String radius = "10";

class addabsenscreen extends StatefulWidget {
  final User user;
  const addabsenscreen({Key? key, required this.user});

  @override
  State<addabsenscreen> createState() => _addabsenscreenState();
}

class _addabsenscreenState extends State<addabsenscreen> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  late Position _currentPosition;
  String _currentAddress = " Searching cureent location";
  List? data;

//  this is for button dropdownlocation
  final List<String> items = [
    'Wisma BSG',
    'Di Luar',
  ];
  String? selectedValue;
  String cdate1 = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String tdata = DateFormat("HH:mm:ss").format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Attendance Page"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Container(
            height: 250,
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _currentAddress,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        hint: Text(
                          'Select your site',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        items: items
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ))
                            .toList(),
                        value: selectedValue,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value as String;
                          });
                        },
                        buttonStyleData: const ButtonStyleData(
                          height: 40,
                          width: 140,
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    StreamBuilder(
                        stream: Stream.periodic(const Duration(seconds: 1)),
                        builder: (context, snapshot) {
                          return Text(
                              DateFormat('hh:mm:ss').format(DateTime.now()));
                        }),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    InkWell(
                      child: Container(
                        width: 300,
                        height: 50,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              // For the gradient colour of the box
                              Color(0xFF17ead9), //cyan
                              Color(0xFF6078ea), //blue
                              Color(0xFFFF4081) //pink
                            ]),
                            borderRadius: BorderRadius.circular(15.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0xFF6078ea).withOpacity(0.5),
                                  offset: Offset(0.0, 8.0),
                                  blurRadius: 8.0)
                            ]),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: (_uploadabsenbutton),
                            child: Center(
                              child: Text("Absen",
                                  style: TextStyle(
                                      color: Colors.white, // LOGIN Name
                                      fontFamily: "Poppins-Bold",
                                      fontSize: 18,
                                      letterSpacing:
                                          10.0)), //for the space of the text
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _getCurrentLocation() async {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        print(_currentPosition);
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name},${place.locality}, ${place.postalCode}, ${place.country}";
        // init(); //load data from database into list array 'data'
      });
    } catch (e) {
      print(e);
    }
  }

  void _uploadabsenbutton() {
    print(" This is absen button ");
    print(selectedValue);
    print(widget.user.email);
    print(loc_latitude_wisma);
    print(loc_longitude_wisma);
    print(_currentPosition.latitude);
    print(_currentPosition.longitude);
    print(radius);
    print(cdate1);
    print(verify);

    selectedValue = selectedValue.toString();

    if ((selectedValue != null && selectedValue == 'Wisma BSG')) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);

      pr.style(message: "in progress");
      pr.show();
      http.post(Uri.parse(urlUpload), body: {
        'email': widget.user.email,
        'location': selectedValue,
        'jam': tdata.toString(),
        'longitude_w': loc_longitude_wisma.toString(),
        'latitude_w': loc_latitude_wisma.toString(),
        'latitude_now': _currentPosition.latitude.toString(),
        'longitude_now': _currentPosition.longitude.toString(),
        'radius': radius,
        'date_on_user': cdate1.toString(),
        'verify': verify,
      }).then((res) {
        print(res.statusCode);
        print(res.body);
        if (res.body == "success") {
          print("Test di bawah succes");
          Toast.show("Check your registration information", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
          pr.hide();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => Maincsreen(
                        user: widget.user,
                      )));
        } else if (res.body == 'failed 2') {
          Toast.show("Your location too far from the base site", context,
              duration: 3, gravity: Toast.BOTTOM, backgroundColor: Colors.red);
          pr.hide();
        } else if (res.body == "failed 1") {
          Toast.show("Sorry Your Attendace have been took before", context,
              duration: 3,
              gravity: Toast.BOTTOM,
              backgroundColor: Color.fromARGB(198, 223, 67, 67));
          pr.hide();
        }
      }).catchError((err) {
        print(err);
      });
    } else {
      Toast.show(" Please Select Your Site Location", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Maincsreen(
            user: widget.user,
          ),
        ));
    return Future.value(false);
  }
}
