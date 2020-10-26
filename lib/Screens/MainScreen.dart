import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:page_transition/page_transition.dart';
import 'package:uBookSharing/BackEnd/Datas.dart';
import 'package:uBookSharing/BackEnd/FireBase.dart';
import 'package:uBookSharing/Components/CompoundWidgets.dart';
import 'package:uBookSharing/Components/favCustom.dart';
import 'package:uBookSharing/Screens/AddBookScreen.dart';
import 'package:uBookSharing/Screens/AddRequestScreen.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool favVis = false;
  int lim = 5;

  loadUser() async {
    await GetBookData.getBookNameListFirebase();
    // print(GetBookData.bookNameList);
    String msg =
        await GetUserData.getUserData(FirebaseAuth.instance.currentUser.email);

    if (msg == 'done') {
      setState(() {
        favVis = true;
      });
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertsCompound(
            msg: 'Something Wrong',
            color: Colors.red.shade200,
            des: 'Try again',
            buttonTxt: 'OK',
            function: () {
              // spinner = false;
              Navigator.pop(context);
            },
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      // floatingActionButton: AnimatedOpacity(
      //   duration: Duration(milliseconds: 400),
      //   opacity: favVis ? 1 : 0,
      //   child: Visibility(
      //     visible: favVis,
      //     child: FloatingActionButton(
      //       isExtended: true,
      //       onPressed: () {
      //         Navigator.push(
      //           context,
      //           PageTransition(
      //             // duration: Duration(seconds:),
      //             // settings: RouteSettings(),
      //             child: AddBookScreen(),
      //             type: PageTransitionType.rightToLeftWithFade,
      //             alignment: Alignment.bottomRight,
      //             curve: Curves.fastOutSlowIn,
      //           ),
      //         );
      //       },
      //       backgroundColor: Color(0xfffb8b24),
      //       child: Icon(
      //         Icons.book,
      //         color: Colors.white,
      //       ),
      //     ),
      //   ),
      // ),
      drawer: CustomDrawer(),
      body: ModalProgressHUD(
        inAsyncCall: !favVis,
        progressIndicator: SpinkitFading(
          msg: 'Loading',
        ),
        child: Builder(
          builder: (context) => FabMenu(
            blur: 20,
            iconColor: Colors.white,
            fabColor: Theme.of(context).accentColor,
            icon: AnimatedIcons.menu_close,
            items: [
              FabMenuItem(
                  label: 'Upload Book',
                  ontap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        // duration: Duration(seconds:),
                        // settings: RouteSettings(),
                        child: AddBookScreen(),
                        type: PageTransitionType.rightToLeftWithFade,
                        alignment: Alignment.bottomRight,
                        curve: Curves.fastOutSlowIn,
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.book,
                    color: Colors.white,
                  ),
                  color: Color(0xff144552),
                  labelColor: Colors.white,
                  labelBackgroundColor: Color(0xff144552)),
              FabMenuItem(
                label: 'Add a request',
                ontap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      // duration: Duration(seconds:),
                      // settings: RouteSettings(),
                      child: AddRequestScreen(),
                      type: PageTransitionType.rightToLeftWithFade,
                      alignment: Alignment.bottomRight,
                      curve: Curves.fastOutSlowIn,
                    ),
                  );
                },
                icon: Icon(
                  Icons.sentiment_satisfied_outlined,
                  color: Colors.white,
                ),
                color: Color(0xff6F00FF),
                labelColor: Colors.white,
                labelBackgroundColor: Color(0xff6F00FF),
              )
            ],
            body: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  // title: Text(
                  //   'uBookSharing',
                  //   style: GoogleFonts.abrilFatface(
                  //       color: Color(0xff02effc), fontSize: 25),
                  // ),
                  // floating: false,
                  pinned: true,
                  // snap: true,
                  // floating: true,

                  backgroundColor: Color(0xff6F00FF),
                  expandedHeight: CommonThings.size.height * .25,
                  // collapsedHeight: CommonThings.size.height * .1,
                  flexibleSpace: FlexibleSpaceBar(
                    // titlePadding: EdgeInsets.only(
                    // bottom: CommonThings.size.width * 98 / 160 / 2, left: 20),
                    title: Text(
                      'uBookSharing',
                      style: GoogleFonts.abrilFatface(
                          color: Color(0xff02effc), fontSize: 20),
                    ),
                    background: Padding(
                      padding: const EdgeInsets.only(bottom: 25.0, top: 8),
                      child: FlareActor(
                        'assets/flr/sittingBook.flr',
                        fit: BoxFit.contain,
                        animation: 'Untitled',
                      ),
                    ),
                  ),
                ),
                SliverFillRemaining(
                  // hasScrollBody: false,
                  // fillOverscroll: true,

                  child: SafeArea(
                    child: Column(
                      children: [
                        SizedBox(
                          height: CommonThings.size.height * .065,
                        ),
                        Center(
                          child: Text('New Books'),
                        ),
                        SizedBox(
                          height: CommonThings.size.width * .7,
                          child: StreamBuilder(
                            stream: GetBookData.getRecentBookStream(
                                lim, 'AllBooks'),
                            builder:
                                (context, AsyncSnapshot<QuerySnapshot> snp) {
                              if (snp.hasData) {
                                if (snp.data.size == 0) {
                                  return Text('There are no requests');
                                } else {
                                  List<BookData> recentDataList;

                                  recentDataList = GetBookData
                                      .getBookDataObjFromQuerySnapshot(
                                          snp.data);

                                  List<Widget> bookcardList = [];
                                  for (BookData bookData in recentDataList) {
                                    bookcardList.add(Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: BookCard(
                                        width: CommonThings.size.width * .70,
                                        bookData: bookData,
                                      ),
                                    ));
                                  }

                                  bookcardList.add(
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (lim <= 30) lim = lim + 5;
                                        });
                                      },
                                      child: Center(
                                        child: ClipOval(
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text('Tap to see more'),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );

                                  return ListView(
                                    // shrinkWrap: true,

                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsets.all(8),
                                    // itemExtent: CommonThings.size.width * .40,
                                    children: bookcardList,
                                  );
                                }
                              } else if (snp.hasError) {
                                return Text(
                                    'Something went wrong. Restart the app');
                              } else
                                return Center(
                                    child: CircularProgressIndicator());
                            },
                          ),
                        ),
                        Center(
                          child: Text('New Requests'),
                        ),
                        Expanded(
                          // height: CommonThings.size.width * .6,
                          child: StreamBuilder(
                            stream:
                                GetBookData.getRecentBookStream(20, 'Requests'),
                            builder:
                                (context, AsyncSnapshot<QuerySnapshot> snp) {
                              if (snp.hasData) {
                                if (snp.data.size == 0) {
                                  return Text('There are no requests');
                                } else {
                                  List<BookData> recentDataList;

                                  recentDataList = GetBookData
                                      .getBookDataObjFromQuerySnapshot(
                                          snp.data);

                                  List<Widget> bookcard = [];
                                  for (BookData bookData in recentDataList) {
                                    bookcard.add(Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: BookCard(
                                        width: CommonThings.size.width * .6,
                                        bookData: bookData,
                                      ),
                                    ));
                                  }

                                  bookcard.add(Icon(Icons.add));

                                  return ListView(
                                    // crossAxisCount: 2,
                                    shrinkWrap: true,

                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsets.all(8),
                                    // itemExtent: CommonThings.size.width * .40,
                                    children: bookcard,
                                  );
                                }
                              } else if (snp.hasError) {
                                return Text(
                                    'Something went wrong. Restart the app');
                              } else
                                return Center(
                                    child: CircularProgressIndicator());
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
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
// 'subject=uBookSharing response&body=Hi {lender name},\n I\'m ${UserProfileData.name}. I\'m a student of ${UserProfileData.versityName}, department ${UserProfileData.dept}, year ${UserProfileData.admitted}. My registration number is ${UserProfileData.registrationNo}.\n Would you please share you book{book name}  with me. My personal phone Number is ${UserProfileData.phoneNum}. I currently live in ${UserProfileData.address}.\n Thanks for your contribution'
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

//  Expanded(
//     child: FutureBuilder(
//         future: GetBookData.getRecent10Books(),
//         builder: (context, bookList) {
//           if (bookList.hasData) {
//             if (bookList.data.length == 0)
//               return Text(
//                 'There are no Books 😞',
//                 style: TextStyle(fontSize: 20),
//               );
//             return ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: bookList.data.length,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: BookCard(
//                       tap: () {
//                         Navigator.push(context,
//                             MaterialPageRoute(
//                                 builder: (context) {
//                           return Mainpage2();
//                         }));
//                       },
//                       bookData: bookList.data[index],
//                       width: CommonThings.size.width * .80,
//                     ),
//                   );
//                 });
//           }
//           return SpinkitFading();
//         }),
//   ),

// child: Hero(
//   tag: 'Book',
//   child: Image.asset(
//     'assets/img/bookSharingPink.jpg',
//     fit: BoxFit.fill,
//   ),
// ),
// child: Lottie.asset(
//   'assets/lottie/appBar.json',
//   reverse: true,
// ),
