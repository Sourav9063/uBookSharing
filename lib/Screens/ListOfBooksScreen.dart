import 'package:flutter/material.dart';

class ListOfBooksScreen extends StatefulWidget {
  ListOfBooksScreen({Key key}) : super(key: key);

  @override
  _ListOfBooksScreenState createState() => _ListOfBooksScreenState();
}

class _ListOfBooksScreenState extends State<ListOfBooksScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Text('Books'),
    );
  }
}