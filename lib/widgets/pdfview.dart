import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';

class ViewPDF extends StatelessWidget {
  final String pathPDF;
  ViewPDF({this.pathPDF});
  @override
  Widget build(BuildContext context) {

    return PDFViewerScaffold(
        //view PDF
appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0), // here the desired height
          child: AppBar(title: Text("PDF"),    flexibleSpace: IconButton(onPressed: (){Navigator.of(context).pop();},icon: Icon(Icons.arrow_back),),
)),
        primary: false,
        path: pathPDF);
  }
}
