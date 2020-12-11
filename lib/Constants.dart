import 'package:flutter/material.dart';

const kColorThemeAccent = Color(0xfffb8b24);
const kColorNavyBlue = Color(0xff001a54);
const kColorPink = Color(0xfff01a54);

const kDefaultWhiteTextStyle = TextStyle(color: Colors.white);

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
    borderRadius: BorderRadius.all(Radius.circular(18)),
    borderSide: BorderSide(width: 0.0),
  ),

  contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
  // border: OutlineInputBorder(
  //   borderRadius: BorderRadius.all(Radius.circular(5.0)),
  // ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 3.0),
    borderRadius: BorderRadius.all(Radius.circular(18)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xff7b2cbf), width: 4.0),
    borderRadius: BorderRadius.all(Radius.circular(50.0)),
  ),
);

const kBookFormFieldDec = InputDecoration(
  filled: true,
  fillColor: Color(0xffffffff),
  labelText: '',
  hintText: '',
  border: OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xff001a54),
      ),
      borderRadius: BorderRadius.all(Radius.circular(14))),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      width: 2,
      color: Color(0xff6F00FF),
    ),
    borderRadius: BorderRadius.all(Radius.circular(14)),
  ),
);
