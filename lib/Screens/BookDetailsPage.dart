import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uBookSharing/BackEnd/Datas.dart';
import 'package:uBookSharing/Components/CompoundWidgets.dart';
import 'package:url_launcher/url_launcher.dart';

class BookDetailsPage extends StatefulWidget {
  final BookData bookData;

  const BookDetailsPage({Key key, @required this.bookData}) : super(key: key);
  @override
  _BookDetailsPageState createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  double picHeight = CommonThings.size.width * 4 / 3;
  void smallPic() {
    setState(() {
      picHeight = CommonThings.size.width * .61;
    });
  }

  void bigPic() {
    setState(() {
      picHeight = CommonThings.size.width * 4 / 3;
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
              duration: Duration(milliseconds: 650),
              curve: Curves.fastOutSlowIn,
              top: 0,
              left: 0,
              height: picHeight,
              child: InkWell(
                onTap: () {
                  bigPic();
                },
                child: Hero(
                  tag: 'BookImg',
                  child: BookImg(
                    width: CommonThings.size.width,
                    imglink: widget.bookData.bookImgLink,
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 450),
              curve: Curves.fastOutSlowIn,
              top: picHeight - 20,
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
                          padding: EdgeInsets.fromLTRB(
                              8, 8, 8, CommonThings.size.width * .06),
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
                                    style: TextStyle(
                                      color: Color(0xffFFFFFF),
                                      fontSize: 18,
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
                                      fontSize: 18,
                                      // fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    'Uploaded: ' +
                                        widget.bookData.bookTimeUpload
                                            .toDate()
                                            .day
                                            .toString() +
                                        ' ' +
                                        UsableData.getMonthName(widget
                                            .bookData.bookTimeUpload
                                            .toDate()
                                            .month) +
                                        ', ' +
                                        widget.bookData.bookTimeUpload
                                            .toDate()
                                            .year
                                            .toString(),
                                    style: TextStyle(
                                      color: Color(0xffFFFFFF),
                                      fontSize: 18,
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
                                      fontSize: 22, color: Colors.white),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    widget.bookData.bookUploaderName,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      // fit: BoxFit.fitWidth,
                                      child: FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: SelectableText(
                                          'Email: ' +
                                              widget.bookData.bookUploaderEmail,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.content_copy_sharp,
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
                                    )
                                  ],
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
                                      child: Text(
                                        'Dept: ' +
                                            widget.bookData.bookUploaderDept,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          // fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        'Batch: ' +
                                            widget.bookData.bookUploaderBatch,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        RaisedButton(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
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
                                path: widget.bookData.bookUploaderEmail,
                                query: widget.bookData.bookFor == 'Buy' ||
                                        widget.bookData.bookFor == 'Rent'
                                    ? 'subject=uBookSharing response&body=Hi ${widget.bookData.bookUploaderName},\n I\'m ${UserProfileData.name}. I\'m a student of\n${UserProfileData.versityName},\nDepartment ${UserProfileData.dept},\nBatch ${UserProfileData.admitted}.\nRegistration number ${UserProfileData.registrationNo}.' +
                                        'You have requested for a book name \"${widget.bookData.bookName}\" to ${widget.bookData.bookFor.toLowerCase()}.\nI have the book' +
                                        '\nMy personal phone number is \n${UserProfileData.phoneNum}.\nI currently live in ${UserProfileData.address}. Contact me to get this book.\nThanks for your contribution.'
                                    : 'subject=uBookSharing response&body=Hi ${widget.bookData.bookUploaderName},\n I\'m ${UserProfileData.name}. I\'m a student of\n${UserProfileData.versityName},\nDepartment ${UserProfileData.dept},\nBatch ${UserProfileData.admitted}.\nRegistration number ${UserProfileData.registrationNo}.' +
                                        '\nYou have added a book name \"${widget.bookData.bookName}\" ${widget.bookData.bookFor.toLowerCase()}. I am in need of that book. I have read your terms and I agree to fulfill those. Would you please share your book with me' +
                                        '\nMy personal phone number is \n${UserProfileData.phoneNum}.\nI currently live in ${UserProfileData.address}. Please send me a Email or Message containing your phone number and current address.\nThanks for your contribution.'

                                // queryParameters: {
                                //   'subject': 'uBookSharing+response ',
                                //   'body':
                                //       'Hi {lender name},\n I\'m ${UserProfileData.name}. I\'m a student of ${UserProfileData.versityName}, department ${UserProfileData.dept}, year${UserProfileData.admitted}. My registration no. ${UserProfileData.registrationNo}.\n Would you please share you book{book name}  with me. My personal phone No. ${UserProfileData.phoneNum}. I currently live in ${UserProfileData.address}. Thanks for your contribution'
                                // },

                                );
                            String launchEmailUrl = launchEmailData.toString();
                            if (await canLaunch(launchEmailUrl)) {
                              await launch(launchEmailUrl);
                            } else {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      "Can\'t send automated email. Try sending manually")));
                            }
                          },
                        ),
                        SizedBox(
                          height: 2,
                        )
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
                top: 0,
                left: -40,
                height: CommonThings.size.width * .3,
                width: CommonThings.size.width * .4,
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
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                'Time: ${widget.bookData.bookTime}',
                style: TextStyle(
                  color: Color(0xffFFFFFF),
                  fontSize: 18,
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
              fontSize: 18,
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
            fontSize: 18,
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
