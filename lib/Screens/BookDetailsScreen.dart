import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uBookSharing/BackEnd/Datas.dart';
import 'package:uBookSharing/BackEnd/FireBase.dart';
import 'package:uBookSharing/Components/CompoundWidgets.dart';
import 'package:uBookSharing/Components/bluredDialog.dart';
import 'package:uBookSharing/Constants.dart';

import 'package:url_launcher/url_launcher.dart';

class BookDetailsScreen extends StatefulWidget {
  final BookData bookData;

  const BookDetailsScreen({Key key, @required this.bookData}) : super(key: key);
  @override
  _BookDetailsScreenState createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  double picHeight = CommonThings.size.width * 4 / 2.5;
  // double bottom=CommonThings.size.height
  GlobalKey _bottomCard = GlobalKey();
  bool button = true;
  buttonState() {
    setState(() {
      button = false;
    });
  }

  void smallPic() {
    setState(() {
      picHeight = CommonThings.size.height -
          _bottomCard.currentContext.size.height * 1.1;
      // picHeight = 0;
    });
  }

  void bigPic() {
    setState(() {
      picHeight = CommonThings.size.width * 4 / 2.5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,

      body: Builder(
        builder: (context) => Stack(
          children: [
            AnimatedPositioned(
              duration: Duration(milliseconds: 750),
              curve: Curves.fastOutSlowIn,
              top: 0,
              left: 0,
              height: picHeight,
              child: InkWell(
                onTap: () {
                  bigPic();
                },
                child: Container(
                  width: CommonThings.size.width,
                  child: BookImg(
                    width: CommonThings.size.width,
                    imglink: widget.bookData.bookImgLink,
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 550),
              curve: Curves.fastOutSlowIn,
              top: picHeight - 20,
              // bottom: picHeight + 20,
              child: GestureDetector(
                onPanUpdate: (details) {
                  // print(details.delta.direction);
                  if (details.delta.dy > 0) {
                    bigPic();
                  } else if (details.delta.dy < 0) {
                    smallPic();
                  }
                },
                onTap: () {
                  smallPic();
                },
                child: Container(
                  key: _bottomCard,
                  decoration: BoxDecoration(
                    color: Color(0xffe8e8f8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  width: CommonThings.size.width,
                  // height:
                  //     CommonThings.size.height - CommonThings.size.width * .6,
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                          decoration: BoxDecoration(
                              color: Color(0xff001a54),
                              borderRadius: BorderRadius.circular(16)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: CommonThings.size.width * .04),
                                  height: 7,
                                  width: CommonThings.size.width * .23,
                                  decoration: BoxDecoration(
                                      color: Colors.white24,
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                              ),
                              Center(
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    widget.bookData.bookName,
                                    style: GoogleFonts.abrilFatface(
                                      color: Color(0xffFFFFFF),
                                      fontSize: 26,
                                      // fontWeight: FontWeight.w500,
                                      // fontStyle: FontStyle.italic
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    widget.bookData.bookWriter,
                                    style: GoogleFonts.sacramento(
                                      color: Color(0xffFFFFFF),
                                      fontSize: 24,
                                      // fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    'Edition: ${widget.bookData.bookEdition}',
                                    style: TextStyle(
                                      color: Color(0xffFFFFFF),
                                      fontSize: 16,
                                      // fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: widget.bookData.bookTimeUploadString ==
                                          null
                                      ? Text(
                                          'Uploaded: ' +
                                              UsableData.timestampToString(
                                                  widget
                                                      .bookData.bookTimeUpload),
                                          style: TextStyle(
                                            color: Color(0xffFFFFFF),
                                            fontSize: 16,
                                            // fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      : Text(
                                          'Added: ' +
                                              widget.bookData
                                                  .bookTimeUploadString,
                                          style: TextStyle(
                                            color: Color(0xffFFFFFF),
                                            fontSize: 16,
                                            // fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                ),
                              ),
                              forWhat(widget.bookData.bookFor),
                              widget.bookData.bookDes != null
                                  ? Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          widget.bookData.bookDes,
                                          style: TextStyle(
                                            color: Color(0xffFFFFFF),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          'No Description available',
                                          style: TextStyle(
                                            color: Color(0xffFFFFFF),
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xfff01a54),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  widget.bookData.bookFor == 'Buy' ||
                                          widget.bookData.bookFor == 'Rent'
                                      ? 'Requested By'
                                      : 'Owner Information',
                                  style: GoogleFonts.abrilFatface(
                                      fontSize: 24, color: Colors.white70),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Center(
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      widget.bookData.bookUploaderName,
                                      style: GoogleFonts.lora(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: SelectableText(
                                        'Email: ' +
                                            widget.bookData.bookUploaderEmail,
                                        // textScaleFactor: 1,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ),
                                    Expanded(
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.content_copy_rounded,
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                        onPressed: () {
                                          Clipboard.setData(ClipboardData(
                                              text: widget
                                                  .bookData.bookUploaderEmail));

                                          Scaffold.of(context)
                                              .showSnackBar(SnackBar(
                                            backgroundColor:
                                                Colors.blueAccent.shade700,
                                            content: Text(
                                                'Email address copied to clipboard'),
                                          ));
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    'Dept: ' + widget.bookData.bookUploaderDept,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      // fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    'Batch: ${widget.bookData.bookUploaderBatch}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        FirebaseAuth.instance.currentUser.email ==
                                widget.bookData.bookUploaderEmail
                            ? RaisedButton(
                                padding: EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                elevation: 10,
                                child: Center(
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  showDialog(
                                      // barrierColor: Colors.white12,
                                      // child: Text('Hellow'),

                                      context: (context),
                                      builder: (context) => BlurredDialog(
                                            height:
                                                CommonThings.size.height * .2,
                                            width:
                                                CommonThings.size.width * .90,
                                            blurColorWithOpacity:
                                                Colors.white.withOpacity(.3),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Are you sure',
                                                      textScaleFactor: 1.4,
                                                      style: GoogleFonts.lora(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      '?',
                                                      textScaleFactor: 1.45,
                                                      style: GoogleFonts.lora(
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                Divider(
                                                  color: Colors.white10,
                                                  thickness: .5,
                                                ),
                                                Text(
                                                  'You are about to delete your book.',
                                                  textScaleFactor: 1.1,
                                                  // style: GoogleFonts.lora(
                                                  //   color: Colors.white,
                                                  // ),
                                                  style: kDefaultWhiteTextStyle,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    FlatButton(
                                                        color: Colors.red,
                                                        onPressed: () async {
                                                          await GetBookData.bookDataDelete(
                                                              widget.bookData
                                                                  .docId,
                                                              widget.bookData.bookFor ==
                                                                          'Buy' ||
                                                                      widget.bookData
                                                                              .bookFor ==
                                                                          'Rent'
                                                                  ? 'Requests'
                                                                  : 'AllBooks');
                                                          await StorageSettings
                                                              .deleteImage(widget
                                                                  .bookData
                                                                  .bookImgLink);
                                                          Navigator.popUntil(
                                                              context,
                                                              ModalRoute
                                                                  .withName(
                                                                      "Foo"));
                                                        },
                                                        child: Text(
                                                          'Yes',
                                                          style:
                                                              kDefaultWhiteTextStyle,
                                                        )),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    FlatButton(
                                                        color: Colors.white38,
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          'No',
                                                          style:
                                                              kDefaultWhiteTextStyle,
                                                        )),
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                      // AlertDialog(
                                      //   backgroundColor: Colors.red.shade300,
                                      //   title: Text("Are you sure?"),
                                      //   content: Text(
                                      //       'You are about to delete your book'),
                                      //   actions: [
                                      //     TextButton(
                                      //         onPressed: () async {
                                      //           await GetBookData.bookDataDelete(
                                      //               widget.bookData.docId,
                                      //               widget.bookData.bookFor ==
                                      //                           'Buy' ||
                                      //                       widget.bookData
                                      //                               .bookFor ==
                                      //                           'Rent'
                                      //                   ? 'Requests'
                                      //                   : 'AllBooks');
                                      //           await StorageSettings.deleteImage(
                                      //               widget.bookData.bookImgLink);
                                      //           Navigator.popUntil(context,
                                      //               ModalRoute.withName("Foo"));
                                      //         },
                                      //         child: Text('Yes')),
                                      //     TextButton(
                                      //         onPressed: () {
                                      //           Navigator.pop(context);
                                      //         },
                                      //         child: Text('No')),
                                      //   ],
                                      // ),
                                      );
                                },
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: RaisedButton(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      elevation: 10,
                                      child: Center(
                                        child: Text(
                                          'Send Email',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        final Uri launchEmailData = Uri(
                                            scheme: 'mailto',
                                            path: widget
                                                .bookData.bookUploaderEmail,
                                            query: widget.bookData.bookFor ==
                                                        'Buy' ||
                                                    widget.bookData.bookFor ==
                                                        'Rent'
                                                ? 'subject=uBookSharing response&body=Hi ${widget.bookData.bookUploaderName},\n I\'m ${UserProfileData.name}. I\'m a student of\n${UserProfileData.versityName},\nDepartment ${UserProfileData.dept},\nBatch ${UserProfileData.admitted},\nRegistration number ${UserProfileData.registrationNo}.' +
                                                    'You have requested for a book name \"${widget.bookData.bookName}\" to ${widget.bookData.bookFor.toLowerCase()}.\nI have the book' +
                                                    '\nMy personal phone number is \n${UserProfileData.phoneNum}.\nI currently live in ${UserProfileData.address}. Contact me to get this book.\nThanks for your contribution.'
                                                : 'subject=uBookSharing response&body=Hi ${widget.bookData.bookUploaderName},\n I\'m ${UserProfileData.name}. I\'m a student of\n${UserProfileData.versityName},\nDepartment ${UserProfileData.dept},\nBatch ${UserProfileData.admitted},\nRegistration number ${UserProfileData.registrationNo}.' +
                                                    '\nYou have added a book name \"${widget.bookData.bookName}\" ${widget.bookData.bookFor.toLowerCase()} on ${UsableData.timestampToString(widget.bookData.bookTimeUpload)}. I am in need of that book. I have read your terms and I agree to fulfill those. Would you please share your book with me.' +
                                                    '\nMy personal phone number is \n${UserProfileData.phoneNum}.\nI currently live in ${UserProfileData.address}. Please send me a mail or message containing your phone number and current address.\nThanks for your contribution.'

                                            // queryParameters: {
                                            //   'subject': 'uBookSharing+response ',
                                            //   'body':
                                            //       'Hi {lender name},\n I\'m ${UserProfileData.name}. I\'m a student of ${UserProfileData.versityName}, department ${UserProfileData.dept}, year${UserProfileData.admitted}. My registration no. ${UserProfileData.registrationNo}.\n Would you please share you book{book name}  with me. My personal phone No. ${UserProfileData.phoneNum}. I currently live in ${UserProfileData.address}. Thanks for your contribution'
                                            // },

                                            );
                                        String launchEmailUrl =
                                            launchEmailData.toString();
                                        if (await canLaunch(launchEmailUrl)) {
                                          await launch(launchEmailUrl);
                                        } else {
                                          Scaffold.of(context).showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      "Can\'t send automated email. Try sending manually")));
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Expanded(
                                    child: RaisedButton(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      elevation: 10,
                                      child: Text(
                                        button
                                            ? 'Send Message'
                                            : 'Message sent',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                      onPressed: button
                                          ? () {
                                              showDialog(
                                                  context: (context),
                                                  builder:
                                                      (context) =>
                                                          BlurredDialog(
                                                            height: CommonThings
                                                                    .size
                                                                    .height *
                                                                .5,
                                                            width: CommonThings
                                                                    .size
                                                                    .width *
                                                                .90,
                                                            blurColorWithOpacity:
                                                                Colors.white
                                                                    .withOpacity(
                                                                        .3),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        'Are you sure',
                                                                        textScaleFactor:
                                                                            1.4,
                                                                        style: GoogleFonts.lora(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.bold),
                                                                      ),
                                                                      Text(
                                                                        '?',
                                                                        textScaleFactor:
                                                                            1.45,
                                                                        style: GoogleFonts.lora(
                                                                            color:
                                                                                Colors.red,
                                                                            fontWeight: FontWeight.bold),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Divider(
                                                                  color: Colors
                                                                      .white10,
                                                                  thickness: .5,
                                                                ),
                                                                Text(
                                                                  widget.bookData
                                                                          .bookUploaderName +
                                                                      ' will receive the following message.',
                                                                  textScaleFactor:
                                                                      1.1,
                                                                  // style: GoogleFonts.lora(
                                                                  //   color: Colors.white,
                                                                  // ),
                                                                  style:
                                                                      kDefaultWhiteTextStyle,
                                                                ),
                                                                Expanded(
                                                                  flex: 3,
                                                                  child:
                                                                      SingleChildScrollView(
                                                                    physics:
                                                                        BouncingScrollPhysics(),
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Text(
                                                                        widget.bookData.bookFor == 'Buy' || widget.bookData.bookFor == 'Rent'
                                                                            ? '\"Hi ${widget.bookData.bookUploaderName},\nI\'m ${UserProfileData.name}. I\'m a student of\n${UserProfileData.versityName},\nDepartment ${UserProfileData.dept},\nBatch ${UserProfileData.admitted},\nRegistration number ${UserProfileData.registrationNo}.' +
                                                                                'You have requested for a book name \"${widget.bookData.bookName}\" to ${widget.bookData.bookFor.toLowerCase()}.\nI have the book' +
                                                                                '\nMy personal phone number is \n${UserProfileData.phoneNum}.\nI currently live in ${UserProfileData.address}.'
                                                                            : '\"Hi ${widget.bookData.bookUploaderName},\nI\'m ${UserProfileData.name}. I\'m a student of\n${UserProfileData.versityName},\nDepartment ${UserProfileData.dept},\nBatch ${UserProfileData.admitted},\nRegistration number ${UserProfileData.registrationNo}.' +
                                                                                '\nYou have added a book name \"${widget.bookData.bookName}\" ${widget.bookData.bookFor.toLowerCase()} on ${UsableData.timestampToString(widget.bookData.bookTimeUpload)}. I am in need of that book. I have read your terms and I agree to fulfill those. Would you please share your book with me.' +
                                                                                '\nMy personal phone number is \n${UserProfileData.phoneNum}.\nI currently live in ${UserProfileData.address}. Please send me a mail or message containing your phone number and current address.\"',
                                                                        style: kDefaultWhiteTextStyle.copyWith(
                                                                            color:
                                                                                Colors.white70),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    FlatButton(
                                                                        color: Colors
                                                                            .blueAccent
                                                                            .shade700,
                                                                        onPressed: button
                                                                            ? () async {
                                                                                String response = widget.bookData.bookFor == 'Buy' || widget.bookData.bookFor == 'Rent' ? 'Hi ${widget.bookData.bookUploaderName},\nI\'m ${UserProfileData.name}. I\'m a student of\n${UserProfileData.versityName},\nDepartment ${UserProfileData.dept},\nBatch ${UserProfileData.admitted},\nRegistration number ${UserProfileData.registrationNo}.' + 'You have requested for a book name \"${widget.bookData.bookName}\" to ${widget.bookData.bookFor.toLowerCase()}.\nI have the book' + '\nMy personal phone number is \n${UserProfileData.phoneNum}.\nI currently live in ${UserProfileData.address}.' : 'Hi ${widget.bookData.bookUploaderName},\nI\'m ${UserProfileData.name}. I\'m a student of\n${UserProfileData.versityName},\nDepartment ${UserProfileData.dept},\nBatch ${UserProfileData.admitted},\nRegistration number ${UserProfileData.registrationNo}.' + '\nYou have added a book name \"${widget.bookData.bookName}\" ${widget.bookData.bookFor.toLowerCase()} on ${UsableData.timestampToString(widget.bookData.bookTimeUpload)}. I am in need of that book. I have read your terms and I agree to fulfill those. Would you please share your book with me.' + '\nMy personal phone number is \n${UserProfileData.phoneNum}.\nI currently live in ${UserProfileData.address}. Please send me a mail or message containing your phone number and current address.';

                                                                                String responseFor = widget.bookData.bookFor == 'Buy' || widget.bookData.bookFor == 'Rent' ? 'Response to request' : 'Interested about your book';

                                                                                Map<String, dynamic> map = {
                                                                                  AllKeys.emailKey: UserProfileData.email,
                                                                                  AllKeys.phnNumKey: UserProfileData.phoneNum,
                                                                                  AllKeys.profilePicLinkKey: UserProfileData.profilePicLink,
                                                                                  AllKeys.bookForKey: widget.bookData.bookFor,
                                                                                  AllKeys.bookDesKey: response,
                                                                                  'To': widget.bookData.bookUploaderEmail.replaceAll(new RegExp(r'[^\w\s]+'), ''),
                                                                                  'SentKey': DateTime.now(),
                                                                                  'Response For': responseFor,
                                                                                  'Name': UserProfileData.name,
                                                                                };
                                                                                await Interactions.writeMsg(widget.bookData.bookUploaderEmail, map);

                                                                                buttonState();
                                                                                Navigator.pop(context);
                                                                              }
                                                                            : null,
                                                                        child: Text(
                                                                          'Yes',
                                                                          style:
                                                                              kDefaultWhiteTextStyle,
                                                                        )),
                                                                    SizedBox(
                                                                      width: 8,
                                                                    ),
                                                                    FlatButton(
                                                                        color: Colors
                                                                            .white38,
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'No',
                                                                          style:
                                                                              kDefaultWhiteTextStyle,
                                                                        )),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          )

                                                  //     AlertDialog(
                                                  //   backgroundColor:
                                                  //       Colors.greenAccent,
                                                  //   title: Text('Are you sure?'),
                                                  // content: Text(widget.bookData
                                                  //         .bookUploaderName +
                                                  //     ' will receive a message containing your email, phone number and address.'),
                                                  //   actions: [
                                                  //     TextButton(
                                                  //         onPressed: button
                                                  //             ? () async {
                                                  //                 String response = widget.bookData.bookFor ==
                                                  //                             'Buy' ||
                                                  //                         widget.bookData.bookFor ==
                                                  //                             'Rent'
                                                  //                     ? 'Hi ${widget.bookData.bookUploaderName},\nI\'m ${UserProfileData.name}. I\'m a student of\n${UserProfileData.versityName},\nDepartment ${UserProfileData.dept},\nBatch ${UserProfileData.admitted},\nRegistration number ${UserProfileData.registrationNo}.' +
                                                  //                         'You have requested for a book name \"${widget.bookData.bookName}\" to ${widget.bookData.bookFor.toLowerCase()}.\nI have the book' +
                                                  //                         '\nMy personal phone number is \n${UserProfileData.phoneNum}.\nI currently live in ${UserProfileData.address}.'
                                                  //                     : 'Hi ${widget.bookData.bookUploaderName},\nI\'m ${UserProfileData.name}. I\'m a student of\n${UserProfileData.versityName},\nDepartment ${UserProfileData.dept},\nBatch ${UserProfileData.admitted},\nRegistration number ${UserProfileData.registrationNo}.' +
                                                  //                         '\nYou have added a book name \"${widget.bookData.bookName}\" ${widget.bookData.bookFor.toLowerCase()} on ${UsableData.timestampToString(widget.bookData.bookTimeUpload)}. I am in need of that book. I have read your terms and I agree to fulfill those. Would you please share your book with me.' +
                                                  //                         '\nMy personal phone number is \n${UserProfileData.phoneNum}.\nI currently live in ${UserProfileData.address}. Please send me a mail or message containing your phone number and current address.';

                                                  //                 String responseFor = widget.bookData.bookFor ==
                                                  //                             'Buy' ||
                                                  //                         widget.bookData.bookFor ==
                                                  //                             'Rent'
                                                  //                     ? 'Response to request'
                                                  //                     : 'Interested about your book';

                                                  //                 Map<String,
                                                  //                         dynamic>
                                                  //                     map = {
                                                  //                   AllKeys.emailKey:
                                                  //                       UserProfileData
                                                  //                           .email,
                                                  //                   AllKeys.phnNumKey:
                                                  //                       UserProfileData
                                                  //                           .phoneNum,
                                                  //                   AllKeys.profilePicLinkKey:
                                                  //                       UserProfileData
                                                  //                           .profilePicLink,
                                                  //                   AllKeys.bookForKey:
                                                  //                       widget
                                                  //                           .bookData
                                                  //                           .bookFor,
                                                  //                   AllKeys.bookDesKey:
                                                  //                       response,
                                                  //                   'To': widget
                                                  //                       .bookData
                                                  //                       .bookUploaderEmail
                                                  //                       .replaceAll(
                                                  //                           new RegExp(
                                                  //                               r'[^\w\s]+'),
                                                  //                           ''),
                                                  //                   'SentKey':
                                                  //                       DateTime
                                                  //                           .now(),
                                                  //                   'Response For':
                                                  //                       responseFor,
                                                  //                   'Name':
                                                  //                       UserProfileData
                                                  //                           .name,
                                                  //                 };
                                                  //                 await Interactions
                                                  //                     .writeMsg(
                                                  //                         widget
                                                  //                             .bookData
                                                  //                             .bookUploaderEmail,
                                                  //                         map);

                                                  //                 buttonState();
                                                  //                 Navigator.pop(
                                                  //                     context);
                                                  //               }
                                                  //             : null,
                                                  //         child: Text('Yes'),),
                                                  //     TextButton(
                                                  //         onPressed: () {
                                                  //           Navigator.pop(
                                                  //               context);
                                                  //         },
                                                  //         child: Text('No')),
                                                  //   ],
                                                  // ),
                                                  );
                                            }
                                          : null,
                                    ),
                                  )
                                ],
                              ),
                        SizedBox(
                          height: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 650),
              curve: Curves.easeOutBack,
              top: picHeight - CommonThings.size.width * .26 / 1.5,
              right: 0,
              child: IconAccount(
                radious: CommonThings.size.width * .25,
                imglink: widget.bookData.bookUploaderImg,
              ),
            ),
            Positioned(
                top: CommonThings.size.width * .15,
                left: -CommonThings.size.width * .17,
                height: CommonThings.size.width * .3,
                width: CommonThings.size.width * .6,
                child: Center(
                  child: Transform(
                    origin: Offset(CommonThings.size.width * .15, 0),
                    transform: Matrix4.rotationZ(-0.785398),
                    child: Container(
                      height: CommonThings.size.width * .08,
                      width: CommonThings.size.width,
                      color: Color(0xbbfb8b24),
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            widget.bookData.bookFor,
                            style: GoogleFonts.aBeeZee(
                                fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget forWhat(String forWhat) {
    if (forWhat == 'For Rent' || forWhat == 'Rent') {
      return Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                'Price: ${widget.bookData.bookPrice}',
                style: TextStyle(
                  color: Color(0xffFFFFFF),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                'Time: ${widget.bookData.bookTime}',
                style: TextStyle(
                  color: Color(0xffFFFFFF),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (forWhat == 'For Share') {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            'Time: ${widget.bookData.bookTime}',
            style: TextStyle(
              color: Color(0xffffffff),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Text(
          'Price: ${widget.bookData.bookPrice}',
          style: TextStyle(
            color: Color(0xffffffff),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// RaisedButton(
//           elevation: 10,
//           child: Icon(Icons.mail_outline),
//           onPressed: () async {
//             final Uri launchEmailData = Uri(
//                 scheme: 'mailto',
//                 path: widget.bookData.bookUploaderEmail,
//                 query:
//                     'subject=uBookSharing response&body=Hi ${widget.bookData.bookUploaderName},\n I\'m ${UserProfileData.name}. I\'m a student of ${UserProfileData.versityName}, department ${UserProfileData.dept}, year ${UserProfileData.admitted}. My registration number is ${UserProfileData.registrationNo}.\n Would you please share you book \'${widget.bookData.bookName}\'  with me. My personal phone Number is ${UserProfileData.phoneNum}. I currently live in ${UserProfileData.address}.\n Thanks for your contribution'
//                 // queryParameters: {
//                 //   'subject': 'uBookSharing+response ',
//                 //   'body':
//                 //       'Hi {lender name},\n I\'m ${UserProfileData.name}. I\'m a student of ${UserProfileData.versityName}, department ${UserProfileData.dept}, year${UserProfileData.admitted}. My registration no. ${UserProfileData.registrationNo}.\n Would you please share you book{book name}  with me. My personal phone No. ${UserProfileData.phoneNum}. I currently live in ${UserProfileData.address}. Thanks for your contribution'
//                 // },

//                 );
//             String launchEmailUrl = launchEmailData.toString();
//             if (await canLaunch(launchEmailUrl)) {
//               await launch(launchEmailUrl);
//             } else {
//               print('hwwww');
//               Scaffold.of(context).showSnackBar(SnackBar(
//                   content: Text(
//                       "Can\'t send automated email. Try sending manually")));
//             }
//           },
//         ),
