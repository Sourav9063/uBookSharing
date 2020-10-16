import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uBookSharing/BackEnd/Datas.dart';
import 'package:uBookSharing/BackEnd/FireBase.dart';

import 'package:uBookSharing/Screens/LoginScreen.dart';
import 'package:uBookSharing/Screens/Registration.dart';
import 'package:uBookSharing/Screens/mainPage.dart';
import 'package:uBookSharing/Screens/profile.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool animatee = false;
  // double animatedPadding = 10;

  // double animatedPicCont = -200;
  bool navSignIn = false;
  double animatedPicContleft = 00;
  String buttonMsg = 'Sign In';

  checkAuth() async {
    Future.delayed(Duration(seconds: 2));
    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainPage()));
    }
  }

  @override
  void initState() {
    super.initState();
    // checkAuth();
    // UserLogInData.updateUID();

    if (FirebaseAuth.instance.currentUser != null) {
      setState(() {
        buttonMsg = 'Explore';
      });

      GetUserData.getUserData(FirebaseAuth.instance.currentUser.email);
    }
  }

  @override
  void dispose() async {
    if (FirebaseAuth.instance.currentUser != null)
      await GetUserData.getUserData(FirebaseAuth.instance.currentUser.email);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CommonThings.size = CommonThings.size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        overflow: Overflow.clip,
        children: [
          Positioned(
            top: 0,
            left: 0,
            height: CommonThings.size.height * .80,
            width: CommonThings.size.width,
            child: Material(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.elliptical(
                      CommonThings.size.width, CommonThings.size.width * .30)),
              color: Colors.lightBlue.shade700,
              child: FlareActor(
                'assets/flr/BookGive.flr',
                alignment: Alignment.topCenter,
                fit: BoxFit.contain,
                animation: animatee ? 'Give' : 'Idle',
                callback: (value) {
                  if (value == 'Give') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => navSignIn
                                ? FirebaseAuth.instance.currentUser == null
                                    ? LoginScreen()
                                    : FirebaseAuth
                                            .instance.currentUser.emailVerified
                                        ? UserProfileData.tmVersity != null
                                            ? MainPage()
                                            : UserProfile()
                                        : LoginScreen()
                                : RegScreen()));
                    setState(() {
                      animatee = false;
                    });
                  }
                },
              ),
            ),
          ),
          // AnimatedPositioned(
          //     curve: Curves.fastOutSlowIn,
          //     duration: Duration(milliseconds: 400),
          //     left: animatedPicContleft,
          //     // bottom: 00,
          //     top: 0,
          //     onEnd: () {
          //       // print(FirebaseAuth.instance.currentUser);

          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => navSignIn
          //                   ? FirebaseAuth.instance.currentUser == null
          //                       ? LoginScreen()
          //                       : FirebaseAuth
          //                               .instance.currentUser.emailVerified
          //                           ? UserProfileData.tmVersity != null
          //                               ? MainPage()
          //                               : UserProfile()
          //                           : LoginScreen()
          //                   : RegScreen()));
          //     },
          //     child: Hero(
          //       tag: 'Book',
          //       child: Image.asset(
          //         "assets/img/bookSharingBlue.jpg",
          //         // alignment: Alignment.topCenter,
          //         fit: BoxFit.cover,
          //         alignment: Alignment.topCenter,
          //         isAntiAlias: true,
          //       ),
          //     )),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Welcome',
                  style: GoogleFonts.abrilFatface(
                    color: Color(0xffffe066),
                    fontSize: 48,
                    // fontWeight: FontWeight.w500,
                    // fontStyle: FontStyle.italic
                  ),
                ),
                Text(
                  'uBookSharing is a University based book sharing app',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                // AnimatedIcon(

                //   icon: AnimatedIcons.

                // ,),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      0, 0, CommonThings.size.width * 0.3, 200),
                  child: RaisedButton(
                    // focusColor: Colors.pinkAccent.shade400,

                    // focusColor: Colors.pinkAccent.shade400,
                    child: Text(
                      buttonMsg,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),

                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    onPressed: () {
                      navSignIn = true;
                      setState(() {
                        animatee = true;
                        // animatedPadding = animatedPadding == 10 ? 120 : 10;
                        // animatedPicCont = animatedPicCont == -200 ? -100 : -200;
                        // animatedPicContleft =
                        //     animatedPicContleft == 0 ? -150 : 0;
                      });
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) {
                      //       return Registration();
                      //     },
                      //   ),
                      // );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () {
                          navSignIn = false;
                          setState(() {
                            animatee = true;
                            // animatedPadding = animatedPadding == 10 ? 120 : 10;
                            // animatedPicCont = animatedPicCont == -200 ? -100 : -200;
                            // animatedPicContleft =
                            //     animatedPicContleft == 0 ? -150 : 0;
                          });
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => RegScreen()));
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.red,
                            // backgroundColor: Colors.white,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
