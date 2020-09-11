import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/doctor.dart';
import 'package:share/share.dart';

class doctordetail extends StatelessWidget{

  final Doctor _doctor;
  final sendmsg;
  const doctordetail(this._doctor, this.sendmsg);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //extendBodyBehindAppBaorder: true,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            leading: BackButton(color: Colors.black),
            centerTitle: true,
            title: Text("Doctors Details", style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.white,
            brightness: Brightness.light,
//            backgroundColor: Colors.transparent,
            elevation: 0.5,
            actions: <Widget>[
              IconButton(
                color: Colors.black,
                icon: Icon(Icons.share), onPressed: () {
              if (sendmsg != null){
                DateTime now = new DateTime.now();
                Share.share(sendmsg, subject: 'Doctors Details send on ' + now.toString());
              }
            })],
          )
      ),
      body:   new Builder(
          builder:(BuildContext context){
            return new ListView(
                children:<Widget>[
                  Container(
                      height: 80.0,
                      child: Center(
                        child: Wrap(
                          spacing: 4.0,
                          runSpacing: 4.0,
                          alignment: WrapAlignment.start,
                          children: <Widget>[
                            Icon(Icons.person,color: Colors.green, size: 45,),
                            Text(_doctor.name,
                              style: TextStyle(fontSize: 25.0, fontFamily: "Arial",color:Colors.black, height: 1.5 ),
                            ),
                          ],
                        ))
                  ),
                  Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: new BoxDecoration(
                      color: Color.fromARGB(255, 196, 218, 234),
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),),
                    child: Table(
                      columnWidths: const {
                        0: FixedColumnWidth(150.0),
                        1: FlexColumnWidth(1.0),
                      },
                      children: [
//                        TableRow(
//                            children: [
//                              Text("ID:",
//                                style: TextStyle(fontSize: 20.0, fontFamily: "Arial", fontWeight: FontWeight.bold),),
//                              Text(_doctor.id,
//                                style: TextStyle(fontSize: 20.0, fontFamily: "Arial", ),
//                              )]
//                        ),
                        _doctor.bio != null ? TableRow(
                            children: [
                              Text("Bio:",
                                style: TextStyle(fontSize: 20.0, fontFamily: "Arial", fontWeight: FontWeight.bold),),
                              Text(_doctor.bio,
                                style: TextStyle(fontSize: 20.0, fontFamily: "Arial", ),
                              )
                            ]
                        ) : TableRow(
                            children: [
                              Text("Bio:",
                                style: TextStyle(fontSize: 20.0, fontFamily: "Arial", fontWeight: FontWeight.bold),),
                              Text("Not available",
                                style: TextStyle(fontSize: 20.0, fontFamily: "Arial", ),
                              )
                            ]
                        ),
                        _doctor.address != null ? TableRow(
                            children: [
                              Text("Address:",
                                style: TextStyle(fontSize: 20.0, fontFamily: "Arial", fontWeight: FontWeight.bold),),
                              Text(_doctor.address,
                                style: TextStyle(fontSize: 20.0, fontFamily: "Arial", ),
                              )
                            ]
                        ) : TableRow(
                            children: [
                              Text("Address:",
                                style: TextStyle(fontSize: 20.0, fontFamily: "Arial", fontWeight: FontWeight.bold),),
                              Text("Not available",
                                style: TextStyle(fontSize: 20.0, fontFamily: "Arial", ),
                              )
                            ]
                        ),
                        _doctor.phone != null ? TableRow(
                            children: [
                              Text("Phone:",
                                style: TextStyle(fontSize: 20.0, fontFamily: "Arial", fontWeight: FontWeight.bold),),
                              Text(_doctor.phone,
                                style: TextStyle(fontSize: 20.0, fontFamily: "Arial", ),
                              )]
                        ) : TableRow(
                            children: [
                              Text("Phone:",
                                style: TextStyle(fontSize: 20.0, fontFamily: "Arial", fontWeight: FontWeight.bold),),
                              Text("Not available",
                                style: TextStyle(fontSize: 20.0, fontFamily: "Arial", ),
                              )]
                        ),
                        _doctor.fax != null ? TableRow(
                            children: [
                              Text("Fax:",
                                style: TextStyle(fontSize: 20.0, fontFamily: "Arial", fontWeight: FontWeight.bold),),
                              Text(_doctor.fax,
                                style: TextStyle(fontSize: 20.0, fontFamily: "Arial", ),
                              )
                            ]
                        ) : TableRow(
                            children: [
                              Text("Fax:",
                                style: TextStyle(fontSize: 20.0, fontFamily: "Arial", fontWeight: FontWeight.bold),),
                              Text("Not available",
                                style: TextStyle(fontSize: 20.0, fontFamily: "Arial", ),
                              )
                            ]
                        ),
                        _doctor.email != null ? TableRow(
                            children: [
                              Text("Email:",
                                style: TextStyle(fontSize: 20.0, fontFamily: "Arial", fontWeight: FontWeight.bold),),
                              Text(_doctor.email,
                                style: TextStyle(fontSize: 20.0, fontFamily: "Arial", ),
                              )
                            ]
                        ) : TableRow(
                            children: [
                              Text("Email:",
                                style: TextStyle(fontSize: 20.0, fontFamily: "Arial", fontWeight: FontWeight.bold),),
                              Text("Not available",
                                style: TextStyle(fontSize: 20.0, fontFamily: "Arial", ),
                              )
                            ]
                        ),
                        _doctor.website != null ? TableRow(
                            children: [
                              Text("Website:",
                                style: TextStyle(fontSize: 20.0, fontFamily: "Arial", fontWeight: FontWeight.bold),),
                              Text(_doctor.website,
                                style: TextStyle(fontSize: 20.0, fontFamily: "Arial", ),
                              )
                            ]
                        ) : TableRow(
                            children: [
                              Text("Website:",
                                style: TextStyle(fontSize: 20.0, fontFamily: "Arial", fontWeight: FontWeight.bold),),
                              Text("Not available",
                                style: TextStyle(fontSize: 20.0, fontFamily: "Arial", ),
                              )
                            ]
                        ),
                        _doctor.expertise != null ? TableRow(
                            children: [
                              Text("Expertise:",
                                style: TextStyle(fontSize: 20.0, fontFamily: "Arial", fontWeight: FontWeight.bold),),
                              Text(_doctor.expertise,
                                style: TextStyle(fontSize: 20.0, fontFamily: "Arial", ),
                              )]
                        ) : TableRow(
                            children: [
                              Text("Expertise:",
                                style: TextStyle(fontSize: 20.0, fontFamily: "Arial", fontWeight: FontWeight.bold),),
                              Text("Not available",
                                style: TextStyle(fontSize: 20.0, fontFamily: "Arial", ),
                              )]
                        ),

                      ],
                    ),
                  )
//                  new Expanded(
//                        child:,
//                  ),
                ]);
          }),
    );
  }
}