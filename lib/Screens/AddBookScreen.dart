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
  bool visible = true;
  double picHeight = CommonThings.size.height * .60 + 20;
  double formTop = CommonThings.size.height * .60;
  void riseForm() {
    setState(() {
      visible = false;
      picHeight = CommonThings.size.height * .20 + 20;
      formTop = CommonThings.size.height * .20;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 600),
            curve: Curves.fastOutSlowIn,
            top: 0,
            left: 0,
            height: picHeight,
            child: InkWell(
              onTap: () {
                setState(() {
                  visible = true;
                  picHeight = CommonThings.size.height * .60 + 20;
                  formTop = CommonThings.size.height * .60;
                });
              },
              child: Container(
                width: CommonThings.size.width,
                child: BookImg(
                  radious: CommonThings.size.height * .60 + 20,
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
          ),
          AnimatedPositioned(
            curve: Curves.fastOutSlowIn,
            duration: Duration(milliseconds: 400),
            top: formTop,
            right: 0,
            width: CommonThings.size.width,
            child: InkWell(
              onTap: () {
                riseForm();
              },
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
                                  child: TextFormField(
                                    onTap: () {
                                      riseForm();
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Book\'s Name',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xff001a54),
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                  ),
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
          ),
          Positioned(
            right: 8,
            top: CommonThings.size.height * .60 - 30,
            child: Visibility(
              visible: visible,
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
                          visible = false;
                        });
                      },
                      color: Colors.white,
                      iconSize: CommonThings.size.width * .09,
                    ),
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
