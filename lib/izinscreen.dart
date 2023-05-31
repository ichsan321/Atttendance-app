import 'package:flutter/material.dart';
import 'package:my_project/user.dart';

class izinscreen extends StatefulWidget {
  const izinscreen({super.key, required User user});

  @override
  State<izinscreen> createState() => _izinscreenState();
}

class _izinscreenState extends State<izinscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Izin Page Detail'),
      ),
      body: Center(
        child: ListView.builder(
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 4,
                child: InkWell(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          " Date Applied : Wednesday 1/5/2023",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(" Keterangan : Acara Pernikahan Saudara"),
                        Text(" Date approve : Saturday 12/4/2023"),
                        Text(" Approve By : Mr By U"),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _izinbutton,
      //   tooltip: "izinbutton",
      //   child: Icon(Icons.add),
      // ),
    );
  }

  void _izinbutton() {
    setState(() {
      print(" This is izin button ");
    });
  }
}
