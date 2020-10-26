import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:page_transition/page_transition.dart';
import 'package:uBookSharing/BackEnd/Datas.dart';
import 'package:uBookSharing/Screens/BookDetailsPage.dart';
import 'package:uBookSharing/Screens/Homepage.dart';
import 'package:uBookSharing/Screens/profile.dart';

class BookImg extends StatelessWidget {
  final String imglink;
  final double width;
  final TransformationController transformationController =
      TransformationController();
  BookImg({Key key, this.imglink, @required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(imglink);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      height: width * 4 / 3,
      width: width,
      child: imglink == null
          ?
          //  Image.asset(
          //     'assets/img/AddBookImgL.png',
          //     fit: BoxFit.contain,
          //   )
          // Lottie.asset('assets/lottie/bookLoading.json', fit: BoxFit.contain)
          FlareActor(
              'assets/flr/BookLoadingLottie.flr',
              fit: BoxFit.contain,
              animation: 'Animations',
            )
          // ColorFiltered(
          //     colorFilter: ColorFilter.mode(Colors.white, BlendMode.color),
          //     child: Image.asset(
          //       'assets/img/bookSharingPink.jpg',
          //       fit: BoxFit.cover,
          //     ),
          //   )
          : InteractiveViewer(
              transformationController: transformationController,
              maxScale: 5,
              onInteractionEnd: (details) async {
                await Future.delayed(Duration(seconds: 3));

                transformationController.value = Matrix4.identity();
              },
              child: Image.network(
                imglink,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.error,
                      color: Colors.red,
                      size: width / 2,
                    ),
                  );
                },
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes
                          : null,
                    ),
                  );
                },
                fit: BoxFit.cover,
                height: width,
                width: width,
              ),
            ),
    );
  }
}

class BookCard extends StatelessWidget {
  final double width;
  final BookData bookData;

