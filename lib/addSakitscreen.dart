import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_project/mainscreen.dart';
import 'package:my_project/user.dart';

class addSakit extends StatefulWidget {
  final User user;

  const addSakit({Key? key, required this.user});

  @override
  State<addSakit> createState() => _addSakitState();
}

class _addSakitState extends State<addSakit> {
  TextEditingController dateinput = TextEditingController();
  TextEditingController sakitinput = TextEditingController();

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
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Sakit Form"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Container(
            height: 700,
            child: Column(
              children: [
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
                  height: 10.0,
                ),
                TextField(
                  controller: sakitinput,
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
                  height: 490.0,
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
                        onTap: (_Sakitbutton),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _Sakitbutton() {
    setState(() {
      print(" This is absen button ");
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => (Maincsreen(user: widget.user))),
      );
    });
  }
}
