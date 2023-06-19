import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_project/izinscreen.dart';
import 'package:my_project/mainscreen.dart';
import 'package:my_project/user.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

String urlUpload =
    "https://myattendance-test.000webhostapp.com/php/add_izin.php";

class AddIzin extends StatefulWidget {
  final User user;
  AddIzin({Key? key, required this.user});

  @override
  State<AddIzin> createState() => _AddIzinState();
}

class _AddIzinState extends State<AddIzin> {
  TextEditingController dateinput = TextEditingController();
  TextEditingController keteranganizin = TextEditingController();

  @override
  void initState() {
    dateinput.text = "";
    //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: (AppBar(
        backgroundColor: Colors.blue,
        title: Text("Permohonan Izin"),
      )),
      body: Container(
          padding: EdgeInsets.all(10.0),
          height: 700,
          child: Center(
            child: Column(children: [
              TextField(
                controller: dateinput, //editing controller of this TextField
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
                    print(
                        formattedDate); //formatted date output using intl package =>  2021-03-16
                    //you can implement different kind of Date Format here according to your requirement

                    setState(() {
                      dateinput.text =
                          formattedDate; //set output date to TextField value.
                    });
                  } else {
                    print("Date is not selected");
                  }
                },
              ),
              SizedBox(
                height: 15.0,
              ),
              TextField(
                controller: keteranganizin,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(16.0),
                  prefixIcon: Container(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
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
                height: 500.0,
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
                      onTap: (_Izinbutton),
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
          )),
    );
  }

  void _Izinbutton() async {
    print("this is izin button");
    print(widget.user.email);
    print(dateinput.text);
    print(keteranganizin.text);

    if ((dateinput != null && keteranganizin != null)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "in progress");
      pr.show();
      http.post(Uri.parse(urlUpload), body: {
        'email': widget.user.email,
        'date': (dateinput.text).toString(),
        'keterangan': keteranganizin.text,
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
              duration: 3, gravity: Toast.BOTTOM, backgroundColor: Colors.red);
          pr.hide();
        }
      }).catchError((err) {
        print(err);
      });
    } else {
      Toast.show(" Please input the column", context,
          duration: 3, gravity: Toast.BOTTOM);
    }
  }
}
