import 'package:flutter/material.dart';
import 'package:expansion_card/expansion_card.dart';
import 'package:medical_pdf/model/book.dart';

class Demo extends StatefulWidget {
  final Book books;
  Demo(this.books);

  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
          child: Card(
            margin: EdgeInsets.only(top: 50),
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              width: 300,
              height: 300,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.books.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Averta-☞',
                      color: Color(0xff679f3d),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(widget.books.id,
                      style: TextStyle(
                        fontSize: 23,
                        fontFamily: 'Averta-☞',
                        color: Color(0xff679f3d),
                      )),
                  const SizedBox(height: 1),
                  Text(
                    widget.books.link,
                    style: TextStyle(
                      fontSize: 50,
                      fontFamily: 'Averta-☞',
                      color: Color(0xff679f3d),
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
          onTap: () {}),
    );
  }
}
