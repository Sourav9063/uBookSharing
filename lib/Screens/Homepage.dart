import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uBookSharing/BackEnd/Datas.dart';
import 'package:uBookSharing/BackEnd/FireBase.dart';

import 'package:uBookSharing/Screens/Auth/LoginScreen.dart';
import 'package:uBookSharing/Screens/MainScreenNew.dart';
import 'package:uBookSharing/Screens/Auth/RegistrationScreen.dart';
// import 'package:uBookSharing/Screens/MainScreen.dart';
import 'package:uBookSharing/Screens/Auth/ProfileEditScreen.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String animatee = 'Idle';
  // double animatedPadding = 10;

  // double animatedPicCont = -200;
  bool navSignIn = false;
  double animatedPicContleft = 00;
  String buttonMsg = 'Sign In';

  // checkAuth() async {
  //   Future.delayed(Duration(seconds: 2));
  //   if (FirebaseAuth.instance.currentUser != null) {
  //     Navigator.pushReplacement(
  //         context, MaterialPageRoute(builder: (context) => MainScreenNew()));
  //   }
  // }

  void start() async {
    setState(() {
      animatee = 'Idle';
    });

    if (FirebaseAuth.instance.currentUser != null) {
      setState(() {
        buttonMsg = 'Explore';
      });

      await GetUserData.getUserData(FirebaseAuth.instance.currentUser.email);
    } else {
      setState(() {
        buttonMsg = 'Sign In';
      });
    }
  }

  @override
  void initState() {
    start();
    // checkAuth();
    // UserLogInData.updateUID();
    super.initState();
  }

  @override
  void dispose() async {
    if (UserProfileData.tmVersity == null)
      await GetUserData.getUserData(FirebaseAuth.instance.currentUser.email);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      // backgroundColor: Color(0xffAf9884),
      backgroundColor: Color(0xff001a54),
      body: Stack(
        overflow: Overflow.clip,
        children: [
          Positioned(
            top: 0,
            left: 0,
            height: CommonThings.size.height * .82,
            width: CommonThings.size.width,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      offset: Offset(-2, 3),
                      blurRadius: 8,
                      color: Color(0xaa000000))
                ],
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.elliptical(CommonThings.size.width,
                        CommonThings.size.width * .30)),
                // color: Colors.lightBlue.shade700,
                color: Color(0xffF0E4D4),
                // color: Color(0xfff01a54),
              ),
              child: FlareActor(
                'assets/flr/BookGive.flr',
                alignment: Alignment.topCenter,
                fit: BoxFit.contain,
                animation: animatee,
                callback: (value) {
                  if (value == 'Give') {
                    UsableData.getSetMillisecondsId();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            settings: RouteSettings(name: "Foo"),
                            builder: (context) => navSignIn
                                ? FirebaseAuth.instance.currentUser == null
                                    ? LoginScreen()
                                    : FirebaseAuth
                                            .instance.currentUser.emailVerified
                                        ? UserProfileData.tmVersity != null
                                            ? MainScreenNew()
                                            : ProfileEditScreen()
                                        : LoginScreen()
                                : RegScreen()));
                    setState(() {
                      animatee = 'Idle2';
                    });
                  }
                  if (value == 'Idle') {
                    // print('Idle');
                    if (FirebaseAuth.instance.currentUser != null &&
                        UserProfileData.tmVersity != null)
                      setState(() {
                        navSignIn = true;
                        animatee = 'Give';
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
                    // color: Color(0xffffe066),
                    color: Color(0xff001a54),
                    fontSize: 48,
                    // fontWeight: FontWeight.w500,
                    // fontStyle: FontStyle.italic
                  ),
                ),
                Text(
                  'uBookSharing is a University based book sharing app',
                  style: GoogleFonts.lora(
                    // color: Colors.deepPurpleAccent.shade200,
                    color: Color(0xff001a5f),
                    fontSize: 18,
                  ),
                ),
                // AnimatedIcon(

                //   icon: AnimatedIcons.

                // ,),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      0,
                      0,
                      CommonThings.size.width * 0.3,
                      CommonThings.size.height * .23),
                  child: RaisedButton(
                    // focusColor: Colors.pinkAccent.shade400,

                    // focusColor: Colors.pinkAccent.shade400,
                    elevation: 0,

                    child: Text(
                      buttonMsg,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),

                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    onPressed: () {
                      navSignIn = true;
                      setState(() {
                        animatee = 'Give';
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
                            animatee = 'Give';
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
