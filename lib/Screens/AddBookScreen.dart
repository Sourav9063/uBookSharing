import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:uBookSharing/BackEnd/Datas.dart';

class AddBookScreen extends StatefulWidget {
  AddBookScreen({Key key}) : super(key: key);

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            bottom: 20,
            right: 20,
            height: CommonThings.size.width * .25,
            width: CommonThings.size.width * .25,
            child:
                Lottie.asset('assets/lottie/AddLottie.json', fit: BoxFit.cover),
          ),
        ],
      ),
    );
  }
}
