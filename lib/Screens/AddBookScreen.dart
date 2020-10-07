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
  bool agree = false;
  double picHeight = CommonThings.size.height * .60 + 20;
  double formTop = CommonThings.size.height * .60;

  bool forTime = false;
  bool forPrice = false;
  void riseForm() {
    setState(() {
      visible = false;
      picHeight = CommonThings.size.height * .30 + 20;
      formTop = CommonThings.size.height * .30;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        
              child: Container(
          height: CommonThings.size.height,
          child: Stack(
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
                child: GestureDetector(
                  onPanUpdate: (details) {
                    if (details.delta.dy > 0) {
                      setState(() {
                        visible = true;
                        picHeight = CommonThings.size.height * .60 + 20;
                        formTop = CommonThings.size.height * .60;
                      });
                    } else if (details.delta.dy < 0) riseForm();
                  },
                  onTap: () {
                    riseForm();
                  },
                  child: Container(
                    height: CommonThings.size.height * .7,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Color(0xffF8F4FF),
                        borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            color: Color(0x33001a54),
                            height: 5,
                            width: 40,
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          'Add Book',
                          style: GoogleFonts.abrilFatface(
                            color: Color(0xff001a54),
                            fontSize: 38,
                            // fontWeight: FontWeight.w500,
                            // fontStyle: FontStyle.italic
                          ),
                        ),
                        Form(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BookFormField(
                                lebel: 'Book\'s Name',
                                hintText: 'Please provide the right name',
                                raiseForm: () {
                                  riseForm();
                                },
                                onChanged: (value) {
                                  BookData.bookName = value;
                                },
                                validate: (value) {
                                  if (value == null)
                                    return 'This field cannot be empty';
                                  return null;
                                },
                              ),
                              BookFormField(
                                lebel: 'Writer',
                                hintText: 'The main writer\'s name',
                                raiseForm: () {
                                  riseForm();
                                },
                                onChanged: (value) {
                                  BookData.bookWriter = value;
                                },
                                validate: (value) {
                                  if (value == null)
                                    return 'This field cannot be empty';
                                  return null;
                                },
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: BookFormField(
                                      lebel: 'Edition',
                                      hintText: 'Edition or released year',
                                      raiseForm: () {
                                        riseForm();
                                      },
                                      onChanged: (value) {
                                        BookData.bookName = value;
                                      },
                                      validate: (value) {
                                        if (value == null)
                                          return 'This field cannot be empty';
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Expanded(
                                      child: DropdownButtonFormField(
                                    onTap: () {
                                      riseForm();
                                    },
                                    validator: (value) {
                                      if (value == null)
                                        return 'This field cannot be empty';
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 17, horizontal: 8),
                                      filled: true,
                                      fillColor: Color(0xffffffff),
                                      labelText: 'For',
                                      hintText: 'Rent or Sell',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xff001a54),
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 2.5,
                                          color: Color(0xff6F00FF),
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    items: [
                                      DropdownMenuItem(
                                        child: Text('For Share',
                                            style: TextStyle(fontSize: 18)),
                                        value: 'For Share',
                                      ),
                                      DropdownMenuItem(
                                        child: Text('For Sell',
                                            style: TextStyle(fontSize: 18)),
                                        value: 'For Sell',
                                      ),
                                      DropdownMenuItem(
                                        child: Text('For Rent ',
                                            style: TextStyle(fontSize: 18)),
                                        value: 'For Rent',
                                      ),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        BookData.bookFor = value;
                                        if (value == 'For Share') {
                                          forTime = true;
                                          forPrice = false;
                                        } else if (value == 'For Rent') {
                                          forPrice = true;
                                          forTime = true;
                                        } else {
                                          forPrice = true;
                                          forTime = false;
                                        }
                                      });
                                    },
                                  ))
                                ],
                              ),
                              AnimatedOpacity(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeInCubic,
                                opacity: forPrice ? 1 : 0,
                                child: Visibility(
                                  visible: forPrice,
                                  child: BookFormField(
                                    lebel: 'Price',
                                    hintText: 'Enter fair amount',
                                    raiseForm: () {
                                      riseForm();
                                    },
                                    onChanged: (value) {
                                      BookData.bookPrice = value;
                                    },
                                    validate: (value) {
                                      if (value == null)
                                        return 'This field cannot be empty. Input 0 taka';
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              AnimatedOpacity(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeInCubic,
                                opacity: forTime ? 1 : 0,
                                child: Visibility(
                                  visible: forTime,
                                  child: BookFormField(
                                    lebel: 'Time',
                                    hintText: 'Be specific about time and date',
                                    raiseForm: () {
                                      riseForm();
                                    },
                                    onChanged: (value) {
                                      BookData.bookDes = value;
                                    },
                                    validate: (value) {
                                      if (value == null)
                                        return 'This cannot be empty';
                                    },
                                  ),
                                ),
                              ),
                              Text(
                                '*Please read carefully.\n The following informations will be visible to all user.\n- Your name.\n- Your profile picture.\n- Your department, year and registration no.\n- Your email address.\n- Book\'s informations.',
                                style: TextStyle(color: Colors.red),
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                      value: agree,
                                      onChanged: (val) {
                                        setState(() {
                                          agree = val;
                                          print(agree);
                                        });
                                      }),
                                  Text('I agree to share these information.')
                                ],
                              )
                            ],
                          ),
                        )
                      ],
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
                  onTap: () {
                    print(BookData.bookName);
                  }
                  //  () async {
                  //   print(UserProfileData.uploadedBookNo);
                  //   GetUserData.setUploadedBookNo();
                  // }
                  ,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
