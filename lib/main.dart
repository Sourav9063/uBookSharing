// import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uBookSharing/BackEnd/Datas.dart';

import 'package:uBookSharing/Components/CompoundWidgets.dart';
import 'package:uBookSharing/Screens/Homepage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  runApp(MyAwesomeApp());
}

class MyAwesomeApp extends StatelessWidget {
  const MyAwesomeApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'uBookSharing',
      theme: ThemeData(
          // brightness: Brightness.dark,

          // scaffoldBackgroundColor: Color(0xff6F00FF),

          // cardColor: Colors.white,

          bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18))),
          primarySwatch: Colors.purple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          accentColor: Color(0xfffb8b24),
          buttonTheme: ButtonTheme.of(context).copyWith(
            buttonColor: Color(0xfffb8b24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          )),
      home: FutureBuilderRouteFirebase(),
      // home: LoginScreen(),
    );
  }
}

class FutureBuilderRouteFirebase extends StatefulWidget {
  FutureBuilderRouteFirebase({Key key}) : super(key: key);

  @override
  _FutureBuilderRouteFirebaseState createState() =>
      _FutureBuilderRouteFirebaseState();
}

class _FutureBuilderRouteFirebaseState
    extends State<FutureBuilderRouteFirebase> {
  // bool loading = true;
  bool ini = false;
  bool error = false;
  bool connected = true;
  String errorMsg;
  void intFirebase() async {
    try {
      await Firebase.initializeApp();

      setState(() {
        ini = true;
      });
    }on FirebaseException catch (e) {
      setState(() {
        errorMsg = e.message;
        error = true;
      });
    }
  }

  void checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          connected = true;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        connected = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkConnection();
    intFirebase();
  }

//helloooo vsCode  git check
  @override
  Widget build(BuildContext context) {
    CommonThings.size = MediaQuery.of(context).size;
    // return FutureBuilder(
    //   future: Firebase.initializeApp(),
    //   builder: (context, snp) {
    //     if (snp.connectionState == ConnectionState.done) return ErrorState();
    //     if (snp.connectionState != ConnectionState.done)
    //       return SomethingWentWrong(
    //         errorMsg: 'No connection',
    //       );
    //     if (snp.connectionState == ConnectionState.waiting)
    //       return LoadingState();
    //     return LoadingState();
    //   },
    // );
    if (!connected)
      return SomethingWentWrong(
        errorMsg: 'No Internet Connection',
      );
    if (error)
      return SomethingWentWrong(
        errorMsg: errorMsg,
      );
    if (ini == false) return LoadingState();

    return MyHomePage();
  }
}

class LoadingState extends StatelessWidget {
  const LoadingState({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade100,
      body: Center(
          child: SpinkitFading(
        msg: 'Loading',
      )),

      // home: LoginScreen(),
    );
  }
}

class SomethingWentWrong extends StatelessWidget {
  final String errorMsg;
  const SomethingWentWrong({Key key, this.errorMsg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.error,
              color: Colors.white,
              size: CommonThings.size.width * .55,
            ),
            Text(
              'Error',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              errorMsg == null
                  ? 'Something Went Wrong. Restart the App.'
                  : errorMsg,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            IconButton(
              icon: Icon(
                Icons.replay_rounded,
                color: Colors.white,
                size: 50,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FutureBuilderRouteFirebase()));
              },
            )
          ],
        ),
      ),
    );
  }
}

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   // final Future<FirebaseApp> _initialization = Firebase.initializeApp();
//   @override
//   Widget build(BuildContext context) {
//     CommonThings.size = CommonThings.size;
// return FutureBuilder(
//       builder: (context, snapshot) {
// if (snapshot.hasData)
//   return MyHomePage();
// else if (snapshot.error)
//   return ErrorState(

//     msg: 'Something wrong.\n Please try again',
//   );
// else if (snapshot.connectionState != ConnectionState.done)
//   return ErrorState(
//     msg: 'Can\'t Connect to Internet ',
//   );

//         // return ErrorState(msg: 'Loading...');
//       },
//       future: Firebase.initializeApp(),
//     );
//   }
// }

// class MyAppState extends StatelessWidget {
//   const MyAppState({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       // Initialize FlutterFire
//       future: Firebase.initializeApp(),
//       builder: (context, snapshot) {
//         // Check for errors
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return LoadingState();
//         }
//         if (snapshot.connectionState == ConnectionState.done) {
//           return MyAwesomeApp();
//           // return LoadingState();
//         }
//         if (snapshot.hasError) {
//           return SomethingWentWrong(
//             errorMsg: 'An Error Occured',
//           );
//         }
//         if (snapshot.connectionState != ConnectionState.done) {
//           return SomethingWentWrong(
//             errorMsg: 'No connection',
//           );
//         }

//         // Once complete, show your application

//         // Otherwise, show something whilst waiting for initialization to complete
//         return LoadingState();
//       },
//     );
//   }
// }

// MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'uBookSharing',
//       theme: ThemeData(
//           primarySwatch: Colors.blue,
//           visualDensity: VisualDensity.adaptivePlatformDensity,
//           accentColor: Color(0xffffb8b24),
//           buttonTheme: ButtonTheme.of(context).copyWith(
//             buttonColor: Color(0xffffb8b24),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(50),
//             ),
//           )),
//       home: MyHomePage(),
//       // home: LoginScreen(),
//     );
