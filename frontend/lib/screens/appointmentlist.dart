import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/util/authentication.dart';
import 'package:frontend/util/serverDetails.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/components/appointment.dart';
import 'package:frontend/screens/appointmentdetail.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:frontend/screens/appointments.dart';
import 'package:frontend/components/doctor.dart';

class AppointmentList extends StatefulWidget {
  @override
  _AppointmentListState createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {
  List<Appointment> _thirtydaysevents = List<Appointment>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getUpcomingAppointments();
  }

  getUpcomingAppointments() async {
    setState(() {
      _isLoading = true;
    });
    String currentToken = await Authentication.getCurrentToken();
    print(currentToken);
    if (currentToken == null) {
      print('bouncing');
      Authentication.bounceUser(context);
    } else {
      String auth = "Bearer " + currentToken;
      String url = ServerDetails.ip +
          ':' +
          ServerDetails.port +
          ServerDetails.api +
          'me/appointments';
      print(url);
      Map<String, String> headers = {"Authorization": auth};
      print(headers);
      var jsonResponse = null;
      var response = await http.get(url, headers: headers);

      print(response.body);
      if (response.statusCode == 200) {
        print("200" + response.body);
        jsonResponse = json.decode(response.body);
        if (jsonResponse != null) {
          for (var doc in jsonResponse) {
            Appointment appointment = Appointment.fromJson(doc);
            String url = ServerDetails.ip +
                ':' +
                ServerDetails.port +
                ServerDetails.api +
                'generalInformation/oneDoctor/' +
                appointment.did;
            print(url);
            Map<String, String> headers = {"Authorization": auth};
            print(headers);
            var jsonResponse = null;
            var response = await http.get(url, headers: headers);
            print(response.body);
            if (response.statusCode == 200) {
              jsonResponse = json.decode(response.body);
              if (jsonResponse != null) {
                Doctor doctor = Doctor.fromJson(jsonResponse);
                appointment.doctor = doctor;
                setState(() {
                  var now = new DateTime.now();
                  if (appointment.date.isAfter(now)) {
                    _thirtydaysevents.add(appointment);
                  }
                });
              }
            } else {}
          }
        }
      } else {
        print(response.body);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  build(context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            leading: new IconButton(
                icon: new Icon(Icons.arrow_back),
                color: Colors.black,
                onPressed: () {
                  setState(() {});
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Appointments()));
                }),
            centerTitle: true,
            title: Text("Upcoming Appointment",
                style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.white,
            brightness: Brightness.light,
//          backgroundColor: Color(0x44000000),
            elevation: 0.5,
          ),
        ),
        body: (_thirtydaysevents.length == 0)
            ? (!_isLoading
                ? Text("No upcoming appointment record currently!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.pink, fontSize: 16))
                : Text("Loading...",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 16)))
            : ListView(
                children: _thirtydaysevents
                    .map((event) => Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.8),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: (event is Appointment)
                            ? ListTile(
                                leading: SizedBox(
                                  width: 90,
                                  child: Column(children: <Widget>[
                                    //Show Weekday, Month and day of Appiontment
                                    Text(
                                        DateFormat('EE').format(event.date) +
                                            '  ' +
                                            DateFormat.MMMd()
                                                .format(event.date),
                                        style: TextStyle(
                                          color: Colors.blue.withOpacity(1.0),
                                          fontWeight: FontWeight.bold,
                                        )),
                                    //Show Start Time of Appointment
                                    Text(DateFormat.jm().format(event.date),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          height: 1.5,
                                        )),
                                    //Show End Time of Appointment
                                    Text(
                                      DateFormat.jm().format(event.date.add(
                                          Duration(
                                              minutes: event.duration ?? 0))),
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.6)),
                                    ),
                                  ]),
                                ),
                                title: Text(event.doctor.name != null
                                    ? event.doctor.name
                                    : event.title),
                                trailing: event.status == 'UNCONFIRMED'
                                    ? Column(children: <Widget>[
                                        Icon(Icons.error,
                                            color: Colors.pink,
                                            semanticLabel:
                                                'Unconfirmed Appointment'), //:Container(width:0,height:0),
                                        Icon(Icons.arrow_right),
                                      ])
                                    : Icon(Icons.arrow_right),
                                onTap: () {
                                  setState(() {});
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AppointmentDetail(event)));
                                },
                              )
                            : null))
                    .toList()));
  }
}
