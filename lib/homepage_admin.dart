import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_project/addIzinscreen.dart';
import 'package:my_project/addSakitscreen.dart';
import 'package:my_project/addabsenscreen.dart';
import 'package:my_project/addcutiscreen.dart';
import 'package:my_project/admin.dart';
import 'package:my_project/cutipegawai_admin.dart';
import 'package:my_project/izinpegawai_admin.dart';
import 'package:my_project/list_useraccount.dart';
import 'package:my_project/loginscreen.dart';
import 'package:my_project/sakitadmin.dart';
import 'package:my_project/user.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_project/verify_useradmin.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:my_project/cutipegawai_admin.dart';
import 'package:my_project/list_useraccount.dart';
import 'package:my_project/aboutappuser.dart';
import 'package:flutter/services.dart';

import 'absenkeluarscreen.dart';

class homepage_admin extends StatefulWidget {
  final Admin admin;
  homepage_admin({Key? key, required this.admin});

  @override
  State<homepage_admin> createState() => _homepage_adminState();
}

class _homepage_adminState extends State<homepage_admin> {
  late GlobalKey<RefreshIndicatorState> refreshKey;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  late Position _currentPosition;
  String _currentAddress = " Searching cureent location";
  String? hasil = null;
  List? data;

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.black));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: RefreshIndicator(
        key: refreshKey,
        color: Colors.cyan,
        onRefresh: () async {
          //await refreshList();
        },
        child: ListView.builder(
            itemCount: data == null ? 1 : data!.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      Stack(children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              left: 200, right: 10, top: 30, bottom: 10),
                          child: Container(
                            height: 80,
                            width: 200,
                            // decoration: BoxDecoration(
                            //   color: Colors.yellow[100],
                            // ),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Welcome",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    Text(widget.admin.name + ""),
                                    Text(widget.admin.jabatan + "")
                                  ],
                                ),
                                SizedBox(
                                  width: 10,
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
                                          border:
                                              Border.all(color: Colors.black),
                                        )),
                                  ),
                                ),
                                SizedBox(
                                  child: Text("      "),
                                ),
                              ],
                            ),
                          ),
                        )
                      ]),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Card(
                                elevation: 10.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: ElevatedButton(
                                  onPressed: _cutibutton,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(10, 15, 15, 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.add),
                                        SizedBox(
                                          height: 15.0,
                                        ),
                                        Text(
                                          'Cuti Pegawai',
                                        ),
                                        Text(
                                          'History',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                elevation: 10.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: ElevatedButton(
                                  onPressed: _izinbutton,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(10, 15, 15, 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.add),
                                        SizedBox(
                                          height: 15.0,
                                        ),
                                        Text(
                                          'Izin Pegawai',
                                        ),
                                        Text(
                                          'History',
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
                              Card(
                                elevation: 10.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: ElevatedButton(
                                  onPressed: _sakitbutton,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(10, 15, 10, 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.add),
                                        SizedBox(
                                          height: 15.0,
                                        ),
                                        Text(
                                          'Sakit Pegawai',
                                        ),
                                        Text(
                                          'History',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                elevation: 10.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: ElevatedButton(
                                  onPressed: _verifyuser,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(10, 15, 35, 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.add),
                                        SizedBox(
                                          height: 15.0,
                                        ),
                                        Text(
                                          'Verify',
                                        ),
                                        Text(
                                          'New User',
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
                              Card(
                                elevation: 10.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: ElevatedButton(
                                  onPressed: _listuseraccount,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(10, 15, 40, 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.add),
                                        SizedBox(
                                          height: 15.0,
                                        ),
                                        Text(
                                          'List User',
                                        ),
                                        Text(
                                          'Account',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                elevation: 10.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: ElevatedButton(
                                  onPressed: buttonabout,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(10, 15, 58, 10),
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
                          SizedBox(
                            height: 10,
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
                                        color:
                                            Color(0xFF6078ea).withOpacity(0.5),
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
                      SizedBox(
                        height: 4,
                      ),
                      Stack(children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 25, right: 10, top: 10, bottom: 10),
                          child: Row(
                            children: [
                              Text(
                                "List .",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Absen Pegawai Hari ini             ",
                                style: TextStyle(fontSize: 12),
                              ),
                              // (data!.length > 0)
                              //     ? Text(" Total : " + data!.length.toString(),
                              //         style: TextStyle(
                              //           fontWeight: FontWeight.bold,
                              //         ))
                              //     : Text("Total :")
                            ],
                          ),
                        )
                      ]),
                    ],
                  ),
                );
              }

              index -= 1;
              return Scrollbar(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Expanded(
                    child: Container(
                        margin: EdgeInsets.only(
                          bottom: 8,
                          left: 10,
                          right: 10,
                        ),
                        child: Row(children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: NetworkImage(
                                    "https://myattendance-test.000webhostapp.com/profile/${data![index]['email'].toString()}"),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                              child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                    color: Colors.grey[400],
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: Text(
                                            data![index]['name']
                                                .toString()
                                                .toUpperCase(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            "Date : " +
                                                data![index]['date']
                                                    .toString()
                                                    .toUpperCase(),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Masuk",
                                              style: TextStyle(
                                                  color: Colors.green[800]),
                                            ),
                                            Text(
                                              "Keluar",
                                              style: TextStyle(
                                                  color: Colors.red[800]),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Jam : " +
                                                data![index]['jam'].toString()),
                                            (data![index]['jamkeluar'].length >
                                                    0)
                                                ? Text("Jam : " +
                                                    data![index]['jamkeluar']
                                                        .toString())
                                                : Text("Belum Absen Keluar")
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text("Location : " +
                                            data![index]['location'].toString())
                                      ],
                                    ),
                                  )))
                        ])),
                  ),
                ),
              );
            }),
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
        init();
        // init(); //load data from database into list array 'data'
      });
    } catch (e) {
      print(e);
    }
  }

  Future init() async {
    this.makeRequest();
    //_getCurrentLocation();
  }

  Future<String?> makeRequest() async {
    String urlLoadAbsen =
        "https://myattendance-test.000webhostapp.com/php/load_allabsenadmin.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Load absen list");
    pr.style(maxProgress: 5.0);
    pr.show();

    http.post(Uri.parse(urlLoadAbsen), body: {}).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        data = extractdata["absen"];
        print("data");
        print(data);
        pr.hide();
      });
    }).catchError((err) {
      print(err);
      pr.hide();
    });
    return null;
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    this.makeRequest();
    return null;
  }

  void _changeEmail() async {
    print("this is change email button");
  }

  void _changeNoHp() async {
    print(" this is change no hp button ");
  }

  void _listuseraccount() async {
    print("list user account button");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => list_useraccount(
                  admin: widget.admin,
                )));
  }

  void _Logoutbutton() async {
    print(" this is log out button ");
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  void buttonabout() async {
    print("this is about app button");
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => aboutuserapp()));
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

  void _izinbutton() async {
    print("izin button");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => izinpegawaiadmin(admin: widget.admin)));
  }

  void _sakitbutton() async {
    print("sakit button");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => sakitpegawaiadmin(admin: widget.admin)));
  }

  void _cutibutton() async {
    print("cuti button");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => cutipegawaiadmin(admin: widget.admin)));
  }

  void _verifyuser() async {
    print("verify user");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => verify_useradmin(admin: widget.admin)));
  }

  void _absenoutButton() async {}
}
