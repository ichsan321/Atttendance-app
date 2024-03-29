import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:my_project/absen.dart';
import 'package:my_project/user.dart';
import 'package:progress_dialog/progress_dialog.dart';

double perpage = 1;
int count = 0;

class sakitscreen extends StatefulWidget {
  final User user;

  sakitscreen({Key? key, required this.user});

  @override
  _sakitscreenState createState() => _sakitscreenState();
}

class _sakitscreenState extends State<sakitscreen> {
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
        SystemUiOverlayStyle(statusBarColor: Colors.black));
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
                                  // Center(
                                  //   child: Text("Sakit Detail",
                                  //       style: TextStyle(
                                  //           fontSize: 24,
                                  //           fontWeight: FontWeight.bold,
                                  //           color: Colors.black)),
                                  // ),
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
                                                    widget.user.name
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
                              height: 20,
                            ),
                            Container(
                              width: 370,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Center(
                                child: Text("SAKIT LIST",
                                    style: TextStyle(
                                        letterSpacing: 5,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            )
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
                    if (data != null) {
                      print("Test sakit");
                      print(data);
                      index -= 1;
                      count = index + 1;
                      return Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Card(
                          elevation: 2,
                          child: InkWell(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            count.toString(),
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                              "Date : " +
                                                  data![index]['date']
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
                                          (data![index]['Approve'].toString() ==
                                                  "Administrator")
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                      Text("Approve By : "),
                                                      Text(
                                                        data![index]['Approve'],
                                                        style: TextStyle(
                                                            color:
                                                                Colors.green),
                                                      )
                                                    ])
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text("Approve By : "),
                                                    Text(
                                                      data![index]['Approve']
                                                          .toString(),
                                                      style: TextStyle(
                                                          color:
                                                              Colors.red[100]),
                                                    )
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
                    } else {
                      return Expanded(
                        child: Container(
                          child: Text("No Data"),
                        ),
                      );
                    }
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
        "https://myattendance-test.000webhostapp.com/php/load_sakit.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Load sakit list");
    pr.show();
    http.post(Uri.parse(urlLoadIzin), body: {
      "email": widget.user.email,
    }).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        data = extractdata["sakit"];
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

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    this.makeRequest();
    return null;
  }
}
