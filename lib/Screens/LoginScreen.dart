import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
// import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:uBookSharing/BackEnd/Datas.dart';
import 'package:uBookSharing/BackEnd/FireBase.dart';
// import 'package:uBookSharing/BackEnd/Datas.dart';
import 'package:uBookSharing/Components/CompoundWidgets.dart';
// import 'package:uBookSharing/Components/CompoundWidgets.dart';
import 'package:uBookSharing/Constants.dart';
import 'package:uBookSharing/Screens/MainScreenNew.dart';

import 'package:uBookSharing/Screens/ProfileEditScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool animationUnloack = false;
  String _email;
  String _password;
  bool spinner = false;
  double aPEmail = 50;
  double aPPassword = 50;
  bool verified = false;
  final _formKey = GlobalKey<FormState>();

  FirebaseAuth auth = FirebaseAuth.instance;

  spinnerState(bool value) {
    setState(() {
      spinner = value;
    });
  }

  void verifiedCheck() async {
    await auth.currentUser.reload();
    setState(() {
      verified = auth.currentUser.emailVerified;

      // print(verified);
    });
  }

  void signIn(String email, String password) async {
    spinnerState(true);
    print('signIn start');
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      print('signIn done');
      // if (auth.currentUser != null) {
      //   await UserDataSavedEmailPassword.saveuidSharedPref(
      //       auth.currentUser.uid);
      //   animationUnloack = true;
      if (auth.currentUser.emailVerified && auth.currentUser != null) {
        spinnerState(false);
        await GetUserData.getUserData(email);
        // await UserDataSavedEmailPassword.saveuidSharedPref(
        //     auth.currentUser.uid);
        setState(() {
          animationUnloack = true;
        });
        print('signIn Unlock');
        // Future.delayed(Duration(milliseconds: 2000));
        // await UserDataSavedEmailPassword.saveuidSharedPref(
        //     auth.currentUser.uid);
        // UserLogInData.updateUID();
      } else {
        await auth.currentUser.sendEmailVerification();

        verifiedCheck();
        print('signIn verification');
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
      }
    } on FirebaseAuthException catch (e) {
      print('signIn Error');
      spinnerState(false);
      showDialog(
        context: context,
        builder: (context) {
          return AlertsCompound(
            msg: 'Something Wrong',
            color: Colors.red.shade200,
            des: e.message,
            buttonTxt: 'Ok',
            function: () {
              spinnerState(false);
              // spinner = false;
              Navigator.pop(context);
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xffDACEBA),
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        opacity: .55,
        color: Colors.white,
        dismissible: true,
        progressIndicator: SpinkitFading(
          msg: 'Checking...',
        ),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          height: CommonThings.size.height -
              MediaQuery.of(context).viewInsets.bottom,
          curve: Curves.fastOutSlowIn,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/img/BookBack.jpg'),
                  alignment: Alignment.center,
                  fit: BoxFit.cover)),
          child: SafeArea(
            child: Container(
              color: Colors.white24,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 2,
                      child: FlareActor(
                        'assets/flr/lockStates.flr',
                        animation: !animationUnloack ? 'play_lock' : 'unlock',
                        color: Colors.pinkAccent.shade400,
                        callback: (name) {
                          if (name == 'unlock') {
                            UsableData.getSetMillisecondsId();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return UserProfileData.tmVersity != null
                                        ? MainScreenNew()
                                        : ProfileEditScreen();
                                  },
                                  settings: RouteSettings(name: "Foo"),
                                )
                                // PageTransition(
                                //     settings: RouteSettings(name: "Foo"),
                                //     curve: Curves.fastOutSlowIn,
                                //     duration: Duration(milliseconds: 400),
                                //     child: UserProfileData.tmVersity != null
                                //         ? MainScreenNew()
                                //         : ProfileEditScreen(),
                                //     type: PageTransitionType.bottomToTop),
                                );
                          }
                        },
                      )),
                  Expanded(
                      flex: 1,
                      child: Text(
                        'Sign In',
                        style: GoogleFonts.abrilFatface(
                          fontSize: 40,
                          // fontWeight: FontWeight.bold,

                          color: Color(0xff001a54),
                        ),
                      )),
                  Expanded(
                    flex: 5,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AnimatedPadding(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.fastOutSlowIn,
                            padding: EdgeInsets.symmetric(
                                horizontal: aPEmail, vertical: 0),
                            child: TextFormField(
                              onEditingComplete: () {
                                FocusScope.of(context).nextFocus();
                                setState(() {
                                  aPPassword = 10;
                                  aPEmail = 50;
                                  // aPPassword = 50;
                                });
                              },
                              // autovalidate: true,
                              validator: (value) {
                                if (value == '' || value == null)
                                  return 'Enter email address';
                                else if (!RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)) return 'Invalid Email';

                                return null;
                              },
                              onTap: () {
                                setState(() {
                                  aPEmail = 10;
                                  //  aPEmail = 50;
                                  aPPassword = 50;
                                });
                              },
                              // onSubmitted: (value) {
                              //   setState(() {
                              //     aPEmail = 50;
                              //   });

                              //   _email = value;
                              // },
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
                                  aPPassword = 50;
                                });

                                bool isAlright =
                                    _formKey.currentState.validate();
                                // print(auth.currentUser.uid);
                                // auth.currentUser.uid != null
                                //     ? signUn(_email, _password)
                                //     : verifiedCheck();
                                if (isAlright) signIn(_email, _password);
                              },
                              onTap: () {
                                setState(() {
                                  aPPassword = 10;
                                  aPEmail = 50;
                                  // aPPassword = 50;
                                });
                              },
                              validator: (value) {
                                if (value == null || value == '')
                                  return 'Enter your password';
                                if (value.length < 6)
                                  return 'At least 6 characters';

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

                                  hintText: 'Enter your password',
                                  labelText: 'Password'),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            child: RaisedButton(
                              // focusColor: Colors.pinkAccent.shade400,

                              // focusColor: Colors.pinkAccent.shade400,

                              child: Center(
                                child: Text(
                                  'Sign In',
                                  style: GoogleFonts.aBeeZee(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),

                              padding: EdgeInsets.only(top: 15, bottom: 15),
                              onPressed: () {
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
                                if (isAlright) signIn(_email, _password);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // FirebaseAuth.instance.
                    },
                    child: Text(
                      'Forgot password?',
                      textScaleFactor: 1.1,
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
