import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';

import 'package:page_transition/page_transition.dart';
import 'package:uBookSharing/BackEnd/Datas.dart';
import 'package:uBookSharing/BackEnd/FireBase.dart';
import 'package:uBookSharing/Components/CompoundWidgets.dart';
import 'package:uBookSharing/Screens/AddBookScreen.dart';
import 'package:uBookSharing/Screens/AddRequest.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool favVis = false;

  loadUser() async {
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
      backgroundColor: Color(0xfffff1e6),
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
      body: Builder(
        builder: (context) => HawkFabMenu(
          blur: 20,
          iconColor: Colors.white,
          fabColor: Theme.of(context).accentColor,
          icon: AnimatedIcons.menu_arrow,
          items: [
            HawkFabMenuItem(
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
            HawkFabMenuItem(
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
                pinned: true,
                // snap: true,
                // floating: true,
                backgroundColor: Color(0xff6F00FF),
                expandedHeight: CommonThings.size.width * .5,

                flexibleSpace: FlexibleSpaceBar(
                  // titlePadding: EdgeInsets.only(
                  // bottom: CommonThings.size.width * 98 / 160 / 2, left: 20),
                  title: Text(
                    'uBookSharing',
                    style: GoogleFonts.abrilFatface(
                        color: Color(0xff02effc), fontSize: 25),
                  ),
                  background: SafeArea(
                                      child: FlareActor(
                                        'assets/flr/sittingBook.flr',
                                        fit: BoxFit.contain,
                                        animation: 'Untitled',
                                      ),
                  ),
                ),
              ),
              SliverFillRemaining(
                child: Column(
                  children: [
                    SizedBox(
                      height: CommonThings.size.height * .065,
                    ),
                    Expanded(
                      child: Center(
                        child: Text('New Books'),
                      ),
                    ),
                    SizedBox(
                      height: CommonThings.size.width * .60 * .9,
                      child: StreamBuilder(
                        stream: GetBookData.getRecentBookStream(20, 'AllBooks'),
                        builder: (context, AsyncSnapshot<QuerySnapshot> snp) {
                          if (snp.hasData) {
                            if (snp.data.size == 0) {
                              return Text('There are no requests');
                            } else {
                              List<BookData> recentDataList;

                              recentDataList =
                                  GetBookData.getBookDataObjFromQuerySnapshot(
                                      snp.data);

                              List<Widget> bookcard = [];
                              for (BookData bookData in recentDataList) {
                                bookcard.add(Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: BookCard(
                                    width: CommonThings.size.width * .60,
                                    bookData: bookData,
                                  ),
                                ));
                              }

                              bookcard.add(
                                InkWell(
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('And many more'),
                                    ),
                                  ),
                                ),
                              );

                              return ListView(
                                // shrinkWrap: true,

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
                            return SpinkitFading();
                        },
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text('New Requests'),
                      ),
                    ),
                    SizedBox(
                      height: CommonThings.size.width * .40,
                      child: StreamBuilder(
                        stream: GetBookData.getRecentBookStream(20, 'Requests'),
                        builder: (context, AsyncSnapshot<QuerySnapshot> snp) {
                          if (snp.hasData) {
                            if (snp.data.size == 0) {
                              return Text('There are no requests');
                            } else {
                              List<BookData> recentDataList;

                              recentDataList =
                                  GetBookData.getBookDataObjFromQuerySnapshot(
                                      snp.data);

                              List<Widget> bookcard = [];
                              for (BookData bookData in recentDataList) {
                                bookcard.add(Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: BookCard(
                                    width: CommonThings.size.width * .40,
                                    bookData: bookData,
                                  ),
                                ));
                              }

                              bookcard.add(Icon(Icons.add));

                              return ListView(
                                // shrinkWrap: true,

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
                            return SpinkitFading();
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
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