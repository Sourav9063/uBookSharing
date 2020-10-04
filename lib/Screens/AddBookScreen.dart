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
  String bookId =
      UserProfileData.email + UserProfileData.uploadedBookNo.toString();
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
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xfff4f1de),
                      borderRadius: BorderRadius.circular(16)),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
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
                        Form(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(),
                              ),
                              
                            
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
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
                  padding: const EdgeInsets.all(5.0),
                  child: IconButton(
                    icon: Icon(Icons.add_a_photo),
                    onPressed: () async {
                      await UploadIMG().getBookPic();
                      bookImgLink = await UploadIMG().uploadBookPic(bookId);
                      setState(() {
                        bookImgLink = bookImgLink;
                      });
                    },
                    color: Colors.white,
                    iconSize: CommonThings.size.width * .09,
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
            child: InkWell(
              child: Lottie.asset(
                'assets/lottie/AddLottie.json',
                fit: BoxFit.cover,
              ),
              onTap: null
              //  () async {
              //   print(UserProfileData.uploadedBookNo);
              //   GetUserData.setUploadedBookNo();
              // }
              ,
            ),
          ),
        ],
      ),
    );
  }
}
