import 'package:flutter/material.dart';
import 'package:my_project/Absenscreen.dart';
import 'package:my_project/admin.dart';
import 'package:my_project/sakit_admin.dart';
import 'package:my_project/cuti_admin.dart';
import 'package:my_project/izin_admin.dart';
import 'package:my_project/homepage_admin.dart';
import 'package:my_project/profilescreen.dart';
import 'package:badges/badges.dart';
import 'package:my_project/user.dart';
import 'package:my_project/absen_admin.dart';
import 'package:my_project/absen.dart';

class Mainadmincsreen extends StatefulWidget {
  final Admin admin;
  const Mainadmincsreen({Key? key, required this.admin}) : super(key: key);

  // This widget is the root of your application.
  @override
  _MyHomePageAdminState createState() => _MyHomePageAdminState();
}

class _MyHomePageAdminState extends State<Mainadmincsreen> {
  @override
  late List<Widget> tabs;
  int _selectedIndex = 0;
  void initState() {
    super.initState();
    tabs = [
      homepage_admin(admin: widget.admin),
      izin_admin(admin: widget.admin),
      cuti_admin(admin: widget.admin),
      sakit_admin(admin: widget.admin),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print("index select dari tab bar" + _selectedIndex.toString());
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey[500],
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home Page',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              position: BadgePosition.topEnd(),
              child: Icon(Icons.book),
              // badgeContent: Text(
              //   "1",
              //   style: TextStyle(color: Colors.white),
              // )
            ),
            label: 'Izin',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.card_travel,
            ),
            label: 'Cuti',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.sick,
            ),
            label: 'Sakit',
            backgroundColor: Colors.blue,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
