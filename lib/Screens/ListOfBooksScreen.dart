import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:uBookSharing/BackEnd/Datas.dart';
import 'package:uBookSharing/BackEnd/FireBase.dart';
import 'package:uBookSharing/Components/CompoundWidgets.dart';

import 'package:uBookSharing/Screens/AddRequestScreen.dart';

class ListOfBooksScreen extends StatefulWidget {
  final QuerySnapshot<Map<String, dynamic>> snapshot;
  final String? searchName;
  ListOfBooksScreen({Key? key, required this.snapshot, this.searchName})
      : super(key: key);

  @override
  _ListOfBooksScreenState createState() => _ListOfBooksScreenState();
}

class _ListOfBooksScreenState extends State<ListOfBooksScreen> {
  late List<BookData> bookData;
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
        title: Text(
          widget.searchName!,
          textScaleFactor: 1,
        ),
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
                          'There are no books listed named "${widget.searchName}"',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          UsableData.getSetMillisecondsId();
                          Navigator.pushAndRemoveUntil(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => AddRequestScreen()),
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
                  physics: BouncingScrollPhysics(),
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
