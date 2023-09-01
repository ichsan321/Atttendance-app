import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_project/login_admin.dart';
import 'package:my_project/mainscreen.dart';
import 'package:my_project/registrationscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'user.dart';
import 'package:my_project/login_admin.dart';

String urlLogin = "https://myattendance-test.000webhostapp.com/php/login.php";

final TextEditingController _emcontroller = TextEditingController();
String _email = "";
final TextEditingController _passcontroller = TextEditingController();
String _password = "";
bool _isChecked = false;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool passwordVisible = false;
  @override
  void initState() {
    //  loadpref();
    print('Init: $_email');
    super.initState();
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.black));
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: new Container(
          child: new Container(
            // decoration: new BoxDecoration(
            //     image: new DecorationImage(
            //         image: AssetImage('asset/image/vitech asia.jpg'),
            //         fit: BoxFit.fill)),
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'asset/image/vitech asia.png',
                  scale: 3,
                ),
                SizedBox(
                  height: 10,
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
                  controller: _passcontroller,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(16.0),
                    suffixIcon: IconButton(
                      color: Colors.black,
                      icon: Icon(passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
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
                        onTap: (_onLogin),
                        child: Center(
                          child: Text("LOGIN USER",
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
                SizedBox(
                  height: 10,
                ),
                // Row(
                //   children: <Widget>[
                //     Checkbox(
                //       value: _isChecked,
                //       onChanged: (bool value) {
                //         _onChange(value);
                //       },
                //     ),
                //     Text('Remember Me', style: TextStyle(fontSize: 16))
                //   ],
                // ),

                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.indigo, // Background color
                      ),
                      child: Text(
                        "Create Account".toUpperCase(),
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: _onRegister,
                    ),
                    Container(
                      child: (Text(
                        " | ",
                        // style: TextStyle(fontWeight: FontWeight.w700),
                      )),
                      height: 20.0,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.indigo, // Background color
                      ),
                      child: Text(
                        " Log in for admin".toUpperCase(),
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: _onForgot,
                    ),
                  ],
                ),
                SizedBox(height: 0.4),
              ],
            ),
          ),
        ));
  }

  void _onLogin() {
    _email = _emcontroller.text;
    _password = _passcontroller.text;
    print('login');
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => Maincsreen()),
    // );
    if (_isEmailValid(_email) && (_password.length > 4)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Login in");
      pr.show();
      http.post(Uri.parse(urlLogin), body: {
        "email": _email,
        "password": _password,
      }).then((res) {
        print(res.statusCode);
        var string = res.body;
        List dres = string.split(",");
        print(dres);
        Toast.show(dres[0], context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        if (dres[0] == "success") {
          pr.hide();
          // print("Radius:");
          print(dres);
          User user = new User(
              name: dres[1],
              email: dres[2],
              password: dres[3],
              phone: dres[4],
              jabatan: dres[5],
              totalsakit: dres[6],
              totalcuti: dres[7],
              totalizin: dres[8],
              sisa: dres[9]);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Maincsreen(user: user)));
        } else if (dres[0] == "failed1") {
          Toast.show(
              "Mohon Maaf Password Yang Anda Masukkan Itu Salah", context,
              duration: 6, gravity: Toast.TOP, backgroundColor: Colors.red);
          pr.hide();
        } else if (dres[0] == "failed2") {
          Toast.show("Tolong Verifikasi Email Anda Dahulu Kepada Administrator",
              context,
              duration: 6, gravity: Toast.TOP, backgroundColor: Colors.red);
          pr.hide();
        }
      }).catchError((err) {
        pr.hide();
        print(err);
      });
    } else {}
  }

  void _onRegister() {
    print('onRegister');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterScreen()));
  }

  void _onForgot() {
    print('Forgot');
    Navigator.push(context, MaterialPageRoute(builder: (context) => Myadmin()));
  }
}

Future<bool> _onBackPressAppBar() async {
  SystemNavigator.pop();
  print('Backpress');
  return Future.value(false);
}

bool _isEmailValid(String email) {
  return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
}
