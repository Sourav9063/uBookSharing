import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:uBookSharing/BackEnd/Datas.dart';
import 'package:uBookSharing/BackEnd/FireBase.dart';
import 'package:uBookSharing/Components/CompoundWidgets.dart';
import 'package:url_launcher/url_launcher.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();

    GetUserData().getUserData(FirebaseAuth.instance.currentUser.email);
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      body: Builder(
        builder: (context) => SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                // title: Text(
                //   'uBookSharing',
                //   style: GoogleFonts.abrilFatface(
                //       color: Color(0xff02effc), fontSize: 25),
                // ),
                pinned: true,
                backgroundColor: Color(0xff343669),
                expandedHeight: CommonThings.size.width * 98 / 160,
                flexibleSpace: FlexibleSpaceBar(
                  // titlePadding: EdgeInsets.only(
                  //     bottom: CommonThings.size.width * 98 / 160 / 2, left: 20),
                  title: Text(
                    'uBookSharing',
                    style: GoogleFonts.abrilFatface(
                        color: Color(0xff02effc), fontSize: 25),
                  ),
                  background: Container(
                    child: Lottie.asset(
                      'assets/lottie/appBar.json',
                      reverse: true,
                    ),
                  ),
                ),
              ),
              SliverFillRemaining(
                child: Container(
                  child: RaisedButton(onPressed: () async {
                    final Uri launchEmailData = Uri(
                        scheme: 'mailto',
                        path: 'sourav68@student.sust.edu',
                        queryParameters: {
                          'subject': 'uBookSharing response ',
                          'body': 'Default body'
                        });
                    String launchEmailUrl = launchEmailData.toString();
                    if (await canLaunch(launchEmailUrl)) {
                      await launch(launchEmailUrl);
                    } else {
                      print('hwwww');
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "Can\'t send automated email. Try sending manually")));
                    }
                  }),
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
