import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uBookSharing/BackEnd/Datas.dart';
import 'package:uBookSharing/BackEnd/FireBase.dart';
import 'package:uBookSharing/Components/CompoundWidgets.dart';
import 'package:uBookSharing/Screens/AddBookScreen.dart';


class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    setState(() {
      GetUserData.getUserData(FirebaseAuth.instance.currentUser.email);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        isExtended: true,
        onPressed: () {
          Navigator.push(
            context,
            PageTransition(
              child: AddBookScreen(),
              type: PageTransitionType.scale,
              alignment: Alignment.bottomRight,
              curve: Curves.easeIn,
            ),
          );
        },
        backgroundColor: Color(0xfffb8b24),
        child: Icon(
          Icons.book,
          color: Colors.white,
        ),
      ),
      drawer: CustomDrawer(),
      body: Builder(
        builder: (context) => CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              // title: Text(
              //   'uBookSharing',
              //   style: GoogleFonts.abrilFatface(
              //       color: Color(0xff02effc), fontSize: 25),
              // ),
              pinned: true,
              backgroundColor: Color(0xff343669),
              expandedHeight: CommonThings.size.width * 16 / 19,

              flexibleSpace: FlexibleSpaceBar(
                // titlePadding: EdgeInsets.only(
                // bottom: CommonThings.size.width * 98 / 160 / 2, left: 20),
                title: Text(
                  'uBookSharing',
                  style: GoogleFonts.abrilFatface(
                      color: Color(0xff02effc), fontSize: 25),
                ),
                background: Container(
                  child: Hero(
                    tag: 'Book',
                    child: Image.asset(
                      'assets/img/bookSharingPink.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  // child: Lottie.asset(
                  //   'assets/lottie/appBar.json',
                  //   reverse: true,
                  // ),
                ),
              ),
            ),
            SliverFillRemaining(
              child: Center(
                  child: BookCard(
                width: CommonThings.size.width*.8,
              )),
            )
          ],
        ),
      ),
    );
  }
}

// RaisedButton(
//                   elevation: 10,
//                   child: Icon(Icons.mail_outline),
//                   onPressed: () async {
//                     final Uri launchEmailData = Uri(
//                         scheme: 'mailto',
//                         path: 'sourav68@student.sust.edu',
//                         query:
//                             'subject=uBookSharing response&body=Hi {lender name},\n I\'m ${UserProfileData.name}. I\'m a student of ${UserProfileData.versityName}, department ${UserProfileData.dept}, year ${UserProfileData.admitted}. My registration number is ${UserProfileData.registrationNo}.\n Would you please share you book{book name}  with me. My personal phone Number is ${UserProfileData.phoneNum}. I currently live in ${UserProfileData.address}.\n Thanks for your contribution'
//                         // queryParameters: {
//                         //   'subject': 'uBookSharing+response ',
//                         //   'body':
//                         //       'Hi {lender name},\n I\'m ${UserProfileData.name}. I\'m a student of ${UserProfileData.versityName}, department ${UserProfileData.dept}, year${UserProfileData.admitted}. My registration no. ${UserProfileData.registrationNo}.\n Would you please share you book{book name}  with me. My personal phone No. ${UserProfileData.phoneNum}. I currently live in ${UserProfileData.address}. Thanks for your contribution'
//                         // },

//                         );
//                     String launchEmailUrl = launchEmailData.toString();
//                     if (await canLaunch(launchEmailUrl)) {
//                       await launch(launchEmailUrl);
//                     } else {
//                       print('hwwww');
//                       Scaffold.of(context).showSnackBar(SnackBar(
//                           content: Text(
//                               "Can\'t send automated email. Try sending manually")));
//                     }
//                   },
//                 ),
