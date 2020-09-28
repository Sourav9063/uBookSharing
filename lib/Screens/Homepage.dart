import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uBookSharing/BackEnd/Datas.dart';
// import 'package:uBookSharing/Constants.dart';
import 'package:uBookSharing/Screens/LoginScreen.dart';
import 'package:uBookSharing/Screens/Registration.dart';
import 'package:uBookSharing/Screens/profile.dart';
// import 'package:uBookSharing/Screens/profile.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool pic = true;
  double animatedPadding = 10;
  // double animatedPicCont = -200;
  bool navSignIn = false;
  double animatedPicContleft = 00;
  @override
  void initState() {
    super.initState();

    UserLogInData.updateUID();
  }

  @override
  Widget build(BuildContext context) {
    CommonThings.size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        overflow: Overflow.clip,
        children: [
          AnimatedPositioned(
              curve: Curves.easeInOutCubic,
              duration: Duration(milliseconds: 400),
              left: animatedPicContleft,
              // bottom: 00,
              top: 0,
              onEnd: () {
                print("navigate to sign in");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => navSignIn
                            ? UserLogInData.uid == null
                                ? LoginScreen()
                                : UserProfile()
                            : RegScreen()));
              },
              child: Image.asset(
                "assets/img/bookSharingBlue.jpg",
                // alignment: Alignment.topCenter,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                isAntiAlias: true,
              )),
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
                      'Sign In',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),

                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    onPressed: () {
                      navSignIn = true;
                      setState(() {
                        // animatedPadding = animatedPadding == 10 ? 120 : 10;
                        // animatedPicCont = animatedPicCont == -200 ? -100 : -200;
                        animatedPicContleft =
                            animatedPicContleft == 0 ? -150 : 0;
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
                            // animatedPadding = animatedPadding == 10 ? 120 : 10;
                            // animatedPicCont = animatedPicCont == -200 ? -100 : -200;
                            animatedPicContleft =
                                animatedPicContleft == 0 ? -150 : 0;
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
