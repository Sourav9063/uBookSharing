import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:uBookSharing/BackEnd/Datas.dart';
// import 'package:uBookSharing/BackEnd/FireBase.dart';
import 'package:uBookSharing/BackEnd/UploadIMG.dart';
import 'package:uBookSharing/Components/CompoundWidgets.dart';

class AddRequestScreen extends StatefulWidget {
  AddRequestScreen({Key? key}) : super(key: key);

  @override
  _AddRequestScreenState createState() => _AddRequestScreenState();
}

class _AddRequestScreenState extends State<AddRequestScreen> {
  String? bookImgLink;

  //     UserProfileData.email + UserProfileData.uploadedBookNo.toString();
  bool ignore = true;
  bool visible = true;
  bool? agree = false;
  bool valdated = false;
  double picHeight = CommonThings.size.height * .60 + 20;
  double formTop = CommonThings.size.height * .60;
  final _formKeyBook = GlobalKey<FormState>();
  // double keyboardHeight = 0;
  bool forTime = false;
  bool forPrice = false;
  BookData bookData = BookData();
  void riseForm() {
    setState(() {
      ignore = false;
      visible = false;
      picHeight = CommonThings.size.height * .20 + 20;
      formTop = CommonThings.size.height * .20;

      // keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      // if (keyboardHeight == 0) {
      //   // keyboardHeight = CommonThings.size.height * .10;
      // }
    });
  }

  late ScrollController controller;
  scrlLstnr() {
    // print(controller.offset);
    if (controller.offset > 15) {
      riseForm();
    } else if (controller.offset == 0) {
      setState(() {
        // FocusScope.of(context).unfocus();
        // keyboardHeight = 0;
        visible = true;
        picHeight = CommonThings.size.height * .60 + 20;
        formTop = CommonThings.size.height * .60;
      });
    }
  }

