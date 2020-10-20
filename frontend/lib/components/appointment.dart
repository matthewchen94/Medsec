import 'dart:convert';

import 'package:flutter/foundation.dart';

List<Appointment> appointmentFromJson(String str) => List<Appointment>.from(
    json.decode(str).map((x) => Appointment.fromJson(x)));

String appointmentToJson(List<Appointment> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Appointment {
  final String id;
  final String pid;
  final String title;
  final String detail;
  final DateTime date;
  final int duration;
  final String note;
  final String userNote;
  final String status;
   final String  did;
  

  var doctor;

  Appointment(
      {this.id,
      this.pid,
      this.title,
      this.detail,
      this.date,
      this.duration,
      this.note,
      this.userNote,
      this.status,
      this.did});

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
        id: json['id'],
        pid: json['uid'],
        title: json['title'],
        detail: json['detail'],
        date: DateTime.parse(json['date']),
        duration: json['duration'] as int,
        note: json['note'],
        userNote: json['user_note'],
        status: json['status'],
         did: json['did']
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "uid": pid,
        "title": title,
        "detail": detail,
        "date": date.toIso8601String(),
        "duration": duration,
        "note": note,
        "user_note": userNote,
        "status": status,
       "did": did,
      };
}

