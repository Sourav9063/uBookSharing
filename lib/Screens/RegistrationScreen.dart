// import 'package:flare_flutter/flare_actor.dart';
import 'dart:ui';

import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:uBookSharing/BackEnd/Datas.dart';

import 'package:uBookSharing/Components/CompoundWidgets.dart';
import 'package:uBookSharing/Components/ModalPeogressHub.dart';

import 'package:uBookSharing/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uBookSharing/Screens/ProfileEditScreen.dart';

class RegScreen extends StatefulWidget {
  RegScreen({Key key}) : super(key: key);

  @override
  _RegScreenState createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  bool spinner = false;
  bool animationUnloack = false;
  String _email = '';
  String _userName = '';
  String _password = '';
  bool verified = false;
  double aPEmail = 50;
  double aPPassword = 50;
  double aPUsername = 50;
  String verifyButtonText = 'Verify Email';
  final _formKey = GlobalKey<FormState>();

  spinnerState(bool value) {
    setState(() {
      spinner = value;
    });
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  // AlertDialog alerts(String error) {
  //   error = error.replaceAll(RegExp('-'), ' ');

  //   AlertDialog alert = AlertDialog(
  //     title: Text('Error'),
  //     content: Text(error),
  //     actions: <Widget>[
  //       FlatButton(
  //         child: Text('OK'),
  //         onPressed: () {
  //           spinnerState(false);
  //           // spinner = false;
  //           Navigator.pop(context);
  //         },
  //       )
  //     ],
  //   );
  //   return alert;
  // }

  // AlertDialog veryfyEmailAlertDialog() {
  //   AlertDialog alert = AlertDialog(
  //     title: Text('Email Verification'),
  //     content: Text('Check your email and click the link to verify'),
  //     actions: <Widget>[
  //       FlatButton(
  //         child: Text('Check'),
  //         onPressed: () async {
  //           spinnerState(false);
  //           verifiedCheck();
  //           if (verified) Navigator.pop(context);
  //         },
  //       )
  //     ],
  //   );
  //   return alert;
  // }

  void signUn(String email, String password) async {
    //  _email!=''? verifiedCheck():null;
    spinnerState(true);
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      await auth.currentUser.updateProfile(displayName: _userName);

      await auth.currentUser.sendEmailVerification();

      verifiedCheck();
      spinnerState(false);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertsCompound(
              buttonTxt: 'Check',
              des:
                  'Check your email and click the link in the description to verify',
              msg: 'Email Verification',
              color: Colors.greenAccent,
              function: () async {
                spinnerState(false);
                verifiedCheck();
                if (verified) Navigator.pop(context);
              },
            );
          });

