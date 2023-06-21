import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_project/addIzinscreen.dart';
import 'package:my_project/addSakitscreen.dart';
import 'package:my_project/addabsenscreen.dart';
import 'package:my_project/addcutiscreen.dart';
import 'package:my_project/admin.dart';
import 'package:my_project/loginscreen.dart';
import 'package:my_project/user.dart';
import 'package:geolocator/geolocator.dart';

import 'absenkeluarscreen.dart';

class homepage_admin extends StatefulWidget {
  final Admin admin;
  homepage_admin({Key? key, required this.admin});

  @override
  State<homepage_admin> createState() => _homepage_adminState();
}

class _homepage_adminState extends State<homepage_admin> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  late Position _currentPosition;
  String _currentAddress = " Searching cureent location";
  List? data;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   resizeToAvoidBottomInset: false,
    //   appBar: PreferredSize(  preferredSize: Size.fromHeight(180),
    //   child: AppBar(backgroundColor: Colors.black),),
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 0),
                  child: Container(
                    height: 70,
                    width: 500,
                    decoration: BoxDecoration(
                        // color: Colors.red[400],
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome  ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Text(widget.admin.name + "  "),
                              Text(widget.admin.jabatan + "  "),
                            ],
                          ),
                        ),
                        SizedBox(
                          child: Text("      "),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                  child: Scrollbar(
                thickness: 3,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Card(
                                      elevation: 10.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: ElevatedButton(
                                        onPressed: _absenbutton,
                                        child: Padding(
                                          padding: EdgeInsets.all(25.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Icon(Icons.add),
                                              SizedBox(
                                                height: 15.0,
                                              ),
                                              Text(
                                                'Cuti',
                                              ),
                                              Text(
                                                'Pegawai',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Card(
                                  elevation: 10.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: _izinscreen,
                                    child: Padding(
                                      padding: EdgeInsets.all(25.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(Icons.add),
                                          SizedBox(
                                            height: 15.0,
                                          ),
                                          Text(
                                            'Izin',
                                          ),
                                          Text(
                                            'Pegawai',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Card(
                                      elevation: 10.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: ElevatedButton(
                                        onPressed: _sakitscreen,
                                        child: Padding(
                                          padding: EdgeInsets.all(25.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Icon(Icons.add),
                                              SizedBox(
                                                height: 15.0,
                                              ),
                                              Text(
                                                'Sakit  ',
                                              ),
                                              Text(
                                                'Pegawai',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Card(
                                  elevation: 10.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: _cutiscreen,
                                    child: Padding(
                                      padding: EdgeInsets.all(25.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(Icons.add),
                                          SizedBox(
                                            height: 15.0,
                                          ),
                                          Text(
                                            'About ',
                                          ),
                                          Text(
                                            'App  ',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        InkWell(
                          child: Container(
                            width: 200,
                            height: 40,
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
                                onTap: (_Logoutbutton),
                                child: Center(
                                  child: Text("Log Out",
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
              )),
            )
          ],
        ),
      ),

      // ElevatedButton(onPressed: _changeEmail, child: Text("Change Email")),
      // ElevatedButton(onPressed: _changeNoHp, child: Text("Change No HP")),
      // ElevatedButton(onPressed: _logOut, child: Text(" Log Out")),
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

  void _changeEmail() async {
    print("this is change email button");
  }

  void _changeNoHp() async {
    print(" this is change no hp button ");
  }

  void _Logoutbutton() async {
    print(" this is log out button ");
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  void _takePicture() async {
    // if (widget.user.name == "not register") {
    //   Toast.show("Not allowed", context,
    //       duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    //   return;
    // }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title: new Text("Take new profile picture?"),
            content: new Text("Are your sure?"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
            ]);
      },
    );
  }

  void _izinscreen() async {}

  void _sakitscreen() async {
    print("sakitform");
  }

  void _cutiscreen() async {}

  void _absenbutton() async {}

  void _absenoutButton() async {}
}