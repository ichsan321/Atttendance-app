import 'package:flutter/material.dart';
import 'package:my_project/mainscreen.dart';
import 'package:my_project/user.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:toast/toast.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:progress_dialog/progress_dialog.dart';

String urlUpload =
    "https://myattendance-test.000webhostapp.com/php/add_absenkeluar.php";
String loc_latitude_wisma = "-6.175019394047249";
String loc_longitude_wisma = " 106.81996316318025";

final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
late Position _currentPosition;
String _currentAddress = " Searching cureent location";
List? data;
String verifykeluar = '1';

final List<String> items = [
  'Wisma BSG',
  'Di Luar',
];

String tdata = DateFormat("HH:mm:ss").format(DateTime.now());
String? selectedValue;
String cdate1 = DateFormat("yyyy-MM-dd").format(DateTime.now());

class absenKeluar extends StatefulWidget {
  final User user;
  const absenKeluar({Key? key, required this.user});

  @override
  State<absenKeluar> createState() => _absenKeluarState();
}

class _absenKeluarState extends State<absenKeluar> {
  TextEditingController keterangankeluar = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Absen Keluar"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Container(
            width: 360,
            height: 300,
            child: Card(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(_currentAddress),
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
                      height: 10.0,
                    ),
                    // DropdownButtonHideUnderline(
                    //   child: DropdownButton2(
                    //     hint: Text(
                    //       'Select your base site',
                    //       style: TextStyle(
                    //         fontSize: 14,
                    //         color: Colors.black,
                    //       ),
                    //     ),
                    //     items: items
                    //         .map((item) => DropdownMenuItem<String>(
                    //               value: item,
                    //               child: Text(
                    //                 item,
                    //                 style: const TextStyle(
                    //                   fontSize: 14,
                    //                 ),
                    //               ),
                    //             ))
                    //         .toList(),
                    //     value: selectedValue,
                    //     onChanged: (value) {
                    //       setState(() {
                    //         selectedValue = value as String;
                    //       });
                    //     },
                    //     buttonStyleData: const ButtonStyleData(
                    //       height: 40,
                    //       width: 140,
                    //     ),
                    //     menuItemStyleData: const MenuItemStyleData(
                    //       height: 40,
                    //     ),
                    //   ),
                    // ),

                    TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      controller: keterangankeluar,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10.0),
                        prefixIcon: Container(
                            padding:
                                const EdgeInsets.only(top: 80.0, bottom: 16.0),
                            margin: const EdgeInsets.only(right: 8.0),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    bottomLeft: Radius.circular(30.0),
                                    topRight: Radius.circular(30.0),
                                    bottomRight: Radius.circular(10.0))),
                            child: Icon(
                              Icons.receipt,
                              color: Colors.lightBlue,
                            )),
                        hintText: "Keterangan",
                        hintStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Colors.cyan.withOpacity(0.8),
                      ),
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
                            onTap: (_onabsenKeluar),
                            child: Center(
                              child: Text("KELUAR",
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
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  void _onabsenKeluar() async {
    print("this is absen keluar button");
    print(widget.user.email);
    print(keterangankeluar.text);
    print(cdate1);
    print(tdata);

    if ((keterangankeluar.text.length > 5)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "in progress");
      pr.show();
      http.post(Uri.parse(urlUpload), body: {
        'email': widget.user.email,
        'date': cdate1.toString(),
        'jamkeluar': tdata.toString(),
        'ketkeluar': keterangankeluar.text,
        'verifykeluar': verifykeluar
      }).then((res) {
        print(res.statusCode);
        print(res.body);
        if (res.body == "success") {
          Toast.show("Successfully", context,
              duration: 3, gravity: Toast.CENTER);
          pr.hide();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => Maincsreen(
                        user: widget.user,
                      )));
        } else if (res.body == "failed") {
          Toast.show("There is some trouble with connection", context,
              duration: 3, gravity: Toast.BOTTOM, backgroundColor: Colors.red);
          pr.hide();
        }
      }).catchError((err) {
        print(err);
      });
    } else {
      Toast.show(" Please fill keterangan first", context,
          duration: 3, gravity: Toast.BOTTOM);
    }
  }

  void _getCurrentLocation() async {
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
}
