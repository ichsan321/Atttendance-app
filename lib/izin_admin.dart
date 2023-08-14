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

class izin_admin extends StatefulWidget {
  final Admin admin;

  izin_admin({Key? key, required this.admin});

  @override
  _izin_adminState createState() => _izin_adminState();
}

class _izin_adminState extends State<izin_admin> {
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
                await refreshList();
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
                                    child: Text("Izin Pegawai",
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
                                child: Text("Izin Pegawai List",
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
                    // if (index == data!.length && perpage > 1) {
                    //   return Container(
                    //     width: 250,
                    //     color: Colors.cyan,
                    //     child: MaterialButton(
                    //       child: Text(
                    //         "Load More",
                    //         style: TextStyle(color: Colors.black),
                    //       ),
                    //       onPressed: () {},
                    //     ),
                    //   );
                    // }
                    index -= 1;

                    // if (data![index]['aprove'].toString() == "Administrator"){
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
                                  onIzinDelete(data![index]['id'].toString());
                                },
                                backgroundColor:
                                    Color.fromARGB(255, 184, 30, 30),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),

                          // onLongPress: () => _onIzinDelete(
                          //     data![index]['id'].toString(),
                          //     data![index]['date'].toString(),
                          //     data![index]['keterangan'].toString(),
                          //     data![index]['aprove'].toString()),
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
                                        TextButton(
                                          onPressed: () => showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                              content: SizedBox(
                                                width: 500.0,
                                                height: 700.0,
                                                child: Image.network(
                                                  "https://myattendance-test.000webhostapp.com/izin/${data![index]['email'] + data![index]['date']}.jpg",
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: const Text(
                                                        'There is no data',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'Cancel'),
                                                  child: const Text('Cancel'),
                                                ),
                                              ],
                                            ),
                                          ),
                                          child: const Text('Additional file'),
                                        ),
                                        // Container(
                                        //     width: 150.0,
                                        //     height: 150.0,
                                        //     decoration: new BoxDecoration(
                                        //         shape: BoxShape.circle,
                                        //         border: Border.all(
                                        //             color: Colors.black),
                                        //         image: new DecorationImage(
                                        //             fit: BoxFit.cover,
                                        //             image: new NetworkImage(
                                        //                 "https://myattendance-test.000webhostapp.com/izin/${data![index]['email'] + data![index]['date']}.jpg")))),
                                        // (data![index]['aprove'].toString() ==
                                        //         "Administrator")
                                        //     ? Row(
                                        //         mainAxisAlignment:
                                        //             MainAxisAlignment.center,
                                        //         children: [
                                        //           Text("Approve By : "),
                                        //           Text(
                                        //             data![index]['aprove'],
                                        //             style: TextStyle(
                                        //                 color: Colors.green),
                                        //           )
                                        //         ],
                                        //       )
                                        //     : Row(
                                        //         mainAxisAlignment:
                                        //             MainAxisAlignment.center,
                                        //         children: [
                                        //           Text("Approve By : "),
                                        //           Text(
                                        //             data![index]['aprove'],
                                        //             style: TextStyle(
                                        //                 color: Colors.red),
                                        //           )
                                        //         ],
                                        //       ),
                                        (data![index]['aprove'].length > 0)
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text("Done",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Icon(Icons.check)
                                                ],
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
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
                                                          data![index]['date']
                                                              .toString(),
                                                          data![index]
                                                                  ['totalizin']
                                                              .toString()),
                                                      child: Text("Accepted")),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: Color.fromARGB(
                                                            189,
                                                            223,
                                                            22,
                                                            22), // Background color
                                                        onPrimary: Colors.white,
                                                      ),
                                                      onPressed: () =>
                                                          onRejected(
                                                              data![index]['id']
                                                                  .toString(),
                                                              data![index]
                                                                      ['name']
                                                                  .toString(),
                                                              data![index]
                                                                      ['email']
                                                                  .toString(),
                                                              data![index]
                                                                      ['date']
                                                                  .toString()),
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
        "https://myattendance-test.000webhostapp.com/php/load_izinadmin.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Load izin list");
    pr.show();
    http.post(Uri.parse(urlLoadIzin), body: {
      "email": widget.admin.email,
    }).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        data = extractdata["izin"];
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
      String id, String name, String email, String date, String totalizin) {
    print("this is accepted button ");
    _showDialog(id, name, email, date, totalizin);
  }

  void _showDialog(
      String id, String name, String email, String date, String totalizin) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Column(
            children: [
              Text(
                "Apakah anda yakin ingin",
              ),
              Row(
                children: [
                  Text("menyetujui izin "),
                  Text(
                    name,
                    style: TextStyle(color: Colors.red),
                  )
                ],
              ),
              Row(
                children: [
                  Text("pada tanggal "),
                  Text(
                    date,
                    style: TextStyle(color: Colors.red),
                  ),
                  Text(" ?")
                ],
              )
            ],
          ),

          // content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new ElevatedButton(
              child: new Text("Ya"),
              onPressed: () {
                Navigator.of(context).pop();
                AcceptRequest(id, email, totalizin);
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

  Future<String?> AcceptRequest(String id, email, totalizin) async {
    print("id user " + id);
    print("email user " + email);
    String urlAcceptedIzin =
        "https://myattendance-test.000webhostapp.com/php/accepted_izin.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Accepting Izin");
    pr.show();
    http.post(Uri.parse(urlAcceptedIzin), body: {
      "id": id.toString(),
      "email": email.toString(),
      "totalizin": 1.toString(),
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

  void onRejected(String id, String name, String email, String date) {
    print("This is rejected button");
    _showDialog1(id, name, email, date);
  }

  void _showDialog1(String id, String name, String email, String date) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Apakah anda yakin ingin menolak izin  " +
              name +
              " pada tanggal " +
              date +
              " ?"),
          // content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new ElevatedButton(
              child: new Text("Ya"),
              onPressed: () {
                Navigator.of(context).pop();
                AcceptRequest1(id, email);
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

  Future<String?> AcceptRequest1(String id, email) async {
    print("id user " + id);
    print("email user " + email);
    String urlAcceptedIzin =
        "https://myattendance-test.000webhostapp.com/php/rejected_izin.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Rejecting Izin");
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
