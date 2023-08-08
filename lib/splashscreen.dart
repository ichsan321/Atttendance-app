import 'package:flutter/material.dart';
import 'package:my_project/loginscreen.dart';
import 'package:toast/toast.dart';
import 'dart:io';
import 'package:my_project/constant.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: isDark == true ? darkTheme : lightTheme,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'asset/image/vitech asia.png',
                  scale: 3,
                ),
                SizedBox(
                  height: 20,
                ),
                new ProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProgressIndicator extends StatefulWidget {
  @override
  _ProgressIndicatorState createState() => new _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          if (animation.value > 0.99) {
            //print('Sucess Login');
            // loadpref(this.context);

            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          }
        });
      });
    controller.repeat();
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Container(
      child: CircularProgressIndicator(),
    ));
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// void loadpref(BuildContext ctx) async {
//   print('Inside loadpref()');
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   _email = (prefs.getString('email')??'');
//   _password = (prefs.getString('pass')??'');
//   print("Splash:Preference");
//   print(_email);
//   print(_password);
//   if (_isEmailValid(_email??"no email")) {
//     //try to login if got email;
//     _onLogin(_email, _password, ctx);
//   } else {
//     //login as unregistered user
//     User user = new User(
//         name: "not register",
//         email: "user@noregister",
//         phone: "not register",
//         radius: "15",
//         credit: "0",
//         rating: "0");
//     Navigator.push(
//         ctx, MaterialPageRoute(builder: (context) => MainScreen(user: user)));
//   }
// }

bool _isEmailValid(String email) {
  return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
}

// void _onLogin(String email, String pass, BuildContext ctx) {
//   http.post(urlLogin, body: {
//     "email": _email,
//     "password": _password,
//   }).then((res) {
//     print(res.statusCode);
//     var string = res.body;
//     List dres = string.split(",");
//     print("SPLASH:loading");
//     print(dres);
//     if (dres[0] == "success") {
//       User user = new User(
//           name: dres[1],
//           email: dres[2],
//           phone: dres[3],
//           radius: dres[4],
//           credit: dres[5],
//           rating: dres[6]);
//       Navigator.push(
//           ctx, MaterialPageRoute(builder: (context) => MainScreen(user: user)));
//     } else {
//       //allow login as unregistered user
//       User user = new User(
//           name: "not register",
//           email: "user@noregister",
//           phone: "not register",
//           radius: "15",
//           credit: "0",
//           rating: "0");
//       Navigator.push(
//           ctx, MaterialPageRoute(builder: (context) => MainScreen(user: user)));
//     }
//   }).catchError((err) {
//     print(err);
//   });
// }


