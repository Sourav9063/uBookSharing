import 'package:flutter/material.dart';
import 'package:uBookSharing/BackEnd/Datas.dart';

class BookDetailsPage extends StatefulWidget {
  final BookData bookData;

  const BookDetailsPage({Key key, @required this.bookData}) : super(key: key);
  @override
  _BookDetailsPageState createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: (Text(widget.bookData.bookName)),
      ),
    );
  }
}
