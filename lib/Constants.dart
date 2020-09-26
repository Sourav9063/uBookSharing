import 'package:flutter/material.dart';

// import 'package:google_fonts/google_fonts.dart';

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

// const kMessageTextFieldDecoration = InputDecoration(

//   contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//   hintText: 'Type your message here...',
//   filled: true,
//   fillColor: Colors.white,
//   border:
//       OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
//   // focusedBorder: OutlineInputBorder(
//   //   borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 4.0),
//   //   borderRadius: BorderRadius.all(
//   //     Radius.circular(50.0),
//   //   ),
//   // ),
// );

// const kButtonTextStyle = GoogleFonts.aBeeZee(fontSize: 18, color: Colors.white);

const kMessageContainerDecoration = BoxDecoration(
    color: Color(0xfff85068),
    borderRadius: BorderRadius.all(Radius.circular(30)));
const kTextFieldDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white70,

  errorStyle: TextStyle(fontWeight: FontWeight.bold),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(30)),
    borderSide: BorderSide(width: 4.0, color: Colors.red),
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(30)),
    borderSide: BorderSide(width: 4.0),
  ),

  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  // border: OutlineInputBorder(
  //   borderRadius: BorderRadius.all(Radius.circular(5.0)),
  // ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 4.0),
    borderRadius: BorderRadius.all(Radius.circular(50)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 5.0),
    borderRadius: BorderRadius.all(Radius.circular(50.0)),
  ),
);
