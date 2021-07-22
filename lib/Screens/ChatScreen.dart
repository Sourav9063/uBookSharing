import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uBookSharing/BackEnd/Datas.dart';
import 'package:uBookSharing/BackEnd/FireBase.dart';
import 'package:uBookSharing/Constants.dart';

class ChatScreen extends StatelessWidget {
  final String docID;
  final String name;
  final TextEditingController textEditingController = TextEditingController();
  // final ScrollController scrollController = ScrollController();
  ChatScreen({Key? key, required this.docID, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade900,
        title: Text(name),
      ),
      backgroundColor: Colors.cyan.shade700,
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: ChatsFirebase().getStream(docID),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Msg> msgList = snapshot.data!.docs
                      .map((e) => Msg.fromMap(e.data()))
                      .toList();
                  if (msgList.length == 0 || msgList.isEmpty) {
                    return Center(
                        child: Text(
                      "Start chatting",
                    ));
                  } else
                    return ListView.builder(
                      reverse: true,
                      // shrinkWrap: true,
                      // controller: scrollController,
                      physics: BouncingScrollPhysics(),
                      itemCount: msgList.length,
                      itemBuilder: (context, index) {
                        return Align(
                            alignment:
                                msgList[index].from == UserProfileData.email!
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                            child: Container(
                                margin: EdgeInsets.all(2),
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomLeft: msgList[index].from ==
                                            UserProfileData.email!
                                        ? Radius.circular(20)
                                        : Radius.circular(0),
                                    bottomRight: msgList[index].from ==
                                            UserProfileData.email!
                                        ? Radius.circular(0)
                                        : Radius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  msgList[index].msg,
                                  style: TextStyle(fontSize: 16),
                                )));
                      },
                    );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textEditingController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: kTextFieldDecoration,
                    onSubmitted: (value) {
                      sendMsg();
                    },
                    // onTap: () {
                    //   UserProfileData.email = "dd";
                    // },
                  ),
                ),
                IconButton(
                    onPressed: () {
                      sendMsg();
                    },
                    icon: Icon(
                      Icons.send,
                      size: CommonThings.size.width * .08,
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  sendMsg() {
    if (textEditingController.text == "") return;
    try {
      Msg _msg = Msg(
          msg: textEditingController.text,
          from: UserProfileData.email!,
          time: Timestamp.fromDate(DateTime.now()));
      ChatsFirebase().fromMe(docID, _msg.toMap());
      textEditingController.clear();
    } catch (e) {}
  }
}

class Msg {
  String msg;
  String from;
  Timestamp time;
  Msg({
    required this.msg,
    required this.from,
    required this.time,
  });

  Msg copyWith({
    String? msg,
    String? from,
    Timestamp? time,
  }) {
    return Msg(
      msg: msg ?? this.msg,
      from: from ?? this.from,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'msg': msg,
      'from': from,
      'time': time,
    };
  }

  factory Msg.fromMap(Map<String, dynamic> map) {
    return Msg(
      msg: map['msg'] ?? '',
      from: map['from'] ?? '',
      time: map["time"],
    );
  }

  String toJson() => json.encode(toMap());

  factory Msg.fromJson(String source) => Msg.fromMap(json.decode(source));

  @override
  String toString() => 'Msg(msg: $msg, from: $from, time: $time)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Msg &&
        other.msg == msg &&
        other.from == from &&
        other.time == time;
  }

  @override
  int get hashCode => msg.hashCode ^ from.hashCode ^ time.hashCode;
}
