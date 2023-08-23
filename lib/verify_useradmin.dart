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
import 'package:flutter_slidable/flutter_slidable.dart';

double perpage = 1;

class verify_useradmin extends StatefulWidget {
  final Admin admin;

  verify_useradmin({Key? key, required this.admin});

  @override
  _verify_useradminState createState() => _verify_useradminState();
}

class _verify_useradminState extends State<verify_useradmin> {
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
            await refreshList();
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
                                  child: Text("USER VERIFICATION LIST",
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
                index -= 1;
                return Container(
                  padding: EdgeInsets.all(2.0),
                  child: Card(
                    elevation: 2,
                    child: Slidable(
                      key: const ValueKey(0),
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        dismissible: DismissiblePane(onDismissed: () {}),
                        children: [
                          SlidableAction(
                            flex: 1,
                            onPressed: (BuildContext context) {
                              onIzinDelete(data![index]['EMAIL'].toString());
                            },
                            backgroundColor: Color.fromARGB(255, 184, 30, 30),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                        "Name : " +
                                            data![index]['NAME']
                                                .toString()
                                                .toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                        "Email : " +
                                            data![index]['EMAIL'].toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                        )),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text("NO HP : " +
                                        data![index]['PHONE'].toString()),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text("Jabatan : " +
                                        data![index]['JABATAN'].toString()),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Color.fromARGB(190, 83,
                                                  205, 49), // Background color
                                              onPrimary: Colors.white,
                                            ),
                                            onPressed: () => onAccepted(
                                                  data![index]['NAME']
                                                      .toString(),
                                                  data![index]['EMAIL']
                                                      .toString(),
                                                ),
                                            child: Text("Accepted")),
                                        SizedBox(
                                          width: 15,
                                        ),
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
    String urlLoadUser =
        "https://myattendance-test.000webhostapp.com/php/load_usernotverify.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Load User List");
    pr.show();
    http.post(Uri.parse(urlLoadUser), body: {}).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        data = extractdata["user"];
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
    String name,
    String email,
  ) {
    print("this is accepted button ");
    _showDialog(name, email);
  }

  void _showDialog(String name, String email) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
              "Apakah anda yakin ingin menyetujui pegawai dengan nama " +
                  name +
                  " ?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new ElevatedButton(
              child: new Text("Ya"),
              onPressed: () {
                Navigator.of(context).pop();
                AcceptRequest(email);
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
      },
    );
  }

  Future<String?> AcceptRequest(String email) async {
    print("email user " + email);
    String urlAcceptedIzin =
        "https://myattendance-test.000webhostapp.com/php/verify.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Accepting Izin");
    pr.show();
    http.post(Uri.parse(urlAcceptedIzin), body: {
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

  void onRejected(String name, String email) {
    print("This is rejected button");
    _showDialog1(name, email);
  }

  void _showDialog1(String name, String email) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
              "Apakah anda yakin ingin menyetujui pegawai dengan nama  " +
                  name +
                  " ?"),
          // content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new ElevatedButton(
              child: new Text("Ya"),
              onPressed: () {
                Navigator.of(context).pop();
                AcceptRequest1(email);
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
      },
    );
  }

  Future<String?> AcceptRequest1(String email) async {
    print("email user " + email);
    String urlAcceptedIzin =
        "https://myattendance-test.000webhostapp.com/php/rejected_user.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Rejecting User");
    pr.show();
    http.post(Uri.parse(urlAcceptedIzin), body: {
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

  void onIzinDelete(String id) {
    print("This is delete izin button");
    print("id user" + id);
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    this.makeRequest();
    return null;
  }
}
