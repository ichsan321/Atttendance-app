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

class list_useraccount extends StatefulWidget {
  final Admin admin;

  list_useraccount({Key? key, required this.admin});

  @override
  _list_useraccountState createState() => _list_useraccountState();
}

class _list_useraccountState extends State<list_useraccount> {
  // late GlobalKey<RefreshIndicatorState> refreshKey;

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position? _currentPosition;
  String _currentAddress = "Searching current location...";
  List? data = [];
  var searchController = new TextEditingController();
  List? data1 = [];

  @override
  initState() {
    super.initState();
    // refreshKey = GlobalKey<RefreshIndicatorState>();
    // _getCurrentLocation();
    init();

    print("result di inistate");
    print(data1);
  }

  void _runFilter(String enteredKeyword) {
    List? result;

    if (enteredKeyword.isEmpty) {
      result = data;
    } else {
      result = data
          ?.where((data) => data!["NAME"]
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      print("Test1");
      print(result);
    }
    setState(() {
      data1 = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List All User Registered'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            TextField(
              onChanged: (value) => _runFilter(value),
              decoration: const InputDecoration(
                  labelText: 'Search', suffixIcon: Icon(Icons.search)),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: data1!.isNotEmpty
                  ? ListView.builder(
                      itemCount: data1!.length,
                      itemBuilder: (context, index) => Card(
                        key: ValueKey(data1![index]["NAME"]),
                        color: Colors.amberAccent,
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          leading: Text(
                            data1![index]["Id"].toString(),
                            style: const TextStyle(fontSize: 24),
                          ),
                          title: Text(
                            data1![index]['NAME'].toUpperCase(),
                          ),
                          subtitle:
                              Text(data1![index]['JABATAN'].toUpperCase()),
                          trailing: InkWell(
                              onTap: () => onDeleted(
                                    data![index]['Id'].toString(),
                                    data![index]['NAME'].toString(),
                                  ),
                              child: Icon(Icons.delete_outline)),
                        ),
                      ),
                    )
                  : const Text(
                      'No results found',
                      style: TextStyle(fontSize: 24),
                    ),
            ),
          ],
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
        print("this is button current location ");
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  Future _getdata() async {
    init();
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name},${place.locality}, ${place.postalCode}, ${place.country}";
        print("this is get address from latlong");
        init(); //load data from database into list array 'data'
      });
    } catch (e) {
      print(e);
    }
  }

  Future<String?> makeRequest() async {
    String urlLoadUser =
        "https://myattendance-test.000webhostapp.com/php/list_useraccount.php";
    ProgressDialog pr = new ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    pr.style(message: "Load User Account List");
    pr.show();
    http.post(Uri.parse(urlLoadUser), body: {}).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        data = extractdata["user"];
        perpage = (data!.length / 10);
        print("data");
        print(data);
        data1 = data;

        pr.hide();
      });
    }).catchError((err) {
      print(err);
      pr.hide();
    });
    return null;
  }

  Future init() async {
    makeRequest();
    //_getCurrentLocation();
  }

  void onDeleted(
    String id,
    String name,
  ) {
    print("this is accepted button ");
    _showDialog(id, name);
  }

  void _showDialog(String id, name) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
              "Apakah anda yakin ingin menghapus account dengan nama " +
                  name +
                  " ?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new ElevatedButton(
              child: new Text("Ya"),
              onPressed: () {
                Navigator.of(context).pop();
                delete(id);
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

  Future<String?> delete(String id) async {
    print("email user " + id);
    String urlAcceptedIzin =
        "https://myattendance-test.000webhostapp.com/php/deleted_useradmin.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Deleting User");
    pr.show();
    http.post(Uri.parse(urlAcceptedIzin), body: {
      "id": id.toString(),
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
