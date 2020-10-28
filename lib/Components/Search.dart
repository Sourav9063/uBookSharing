import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uBookSharing/BackEnd/Datas.dart';
import 'package:uBookSharing/BackEnd/FireBase.dart';
import 'package:uBookSharing/Screens/ListOfBooksScreen.dart';

class SearchPageTest extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    // throw UnimplementedError();
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
        primaryColor: Color(0xfff01a54),
        primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.white),
        primaryColorBrightness: Brightness.dark,
        textTheme: TextTheme(headline6: TextStyle(color: Colors.white)));
  }

  @override
  Widget buildLeading(BuildContext context) {
    // throw UnimplementedError();

    return IconButton(
        icon: Icon(Icons.arrow_back_rounded),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  TextStyle get searchFieldStyle => GoogleFonts.abrilFatface(
        color: Color(0xbbffffff),
        fontSize: 20,
        // fontWeight: FontWeight.w500,
        // fontStyle: FontStyle.italic
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    // throw UnimplementedError();

    var tmpList = query == null || query == ''
        ? GetBookData.bookNameList
        : GetBookData.bookNameList
            .where((element) => element
                .toString()
                .toLowerCase()
                .startsWith(query.toLowerCase()))
            .toList();
    return tmpList.isEmpty
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
                    child: Text(
                      'No Book is Found',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      onPressed: () async {
                        var data = await GetBookData.bookDataGrSearch(
                            AllKeys.bookNameKey, query);

                        Navigator.push(
                            context,
                            PageTransition(
                                curve: Curves.fastOutSlowIn,
                                child: ListOfBooksScreen(
                                  snapshot: data,
                                  searchName: query,
                                ),
                                type: PageTransitionType.rightToLeft));
                      },
                      child: Text('Search entair database'),
                    ),
                  )
                ],
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                itemCount: tmpList.length,
                itemBuilder: (
                  context,
                  index,
                ) {
                  return Card(
                    color: Colors.white,
                    elevation: 8,
                    child: ListTile(
                      title: Text(tmpList[index]),
                      onTap: () async {
                        print(tmpList[index]);
                        var data = await GetBookData.bookDataSearch(
                            AllKeys.bookNameKey, tmpList[index]);

                        Navigator.push(
                            context,
                            PageTransition(
                                curve: Curves.fastOutSlowIn,
                                child: ListOfBooksScreen(
                                  snapshot: data,
                                  searchName: tmpList[index],
                                ),
                                type: PageTransitionType.rightToLeft));
                      },
                      leading: Icon(
                        Icons.folder_rounded,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  );
                }),
          );
  }

  @override
  Widget buildResults(BuildContext context) {
    throw UnimplementedError();
  }
}
