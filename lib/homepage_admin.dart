import 'package:flutter/material.dart';
import 'package:my_project/admin.dart';

class homepage_admin extends StatefulWidget {
  final Admin admin;
  const homepage_admin({super.key, required this.admin});

  @override
  State<homepage_admin> createState() => _homepage_adminState();
}

class _homepage_adminState extends State<homepage_admin> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Column(children: [
        Text("Ichsan Septriansyah "),
        Text(" Mobile Programming")
      ])),
    );
  }
}
