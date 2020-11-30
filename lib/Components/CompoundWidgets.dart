import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:uBookSharing/BackEnd/Datas.dart';
import 'package:uBookSharing/Components/spinkit.dart';

import 'package:uBookSharing/Screens/BookDetailsScreen.dart';
import 'package:uBookSharing/Screens/Homepage.dart';
import 'package:uBookSharing/Screens/InteractionsScreen.dart';

import 'package:uBookSharing/Screens/ProfileEditScreen.dart';

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
          // Image.asset(
          //     'assets/img/BookBack.jpg',
          //     fit: BoxFit.cover,
          //     alignment: Alignment.bottomLeft,
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
                await Future.delayed(Duration(seconds: 5));

                transformationController.value = Matrix4.identity();
              },
              child: CachedNetworkImage(
                imageUrl: imglink,
                fit: BoxFit.cover,
                errorWidget: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.error,
                      color: Colors.red,
                      size: CommonThings.size.width * .2,
                    ),
                  );
                },
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                  child: CircularProgressIndicator(
                      value: downloadProgress.progress),
                ),
              ),

              // child: Image.network(
              //   imglink,
              //   errorBuilder: (context, error, stackTrace) {
              //     return Center(
              //       child: Icon(
              //         Icons.error,
              //         color: Colors.red,
              //         size: width / 2,
              //       ),
              //     );
              //   },
              //   loadingBuilder: (BuildContext context, Widget child,
              //       ImageChunkEvent loadingProgress) {
              //     if (loadingProgress == null) return child;
              //     return Center(
              //       child: CircularProgressIndicator(
              //         strokeWidth: 4,
              //         value: loadingProgress.expectedTotalBytes != null
              //             ? loadingProgress.cumulativeBytesLoaded /
              //                 loadingProgress.expectedTotalBytes
              //             : null,
              //       ),
              //     );
              //   },
              //   fit: BoxFit.cover,
              //   height: width,
              //   width: width,
              // ),
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
        Navigator.push(context,
            // PageTransition(
            //   curve: Curves.fastOutSlowIn,
            //   child: BookDetailsScreen(bookData: bookData),
            //   type: PageTransitionType.size,
            //   alignment: Alignment.center,
            // )

            MaterialPageRoute(builder: (context) {
          return BookDetailsScreen(bookData: bookData);
        }));
      },
      child: Container(
        // padding: EdgeInsets.all(8),
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
                  color: Color(0xff089080),
                  // color: Colors.teal.shade700,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(3, 3),
                      blurRadius: 4,
                      color: Color(0xcc087060),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              width: width * .50 * 1.38,
              height: width * .753,
              child: Container(
                padding: EdgeInsets.all(4),
                // color: Colors.white10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // FittedBox(
                    //   fit: BoxFit.fitWidth,
                    //   child: Text(
                    //     bookData.bookName,
                    //     style: GoogleFonts.abrilFatface(
                    //         fontSize: width * .08,
                    //         // fontWeight: FontWeight.bold,
                    //         color: Colors.grey.shade200,
                    //         shadows: [
                    //           Shadow(
                    //             blurRadius: 4,
                    //             color: Colors.black54,
                    //             offset: Offset(2, 2),
                    //           ),
                    //         ]),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    //   child: FittedBox(
                    //     fit: BoxFit.fitWidth,
                    //     child: Text(
                    //       bookData.bookWriter,
                    //       style: GoogleFonts.sacramento(
                    //         fontSize: width * .08,
                    //         // fontWeight: FontWeight.bold,
                    //         color: Colors.white,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Text(
                      bookData.bookFor == 'Buy' || bookData.bookFor == 'Rent'
                          ? 'Requested By'
                          : 'Owned by',
                      style: GoogleFonts.abrilFatface(
                          fontSize: width * .06, color: Colors.white),
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
                        bookData.bookUploaderName,
                        style: GoogleFonts.lora(
                            fontSize: width * .05, color: Colors.white),
                      ),
                    ),
                    Container(
                      color: Colors.green,
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
                      child: bookData.bookTimeUploadString == null
                          ? Text(
                              'Uploaded: ' +
                                  UsableData.timestampToString(
                                      bookData.bookTimeUpload),
                              style: TextStyle(
                                  fontSize: width * .055, color: Colors.white),
                            )
                          : Text(
                              'Added: ' + bookData.bookTimeUploadString,
                              style: TextStyle(
                                  fontSize: width * .055, color: Colors.white),
                            ),
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
                  color: Color(0x00082040),
                  // color: Colors.grey.shade200,
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(4, 4),
                      blurRadius: 4,
                      color: Color(0xbb082040),
                    ),
                  ],
                ),
                child: CustomPaint(
                  // decoration: BoxDecoration(
                  //   color: Color(0xff082040),
                  //   // color: Colors.grey.shade200,
                  //   boxShadow: [
                  //     BoxShadow(
                  //       offset: Offset(4, 4),
                  //       blurRadius: 4,
                  //       color: Color(0xaa082040),
                  //     ),
                  //   ],
                  // ),

                  // size: Size(width * .60, width * .60 * 4 / 3),
                  painter: RPSCustomPainter(),
                  // child: BookImg(
                  //   width: width * .50,
                  //   imglink: bookData == null ? null : bookData.bookImgLink,
                  //   // imglink: null,
                  // ),
                  child: Stack(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Positioned(
                        bottom: 0,
                        left: width * .035,
                        child: Text(
                          bookData.bookName[0].toUpperCase(),
                          style: GoogleFonts.abrilFatface(
                            color: Colors.white12,
                            fontSize: width * .4,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB((width * .055), 6, 4, 0),
                        child: Text(
                          bookData.bookName,
                          style: GoogleFonts.abrilFatface(
                              fontSize: width * .08,
                              // fontWeight: FontWeight.bold,
                              color: Colors.grey.shade200,
                              shadows: [
                                Shadow(
                                  blurRadius: 4,
                                  color: Colors.black54,
                                  offset: Offset(2, 2),
                                ),
                              ]),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                              (width * .055), 6, 4, width * .055),
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              bookData.bookWriter,
                              style: GoogleFonts.sacramento(
                                fontSize: width * .08,
                                // fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0 = new Paint()
      ..color = Color.fromARGB(255, 27, 2, 87)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;

    Path path_0 = Path();
    path_0.moveTo(size.width * 0.07, 0);
    path_0.lineTo(size.width, 0);
    path_0.lineTo(size.width, size.height * 0.95);
    path_0.lineTo(size.width * 0.07, size.height * 0.95);
    path_0.lineTo(size.width * 0.07, 0);
    path_0.close();

    canvas.drawPath(path_0, paint_0);

    Paint paint_1 = new Paint()
      ..color = Color.fromARGB(255, 90, 57, 170)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.07, size.height * 0.00);
    path_1.quadraticBezierTo(size.width * 0.00, size.height * 0.02,
        size.width * 0.01, size.height * 0.05);
    path_1.cubicTo(size.width * 0.01, size.height * 0.29, size.width * 0.02,
        size.height * 0.76, size.width * 0.01, size.height * 0.99);
    path_1.quadraticBezierTo(size.width * 0.07, size.height * 0.98,
        size.width * 0.07, size.height * 0.95);
    path_1.lineTo(size.width * 0.07, size.height * 0.00);
    path_1.close();

    canvas.drawPath(path_1, paint_1);

    Paint paint_2 = new Paint()
      ..color = Color.fromARGB(255, 27, 2, 87)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.01, size.height * 0.99);
    path_2.lineTo(size.width * 0.95, size.height * 0.99);
    path_2.lineTo(size.width * 0.95, size.height * 0.98);
    path_2.lineTo(size.width * 0.04, size.height * 0.98);

    canvas.drawPath(path_2, paint_2);

    Paint paint_3 = new Paint()
      ..color = Color.fromARGB(255, 255, 243, 199)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;

    Path path_3 = Path();
    path_3.moveTo(size.width * 0.99, size.height * 0.95);
    path_3.quadraticBezierTo(size.width * 0.95, size.height * 0.97,
        size.width * 0.95, size.height * 0.98);
    path_3.cubicTo(size.width * 0.75, size.height * 0.98, size.width * 0.24,
        size.height * 0.98, size.width * 0.04, size.height * 0.98);
    path_3.cubicTo(size.width * 0.00, size.height * 0.99, size.width * 0.03,
        size.height * 0.95, size.width * 0.07, size.height * 0.95);
    path_3.quadraticBezierTo(size.width * 0.15, size.height * 0.95,
        size.width * 0.47, size.height * 0.95);

    canvas.drawPath(path_3, paint_3);

    // Paint paint_4 = new Paint()
    //   ..color = Color.fromARGB(255, 26, 1, 82)
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 5.0;

    // Path path_4 = Path();
    // path_4.moveTo(size.width * 0.13, size.height * 0.00);
    // path_4.lineTo(size.width * 0.13, size.height * 0.94);

    // canvas.drawPath(path_4, paint_4);

    Paint paint_5 = new Paint()
      ..color = Color.fromARGB(255, 0, 0, 0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    Path path_5 = Path();
    path_5.moveTo(size.width * 0.95, size.height * 0.97);
    path_5.lineTo(size.width * 0.52, size.height * 0.97);

    canvas.drawPath(path_5, paint_5);

    Paint paint_6 = new Paint()
      ..color = Color.fromARGB(255, 0, 0, 0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    Path path_6 = Path();
    path_6.moveTo(size.width * 0.96, size.height * 0.96);
    path_6.lineTo(size.width * 0.47, size.height * 0.96);

    canvas.drawPath(path_6, paint_6);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class IconAccount extends StatelessWidget {
  IconAccount({
    @required this.radious,
    Key key,
    this.imglink,
  }) : super(key: key);
  final double radious;
  final String imglink;
  final id = UsableData.getSetMillisecondsId();
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
            // Colors.pinkAccent.shade400,
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
              child: InkWell(
                onTap: () {
                  // print(id);
                  // if (imglink != null)
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ImageFull(
                                imgLink: imglink,
                                id: id,
                              )));
                },
                child: ClipOval(
                  child: Hero(
                    tag: id,
                    child: CachedNetworkImage(
                      imageUrl: imglink,
                      height: radious,
                      width: radious,
                      fit: BoxFit.cover,
                      errorWidget: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.error,
                            color: Colors.white,
                            size: CommonThings.size.width * .2,
                          ),
                        );
                      },
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Center(
                        child: CircularProgressIndicator(
                            value: downloadProgress.progress),
                      ),
                    ),
                    // child: Image.network(
                    //   imglink,
                    //   errorBuilder: (context, error, stackTrace) {
                    //     return Icon(
                    //       Icons.error,
                    //       color: Colors.white,
                    //       size: radious / 1.5,
                    //     );
                    //   },
                    //   loadingBuilder: (BuildContext context, Widget child,
                    //       ImageChunkEvent loadingProgress) {
                    //     if (loadingProgress == null) return child;
                    //     return Center(
                    //       child: CircularProgressIndicator(
                    //         strokeWidth: 7,
                    //         value: loadingProgress.expectedTotalBytes != null
                    //             ? loadingProgress.cumulativeBytesLoaded /
                    //                 loadingProgress.expectedTotalBytes
                    //             : null,
                    //       ),
                    //     );
                    //   },
                    //   fit: BoxFit.cover,
                    //   height: radious,
                    //   width: radious,
                    // ),
                  ),
                ),
              ),
            ),
    );
  }
}

