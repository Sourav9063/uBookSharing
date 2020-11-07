import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uBookSharing/BackEnd/FireBase.dart';
import 'package:uBookSharing/Components/CompoundWidgets.dart';
import 'package:uBookSharing/Components/Search.dart';
import 'package:uBookSharing/Components/favCustom.dart';
import 'package:uBookSharing/BackEnd/Datas.dart';
import 'package:uBookSharing/Screens/InteractionsScreen.dart';

import 'package:vibration/vibration.dart';
import 'AddBookScreen.dart';
import 'AddRequestScreen.dart';

class MainScreenNew extends StatefulWidget {
  MainScreenNew({Key key}) : super(key: key);

  @override
  _MainScreenNewState createState() => _MainScreenNewState();
}

class _MainScreenNewState extends State<MainScreenNew> {
  // int _selectedIndex = 1;
  int pressed = 1;
  int lim = 5;
  int limReq = 5;
  double width = 0;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  PageController pagecontroller = PageController();

  Widget notiIcons = Icon(
    Icons.notifications_outlined,
    color: Colors.white,
  );

  bool favVis = false;
  loadUser() async {
    await GetBookData.getBookNameListFirebase();
    // print(GetBookData.bookNameList);
    String msg =
        await GetUserData.getUserData(FirebaseAuth.instance.currentUser.email);

    if (msg == 'done') {
      setState(() {
        favVis = true;
        width = CommonThings.size.width * .15;
      });
    } else {
      setState(() {
        favVis = false;
      });
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
    loadUser();
  
    final fcm = FirebaseMessaging();
    fcm.requestNotificationPermissions();
    fcm.configure(
      onLaunch: (message) {
        // print('OnLaunch');
        // print(message);
        // if (message != null)
        setState(() {
          notiIcons = Icon(
            Icons.notifications_active,
            color: Colors.lightBlue,
          );
        });
        return;
      },
      onMessage: (message) {
        // print('message');
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => InteractionsScreen()));
        setState(() {
          notiIcons = Icon(
            Icons.notifications_active,
            color: Colors.lightBlue,
          );
        });
        print(message);

        return;
      },
      onResume: (message) {
        // print('resume');
        setState(() {
          notiIcons = Icon(
            Icons.notifications_active,
            color: Colors.lightBlue,
          );
        });
        // print(message);

        return;
      },
    );
    // fcm.getToken();
    fcm.subscribeToTopic(FirebaseAuth.instance.currentUser.email
        .replaceAll(new RegExp(r'[^\w\s]+'), ''));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
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
                    UsableData.getSetMillisecondsId();
                    Navigator.push(
                      context,
                      PageTransition(
                        curve: Curves.fastOutSlowIn,
                        // duration: Duration(seconds:),
                        // settings: RouteSettings(),
                        child: AddBookScreen(),
                        type: PageTransitionType.rightToLeft,
                        alignment: Alignment.bottomRight,
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
                  UsableData.getSetMillisecondsId();
                  Navigator.push(
                    context,
                    PageTransition(
                      curve: Curves.fastOutSlowIn,
                      // duration: Duration(seconds:),
                      // settings: RouteSettings(),
                      child: AddRequestScreen(),
                      type: PageTransitionType.rightToLeft,
                      alignment: Alignment.bottomRight,
                    ),
                  );
                },
                icon: Icon(
                  Icons.sentiment_satisfied_alt,
                  color: Colors.white,
                ),
                color: Color(0xff6F00FF),
                labelColor: Colors.white,
                labelBackgroundColor: Color(0xff6F00FF),
              )
            ],
            body: Row(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 700),
                  curve: Curves.easeOutBack,
                  // curve: Cubic(0.7, .0, 0.7, 1.4),
                  width: width,
                  color: Color(0xffF01a54),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 16),
                            IconButton(
                              icon: Icon(
                                Icons.menu,
                                color: Colors.white,
                              ),
                              onPressed: () =>
                                  scaffoldKey.currentState.openDrawer(),
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  showSearch(
                                      context: context,
                                      delegate: SearchPageTest());
                                }),
                            IconButton(
                                splashColor: Theme.of(context).accentColor,
                                icon: notiIcons,
                                onPressed: () {
                                  setState(() {
                                    notiIcons = Icon(
                                      Icons.notifications_outlined,
                                      color: Colors.white,
                                    );
                                  });
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          curve: Curves.fastOutSlowIn,
                                          child: InteractionsScreen(),
                                          type:
                                              PageTransitionType.leftToRight));
                                })
                          ],
                        ),
                        Expanded(
                          child: RotatedBox(
                            quarterTurns: -1,
                            child: Padding(
                              padding: EdgeInsets.all(4),
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  UserProfileData.versityName.toUpperCase(),
                                  textScaleFactor: 1,
                                  style: GoogleFonts.lora(
                                    color: Color(0xff001a54),
                                    // fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    // fontStyle: FontStyle.italic
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Column(
                          children: [
                            RotatedBox(
                              quarterTurns: -1,
                              child: RaisedButton(
                                color: pressed == 1 ? null : Color(0xAA24217a),
                                onPressed: () async {
                                  // setState(() {
                                  //   pressed = 1;
                                  // });
                                  if (await Vibration.hasVibrator())
                                    Vibration.vibrate(duration: 50);
                                  pagecontroller.animateToPage(0,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.fastOutSlowIn);
                                },
                                child: Text(
                                  'New Books',
                                  textScaleFactor: 1,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: RotatedBox(
                                quarterTurns: -1,
                                child: RaisedButton(
                                  color:
                                      pressed == 2 ? null : Color(0xAA24217a),
                                  onPressed: () async {
                                    // setState(() {
                                    //   pressed = 2;
                                    // });
                                    if (await Vibration.hasVibrator())
                                      Vibration.vibrate(duration: 50);
                                    pagecontroller.animateToPage(1,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.fastOutSlowIn);
                                  },
                                  child: Text(
                                    'New Requests',
                                    textScaleFactor: 1,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            RotatedBox(
                              quarterTurns: -1,
                              child: RaisedButton(
                                color: pressed == 3 ? null : Color(0xAA24217a),
                                onPressed: () async {
                                  // setState(() {
                                  //   pressed = 3;
                                  // });
                                  if (await Vibration.hasVibrator())
                                    Vibration.vibrate(duration: 50);
                                  pagecontroller.animateToPage(2,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.fastOutSlowIn);
                                },
                                child: Text(
                                  'My Books',
                                  textScaleFactor: 1,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    // duration: Duration(milliseconds: 400),
                    // curve: Curves.easeInOut,
                    width: CommonThings.size.width - width,
                    // padding: EdgeInsets.all(8),
                    child: SafeArea(
                      child: PageView(
                        physics: BouncingScrollPhysics(),
                        controller: pagecontroller,
                        onPageChanged: (value) {
                          // print(value);
                          setState(() {
                            pressed = value + 1;
                          });
                        },
                        children: [
                          //New BOok
                          //
                          //
                          KeepAlivePage(
                                                      child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: CommonThings.size.height * .22,
                                  width: CommonThings.size.width * .85,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        height: CommonThings.size.height * .20,
                                        width: CommonThings.size.height * .25,
                                        bottom: 0,
                                        right: 0,
                                        child: FlareActor(
                                          'assets/flr/sittingBook.flr',
                                          fit: BoxFit.contain,
                                          animation: 'Untitled',
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Center(
                                          //   child: Padding(
                                          //     padding: EdgeInsets.all(4),
                                          //     child: FittedBox(
                                          //       fit: BoxFit.fitWidth,
                                          //       child: Text(
                                          //         UserProfileData.versityName,
                                          //         textScaleFactor: 1,
                                          //         style: GoogleFonts.lora(
                                          //           color: Color(0xff001a54),
                                          //           // fontSize: 30,
                                          //           fontWeight: FontWeight.bold,
                                          //           // fontStyle: FontStyle.italic
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                          Text(
                                            '   NewBooks',
                                            textScaleFactor: 2.5,
                                            style: GoogleFonts.abrilFatface(
                                              color: Color(0xff003aa4),
                                              // fontSize: 30,
                                              // fontWeight: FontWeight.w500,
                                              // fontStyle: FontStyle.italic
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: StreamBuilder(
                                    stream: GetBookData.getRecentBookStream(
                                        lim, 'AllBooks'),
                                    builder: (context, snp) {
                                      if (snp.hasData) {
                                        if (snp.data.size == 0) {
                                          return Column(
                                            children: [
                                              Container(
                                                height:
                                                    CommonThings.size.width * .50,
                                                // fit: BoxFit.contain,
                                                child: FlareActor(
                                                  'assets/flr/Not found.flr',
                                                  animation: 'idle',
                                                ),
                                              ),
                                              Text('There are no Books'),
                                            ],
                                          );
                                        } else {
                                          List<BookData> recentDataList;

                                          recentDataList = GetBookData
                                              .getBookDataObjFromQuerySnapshot(
                                                  snp.data);

                                          List<Widget> bookcardList = [];
                                          for (BookData bookData
                                              in recentDataList) {
                                            bookcardList.add(
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4.0,
                                                        horizontal: 5),
                                                child: BookCard(
                                                  width: CommonThings.size.width *
                                                      .7,
                                                  bookData: bookData,
                                                ),
                                              ),
                                            );
                                          }

                                          bookcardList.add(
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  if (lim <= 30) lim = lim + 5;
                                                });
                                              },
                                              child: Center(
                                                child: Container(
                                                  height:
                                                      CommonThings.size.height *
                                                          .25,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 36.0),
                                                    child: Text(
                                                      'Tap to see more',
                                                      textScaleFactor: 1.2,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );

                                          return ListView(
                                            physics: BouncingScrollPhysics(),
                                            // addAutomaticKeepAlives: true,
                                            cacheExtent: 9999,
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
                              ],
                            ),
                          ),
                          //New req
                          //
                          //
                          KeepAlivePage(
                                                      child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '   NewRequest',
                                  textScaleFactor: 2.5,
                                  style: GoogleFonts.abrilFatface(
                                    color: Color(0xff003aa4),
                                    // fontSize: 30,
                                    // fontWeight: FontWeight.w500,
                                    // fontStyle: FontStyle.italic
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Expanded(
                                  child: StreamBuilder(
                                    stream: GetBookData.getRecentBookStream(
                                        limReq, 'Requests'),
                                    builder: (context, snp) {
                                      if (snp.hasData) {
                                        if (snp.data.size == 0) {
                                          return Column(
                                            children: [
                                              Container(
                                                height:
                                                    CommonThings.size.width * .50,
                                                // fit: BoxFit.contain,
                                                child: FlareActor(
                                                  'assets/flr/Not found.flr',
                                                  animation: 'idle',
                                                ),
                                              ),
                                              Text('There are no Requests'),
                                            ],
                                          );
                                        } else {
                                          List<BookData> recentDataList;

                                          recentDataList = GetBookData
                                              .getBookDataObjFromQuerySnapshot(
                                                  snp.data);

                                          List<Widget> bookcardList = [];
                                          for (BookData bookData
                                              in recentDataList) {
                                            bookcardList.add(
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4.0,
                                                        horizontal: 5),
                                                child: BookCard(
                                                  width: CommonThings.size.width *
                                                      .7,
                                                  bookData: bookData,
                                                ),
                                              ),
                                            );
                                          }

                                          bookcardList.add(
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  if (limReq <= 30)
                                                    limReq = limReq + 5;
                                                });
                                              },
                                              child: Center(
                                                child: Container(
                                                  height:
                                                      CommonThings.size.height *
                                                          .25,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 36.0),
                                                    child: Text(
                                                      'Tap to see more',
                                                      textScaleFactor: 1,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );

                                          return ListView(
                                            cacheExtent: 9999,
                                            physics: BouncingScrollPhysics(),
                                            // shrinkWrap: true,

                                            // scrollDirection: Axis.horizontal,
                                            // padding: EdgeInsets.all(8),
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
                              ],
                            ),
                          ),
                          //My BOoks
                          //
                          KeepAlivePage(
                                                      child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '   MyBooks',
                                  textScaleFactor: 2.5,
                                  style: GoogleFonts.abrilFatface(
                                    color: Color(0xff003aa4),
                                    // fontSize: 30,
                                    // fontWeight: FontWeight.w500,
                                    // fontStyle: FontStyle.italic
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Expanded(
                                  child: StreamBuilder(
                                    stream: GetBookData.bookDataSearchStream(
                                        AllKeys.bookUploaderEmailKey,
                                        UserProfileData.email),
                                    builder: (context, snp) {
                                      if (snp.hasData) {
                                        if (snp.data.size == 0) {
                                          return Column(
                                            children: [
                                              Container(
                                                height:
                                                    CommonThings.size.width * .50,
                                                // fit: BoxFit.contain,
                                                child: FlareActor(
                                                  'assets/flr/Not found.flr',
                                                  animation: 'idle',
                                                ),
                                              ),
                                              Text('You haven\'t added any book'),
                                            ],
                                          );
                                        } else {
                                          List<BookData> recentDataList;

                                          recentDataList = GetBookData
                                              .getBookDataObjFromQuerySnapshot(
                                                  snp.data);

                                          List<Widget> bookcardList = [];
                                          for (BookData bookData
                                              in recentDataList) {
                                            bookcardList.add(
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4.0,
                                                        horizontal: 5),
                                                child: BookCard(
                                                  width: CommonThings.size.width *
                                                      .7,
                                                  bookData: bookData,
                                                ),
                                              ),
                                            );
                                          }

                                          return ListView(
                                            physics: BouncingScrollPhysics(),
                                            // shrinkWrap: true,

                                            // scrollDirection: Axis.horizontal,
                                            // padding: EdgeInsets.all(8),
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
                              ],
                            ),
                          ),
                        ],
                      ),
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




class KeepAlivePage extends StatefulWidget {
  KeepAlivePage({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _KeepAlivePageState createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    /// Dont't forget this
    super.build(context);

    return widget.child;
  }

  @override
  //  implement wantKeepAlive
  bool get wantKeepAlive => true;
}