      // UserDataSavedEmailPassword.saveuidSharedPref(auth.currentUser.uid);
    } on FirebaseAuthException catch (e) {
      spinnerState(false);
      showDialog(
        context: context,
        builder: (context) {
          return AlertsCompound(
            msg: 'Something Wrong',
            color: Colors.red.shade200,
            des: e.message,
            buttonTxt: 'OK',
            function: () {
              spinnerState(false);
              // spinner = false;
              Navigator.pop(context);
            },
          );
        },
      );
    }
    verifiedCheck();
  }

  void verifiedCheck() async {
    await auth.currentUser.reload();
    setState(() {
      verified = auth.currentUser.emailVerified;

      if (verified) {
        verifyButtonText = 'Email verified';
        spinner = false;
      }
      // print(verified);
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.signOut();
    // UserDataSavedEmailPassword.clearuidSharedPref();
    // UserLogInData.updateUID();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff324062),
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        opacity: .55,
        color: Colors.white,
        dismissible: true,
        progressIndicator: SpinkitFading(
          msg: 'Verifying...',
        ),
        child: Stack(
          children: [
            Container(
              height: CommonThings.size.height,
              width: CommonThings.size.width,
              // duration: Duration(milliseconds: 500),
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //       // scale: .4,
              //       alignment: Alignment.bottomLeft,
              //       image: AssetImage('assets/img/BookBack.jpg'),
              //       fit: BoxFit.cover),
              // ),
              child: Image.asset(
                'assets/img/BookBack.jpg',
                fit: BoxFit.cover,
                alignment: Alignment.bottomLeft,
                color: Color(0xBB001a54), colorBlendMode: BlendMode.darken,

                // color: Colors.blue,
              ),
            ),
            // FlareActor(
            //   'assets/flr/Background.flr',
            //   animation: 'Flow',
            //   fit: BoxFit.cover,
            // ),
            SafeArea(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Center(
                            // right: CommonThings.size.width * .05,
                            // top: 200,
                            child: IconAccount(
                              radious: CommonThings.size.width * .40,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Center(
                            child: Text(
                              'Sign Up',
                              style: GoogleFonts.abrilFatface(
                                fontSize: 38,
                                // fontWeight: FontWeight.bold,

                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        AnimatedPadding(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.fastOutSlowIn,
                          padding: EdgeInsets.symmetric(
                              horizontal: aPUsername, vertical: 8),
                          child: TextFormField(
                            onEditingComplete: () {
                              FocusScope.of(context).nextFocus();
                              setState(() {
                                aPEmail = 10;
                                //  aPEmail = 50;
                                aPUsername = 50;
                                aPPassword = 50;
                              });
                            },
                            // autovalidate: true,

                            validator: (value) {
                              if (value == '' || value == null)
                                return 'Your name is required';
                              else if (value.length < 4) return 'Too short';

                              return null;
                            },
                            onTap: () {
                              setState(() {
                                aPEmail = 50;
                                //  aPEmail = 50;
                                aPUsername = 10;
                                aPPassword = 50;
                              });
                            },
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.emailAddress,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              _userName = value;
                            },
                            decoration: kTextFieldDecoration.copyWith(
                                hintText: 'Enter your name',
                                labelText: 'Username'),
                          ),
                        ),
                        AnimatedPadding(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.fastOutSlowIn,
                          padding: EdgeInsets.symmetric(
                              horizontal: aPEmail, vertical: 4),
                          child: TextFormField(
                            onEditingComplete: () {
                              FocusScope.of(context).nextFocus();
                              setState(() {
                                aPEmail = 50;
                                //  aPEmail = 50;
                                aPUsername = 50;
                                aPPassword = 10;
                              });
                            },
                            // autovalidate: true,
                            validator: (value) {
                              if (value == '' || value == null)
                                return 'Your email is required';
                              else if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)) return 'Invalid Email';

                              return null;
                            },
                            onTap: () {
                              setState(() {
                                aPEmail = 10;
                                //  aPEmail = 50;
                                aPUsername = 50;
                                aPPassword = 50;
                              });
                            },

                            keyboardType: TextInputType.emailAddress,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              _email = value;
                            },
                            decoration: kTextFieldDecoration.copyWith(
                                hintText: 'Enter your email',
                                labelText: 'Email'),
                          ),
                        ),
                        AnimatedPadding(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.fastOutSlowIn,
                          padding: EdgeInsets.symmetric(
                              horizontal: aPPassword, vertical: 8),
                          child: TextFormField(
                            onEditingComplete: () {
                              FocusScope.of(context).unfocus();
                              setState(() {
                                aPEmail = 50;
                                //  aPEmail = 50;
                                aPUsername = 50;
                                aPPassword = 50;
                              });
                            },
                            onTap: () {
                              setState(() {
                                aPPassword = 10;
                                aPEmail = 50;
                                aPUsername = 50;
                                // aPPassword = 50;
                              });
                            },
                            validator: (value) {
                              if (value.length < 6)
                                return 'Can\'t you read!? At least 6 characters';

                              return null;
                            },
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              _password = value;
                            },
                            decoration: kTextFieldDecoration.copyWith(
                                // errorText: _email,

                                hintText: "Not less than 6 characters",
                                labelText: 'Password'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                // duration: Duration(milliseconds: 200),
                                flex: 2,
                                child: RaisedButton(
                                  // focusColor: Colors.pinkAccent.shade400,

                                  // focusColor: Colors.pinkAccent.shade400,

                                  child: Center(
                                    child: Text(
                                      verifyButtonText,
                                      style: GoogleFonts.aBeeZee(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                  ),

                                  padding: EdgeInsets.only(top: 15, bottom: 15),
                                  onPressed: verified
                                      ? null
                                      : () {
                                          FocusScope.of(context).unfocus();
                                          setState(() {
                                            aPEmail = 50;
                                            aPPassword = 50;
                                          });
                                          bool isAlright =
                                              _formKey.currentState.validate();
                                          // print(auth.currentUser.uid);
                                          // auth.currentUser.uid != null
                                          //     ? signUn(_email, _password)
                                          //     : verifiedCheck();
                                          if (isAlright)
                                            signUn(_email, _password);
                                        },
                                ),
                              ),
                              Expanded(
                                flex: verified ? 2 : 1,
                                // duration: Duration(milliseconds: 200),
                                child: RaisedButton(
                                  // focusColor: Colors.pinkAccent.shade400,

                                  // focusColor: Colors.pinkAccent.shade400,

                                  child: Text(
                                    'Next',
                                    style: GoogleFonts.aBeeZee(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                  color: Colors.green,

                                  padding: EdgeInsets.only(top: 15, bottom: 15),
                                  onPressed: !verified
                                      ? null
                                      : () async {
                                          UsableData.getSetMillisecondsId();
                                          // UserLogInData.uid =
                                          //     await UserDataSavedEmailPassword
                                          //         .getuidSharedPref();
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProfileEditScreen()));
                                        },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