class ImageFull extends StatelessWidget {
  final String imgLink;
  final String id;
  const ImageFull({
    Key key,
    this.imgLink,
    this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: CommonThings.size.width,
        height: CommonThings.size.height,
        child: InteractiveViewer(
            maxScale: 5,
            child: Hero(
              tag: id,
              child: CachedNetworkImage(
                imageUrl: imgLink,
                // height: radious,
                // width: radious,
                fit: BoxFit.contain,
                errorWidget: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.error,
                      color: Colors.red,
                      size: CommonThings.size.width * .2,
                    ),
                  );
                },
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                  child: CircularProgressIndicator(
                      value: downloadProgress.progress),
                ),
              ),

              // child: Image.network(
              //   imgLink,
              //   fit: BoxFit.contain,
              //   errorBuilder: (context, error, stackTrace) {
              //     return Icon(
              //       Icons.error,
              //       color: Colors.red,
              //       size: CommonThings.size.width * .25,
              //     );
              //   },
              //   loadingBuilder: (BuildContext context, Widget child,
              //       ImageChunkEvent loadingProgress) {
              //     if (loadingProgress == null) return child;
              //     return Center(
              //       child: CircularProgressIndicator(
              //         strokeWidth: 7,
              //         value: loadingProgress.expectedTotalBytes != null
              //             ? loadingProgress.cumulativeBytesLoaded /
              //                 loadingProgress.expectedTotalBytes
              //             : null,
              //       ),
              //     );
              //   },
              // ),
            )),
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
        width: CommonThings.size.width * .70,
        color: Color(0xff000247),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconAccount(
                      radious: CommonThings.size.width * .35,
                      imglink: UserProfileData.profilePicLink,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            UserProfileData.name == null
                                ? 'Loading..'
                                : UserProfileData.name,
                            style: kDrawerTextStyle.copyWith(fontSize: 22),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                    color: Color(0x00000000),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                    onPressed: () {
                      UsableData.getSetMillisecondsId();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileEditScreen(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.account_circle_outlined,
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
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                    color: Color(0x00000000),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                    onPressed: () {
                      // UsableData.getSetMillisecondsId();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InteractionsScreen(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.notifications_on_outlined,
                          color: Colors.white,
                          // size: 30,
                        ),
                        SizedBox(width: 18),
                        Text(
                          'Notification',
                          style: kDrawerTextStyle,
                        ),
                      ],
                    ),
                  ),
                  // RaisedButton(
                  //   padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  //   color: Color(0x00000000),
                  //   shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(0)),
                  //   onPressed: () async {
                  //     var snp = await GetBookData.bookDataSearch(
                  //         AllKeys.bookUploaderEmailKey,
                  //         FirebaseAuth.instance.currentUser.email);
                  //     Navigator.push(
                  //         context,
                  //         PageTransition(
                  //             curve: Curves.fastOutSlowIn,
                  //             child: ListOfBooksScreen(
                  //               snapshot: snp,
                  //               searchName: 'My Books',
                  //             ),
                  //             type: PageTransitionType.leftToRight));
                  //   },
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       Icon(
                  //         Icons.folder_open,
                  //         color: Colors.white,
                  //         // size: 30,
                  //       ),
                  //       SizedBox(width: 18),
                  //       Text(
                  //         'My Books',
                  //         style: kDrawerTextStyle,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                    color: Color(0x00000000),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      UserProfileData.tmVersity = null;
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
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
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
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              height: CommonThings.size.height,
              width: CommonThings.size.width,
              color: Colors.black.withOpacity(.7),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            height: CommonThings.size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Center(
                    child: SpinKitFadingCube(
                      size: CommonThings.size.width * .17,
                      itemBuilder: (BuildContext context, int index) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            color: index % 3 == 0
                                ? Colors.red
                                : Color(0xffffb8b24),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    msg == null ? 'Loading...' : msg,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
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
