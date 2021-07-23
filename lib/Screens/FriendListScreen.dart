import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uBookSharing/BackEnd/Datas.dart';
import 'package:uBookSharing/BackEnd/FireBase.dart';
import 'package:uBookSharing/Components/CompoundWidgets.dart';
import 'package:uBookSharing/Screens/ChatScreen.dart';

class FriendListScreen extends StatelessWidget {
  const FriendListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade200,
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text("Responses"),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: ChatsFirebase.friendStream(UserProfileData.email!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<AcceptReq> friendsList = snapshot.data!.docs
                .map((e) => AcceptReq.fromMap(e.data()))
                .toList();
            if (friendsList.length == 0 || friendsList.isEmpty) {
              return Center(child: Text("No Responses"));
            }
            return ListView.builder(
              itemCount: friendsList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => ChatScreen(
                          msgID: friendsList[index].chatID,
                          name: friendsList[index].toName,
                          // queryDocumentSnapshot: dataSnapshot,
                        ),
                      ));
                    },
                    title: Text(friendsList[index].fromName),
                    subtitle: Text(friendsList[index].fromEmail),
                    contentPadding: EdgeInsets.all(8),
                    leading: IconAccount(
                      pad: 1,
                      radious: CommonThings.size.width * .14,
                      imglink: friendsList[index].fromPic,
                    ),
                  ),
                );
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
