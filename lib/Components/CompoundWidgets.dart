import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:uBookSharing/BackEnd/Datas.dart';

class IconAccount extends StatelessWidget {
  const IconAccount({
    @required this.radious,
    Key key,
    this.imglink,
  }) : super(key: key);
  final double radious;
  final String imglink;
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.lightBlue,
      // color: Colors.blue.shade200,
      // color: Colors.white,

      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1000),
          gradient: RadialGradient(colors: [
            // Colors.pinkAccent.shade100,
            // Colors.pinkAccent.shade100,
            Colors.pinkAccent.shade400,
            Colors.indigoAccent.shade100
          ])),
      height: radious,
      width: radious,
      child: imglink == null
          ? Icon(
              Icons.account_circle,
              size: radious,
              color: Colors.white,
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipOval(
                child: Image.network(
                  imglink,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 7,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes
                            : null,
                      ),
                    );
                  },
                  fit: BoxFit.cover,
                  height: radious - 8,
                  width: radious - 8,
                ),
              ),
            ),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var kDrawerTextStyle = TextStyle(color: Colors.tealAccent, fontSize: 18);
    return Drawer(
      child: Container(
        height: CommonThings.size.height,
        width: CommonThings.size.width * .80,
        color: Color(0xff000247),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    IconAccount(
                      radious: CommonThings.size.width * .35,
                      imglink:
                          FirebaseAuth.instance.currentUser.photoURL == null
                              ? null
                              : FirebaseAuth.instance.currentUser.photoURL,
                    ),
                    Text(
                      UserProfileData.name,
                      style: kDrawerTextStyle,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AnimetedGredian extends StatefulWidget {
  AnimetedGredian({Key key, this.child, this.listColor, this.function})
      : super(key: key);
  final Widget child;
  final List<Color> listColor;
  final Function function;

  @override
  _AnimetedGredianState createState() => _AnimetedGredianState();
}

class _AnimetedGredianState extends State<AnimetedGredian> {
  int rand = 1;
  Alignment alb = Alignment.bottomLeft;
  Alignment ale = Alignment.topRight;
  void gredianAlign() {
    rand = Random().nextInt(5) + 1;

    setState(() {
      if (rand == 1) {
        alb = Alignment.bottomLeft;
        ale = Alignment.topRight;
      }

      if (rand == 2) {
        ale = Alignment.bottomLeft;
        alb = Alignment.topRight;
      }

      if (rand == 3) {
        alb = Alignment.bottomRight;
        ale = Alignment.topLeft;
      }
      if (rand == 4) {
        ale = Alignment.bottomRight;
        alb = Alignment.topLeft;
      }
      if (rand == 5) {
        ale = Alignment.centerLeft;
      }
      if (rand == 6) {
        alb = Alignment.centerRight;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 700),
      curve: Curves.fastOutSlowIn,
      height: CommonThings.size.height,
      width: CommonThings.size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.listColor == null
              ? [
                  Color(0xff000000),
                  Color(0xff14213D),
                  rand % 2 == 1 ? Colors.indigo : Colors.red,

                  Color(0xffFCA311),

                  // Colors.white
                ]
              : widget.listColor,
          begin: alb,
          end: ale,
        ),
      ),
      child: widget.child,
      onEnd: widget.function,
    );
  }
}

class AlertsCompound extends StatelessWidget {
  final Color color;
  final String msg;
  final String des;
  final String buttonTxt;
  final Function function;
  const AlertsCompound(
      {Key key,
      @required this.msg,
      @required this.des,
      this.function,
      @required this.buttonTxt,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: color,
      title: Text(msg),
      content: Text(des),
      actions: <Widget>[
        FlatButton(
          child: Text(buttonTxt),
          onPressed: function,
        )
      ],
    );
  }
}

class SpinkitFading extends StatelessWidget {
  final String msg;
  const SpinkitFading({Key key, this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(38.0),
          child: SpinKitFadingCube(
            size: 80,
            itemBuilder: (BuildContext context, int index) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: index % 3 == 0 ? Colors.red : Color(0xffffb8b24),
                ),
              );
            },
          ),
        ),
        Text(
          msg == null ? 'Loading...' : msg,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        )
      ],
    );
  }
}

class Bookloading extends StatelessWidget {
  const Bookloading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(38.0),
        child: FlareActor(
          'assets/flr/BookLoading.flr',
          fit: BoxFit.contain,
          animation: 'Loading',
        ),
      ),
    );
  }
}

class ErrorState extends StatelessWidget {
  final String msg;
  const ErrorState({Key key, this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CommonThings.size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: CommonThings.size.height,
        width: CommonThings.size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            colors: [Color(0xffffb8b24), Colors.red],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              msg == null ? 'Loading...' : msg,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

class IconAccountOld extends StatelessWidget {
  const IconAccountOld({
    @required this.radious,
    Key key,
  }) : super(key: key);
  final double radious;
  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        // color: Colors.lightBlue,
        // color: Colors.blue.shade200,
        // color: Colors.white,
        decoration: BoxDecoration(
            gradient: RadialGradient(colors: [
          // Colors.pinkAccent.shade100,
          Colors.pinkAccent.shade400,
          Colors.indigoAccent.shade100
        ])),
        height: radious,
        width: radious,
        child: Icon(
          Icons.account_circle,
          size: radious,
          color: Colors.white,
        ),
      ),
    );
  }
}
