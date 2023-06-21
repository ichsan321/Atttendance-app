import 'package:flutter/material.dart';
import 'package:my_project/admin.dart';
import 'package:my_project/absen.dart';

class izin_admin extends StatefulWidget {
  final Izin izin;
  final Admin admin;
  const izin_admin({super.key, required this.izin, required this.admin});

  @override
  State<izin_admin> createState() => _izin_adminState();
}

class _izin_adminState extends State<izin_admin> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
