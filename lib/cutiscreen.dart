import 'package:flutter/material.dart';
import 'package:my_project/user.dart';

class cutiscreen extends StatefulWidget {
  const cutiscreen({super.key, required User user});

  @override
  State<cutiscreen> createState() => _cutiscreenState();
}

class _cutiscreenState extends State<cutiscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar:
          AppBar(backgroundColor: Colors.blue, title: Text('Cuti Page Detail')),
      body: Center(
          child: ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 4,
            child: InkWell(
                child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    "Dari : 20/3/2023",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Sampai : 27/3/23",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("Approve by : Mr By U"),
                ],
              ),
            )),
          );
        },
      )),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _cutiButton,
      //   tooltip: " absenbutton",
      //   child: const Icon(Icons.add),
      // ),
    );
  }

  void _cutiButton() {
    setState(() {
      print(" This is absen button ");
    });
  }
}
