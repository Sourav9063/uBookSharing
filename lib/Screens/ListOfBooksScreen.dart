import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uBookSharing/BackEnd/Datas.dart';
import 'package:uBookSharing/BackEnd/FireBase.dart';
import 'package:uBookSharing/Components/CompoundWidgets.dart';

import 'package:uBookSharing/Screens/AddRequestScreen.dart';

class ListOfBooksScreen extends StatefulWidget {
  final QuerySnapshot snapshot;
  final String searchName;
  ListOfBooksScreen({Key key, @required this.snapshot, this.searchName})
      : super(key: key);

  @override
  _ListOfBooksScreenState createState() => _ListOfBooksScreenState();
}

class _ListOfBooksScreenState extends State<ListOfBooksScreen> {
  List<BookData> bookData;
  loadBook() async {
    bookData = GetBookData.getBookDataObjFromQuerySnapshot(widget.snapshot);
  }

  @override
  void initState() {
    super.initState();
    loadBook();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff001a54),
        title: Text(widget.searchName),
      ),
      body: bookData.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      height: CommonThings.size.width * .50,
                      // fit: BoxFit.contain,
                      child: FlareActor(
                        'assets/flr/Not found.flr',
                        animation: 'idle',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          'There are no books listed name "${widget.searchName}"',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        onPressed: () async {
                          UsableData.getSetMillisecondsId();
                          Navigator.pushAndRemoveUntil(
                              context,
                              PageTransition(
                                  curve: Curves.fastOutSlowIn,
                                  child: AddRequestScreen(),
                                  type: PageTransitionType.bottomToTop),
                              ModalRoute.withName("Foo"));
                        },
                        child: Text('Add a request'),
                      ),
                    )
                  ],
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: ListView.builder(
                  cacheExtent: 9999,
                  itemCount: bookData.length,
                  itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4),
                        child: BookCard(
                          width: CommonThings.size.width * .8,
                          bookData: bookData[index],
                        ),
                      )),
            ),
    );
  }
}
