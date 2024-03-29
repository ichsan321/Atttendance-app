import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:my_project/mainscreen.dart';
import 'package:my_project/user.dart';
import 'dart:convert';
import 'dart:io';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

String urlUpload =
    "https://myattendance-test.000webhostapp.com/php/add_cuti.php";

class addcuti extends StatefulWidget {
  final User user;
  const addcuti({Key? key, required this.user});

  @override
  State<addcuti> createState() => _addcutiState();
}

class _addcutiState extends State<addcuti> {
  TextEditingController cutiinput = TextEditingController();
  TextEditingController startdateinput = TextEditingController();
  TextEditingController enddateinput = TextEditingController();
  String startcal = "";
  String endcal = "";
  @override
  void initState() {
    startdateinput.text = "";
    enddateinput.text = "";
    //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(" Cuti form"),
      ),
      body: Center(
        child: Container(
          height: 700,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Container(
              child: Column(children: [
                TextField(
                  controller:
                      startdateinput, //editing controller of this TextField
                  decoration: InputDecoration(
                      icon: Icon(Icons.calendar_today), //icon of text field
                      labelText: "Enter Date" //label text of field
                      ),
                  readOnly:
                      true, //set it true, so that user will not able to edit text
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(
                            2000), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2101));

                    if (pickedDate != null) {
                      print(
                          pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      String formattedDatecal =
                          DateFormat('dd-MM-yyyy').format(pickedDate);
                      print(
                          formattedDate); //formatted date output using intl package =>  2021-03-16
                      //you can implement different kind of Date Format here according to your requirement

                      setState(() {
                        startdateinput.text = formattedDatecal;
                        startcal = formattedDate;
                        //set output date to TextField value.
                      });
                    } else {
                      print("Date is not selected");
                    }
                  },
                ),
                TextField(
                  controller:
                      enddateinput, //editing controller of this TextField
                  decoration: InputDecoration(
                      icon: Icon(Icons.calendar_today), //icon of text field
                      labelText: "End Date" //label text of field
                      ),
                  readOnly:
                      true, //set it true, so that user will not able to edit text
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(
                            2000), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2101));

                    if (pickedDate != null) {
                      print(
                          pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);

                      String formattedDatecal =
                          DateFormat('dd-MM-yyyy').format(pickedDate);

                      print(
                          formattedDate); //formatted date output using intl package =>  2021-03-16
                      //you can implement different kind of Date Format here according to your requirement

                      setState(() {
                        enddateinput.text =
                            formattedDatecal; //set output date to TextField value.
                        endcal = formattedDate;
                      });
                    } else {
                      print("Date is not selected");
                    }
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  maxLines: 7,
                  controller: cutiinput,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(16.0),
                    prefixIcon: Container(
                        padding: const EdgeInsets.only(top: 85.0, bottom: 85.0),
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
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.cyan.withOpacity(0.8),
                  ),
                ),
                SizedBox(
                  height: 290.0,
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
                        onTap: (_Cutibutton),
                        child: Center(
                          child: Text("Applied",
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
              ]),
            ),
          ),
        ),
      ),
    );
  }

  void _Cutibutton() async {
    print("this is izin button");
    print(widget.user.email);
    print(widget.user.name);
    print(startdateinput.text);
    print(enddateinput.text);

    DateTime awal = DateTime.parse(startcal);
    DateTime akhir = DateTime.parse(endcal);
    Duration diff = akhir.difference(awal);
    print(diff.inDays + 1);

    if ((startcal.length > 5 &&
        endcal.length > 5 &&
        cutiinput.text.length > 5)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "in progress");
      pr.show();
      http.post(Uri.parse(urlUpload), body: {
        'email': widget.user.email,
        'name': widget.user.name,
        'dateawal': (startcal).toString(),
        'dateakhir': (endcal).toString(),
        'keterangan': cutiinput.text,
        'totalcuti': (diff.inDays + 1).toString(),
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
              duration: 3, gravity: Toast.TOP, backgroundColor: Colors.red);
          pr.hide();
        }
      }).catchError((err) {
        print(err);
      });
    } else {
      Toast.show(" Please input the column", context,
          duration: 3, gravity: Toast.TOP);
    }
  }
}
