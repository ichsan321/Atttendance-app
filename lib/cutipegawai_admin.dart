import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:my_project/admin.dart';
import 'package:progress_dialog/progress_dialog.dart';

double perpage = 1;

class cutipegawaiadmin extends StatefulWidget {
  final Admin admin;

  cutipegawaiadmin({Key? key, required this.admin});

  @override
  _cutipegawaiadminState createState() => _cutipegawaiadminState();
}

class _cutipegawaiadminState extends State<cutipegawaiadmin> {
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
    return Scaffold(
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
                  return AppBar(
                    title: Container(
                      child: Column(
                        children: <Widget>[
                          Stack(children: <Widget>[
                            Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: Text("Cuti Pegawai History",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ]),
                        ],
                      ),
                    ),
                    leading: new IconButton(
                      icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    //You can make this transparent
                    elevation: 0.0, //No shadow
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
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Column(children: <Widget>[
                                  Text(
                                    data![index]['name']
                                        .toString()
                                        .toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 80),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            data![index]['dateawal']
                                                .toString()
                                                .toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        Text("-",
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            data![index]['dateakhir']
                                                .toString()
                                                .toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text("Total Cuti : " +
                                      data![index]['totalcuti'].toString() +
                                      " Hari"),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text("Keterangan : " +
                                      data![index]['keterangan']),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  (data![index]['approve'].toString() ==
                                          "Administrator")
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                              Text("Approve By : "),
                                              Text(
                                                data![index]['approve']
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.green),
                                              )
                                            ])
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text("Approve by :"),
                                            Text(
                                              data![index]['approve']
                                                  .toString(),
                                              style:
                                                  TextStyle(color: Colors.red),
                                            )
                                          ],
                                        )
                                ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ));
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
        "https://myattendance-test.000webhostapp.com/php/load_cutiadminhistory.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Load Cuti list");
    pr.show();
    http.post(Uri.parse(urlLoadIzin), body: {}).then((res) {
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

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    this.makeRequest();
    return null;
  }
}
