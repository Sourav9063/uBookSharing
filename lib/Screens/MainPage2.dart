import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uBookSharing/Components/CompoundWidgets.dart';
import 'package:uBookSharing/Components/favCustom.dart';
import 'package:uBookSharing/BackEnd/Datas.dart';
import 'AddBookScreen.dart';
import 'AddRequestScreen.dart';

class MainPage2 extends StatefulWidget {
  MainPage2({Key key}) : super(key: key);

  @override
  _MainPage2State createState() => _MainPage2State();
}

class _MainPage2State extends State<MainPage2> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      body: ModalProgressHUD(
        inAsyncCall: false,
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
                            type: PageTransitionType.rightToLeftWithFade,
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
                          type: PageTransitionType.rightToLeftWithFade,
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
                    NavigationRail(destinations: [
                      NavigationRailDestination(icon: null),
                      NavigationRailDestination(icon: null),
                      NavigationRailDestination(icon: null),
                    ], selectedIndex: _selectedIndex)
                  ],
                ))),
      ),
    );
  }
}
