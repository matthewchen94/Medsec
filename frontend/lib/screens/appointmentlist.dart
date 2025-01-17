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

class AppointmentList extends StatefulWidget {
  @override
  _AppointmentListState createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {
  List<Appointment> _thirtydaysevents = List<Appointment>();

  @override
  void initState() {
    super.initState();
    getUpcomingAppointments();
  }

  getUpcomingAppointments() async {
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
          'me/appointmentswithinThirtydays';
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
          setState(() {
            for (var doc in jsonResponse) {
              _thirtydaysevents.add(Appointment.fromJson(doc));
            }
          });
        }
      } else {
        print(response.body);
      }
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
            ? Text("No appointment record in upcoming 30 days!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.pink, fontSize: 16))
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
                                ), //Text(DateFormat.Hm().format(event.date)),//DateFormat.Hm().format(now)
                                title: Text(event.title),
                                trailing: event.status == 'UNCONFIRMED'
                                    ? Column(children: <Widget>[
                                        //event.status=='CONFIRMED' ?
                                        Icon(Icons.error,
                                            color: Colors.pink,
                                            //size:25.0,
                                            semanticLabel:
                                                'Unconfirmed Appointment'), //:Container(width:0,height:0),
                                        Icon(Icons.arrow_right),
                                      ])
                                    : Icon(Icons.arrow_right),
                                onTap: () {
                                  setState(() {});
                                  /* Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AppointmentDetail(event)));*/
                                },
                              )
                            : null))
                    .toList()));
  }
}