  @override
  void initState() {
    // controller = ScrollController();
    // controller.addListener(() {
    //   scrlLstnr();
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(keyboardHeight);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Builder(
        builder: (context) => Stack(
          children: [
            AnimatedPositioned(
              duration: Duration(milliseconds: 600),
              curve: Curves.fastOutSlowIn,
              top: 0,
              left: 0,
              height: picHeight,
              child: InkWell(
                onTap: () {
                  //  print(bookId);
                  setState(() {
                    ignore = true;
                    visible = true;
                    picHeight = CommonThings.size.height * .60 + 20;
                    formTop = CommonThings.size.height * .60;
                  });
                },
                child: Container(
                  width: CommonThings.size.width,
                  child: BookImg(
                    width: CommonThings.size.height * .60 + 20,
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
              bottom: MediaQuery.of(context).viewInsets.bottom,
              child: GestureDetector(
                onPanUpdate: (details) {
                  if (details.delta.dy > 0) {
                    setState(() {
                      ignore = false;
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
                  // height: CommonThings.size.height * .8 -
                  //     MediaQuery.of(context).viewInsets.bottom,
                  padding:
                      EdgeInsets.only(top: 16, left: 12, right: 12, bottom: 12),
                  decoration: BoxDecoration(
                      color: Color(0xffF8F4FF),
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(
                              bottom: CommonThings.size.width * .03),
                          height: 7,
                          width: CommonThings.size.width * .2,
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                      Expanded(
                        child: IgnorePointer(
                          ignoring: visible,
                          child: SingleChildScrollView(
                            // controller: controller,
                            physics: BouncingScrollPhysics(),
                            child: Form(
                              key: _formKeyBook,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Center(
                                  //   child: ClipRRect(
                                  //     borderRadius: BorderRadius.circular(20),
                                  //     child: Container(
                                  //       color: Color(0x33001a54),
                                  //       height: 5,
                                  //       width: 40,
                                  //     ),
                                  //   ),
                                  // ),
                                  Center(
                                    child: Text(
                                      'Request',
                                      style: GoogleFonts.abrilFatface(
                                        color: Color(0xff001a54),
                                        fontSize: 38,
                                        // fontWeight: FontWeight.w500,
                                        // fontStyle: FontStyle.italic
                                      ),
                                    ),
                                  ),
                                  BookFormField(
                                    cap: TextCapitalization.words,
                                    lebel: 'Book\'s Name',
                                    hintText: 'Please provide the right name',
                                    raiseForm: () {
                                      riseForm();
                                    },
                                    onChanged: (value) {
                                      bookData.bookName = value;
                                    },
                                    validate: (value) {
                                      if (value == null || value == '')
                                        return 'This field cannot be empty';
                                      return null;
                                    },
                                  ),
                                  BookFormField(
                                    cap: TextCapitalization.words,
                                    lebel: 'Writer',
                                    hintText: 'The main writer\'s name',
                                    raiseForm: () {
                                      riseForm();
                                    },
                                    onChanged: (value) {
                                      bookData.bookWriter = value;
                                    },
                                    validate: (value) {
                                      if (value == null || value == '')
                                        return 'This field cannot be empty';
                                      return null;
                                    },
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: BookFormField(
                                          lebel: 'Edition',
                                          hintText: 'Edition or released year',
                                          raiseForm: () {
                                            riseForm();
                                            // print(MediaQuery.of(context).viewInsets.bottom);
                                          },
                                          onChanged: (value) {
                                            bookData.bookEdition = value;
                                          },
                                          validate: (value) {
                                            if (value == null || value == '')
                                              return 'This field cannot be empty';
                                            return null;
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Expanded(
                                          child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: DropdownButtonFormField(
                                          onTap: () {
                                            riseForm();
                                          },
                                          validator: (dynamic value) {
                                            if (value == null)
                                              return 'This field cannot be empty';
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 17,
                                                    horizontal: 8),
                                            filled: true,
                                            fillColor: Color(0xffffffff),
                                            labelText: 'Want to',
                                            hintText: 'Rent or Buy',
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xff001a54),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                width: 2.5,
                                                color: Color(0xff6F00FF),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                          ),
                                          items: [
                                            // DropdownMenuItem(
                                            //   child: Text('For Share',
                                            //       style: TextStyle(fontSize: 18)),
                                            //   value: 'For Share',
                                            // ),
                                            DropdownMenuItem(
                                              child: Text('Buy',
                                                  style:
                                                      TextStyle(fontSize: 18)),
                                              value: 'Buy',
                                            ),
                                            DropdownMenuItem(
                                              child: Text('Rent ',
                                                  style:
                                                      TextStyle(fontSize: 18)),
                                              value: 'Rent',
                                            ),
                                          ],
                                          onChanged: (dynamic value) {
                                            setState(() {
                                              bookData.bookFor = value;
                                              if (value == 'Buy') {
                                                forTime = false;
                                                forPrice = true;
                                              } else if (value == 'Rent') {
                                                forPrice = true;
                                                forTime = true;
                                              } else {
                                                forPrice = false;
                                                forTime = false;
                                              }
                                            });
                                          },
                                        ),
                                      ))
                                    ],
                                  ),
                                  AnimatedOpacity(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeInCubic,
                                    opacity: forPrice ? 1 : 0,
                                    child: Visibility(
                                      visible: forPrice,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: TextFormField(
                                          onEditingComplete: () =>
                                              FocusScope.of(context)
                                                  .nextFocus(),
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(fontSize: 18),
                                          onTap: () {
                                            riseForm();
                                          },
                                          onChanged: (value) {
                                            bookData.bookPrice = value;
                                          },
                                          validator: (value) {
                                            if (value == null || value == '')
                                              return 'This field cannot be empty. Input 0 taka';
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            // contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                            filled: true,
                                            fillColor: Color(0xffffffff),
                                            labelText: 'Price',
                                            hintText:
                                                'Enter the amount you want to pay',
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xff001a54),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                width: 2,
                                                color: Color(0xff6F00FF),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                          ),
                                        ),
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
                                        cap: TextCapitalization.words,
                                        lebel: 'Time',
                                        hintText:
                                            'Be specific about time and date',
                                        raiseForm: () {
                                          riseForm();
                                        },
                                        onChanged: (value) {
                                          bookData.bookTime = value;
                                        },
                                        validate: (value) {
                                          if (value == null || value == '')
                                            return 'This cannot be empty';
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                  BookFormField(
                                      cap: TextCapitalization.sentences,
                                      raiseForm: () {
                                        riseForm();
                                      },
                                      lebel: 'Description',
                                      hintText: 'Extra optional information',
                                      validate: (value) {
                                        return null;
                                      },
                                      onChanged: (value) {
                                        bookData.bookDes = value;
                                      }),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '*Please read carefully.\n The following informations will be visible to all user.\n- Your name.\n- Your profile picture.\n- Your department, year and registration no.\n- Your email address.\n- Book\'s informations.\n ** Only latest 50 requests will be visible.',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  Row(
                                    children: [
                                      Checkbox(
                                          value: agree,
                                          onChanged: (val) {
                                            FocusScope.of(context).unfocus();
                                            riseForm();
                                            setState(() {
                                              agree = val;
                                              // print(agree);
                                            });
                                          }),
                                      Text(
                                          'I agree to share these information.')
                                    ],
                                  ),
                                  AnimatedOpacity(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeInCubic,
                                    opacity: agree! ? 1 : 0,
                                    child: Visibility(
                                      visible: agree!,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12),
                                        ),
                                        onPressed: () {
                                          FocusScope.of(context).unfocus();
                                          setState(() {
                                            valdated = _formKeyBook
                                                .currentState!
                                                .validate();
                                          });

                                          if (valdated && bookImgLink == null) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Please upload an Image'),
                                              ),
                                            );
                                            setState(() {
                                              visible = true;
                                              picHeight =
                                                  CommonThings.size.height *
                                                          .60 +
                                                      20;
                                              formTop =
                                                  CommonThings.size.height *
                                                      .60;
                                            });
                                          }
                                          if (valdated && bookImgLink != null) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                backgroundColor: Colors.green,
                                                content: Text(
                                                    'Varified. Click the Add icon to upload'),
                                              ),
                                            );
                                          }
                                        },
                                        child: Center(
                                            child: Text('Verify',
                                                style: GoogleFonts.aBeeZee(
                                                    fontSize: 18,
                                                    color: Colors.white))),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: CommonThings.size.height * .10,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: 8,
              top: CommonThings.size.height * .60 - 30,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInCubic,
                opacity: visible ? 1 : 0,
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
                            FocusScope.of(context).unfocus();
                            try {
                              await UploadIMG().getUserPic();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: Duration(seconds: 1),
                                  content: Text('Image Uploading'),
                                ),
                              );

                              bookImgLink = await UploadIMG().uploadRequstPic(
                                  UserProfileData.email!,
                                  UsableData.id ??
                                      UsableData.getSetMillisecondsId());
                              if (bookImgLink != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.teal.shade800,
                                    content:
                                        Text('Image Uploaded Successfully'),
                                  ),
                                );
                              }
                              setState(() {
                                bookImgLink = bookImgLink;
                                visible = false;
                              });
                              bookData.bookImgLink = bookImgLink;
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  // width: CommonThings.size.width * .1,
                                  backgroundColor: Colors.redAccent.shade700,
                                  content: Text(
                                      'Couldn\'t upload image. Try again.'),
                                ),
                              );
                            }
                          },
                          color: Colors.white,
                          iconSize: CommonThings.size.width * .09,
                        ),
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
              child: Visibility(
                visible: valdated && bookImgLink != null,
                child: InkWell(
                  // child: Lottie.asset(
                  //   'assets/lottie/AddLottie.json',
                  //   fit: BoxFit.cover,
                  //   repeat: false,
                  // ),
                  child: FlareActor(
                    'assets/flr/AddBookButton.flr',
                    animation: 'AnimationsRep',
                  ),
                  onTap: valdated && bookImgLink != null
                      ? () async {
                          FocusScope.of(context).unfocus();
                          if (bookData.bookPrice != null)
                            bookData.bookPrice = bookData.bookPrice! + ' Taka';
                          // print(   bookData.bookName);
                          try {
                            await FirebaseFirestore.instance
                                .collection(UserProfileData.tmVersity!)
                                .doc('AllBooks')
                                .collection('Requests')
                                .doc()
                                .set(bookData.getBookMap());
                            // String reqRef = FirebaseFirestore.instance
                            //     .collection(UserProfileData.tmVersity)
                            //     .doc('Requests')
                            //     .collection('Requests')
                            //     .doc()
                            //     .path;

                            // UserProfileData.myBookList.add(reqRef);

                            // await FirebaseFirestore.instance
                            //     .collection(UserProfileData.tmVersity)
                            //     .doc('Requests')
                            //     .collection('IINNDDEEXX')
                            //     .doc()
                            //     .set({
                            //   'Name': bookData.bookName,
                            //   'TmName': bookData.bookName
                            //       .replaceAll(' ', '')
                            //       .toUpperCase()
                            // });

                            // String msg = await GetUserData.setUploadedBookNo();
                            // print(msg);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                // width: CommonThings.size.width * .1,
                                backgroundColor: Colors.teal.shade800,
                                content: Text('Your book has been added'),
                              ),
                            );
                            Navigator.pop(context);
                            // Navigator.pushAndRemoveUntil(
                            //     context,
                            //     PageTransition(curve: Curves.fastOutSlowIn,
                            //       // duration: Duration(seconds:),
                            //       // settings: RouteSettings(),
                            //       child: MainPage(),
                            //       type: PageTransitionType.rightToLeftWithFade,
                            //       alignment: Alignment.bottomRight,
                            //       curve: Curves.fastOutSlowIn,
                            //     ),
                            //     (Route<dynamic> route) => false);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                // width: CommonThings.size.width * .1,
                                backgroundColor: Colors.redAccent.shade700,
                                content: Text(
                                    'Couldn\'t upload you book. Try again.'),
                              ),
                            );
                          }
                        }
                      : null
                  //  () async {
                  //   print(UserProfileData.uploadedBookNo);
                  //   GetUserData.setUploadedBookNo();
                  // }
                  ,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
