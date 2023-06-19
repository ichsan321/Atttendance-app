import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_project/loginscreen.dart';
import 'package:my_project/mainscreen.dart';
import 'package:my_project/registrationscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:my_project/mainscreen_admin.dart';
import 'package:my_project/admin.dart';

// String urlSecurityCodeForResetPass ="http://michannael.com/mytolongbeli/php/secure_code.php";
String urlLogin =
    "https://myattendance-test.000webhostapp.com/php/login_admin.php";

final TextEditingController _emcontroller = TextEditingController();
String _email = "";
final TextEditingController _passcontroller = TextEditingController();
String _password = "";
bool _isChecked = false;

class Myadmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyadminPage(),
    );
  }
}

class MyadminPage extends StatefulWidget {
  @override
  _MyadminPageState createState() => _MyadminPageState();
}

class _MyadminPageState extends State<MyadminPage> {
  @override
  void initState() {
    //  loadpref();
    print('Init: $_email');
    super.initState();
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
                  obscureText: true,
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
                          child: Text("LOGIN ADMIN",
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
                        "Log in as user".toUpperCase(),
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: _onUserLogin,
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
    //   print('login');
    //   // Navigator.push(
    //   //   context,
    //   //   MaterialPageRoute(builder: (context) => Maincsreen()),
    //   // );
    //   if (_isEmailValid(_email) && (_password.length > 4)) {
    //     ProgressDialog pr = new ProgressDialog(context,
    //         type: ProgressDialogType.Normal, isDismissible: false);
    //     pr.style(message: "Login in");
    //     pr.show();
    //     http.post(Uri.parse(urlLogin), body: {
    //       "email": _email,
    //       "password": _password,
    //     }).then((res) {
    //       print(res.statusCode);
    //       var string = res.body;
    //       List dres = string.split(",");
    //       print(dres);
    //       Toast.show(dres[0], context,
    //           duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    //       if (dres[0] == "success") {
    //         pr.hide();
    //         // print("Radius:");
    //         print(dres);
    //         Admin admin = new Admin(
    //             name: dres[1], email: dres[2], phone: dres[3], jabatan: dres[4]);
    //         Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //                 builder: (context) => Mainadmincsreen(admin: admin)));
    //       } else {
    //         pr.hide();
    //       }
    //     }).catchError((err) {
    //       pr.hide();
    //       print(err);
    //     });
    //   } else {}
    //
    //  var string = res.body;
    //   List dres = string.split(",");
    //    Admin admin = new Admin(
    //             email: dres[1], name: dres[2], phone: dres[3], jabatan: dres[4]);
    var admin;
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Mainadmincsreen(admin: admin)));
  }

  void _onRegister() {
    print('onRegister');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterScreen()));
  }

  void _onUserLogin() {
    print('Forgot');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));

    // if (_isEmailValid(_email)) {
    //   ProgressDialog pr = new ProgressDialog(context,
    //       type: ProgressDialogType.Normal, isDismissible: false);
    //   pr.style(message: "Sending Email");
    //   pr.show();
    //   http.post(urlSecurityCodeForResetPass, body: {
    //     "email": _email,
    //     "password": _password,
    //   }).then((res) {
    //     print("secure code : " + res.body);
    //     if (res.body == "error") {
    //       pr.dismiss();

    //       Toast.show('error', context,
    //           duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    //     } else {
    //       pr.dismiss();

    //       _saveEmailForPassReset(_email);
    //       _saveSecureCode(res.body);

    //       Toast.show('Security code sent to your email', context,
    //           duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

    //       Navigator.push(context,
    //           MaterialPageRoute(builder: (context) => ResetPassword()));
    //     }
    //   }).catchError((err) {
    //     pr.dismiss();
    //     print(err);
    //   });
    // } else {
    //   Toast.show('Please put the email first', context,
    //       duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    // }
  }
//   void _saveEmailForPassReset(String code) async {
//     print('saving preferences');
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('resetPassEmail', code);
//   }

//   void _saveSecureCode(String code) async {
//     print('saving preferences');
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('secureCode', code);
//   }

//   void _onChange(bool value) {
//     setState(() {
//       _isChecked = value;
//       savepref(value);
//     });
//   }

//   void loadpref() async {
//     print('Inside loadpref()');
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     _email = (prefs.getString('email'));
//     _password = (prefs.getString('pass'));
//     print(_email);
//     print(_password);
//     if (_email.length > 1) {
//       _emcontroller.text = _email;
//       _passcontroller.text = _password;
//       setState(() {
//         _isChecked = true;
//       });
//     } else {
//       print('No pref');
//       setState(() {
//         _isChecked = false;
//       });
//     }
//   }

//   void savepref(bool value) async {
//     print('Inside savepref');
//     _email = _emcontroller.text;
//     _password = _passcontroller.text;
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     if (value) {
//       //true save pref
//       if (_isEmailValid(_email) && (_password.length > 5)) {
//         await prefs.setString('email', _email);
//         await prefs.setString('pass', _password);
//         print('Save pref $_email');
//         print('Save pref $_password');
//         Toast.show("Preferences have been saved", context,
//             duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
//       } else {
//         print('No email');
//         setState(() {
//           _isChecked = false;
//         });
//         Toast.show("Check your credentials", context,
//             duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
//       }
//     } else {
//       await prefs.setString('email', '');
//       await prefs.setString('pass', '');
//       setState(() {
//         _emcontroller.text = '';
//         _passcontroller.text = '';
//         _isChecked = false;
//       });
//       print('Remove pref');
//       Toast.show("Preferences have been removed", context,
//           duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
//     }
//   }

  Future<bool> _onBackPressAppBar() async {
    SystemNavigator.pop();
    print('Backpress');
    return Future.value(false);
  }

  bool _isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }
}
