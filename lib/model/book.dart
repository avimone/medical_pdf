import 'dart:io';

import 'package:flutter/cupertino.dart';

class Book extends ChangeNotifier {
  final String name;
  final String id;
  final String link;
  final String imageUrl;
  bool downloading = false;
  bool downloaded = false;
  String pdfpath;
  var isStart = true;
  Book(
      {@required this.name,
      @required this.id,
      @required this.link,
      @required this.imageUrl});
}