  const BookCard({
    Key key,
    @required this.bookData,
    @required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return BookDetailsPage(bookData: bookData);
        }));
      },
      child: Container(
        color: Color(0x00000000),
        height: width * .753, //.95 * .618,
        width: width * 1.20,
        child: Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                // height: ,
                height: width * .753,
                width: width * .953,
                decoration: BoxDecoration(
                  color: Color(0xff001a5f),
                  // color: Colors.pinkAccent.shade700,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(3, 3),
                      blurRadius: 8,
                      color: Color(0xaa000000),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: width * .087 / 2,
              width: width * .50,
              height: width * .50 * 4 / 3,
              child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xff6F00FF),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(3, 3),
                        blurRadius: 8,
                        color: Color(0xaa000000),
                      ),
                    ],
                  ),
                  child: BookImg(
                    width: width * .50,
                    imglink: bookData == null
                        ?
                        // ? 'https://firebasestorage.googleapis.com/v0/b/ubooksharing-ece40.appspot.com/o/Books%2Fsourav.ahmed5654%40gmail.com5%2Fsourav.ahmed5654%40gmail.com5?alt=media&token=d3482de0-ccb1-40f4-9848-4b8911a80ab6'
                        null
                        : bookData.bookImgLink,
                    // imglink: UserProfileData.profilePicLink
                    // 'https://firebasestorage.googleapis.com/v0/b/ubooksharing-ece40.appspot.com/o/Books%2Fsourav.ahmed5654%40gmail.com5%2Fsourav.ahmed5654%40gmail.com5?alt=media&token=d3482de0-ccb1-40f4-9848-4b8911a80ab6',
                  )),
            ),
            Positioned(
              top: 0,
              right: 0,
              width: width * .50 * 1.38,
              height: width * .753,
              child: Container(
                padding: EdgeInsets.all(4),
                // color: Colors.white54,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        bookData.bookName,
                        style: GoogleFonts.abrilFatface(
                            fontSize: width * .06, color: Colors.white),
                      ),
                    ),
                    //   FittedBox(
                    //          fit: BoxFit.fitWidth,             child: Text(
                    //     bookData.bookName,
                    //     style: TextStyle(fontSize: width * .075),
                    //   ),
                    // ),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        bookData.bookWriter,
                        style: TextStyle(
                            fontSize: width * .05, color: Colors.white),
                      ),
                    ),
                    Container(
                      color: Theme.of(context).accentColor,
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              bookData.bookFor,
                              style: TextStyle(
                                  fontSize: width * .055, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        'Uploaded: ' +
                            bookData.bookTimeUpload.toDate().day.toString() +
                            ' ' +
                            UsableData.getMonthName(
                                bookData.bookTimeUpload.toDate().month) +
                            ', ' +
                            bookData.bookTimeUpload.toDate().year.toString(),
                        style: TextStyle(
                            fontSize: width * .055, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
              padding: const EdgeInsets.all(11.0),
              child: ClipOval(
                child: Image.network(
                  imglink,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.error,
                      color: Colors.white,
                      size: radious / 1.5,
                    );
                  },
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
                  height: radious,
                  width: radious,
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
    var kDrawerTextStyle = TextStyle(color: Colors.tealAccent, fontSize: 14);
    return Drawer(
      child: Container(
        height: CommonThings.size.height,
        width: CommonThings.size.width * .80,
        color: Color(0xff000247),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconAccount(
                      radious: CommonThings.size.width * .35,
                      imglink: UserProfileData.profilePicLink,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        UserProfileData.name == null
                            ? 'Loading..'
                            : UserProfileData.name,
                        style: kDrawerTextStyle.copyWith(fontSize: 22),
                      ),
                    )
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    color: Color(0x00000000),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: UserProfile(),
                              type: PageTransitionType.leftToRight));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.account_circle,
                          color: Colors.white,
                          // size: 30,
                        ),
                        SizedBox(width: 18),
                        Text(
                          'Profile',
                          style: kDrawerTextStyle,
                        ),
                      ],
                    ),
                  ),
                  RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    color: Color(0x00000000),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => MyHomePage()),
                          (Route<dynamic> route) => false);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.exit_to_app, color: Colors.white),
                        SizedBox(width: 18),
                        Text(
                          'Sign out',
                          style: kDrawerTextStyle,
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BookFormField extends StatelessWidget {
  final String lebel;
  final String hintText;
  final Function validate;
  final Function onChanged;
  final Function raiseForm;
  const BookFormField({
    Key key,
    @required this.validate,
    @required this.onChanged,
    this.raiseForm,
    this.lebel,
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextFormField(
        cursorColor: Theme.of(context).accentColor,
        onTap: raiseForm,
        onChanged: onChanged,
        validator: validate,
        style: TextStyle(fontSize: 18),
        decoration: InputDecoration(
          // contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          filled: true,
          fillColor: Color(0xffffffff),
          labelText: lebel,
          hintText: hintText,
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xff001a54),
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Color(0xff6F00FF),
            ),
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
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
        Expanded(
          child: Center(
            child: SpinKitFadingCube(
              size: CommonThings.size.width * .2,
              itemBuilder: (BuildContext context, int index) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: index % 3 == 0 ? Colors.red : Color(0xffffb8b24),
                  ),
                );
              },
            ),
          ),
        ),
        Expanded(
          child: Text(
            msg == null ? 'Loading...' : msg,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
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

// class ErrorState extends StatelessWidget {
//   final String msg;
//   const ErrorState({Key key, this.msg}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // CommonThings.size = CommonThings.size;
//     return Scaffold(
//       body: Container(
//         height: CommonThings.size.height,
//         width: CommonThings.size.width,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topRight,
//             colors: [Color(0xffffb8b24), Colors.red],
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               msg == null ? 'Loading...' : msg,
//               style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.white),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class IconAccountOld extends StatelessWidget {
//   const IconAccountOld({
//     @required this.radious,
//     Key key,
//   }) : super(key: key);
//   final double radious;
//   @override
//   Widget build(BuildContext context) {
//     return ClipOval(
//       child: Container(
//         // color: Colors.lightBlue,
//         // color: Colors.blue.shade200,
//         // color: Colors.white,
//         decoration: BoxDecoration(
//             gradient: RadialGradient(colors: [
//           // Colors.pinkAccent.shade100,
//           Colors.pinkAccent.shade400,
//           Colors.indigoAccent.shade100
//         ])),
//         height: radious,
//         width: radious,
//         child: Icon(
//           Icons.account_circle,
//           size: radious,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }
