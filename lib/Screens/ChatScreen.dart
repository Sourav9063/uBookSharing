import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:uBookSharing/BackEnd/Datas.dart';
import 'package:uBookSharing/BackEnd/FireBase.dart';
import 'package:uBookSharing/Constants.dart';

class ChatScreen extends StatelessWidget {
  final String msgID;
  final String name;
  final QueryDocumentSnapshot? queryDocumentSnapshot;
  final TextEditingController textEditingController = TextEditingController();
  // final ScrollController scrollController = ScrollController();
  ChatScreen(
      {Key? key,
      required this.msgID,
      required this.name,
      this.queryDocumentSnapshot})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade900,
        title: Text(name),
      ),
      backgroundColor: Colors.cyan.shade700,
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: ChatsFirebase.getStreamMsg(msgID),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Msg> msgList =
                snapshot.data!.docs.map((e) => Msg.fromMap(e.data())).toList();
            if (msgList.length == 0 || msgList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Accept Request?",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          String toEmail =
                              queryDocumentSnapshot![AllKeys.emailKey];
                          String fromEmail = UserProfileData.email!;

                          String id =
                              UsableData.getIDFromEmails(toEmail, fromEmail);
                          AcceptReq acceptReq = AcceptReq(
                            interactionId: queryDocumentSnapshot!.reference.id,
                            chatID: id,
                            fromEmail: fromEmail,
                            toEmail: toEmail,
                            to: toEmail.replaceAll(new RegExp(r'[^\w\s]+'), ''),
                            fromName: UserProfileData.name!,
                            toName: queryDocumentSnapshot!["Name"],
                            fromPic: UserProfileData.profilePicLink!,
                            toPic: queryDocumentSnapshot!["ProfileLinkKey"],
                            time: Timestamp.fromDate(
                              DateTime.now(),
                            ),
                          );
                          try {
                            await ChatsFirebase.accept(
                                toEmail, fromEmail, acceptReq);
                            await ChatsFirebase.fromMe(
                                id,
                                Msg(
                                        msg: "Hi.",
                                        from: fromEmail,
                                        time:
                                            Timestamp.fromDate(DateTime.now()))
                                    .toMap());
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: Text("YES"))
                  ],
                ),
              );
            } else {
              return Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 8.0, right: 8, top: 4),
                      child: ListView.builder(
                        reverse: true,
                        // shrinkWrap: true,
                        // controller: scrollController,
                        physics: BouncingScrollPhysics(),
                        itemCount: msgList.length,
                        itemBuilder: (context, index) {
                          bool showTime = false;
                          if (index == msgList.length - 1)
                            showTime = true;
                          else {
                            if ((msgList[index].time.millisecondsSinceEpoch -
                                        msgList[index + 1]
                                            .time
                                            .millisecondsSinceEpoch)
                                    .abs() >
                                600000) showTime = true;
                          }

                          return Column(
                            children: [
                              // Text(
                              //     msgList[index].time.toDate().hour.toString() +
                              //         ':' +
                              //         msgList[index]
                              //             .time
                              //             .toDate()
                              //             .minute
                              //             .toString() +
                              //         '   ' +
                              //         UsableData.timestampToString(
                              //             msgList[index].time)),
                              // if (index > 0)
                              //   Text(msgList[index - 1]
                              //           .time
                              //           .toDate()
                              //           .hour
                              //           .toString() +
                              //       ':' +
                              //       msgList[index - 1]
                              //           .time
                              //           .toDate()
                              //           .minute
                              //           .toString() +
                              //       '   ' +
                              //       UsableData.timestampToString(
                              //           msgList[index].time)),
                              showTime
                                  ? Text(msgList[index]
                                          .time
                                          .toDate()
                                          .toString()
                                          .substring(10, 16) +
                                      "      " +
                                      UsableData.timestampToString(
                                          msgList[index].time))
                                  : SizedBox(),
                              Align(
                                alignment: msgList[index].from ==
                                        UserProfileData.email!
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxWidth: CommonThings.size.width * .77),
                                  child: Container(
                                      margin: EdgeInsets.all(2),
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: msgList[index].from ==
                                                UserProfileData.email!
                                            ? Colors.white70
                                            : Colors.white,
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
                                        msgList[index].msg + index.toString(),
                                        style: TextStyle(fontSize: 16),
                                      )),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, top: 4, bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: textEditingController,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: kTextFieldDecoration,
                            onEditingComplete: () {
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
              );
            }
          }
          return Center(child: CircularProgressIndicator());
        },
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
      ChatsFirebase.fromMe(msgID, _msg.toMap());
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

class AcceptReq {
  String to;
  String interactionId;
  String chatID;
  String fromEmail;
  String toEmail;
  String fromName;
  String toName;
  String bookName;
  String fromPic;
  String toPic;
  Timestamp time;
  AcceptReq({
    required this.to,
    required this.interactionId,
    required this.chatID,
    required this.fromEmail,
    required this.toEmail,
    required this.fromName,
    required this.toName,
    this.bookName = "",
    required this.fromPic,
    required this.toPic,
    required this.time,
  });

  AcceptReq copyWith({
    String? to,
    String? interactionId,
    String? chatID,
    String? fromEmail,
    String? toEmail,
    String? fromName,
    String? toName,
    String? bookName,
    String? fromPic,
    String? toPic,
    Timestamp? time,
  }) {
    return AcceptReq(
      to: to ?? this.to,
      interactionId: interactionId ?? this.interactionId,
      chatID: chatID ?? this.chatID,
      fromEmail: fromEmail ?? this.fromEmail,
      toEmail: toEmail ?? this.toEmail,
      fromName: fromName ?? this.fromName,
      toName: toName ?? this.toName,
      bookName: bookName ?? this.bookName,
      fromPic: fromPic ?? this.fromPic,
      toPic: toPic ?? this.toPic,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'to': to,
      'interactionId': interactionId,
      'chatID': chatID,
      'fromEmail': fromEmail,
      'toEmail': toEmail,
      'fromName': fromName,
      'toName': toName,
      'bookName': bookName,
      'fromPic': fromPic,
      'toPic': toPic,
      'time': time,
    };
  }

  factory AcceptReq.fromMap(Map<String, dynamic> map) {
    return AcceptReq(
      to: map['to'] ?? '',
      interactionId: map['interactionId'] ?? '',
      chatID: map['chatID'] ?? '',
      fromEmail: map['fromEmail'] ?? '',
      toEmail: map['toEmail'] ?? '',
      fromName: map['fromName'] ?? '',
      toName: map['toName'] ?? '',
      bookName: map['bookName'] ?? '',
      fromPic: map['fromPic'] ?? '',
      toPic: map['toPic'] ?? '',
      time: map['time'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AcceptReq.fromJson(String source) =>
      AcceptReq.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AcceptReq(to: $to, interactionId: $interactionId, chatID: $chatID, fromEmail: $fromEmail, toEmail: $toEmail, fromName: $fromName, toName: $toName, bookName: $bookName, fromPic: $fromPic, toPic: $toPic, time: $time)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AcceptReq &&
        other.to == to &&
        other.interactionId == interactionId &&
        other.chatID == chatID &&
        other.fromEmail == fromEmail &&
        other.toEmail == toEmail &&
        other.fromName == fromName &&
        other.toName == toName &&
        other.bookName == bookName &&
        other.fromPic == fromPic &&
        other.toPic == toPic &&
        other.time == time;
  }

  @override
  int get hashCode {
    return to.hashCode ^
        interactionId.hashCode ^
        chatID.hashCode ^
        fromEmail.hashCode ^
        toEmail.hashCode ^
        fromName.hashCode ^
        toName.hashCode ^
        bookName.hashCode ^
        fromPic.hashCode ^
        toPic.hashCode ^
        time.hashCode;
  }
}
