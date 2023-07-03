import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:my_project/user.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:my_project/admin.dart';
import 'package:toast/toast.dart';

double perpage = 1;

class cuti_admin extends StatefulWidget {
  final Admin admin;

  cuti_admin({Key? key, required this.admin});

  @override
  _cuti_adminState createState() => _cuti_adminState();
}

class _cuti_adminState extends State<cuti_admin> {
  late GlobalKey<RefreshIndicatorState> refreshKey;

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position? _currentPosition;
  String _currentAddress = "Searching current location...";
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
        SystemUiOverlayStyle(statusBarColor: Colors.blue));
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            body: RefreshIndicator(
              key: refreshKey,
              color: Colors.cyan,
              onRefresh: () async {
                //await refreshList();
              },
              child: ListView.builder(
                  //Step 6: Count the data
                  itemCount: data == null ? 1 : data!.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Container(
                        child: Column(
                          children: <Widget>[
                            Stack(children: <Widget>[
                              Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Center(
                                    child: Text("Cuti Detail",
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: 300,
                                    height: 140,
                                    child: Card(
                                      child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.person,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    widget.admin.name
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.location_on,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child: Text(_currentAddress),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                            SizedBox(
                              height: 4,
                            ),
                            Container(
                              color: Colors.blue,
                              child: Center(
                                child: Text("Cuti List",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    if (index == data!.length && perpage > 1) {
                      return Container(
                        width: 250,
                        color: Colors.cyan,
                        child: MaterialButton(
                          child: Text(
                            "Load More",
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {},
                        ),
                      );
                    }
                    index -= 1;
                    return Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Card(
                        elevation: 2,
                        child: InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                            "Name : " +
                                                data![index]['name']
                                                    .toString()
                                                    .toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                            "Date : " +
                                                data![index]['dateawal']
                                                    .toString()
                                                    .toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                            "Date : " +
                                                data![index]['dateakhir']
                                                    .toString()
                                                    .toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text("Keterangan : " +
                                            data![index]['keterangan']),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text("Approve By : " +
                                            data![index]['approve']),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Color.fromARGB(
                                                      190,
                                                      83,
                                                      205,
                                                      49), // Background color
                                                  onPrimary: Colors.white,
                                                ),
                                                onPressed: () => onAccepted(
                                                      data![index]['id']
                                                          .toString(),
                                                      data![index]['name']
                                                          .toString(),
                                                      data![index]['email']
                                                          .toString(),
                                                      data![index]['dateawal']
                                                          .toString(),
                                                      data![index]['dateakhir']
                                                          .toString(),
                                                    ),
                                                child: Text("Accepted")),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Color.fromARGB(
                                                      189,
                                                      223,
                                                      22,
                                                      22), // Background color
                                                  onPrimary: Colors.white,
                                                ),
                                                onPressed: onRejected,
                                                child: Text("Rejected"))
                                          ],
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
                    );
                  }),
            )));
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
          _currentPosition!.latitude, _currentPosition!.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name},${place.locality}, ${place.postalCode}, ${place.country}";
        init(); //load data from database into list array 'data'
      });
    } catch (e) {
      print(e);
    }
  }

  Future<String?> makeRequest() async {
    String urlLoadIzin =
        "https://myattendance-test.000webhostapp.com/php/load_cuti.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Load Cuti list");
    pr.show();
    http.post(Uri.parse(urlLoadIzin), body: {
      "email": widget.admin.email,
    }).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        data = extractdata["cuti"];
        perpage = (data!.length / 10);
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

  Future init() async {
    this.makeRequest();
    //_getCurrentLocation();
  }

  void onAccepted(
      String id, String name, String email, String dateawal, String dateakhir) {
    print("this is accepted button ");
    _showDialog(id, name, email, dateawal, dateakhir);
  }

  _showDialog(
      String id, String name, String email, String dateawal, String dateakhir) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Apakah Anda Yakin Untuk Menyetujui Cuti ini ?" +
                name +
                "Pada Tanggal " +
                dateawal +
                "Sampai Tanggal " +
                dateakhir),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new ElevatedButton(
                child: new Text("Ya"),
                onPressed: () {
                  Navigator.of(context).pop();
                  AcceptRequest(id, email);
                },
              ),
              new ElevatedButton(
                child: new Text("Tidak"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<String?> AcceptRequest(String id, email) async {
    print("id user " + id);
    print("email user " + email);
    String urlAcceptedIzin =
        "https://myattendance-test.000webhostapp.com/php/accepted_cuti.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Accepting Izin");
    pr.show();
    http.post(Uri.parse(urlAcceptedIzin), body: {
      "id": id.toString(),
      "email": email.toString(),
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("Successfully", context, duration: 3, gravity: Toast.CENTER);
        init();
      } else if (res.body == "failed") {
        Toast.show("There is a problem with with our api ", context,
            duration: 3, gravity: Toast.BOTTOM);
        pr.hide();
      }
    }).catchError((err) {
      print(err);
      pr.hide();
    });
    return null;
  }

  void onRejected() {
    print("This is rejected button");
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    this.makeRequest();
    return null;
  }
}
