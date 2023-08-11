import 'package:flutter/material.dart';

class aboutuserapp extends StatefulWidget {
  const aboutuserapp({super.key});

  @override
  State<aboutuserapp> createState() => _aboutuserappState();
}

class _aboutuserappState extends State<aboutuserapp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("About App"),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: [
              Image.asset(
                'asset/image/vitech asia.png',
                scale: 15,
              ),
              Text(
                "Version",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text("1.0.0"),
              SizedBox(
                height: 10,
              ),
              Row(children: [
                Text(
                  "Vitech",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 5,
                ),
                Text("All Rights Reserved.")
              ]),
              Text(
                  "Any problem with your account Attendance or for any further information. please contact Administrator 085263633308."),
              SizedBox(
                height: 20,
              ),
              Text("Copyright (c) 2023"),
              SizedBox(
                height: 30,
              ),
              Text(
                "Terms of service",
                style: TextStyle(decoration: TextDecoration.underline),
              )
            ],
          ),
        ),
      ),
    );
  }
}
