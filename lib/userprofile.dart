import 'package:flutter/material.dart';
import 'package:my_project/mainscreen.dart';
import 'package:my_project/user.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:random_string/random_string.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';

String urluploadImage =
    "https://myattendance-test.000webhostapp.com/php/upload_imageprofile.php";
String urlUpload1 =
    "https://myattendance-test.000webhostapp.com/php/update_user.php";

class UpdateProfileScreen extends StatefulWidget {
  final User user;
  const UpdateProfileScreen({Key? key, required this.user});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  File? _image;
  int number = 0;
  TextEditingController phone = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                      child: Text("Profile Details",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ]),
            ],
          ),
        ),
        leading: IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              // -- IMAGE with ICON
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image(
                            image: NetworkImage(
                                "https://myattendance-test.000webhostapp.com/profile/${widget.user.email}?dummy=${(number)}'"))),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _update,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.white),
                        child: const Icon(Icons.camera_alt,
                            color: Colors.black, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),

              // -- Form Fields
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                          enabled: false,
                          label: Text(widget.user.name),
                          prefixIcon: Icon(Icons.account_box_rounded)),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      decoration: InputDecoration(
                          enabled: false,
                          label: Text(widget.user.email),
                          prefixIcon: Icon(Icons.email)),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      decoration: InputDecoration(
                          enabled: false,
                          label: Text(widget.user.jabatan),
                          prefixIcon: Icon(Icons.work)),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: phone,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          label: Text(widget.user.phone),
                          prefixIcon: Icon(Icons.phone)),
                    ),

                    const SizedBox(height: 20),

                    // -- Form Submit Button
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
                            onTap: (_updateuser),
                            child: Center(
                              child: Text("UPDATE",
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
                    const SizedBox(height: 5),

                    // -- Created Date and Delete Button
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _update() async {
    print("update button");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Take new profile picture?"),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new ElevatedButton(
              child: new Text("Yes"),
              onPressed: () async {
                Navigator.of(context).pop();

                XFile? _cameraImage;

                _cameraImage = (await ImagePicker()
                    .pickImage(source: ImageSource.gallery));
                if (_cameraImage != null) {
                  //Avoid crash if user cancel picking image
                  _image = File(_cameraImage.path);
                }

                String base64Image = base64Encode(_image!.readAsBytesSync());
                http.post(Uri.parse(urluploadImage), body: {
                  "encoded_string": base64Image,
                  "email": widget.user.email,
                }).then((res) {
                  print(res.body);

                  if (res.body == "success") {
                    setState(() {
                      number = new Random().nextInt(100);
                      print(number);
                    });
                  } else {}
                }).catchError((err) {
                  print(err);
                });
              },
            ),
            new ElevatedButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateuser() async {
    print(phone.text);
    if ((phone.text.length > 5)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "in progress");
      pr.show();
      http.post(Uri.parse(urlUpload1), body: {
        'email': widget.user.email,
        'phone': (phone.text).toString(),
      }).then((res) {
        var string = res.body;
        List dres = string.split(",");
        if (dres[0] == "success") {
          print('in success');
          setState(() {
            widget.user.phone = dres[4];
            if (dres[0] == "success") {
              Toast.show("Success", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              Navigator.of(context).pop();
            }
          });
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
