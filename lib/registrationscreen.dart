import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:my_project/loginscreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_project/constant.dart';

String pathAsset = 'asset/image/peopleicon.png';
String urlUpload =
    "https://myattendance-test.000webhostapp.com/php/register_user.php";
File? _image;
final TextEditingController _namecontroller = TextEditingController();
final TextEditingController _emcontroller = TextEditingController();
final TextEditingController _passcontroller = TextEditingController();
final TextEditingController _phcontroller = TextEditingController();
final TextEditingController _jabatancontroller = TextEditingController();
// final TextEditingController _verificationcontroller = TextEditingController();
String? _name, _email, _password, _phone, _jabatan;
bool passwordVisible = false;

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
  const RegisterScreen({Key? key, File? image}) : super(key: key);
}

class _RegisterUserState extends State<RegisterScreen> {
  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.black));

    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('New User Registration'),
        ),
        body: SingleChildScrollView(
          child: Container(
            // decoration: new BoxDecoration(
            //     image: new DecorationImage(
            //         image: AssetImage('asset/image/peopleicon.png'),
            //         fit: BoxFit.fill)),
            padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
            child: RegisterWidget(),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressAppBar() async {
    _image = null;
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
    return Future.value(false);
  }
}

class RegisterWidget extends StatefulWidget {
  @override
  RegisterWidgetState createState() => RegisterWidgetState();
}

class RegisterWidgetState extends State<RegisterWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
            onTap: () => mainBottomSheet(context),
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: _image == null
                        ? AssetImage(pathAsset)
                        : FileImage(_image!) as ImageProvider,
                    fit: BoxFit.fill,
                  )),
            )),
        Text('Click on image above to take profile picture'),
        SizedBox(
          height: 20.0,
        ),
        TextField(
          controller: _emcontroller,
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
                  Icons.email,
                  color: Colors.lightBlue,
                )),
            hintText: "Email",
            hintStyle: TextStyle(color: Colors.black),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none),
            filled: true,
            fillColor: Colors.cyan.withOpacity(0.8),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          controller: _namecontroller,
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
                  Icons.person,
                  color: Colors.lightBlue,
                )),
            hintText: "Name",
            hintStyle: TextStyle(color: Colors.black),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none),
            filled: true,
            fillColor: Colors.cyan.withOpacity(0.8),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          controller: _passcontroller,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(16.0),
            suffixIcon: IconButton(
              color: Colors.black,
              icon: Icon(
                  passwordVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(
                  () {
                    passwordVisible = !passwordVisible;
                  },
                );
              },
            ),
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
                  Icons.lock,
                  color: Colors.lightBlue,
                )),
            hintText: "Password",
            hintStyle: TextStyle(color: Colors.black),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none),
            filled: true,
            fillColor: Colors.cyan.withOpacity(0.8),
          ),
          obscureText: passwordVisible,
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          controller: _phcontroller,
          keyboardType: TextInputType.phone,
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
                  Icons.phone,
                  color: Colors.lightBlue,
                )),
            hintText: "Phone Number",
            hintStyle: TextStyle(color: Colors.black),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none),
            filled: true,
            fillColor: Colors.cyan.withOpacity(0.8),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          controller: _jabatancontroller,
          keyboardType: TextInputType.text,
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
                  Icons.assignment_ind,
                  color: Colors.lightBlue,
                )),
            hintText: "Jabatan",
            hintStyle: TextStyle(color: Colors.black),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none),
            filled: true,
            fillColor: Colors.cyan.withOpacity(0.8),
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        SizedBox(
          height: 10,
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
                onTap: (_onRegister),
                child: Center(
                  child: Text("REGISTER",
                      style: TextStyle(
                          color: Colors.white, // LOGIN Name
                          fontFamily: "Poppins-Bold",
                          fontSize: 18,
                          letterSpacing: 10.0)), //for the space of the text
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
            onTap: _onBackPress,
            child: Text('Already Register', style: TextStyle(fontSize: 16))),
      ],
    );
  }

  void mainBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _createTile(context, 'Camera', Icons.camera, _action1),
              _createTile(context, 'Gallery', Icons.photo_album, _action2),
            ],
          );
        });
  }

  ListTile _createTile(
      BuildContext context, String name, IconData icon, Function action) {
    return ListTile(
      leading: Icon(icon),
      title: Text(name),
      onTap: () {
        Navigator.pop(context);
        action();
      },
    );
  }

  //Take profile picture from camera
  _action1() async {
    print('action camera');
    XFile? _cameraImage;
    _cameraImage = (await ImagePicker().pickImage(source: ImageSource.camera));
    if (_cameraImage != null) {
      //Avoid crash if user cancel picking image
      _image = File(_cameraImage.path);

      setState(() {});
    }
  }

  //Take profile picture from gallery
  _action2() async {
    print('action gallery');
    XFile? _galleryImage;

    _galleryImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (_galleryImage != null) {
      //Avoid crash if user cancel picking image

      _image = File(_galleryImage.path);
      setState(() {});
    }
  }

  void _onRegister() {
    print('onRegister Button from RegisterUser()');
    // print(_image.toString());
    uploadData();
  }

  void _onBackPress() {
    _image = null;
    print('onBackpress from RegisterUser');
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
  }

  void uploadData() {
    print(" The upload button function");
    print(_namecontroller.text);
    print(_emcontroller.text);
    print(_passcontroller.text);
    print(_phcontroller.text);
    print(_jabatancontroller.text);

    _name = _namecontroller.text;
    _email = _emcontroller.text;
    _password = _passcontroller.text;
    _phone = _phcontroller.text;
    _jabatan = _jabatancontroller.text;

    if ((_isEmailValid(_email!)) &&
        (_name != null) &&
        (_password!.length > 5) &&
        (_phone!.length > 5) &&
        (_jabatan != null)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Registration in progress");
      pr.show();
      String base64Image = base64Encode(_image!.readAsBytesSync());
      http.post(Uri.parse(urlUpload), body: {
        "encoded_string": base64Image,
        'email': _email,
        'name': _name,
        'password': _password,
        'phone': _phone,
        'jabatan': _jabatan,
      }).then((res) {
        print(res.statusCode);
        print(res.body);
        if (res.body == "success") {
          print("Test di bawah succes");
          savepref(_email!, _password!);
          _namecontroller.text = '';
          _emcontroller.text = '';
          _phcontroller.text = '';
          _passcontroller.text = '';
          _jabatancontroller.text = '';
          pr.hide();
          Toast.show(
              "Pendaftaran Akun Kamu Telah Berhasil, Silahkan Beritahu Kepada Administrator Untuk Mengaktifkan Akun Anda",
              context,
              duration: 3,
              gravity: Toast.TOP,
              backgroundColor: Colors.red);

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginPage()));
        } else if (res.body == "failed2") {
          Toast.show(
              "Mohon Maaf Ada Masalah Dengan Koneksi Interner Anda", context,
              duration: 3, gravity: Toast.TOP, backgroundColor: Colors.red);
          pr.hide();
        } else if (res.body == "failed1") {
          Toast.show("Email Yang Anda Gunakan Telah Di Gunakan", context,
              duration: 5, gravity: Toast.TOP, backgroundColor: Colors.red);
          pr.hide();
        }
      }).catchError((err) {
        print(err);
      });
    } else {
      Toast.show("Please Check Your Fill first", context,
          duration: 3, gravity: Toast.BOTTOM, backgroundColor: Colors.red);
    }
  }

  bool _isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  void savepref(String email, String pass) async {
    print('Inside savepref');
    _email = _emcontroller.text;
    _password = _passcontroller.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //true save pref
    await prefs.setString('email', email);
    await prefs.setString('pass', pass);
    print('Save pref $_email');
    print('Save pref $_password');
  }
}
