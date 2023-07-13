import 'package:flutter/material.dart';
import 'package:my_project/Absenscreen.dart';
import 'package:my_project/cutiscreen.dart';
import 'package:my_project/izinscreen.dart';
import 'package:my_project/sakitscreen.dart';
import 'package:my_project/profilescreen.dart';
import 'package:badges/badges.dart';
import 'package:my_project/user.dart';

class Maincsreen extends StatefulWidget {
  final User user;
  const Maincsreen({Key? key, required this.user}) : super(key: key);

  // This widget is the root of your application.
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Maincsreen> {
  @override
  late List<Widget> tabs;
  int _selectedIndex = 0;
  void initState() {
    super.initState();
    tabs = [
      profilescreen(user: widget.user),
      izinscreen(user: widget.user),
      cutiscreen(user: widget.user),
      sakitscreen(user: widget.user),
      Absenscreen(user: widget.user),
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
            icon: Icon(
              Icons.book,
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
          BottomNavigationBarItem(
            icon: Icon(
              Icons.login,
            ),
            label: 'Absen',
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
