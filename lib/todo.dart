import 'package:flutter/material.dart';

class Todo{
  int id;
  String judul;
  int udah;
  int warna;
  DateTime date;
  String waktu;
  String desk;

  Todo({this.judul, this.udah, this.warna, this.date, this.waktu, this.desk});
  Todo.withId({this.id, this.judul, this.udah, this.warna, this.date, this.waktu, this.desk});

  Map<String, dynamic> toMap(){
    final map = Map<String, dynamic>();
    if (id != null){
      map['id'] = id;
    }
    map['judul'] = judul;
    map['udah'] = udah;
    map['warna'] = warna;
    map['date'] = date.toIso8601String();
    map['waktu'] = waktu;
    map['desk'] = desk;
    return map;
  }

  factory Todo.fromMap(Map<String, dynamic> map){
    return Todo.withId(
      id: map['id'],
      judul: map['judul'],
      udah: map['udah'],
      warna: map['warna'],
      date: DateTime.parse(map['date']),
      waktu: map['waktu'],
      desk: map['desk'],
    );
  }

  Color getColor(){
    print('getcolor');
    switch (warna){
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.green;
        break;
      case 3:
        return Colors.blue;
        break;
      default:
        return Colors.black;
    }
  }
}