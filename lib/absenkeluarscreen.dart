import 'package:flutter/material.dart';
import 'package:my_project/mainscreen.dart';

class absenKeluar extends StatefulWidget {
  const absenKeluar({super.key});

  @override
  State<absenKeluar> createState() => _absenKeluarState();
}

class _absenKeluarState extends State<absenKeluar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Absen Keluar"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Container(
          width: 300,
          height: 200,
          child: Card(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(" Location : Wisma Bsg"),
                  Text(" Jam : 17:30"),
                  ElevatedButton(
                      onPressed: _onabsenKeluar, child: Text(" Keluar "))
                ]),
          ),
        ),
      ),
    );
  }

  void _onabsenKeluar() async {
    print("this is absen keluar");
  }
}
