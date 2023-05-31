import 'package:flutter/material.dart';
import 'package:my_project/user.dart';

class sakitscreen extends StatefulWidget {
  const sakitscreen({super.key, required User user});

  @override
  State<sakitscreen> createState() => _sakitscreenState();
}

class _sakitscreenState extends State<sakitscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Sakit Page Detail"),
      ),
      body: Center(
          child: ListView.builder(
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 4,
                  child: InkWell(
                      child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          "Date : Wednesday 1/5/2023",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text("Keterangan : Demam"),
                      ],
                    ),
                  )),
                );
              })),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _sakitButton,
      //   tooltip: " absenbutton",
      //   child: const Icon(Icons.add),
      // ),
    );
  }

  void _sakitButton() {
    setState(() {
      print(" This is absen button ");
    });
  }
}
