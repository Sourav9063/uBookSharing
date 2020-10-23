import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uBookSharing/BackEnd/Datas.dart';
import 'package:uBookSharing/Components/CompoundWidgets.dart';

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
      body: Stack(
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                width: CommonThings.size.width,
                height: CommonThings.size.height - CommonThings.size.width * .6,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: CommonThings.size.width * .04),
                        height: 7,
                        width: CommonThings.size.width * .23,
                        decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          widget.bookData.bookName,
                          style: GoogleFonts.abrilFatface(
                            color: Color(0xff001a54),
                            fontSize: 28,
                            // fontWeight: FontWeight.w500,
                            // fontStyle: FontStyle.italic
                          ),
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          widget.bookData.bookWriter,
                          style: TextStyle(
                            color: Color(0xff001a54),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                'Edition: ${widget.bookData.bookEdition}',
                                style: TextStyle(
                                  color: Color(0xff001a54),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                'Uploaded: ${widget.bookData.bookTimeUpload.toDate().day.toString()}/${widget.bookData.bookTimeUpload.toDate().month.toString()}/${widget.bookData.bookTimeUpload.toDate().year.toString().substring(2, 4)}',
                                style: TextStyle(
                                  color: Color(0xff001a54),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      forWhat(widget.bookData.bookFor),
                      widget.bookData.bookDes != null
                          ? Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                  'Description: ${widget.bookData.bookDes}'),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text('No Description available'),
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
                      child: Text(
                        widget.bookData.bookFor,
                        style: GoogleFonts.aBeeZee(
                            fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget forWhat(String forWhat) {
    if (forWhat == 'For Rent') {
      return Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                'Price: ${widget.bookData.bookPrice}',
                style: TextStyle(
                  color: Color(0xff001a54),
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                'Time: ${widget.bookData.bookTime}',
                style: TextStyle(
                  color: Color(0xff001a54),
                  fontSize: 20,
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
              color: Color(0xff001a54),
              fontSize: 20,
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
            color: Color(0xff001a54),
            fontSize: 20,
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
