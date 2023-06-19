import 'package:flutter/material.dart';

class absen {
  String id, email, jam, date, location;

  absen({
    required this.id,
    required this.email,
    required this.jam,
    required this.date,
    required this.location,
  });
}

class izin {
  String id, email, date, keterangan, verify, approve;

  izin({
    required this.id,
    required this.email,
    required this.date,
    required this.keterangan,
    required this.verify,
    required this.approve,
  });
}

class sakit {
  String id, email, date, keterangan, verify, approve;
  sakit({
    required this.id,
    required this.email,
    required this.date,
    required this.keterangan,
    required this.verify,
    required this.approve,
  });
}

class cuti {
  String id, email, dateawal, dateakhir, keterangan, verify, approve;

  cuti({
    required this.id,
    required this.email,
    required this.dateawal,
    required this.dateakhir,
    required this.keterangan,
    required this.verify,
    required this.approve,
  });
}
