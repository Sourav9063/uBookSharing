import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uBookSharing/BackEnd/Datas.dart';
import 'package:uBookSharing/Screens/Homepage.dart';
import 'package:uBookSharing/Screens/profile.dart';

class BookImg extends StatelessWidget {
  final String imglink;
  final double radious;
  const BookImg({Key key, this.imglink, this.radious}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(imglink);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      height: radious * 4 / 3,
      width: radious,
      child: imglink == null
          ?
          //  Image.asset(
          //     'assets/img/AddBookImgL.png',
          //     fit: BoxFit.contain,
          //   )
          Lottie.asset('assets/lottie/bookLoading.json', fit: BoxFit.contain)
          // ColorFiltered(
          //     colorFilter: ColorFilter.mode(Colors.white, BlendMode.color),
          //     child: Image.asset(
          //       'assets/img/bookSharingPink.jpg',
          //       fit: BoxFit.cover,
          //     ),
          //   )
          : Image.network(
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
              height: radious,
              width: radious,
            ),
    );
  }
}

class BookCard extends StatelessWidget {
  final double width;
  final BookData bookData;
  final GestureTapCallback tap;
  const BookCard({
    Key key,
    this.bookData,
    @required this.width,
    this.tap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tap,
      child: Container(
        color: Color(0x00000000),
        height: width * .753, //.95 * .618,
        width: width,
        child: Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                // height: ,
                height: width * .753,
                width: width * .753,
                decoration: BoxDecoration(
                  color: Color(0xFFe8a76f),
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
                    radious: width * .50,
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
              width: width * .50,
              height: width * .753,
              child: Container(
                padding: EdgeInsets.all(6),
                // color: Colors.white54,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        bookData.bookName,
                        style: TextStyle(fontSize: width * .075),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        bookData.bookWriter,
                        style: TextStyle(fontSize: width * .06),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        bookData.bookFor,
                        style: TextStyle(fontSize: width * .055),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        bookData.bookTimeUpload.toDate().day.toString() +
                            '/' +
                            bookData.bookTimeUpload.toDate().month.toString() +
                            '/' +
                            bookData.bookTimeUpload.toDate().year.toString(),
                        style: TextStyle(fontSize: width * .075),
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
