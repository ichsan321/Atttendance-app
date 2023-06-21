import 'package:flutter/material.dart';

class Absen {
  String id, email, jam, date, location;

  Absen({
    required this.id,
    required this.email,
    required this.jam,
    required this.date,
    required this.location,
  });
}

class Izin {
  String id, email, date, keterangan, verify, approve;

  Izin({
    required this.id,
    required this.email,
    required this.date,
    required this.keterangan,
    required this.verify,
    required this.approve,
  });
}

class Sakit {
  String id, email, date, keterangan, verify, approve;
  Sakit({
    required this.id,
    required this.email,
    required this.date,
    required this.keterangan,
    required this.verify,
    required this.approve,
  });
}

class Cuti {
  String id, email, dateawal, dateakhir, keterangan, verify, approve;

  Cuti({
    required this.id,
    required this.email,
    required this.dateawal,
    required this.dateakhir,
    required this.keterangan,
    required this.verify,
    required this.approve,
  });
}
