import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uBookSharing/BackEnd/Datas.dart';
import 'package:uBookSharing/BackEnd/FireBase.dart';
import 'package:uBookSharing/Components/CompoundWidgets.dart';
import 'package:url_launcher/url_launcher.dart';

class InteractionsScreen extends StatefulWidget {
  InteractionsScreen({Key key}) : super(key: key);

  @override
  _InteractionsScreenState createState() => _InteractionsScreenState();
}

class _InteractionsScreenState extends State<InteractionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
      ),
      backgroundColor: Color(0xfffff1e6),
      body: StreamBuilder(
        stream: Interactions.getMsgStream(UserProfileData.email),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.documents.length == 0) {
              return Padding(
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
                            'No notification',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                var dataSnapshot = snapshot.data.documents[index];
                Timestamp timestamp = dataSnapshot['SentKey'];
                return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconAccount(
                              radious: CommonThings.size.width * .2,
                              imglink: dataSnapshot[AllKeys.profilePicLinkKey],
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.phone,
                                  color: Colors.green,
                                ),
                                onPressed: () async {
                                  Clipboard.setData(ClipboardData(
                                      text: dataSnapshot[AllKeys.phnNumKey]));

                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text(
                                        'Phone number copied to clipboard'),
                                  ));

                                  String url =
                                      'tel:' + dataSnapshot[AllKeys.phnNumKey];
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  }
                                }),
                            IconButton(
                                icon: Icon(
                                  Icons.mail,
                                  color: Colors.blueAccent.shade700,
                                ),
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(
                                      text: dataSnapshot[AllKeys.emailKey]));

                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    backgroundColor: Colors.blueAccent.shade700,
                                    content: Text(
                                        'Email address copied to clipboard'),
                                  ));
                                }),
                            IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  String id = dataSnapshot.reference.id;
                                  await Interactions.deleteDocWithId(
                                      UserProfileData.email, id);
                                  setState(() {});
                                })
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: CommonThings.size.width * .1,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20))),
                          constraints: BoxConstraints(
                              maxWidth: CommonThings.size.width -
                                  20 -
                                  CommonThings.size.width * .2),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  dataSnapshot['Response For'],
                                  style: GoogleFonts.abrilFatface(fontSize: 18),
                                ),
                                SizedBox(
                                  height: 9,
                                ),
                                Text('Sent: ' +
                                    timestamp.toDate().hour.toString() +
                                    ':' +
                                    timestamp.toDate().minute.toString() +
                                    '   ' +
                                    UsableData.timestampToString(timestamp)),
                                Divider(
                                  thickness: 2,
                                ),
                                SelectableText(
                                    dataSnapshot[AllKeys.bookDesKey]),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ));
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
