import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:uBookSharing/BackEnd/Datas.dart';
import 'package:uBookSharing/BackEnd/UploadIMG.dart';
import 'package:uBookSharing/Components/CompoundWidgets.dart';

class AddBookScreen extends StatefulWidget {
  AddBookScreen({Key key}) : super(key: key);

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  String bookImgLink;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            height: CommonThings.size.height * .40 + 20,
            child: Container(
              width: CommonThings.size.width,
              child: BookImg(
                radious: CommonThings.size.height * .40 + 20,
                imglink: bookImgLink,
              ),
              // child: bookImgLink != null
              //     ? Image.network(
              //         bookImgLink,
              //         fit: BoxFit.cover,
              //       )
              //     : Image.asset(
              //         'assets/img/bookSharingPink.jpg',
              //         fit: BoxFit.cover,
              //       ),
            ),
          ),
          Positioned(
            top: CommonThings.size.height * .40,
            right: 0,
            width: CommonThings.size.width,
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xfff4f1de),
                  borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  Text(
                    'Add Book',
                    style: GoogleFonts.abrilFatface(
                      color: Color(0xffffe066),
                      fontSize: 38,
                      // fontWeight: FontWeight.w500,
                      // fontStyle: FontStyle.italic
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 8,
            top: CommonThings.size.height * .40 - 30,
            child: ClipOval(
              child: Container(
                color: Theme.of(context).accentColor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: IconButton(
                    icon: Icon(Icons.add_a_photo),
                    onPressed: () async {
                      await UploadIMG().getBookPic();
                      bookImgLink = await UploadIMG().uploadBookPic(
                          FirebaseAuth.instance.currentUser.email);
                      setState(() {
                        bookImgLink = bookImgLink;
                      });
                    },
                    color: Colors.white,
                    iconSize: CommonThings.size.width * .10,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            height: CommonThings.size.width * .25,
            width: CommonThings.size.width * .25,
            child:
                Lottie.asset('assets/lottie/AddLottie.json', fit: BoxFit.cover),
          ),
        ],
      ),
    );
  }
}
