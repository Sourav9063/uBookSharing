import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uBookSharing/BackEnd/Datas.dart';
import 'package:uBookSharing/BackEnd/FireBase.dart';
import 'package:uBookSharing/Components/CompoundWidgets.dart';

import 'AddBookScreen.dart';

class Mainpage2 extends StatefulWidget {
  Mainpage2({Key key}) : super(key: key);

  @override
  _Mainpage2State createState() => _Mainpage2State();
}

class _Mainpage2State extends State<Mainpage2> {
  bool favVis = false;

  loadUser() async {
    String msg =
        await GetUserData.getUserData(FirebaseAuth.instance.currentUser.email);

    bookCardList = await GetBookData.getRecent10Books();

    if (msg == 'done') {
      setState(() {
        favVis = true;
        bookCardList = bookCardList;
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

  var bookCardList;
  @override
  void initState() {
    super.initState();
    loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      floatingActionButton: AnimatedOpacity(
        duration: Duration(milliseconds: 400),
        opacity: favVis ? 1 : 0,
        child: Visibility(
          visible: favVis,
          child: FloatingActionButton(
            isExtended: true,
            onPressed: () {
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
            backgroundColor: Color(0xfffb8b24),
            child: Icon(
              Icons.book,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          ListView.builder(
              itemCount: bookCardList.length,
              itemBuilder: (context, index) {
                return BookCard(
                  bookData: bookCardList[index],
                  width: CommonThings.size.width * .60,
                );
              })
        ],
      ),
    );
  }
}
