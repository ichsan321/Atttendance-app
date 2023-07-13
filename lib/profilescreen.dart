import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_project/addIzinscreen.dart';
import 'package:my_project/addSakitscreen.dart';
import 'package:my_project/addabsenscreen.dart';
import 'package:my_project/addcutiscreen.dart';
import 'package:my_project/admin.dart';
import 'package:my_project/cutiuser_overview.dart';
import 'package:my_project/izinuser_overview.dart';
import 'package:my_project/loginscreen.dart';
import 'package:my_project/sakituser_overview.dart';
import 'package:my_project/user.dart';
import 'package:geolocator/geolocator.dart';

import 'absenkeluarscreen.dart';

class profilescreen extends StatefulWidget {
  final User user;
  profilescreen({Key? key, required this.user});

  @override
  State<profilescreen> createState() => _profilescreenState();
}

class _profilescreenState extends State<profilescreen> {
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
                              Text(widget.user.name + "  "),
                              Text(widget.user.jabatan + "  "),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: _takePicture,
                            child: Container(
                                width: 50.0,
                                height: 50.0,
                                decoration: new BoxDecoration(
                                  image: new DecorationImage(
                                      image: AssetImage(
                                          'asset/image/peopleicon.png'),
                                      fit: BoxFit.fill),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black),
                                )),
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
            SizedBox(
              height: 50.0,
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Container(
                height: 140,
                decoration: BoxDecoration(
                    color: (Color.fromARGB(255, 12, 101, 134)),
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20, top: 5, right: 5, bottom: 5),
                      child: Row(children: [
                        Text(
                          "Overview ",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ]),
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Card(
                        child: ElevatedButton(
                          onPressed: _izinoverview,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(" IZIN"),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Text(
                                  widget.user.totalizin,
                                  style: TextStyle(fontSize: 20),
                                )
                              ],
                            ),
                            // child: Text(
                            //   "IZIN : 3",
                            //   style: TextStyle(fontWeight: FontWeight.bold),
                            // ),
                          ),
                        ),
                      ),
                      Card(
                        child: ElevatedButton(
                          onPressed: _sakitoverview,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(" SAKIT"),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Text(
                                  widget.user.totalsakit,
                                  style: TextStyle(fontSize: 20),
                                )
                              ],
                            ),
                            // child: Text(
                            //   "IZIN : 3",
                            //   style: TextStyle(fontWeight: FontWeight.bold),
                            // ),
                          ),
                        ),
                      ),
                      Card(
                        child: ElevatedButton(
                          onPressed: _cutioverview,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(" CUTI"),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Text(
                                  widget.user.totalcuti,
                                  style: TextStyle(fontSize: 20),
                                )
                              ],
                            ),
                            // child: Text(
                            //   "IZIN : 3",
                            //   style: TextStyle(fontWeight: FontWeight.bold),
                            // ),
                          ),
                        ),
                      ),
                      Card(
                        child: ElevatedButton(
                          onPressed: _izinscreen,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(" SISA"),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Text(
                                  widget.user.sisa,
                                  style: TextStyle(fontSize: 20),
                                )
                              ],
                            ),
                            // child: Text(
                            //   "IZIN : 3",
                            //   style: TextStyle(fontWeight: FontWeight.bold),
                            // ),
                          ),
                        ),
                      )
                    ]),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Container(
                color: Colors.white24,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.location_on),
                      Expanded(
                        child: Text(
                          _currentAddress,
                          softWrap: false,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15.0,
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
                                                'Absen',
                                              ),
                                              Text(
                                                'Masuk',
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
                                            'Apply',
                                          ),
                                          Text(
                                            'Izin',
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
                                                'Apply  ',
                                              ),
                                              Text(
                                                'Sakit',
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
                                            'Apply',
                                          ),
                                          Text(
                                            'Cuti',
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
                                        onPressed: _absenoutButton,
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
                                                'Absen',
                                              ),
                                              Text(
                                                'Keluar',
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
                                            'About',
                                          ),
                                          Text(
                                            'App',
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

  void _izinscreen() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddIzin(
                  user: widget.user,
                )));
  }

  void _sakitscreen() async {
    print("sakitform");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => addSakit(
                  user: widget.user,
                )));
  }

  void _cutiscreen() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => addcuti(
                  user: widget.user,
                )));
  }

  void _absenbutton() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => addabsenscreen(
                  user: widget.user,
                )));
  }

  void _absenoutButton() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => absenKeluar(
                  user: widget.user,
                )));
  }

  void _izinoverview() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => izinuseroverview(user: widget.user)));
  }

  void _sakitoverview() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => sakituseroverview(user: widget.user)));
  }

  void _cutioverview() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => cutiuseroverview(user: widget.user)));
  }
}
