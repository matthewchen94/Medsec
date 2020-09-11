import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';

class appointmentfile extends StatelessWidget{

  String pathPDF = "";
  appointmentfile(this.pathPDF);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            leading: BackButton(color: Colors.black),
            centerTitle: true,
            title: Text(pathPDF.substring(pathPDF.lastIndexOf("/") + 1, pathPDF.lastIndexOf(".")), style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.white,
            brightness: Brightness.light,
//            backgroundColor: Colors.transparent,
            elevation: 4,
            actions: <Widget>[
              IconButton(
                  color: Colors.black,
                  icon: Icon(Icons.print), onPressed: () {
              })],
          )
      ),
        path: pathPDF
    );
  }
}