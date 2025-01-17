import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:frontend/util/authentication.dart';
import 'package:frontend/util/serverDetails.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/components/appointment.dart';
import 'package:frontend/screens/appointmentdetail.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:frontend/main.dart';
import 'package:frontend/screens/appointmentlist.dart';

class Appointments extends StatefulWidget {
  @override
  _AppointmentsState createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments>
    with TickerProviderStateMixin {
  var _calendarController;
  Map<DateTime, List> _events;
  List<Appointment> _samemonthevents = List<Appointment>();
  AnimationController _animationController;
  DateTime current = DateTime.now();

  @override
  void initState() {
    super.initState();
    _events = Map<DateTime, List>();
    _calendarController = CalendarController();
    getAppointments();
    getSameMonthAppointments();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  getAppointments() async {
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
          setState(() {
            for (var doc in jsonResponse) {
              Appointment temp = Appointment.fromJson(doc);
              print("TEMP" + temp.date.toString());
              //print("TEMP" + temp.duration.toString());
              if (_events[temp.date] == null) {
                print("deb1" + temp.date.toString());
                _events[temp.date] = List()..add(temp);
              } else {
                //_events[temp.date] = List()..add(temp);
                _events[temp.date].add(temp);
              }
            }
          });
        }
      } else {
        print(response.body);
      }
    }
  }

  getSameMonthAppointments() async {
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
        _samemonthevents = appointmentFromJson(response.body);
      }
    }
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    setState(() {
      current = first;
    });
    print('CALLBACK: _onVisibleDaysChanged first ${first.toIso8601String()}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                color: Colors.black,
                onPressed: () {
                  setState(() {});
                  /* Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MainPage()));*/
                }),
            centerTitle: true,
            title: Text("Appointment", style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            automaticallyImplyLeading: false,
//          backgroundColor: Color(0x44000000),
            elevation: 0.5,
            actions: <Widget>[
              SizedBox(
                  width: 50, // specific value
                  child: FlatButton(
                    padding: const EdgeInsets.all(5.0),
                    onPressed: () {
                      setState(() {});
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AppointmentList()));
                    },
                    child: Ink.image(
                      image: AssetImage('assets/images/list.png'),
                    ),
                    color: Colors.white,
                  ))
            ],
          ),
        ),
        body: Builder(builder: (BuildContext context) {
          return Column(children: <Widget>[
            _buildTableCalendarWithBuilders(),
            const SizedBox(height: 8.0),
            const SizedBox(height: 8.0),
            //_buildEventList()
            //_buildsameMonthEventList()
            Expanded(child: _buildsameMonthEventList()),
          ]);
        }));
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      calendarController: _calendarController,
      events: _events,
      //holidays: _holidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {CalendarFormat.month: ''},
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
        holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.blue[300],
                  borderRadius: BorderRadius.circular(36.0),
                  border: Border.all(width: 2, color: Colors.blue[300])),
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(36.0),
                border: Border.all(width: 2, color: Colors.white)),
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          if (holidays.isNotEmpty) {
            children.add(
              Positioned(
                right: -2,
                top: -2,
                child: _buildHolidaysMarker(),
              ),
            );
          }

          return children;
        },
      ),
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.all(4.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(36.0),
          border: Border.all(width: 2, color: Colors.blue[300])),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  Widget _buildsameMonthEventList() {
    var _samemontheventsFilter = _samemonthevents.where((element) =>
        element.date.year == current.year &&
        element.date.month == current.month);

    return Scaffold(
        body: (_samemontheventsFilter.length == 0)
            ? Text("No appointment record in current month!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.pink, fontSize: 16))
            : ListView(
                children: _samemontheventsFilter
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
