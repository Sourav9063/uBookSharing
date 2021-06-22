import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:uBookSharing/BackEnd/Datas.dart';
import 'package:uBookSharing/BackEnd/FireBase.dart';
import 'package:uBookSharing/BackEnd/UploadIMG.dart';
import 'package:uBookSharing/Components/CompoundWidgets.dart';
import 'package:uBookSharing/Constants.dart';

class AddBookScreen extends StatefulWidget {
  AddBookScreen({Key? key}) : super(key: key);

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  // List<dynamic> bookNameList = [];
  String? bookImgLink;

  //     UserProfileData.email + UserProfileData.uploadedBookNo.toString();
  bool ignore = true;
  bool visible = true;
  bool? agree = false;
  bool valdated = false;
  double picHeight = CommonThings.size.height * .60 + 20;
  double formTop = CommonThings.size.height * .60;
  final _formKeyBook = GlobalKey<FormState>();
  final _bookNameListformKey = GlobalKey<FormState>();
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

  // ScrollController controller;
  // scrlLstnr() {
  //   // print(controller.offset);
  //   if (controller.offset > 15) {
  //     riseForm();
  //   } else if (controller.offset == 0) {
  //     setState(() {
  //       // FocusScope.of(context).unfocus();
  //       // keyboardHeight = 0;
  //       visible = true;
  //       picHeight = CommonThings.size.height * .60 + 20;
  //       formTop = CommonThings.size.height * .60;
  //     });
  //   }
  // }

  // getBookNameList() async {
  //   await FirebaseFirestore.instance
  //       .collection(UserProfileData.tmVersity)
  //       .doc('AllBooks')
  //       .get()
  //       .then((value) {
  //     setState(() {
  //       bookNameList = value.data()['FullNameArray'];
  //     });
  //   });
  //   bookNameList.sort();
  // }

  bool bl = false;
  checkBook() {
    bl = GetBookData.bookNameList!.contains(addBookNametoList);
  }

  String? addBookNametoList;

  addBookInList() {
    showModalBottomSheet(
        context: context,
        enableDrag: true,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.white,
              height: CommonThings.size.height * .80,
              child: Column(
                children: [
                  // Container(

                  Container(
                      color: Colors.white,
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Enlist Your Book',
                            style: GoogleFonts.abrilFatface(
                              color: Colors.red.shade700,
                              fontSize: 28,
                              // fontWeight: FontWeight.w500,
                              // fontStyle: FontStyle.italic
                            ),
                          ),
                          Form(
                            key: _bookNameListformKey,
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: TextFormField(
                                keyboardType: TextInputType.name,
                                textCapitalization: TextCapitalization.words,
                                validator: (value) {
                                  if (value == null)
                                    return 'Enter Book\'s Name';
                                  if (bl) return 'Book already listed';
                                  if (value.length < 5)
                                    return 'Enter full Name';
                                  return null;
                                },
                                onChanged: (value) {
                                  addBookNametoList = value;
                                },
                                decoration: kTextFieldDecoration.copyWith(
                                  labelText: 'Book\'s Name',
                                  hintText: 'Please be careful.',
                                ),
                              ),
                            ),
                          ),
                          Text(
                            '*This app is based on community.So, use the full name of your Book which is known by all. Please be careful and do not use unnecessary spaces or punctuations.\nWe will check and your ID will be banned if we find any hoax name.',
                            style: TextStyle(color: Colors.red),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              // tmAddversity =
                              //     addversity.toUpperCase().replaceAll(' ', '');
                              // print(tmAddversity);
                              addBookNametoList = addBookNametoList!.trim();
                              await checkBook();
                              bool vali =
                                  _bookNameListformKey.currentState!.validate();

                              if (vali) {
                                setState(() {
                                  GetBookData.bookNameList!
                                      .add(addBookNametoList);
                                });

                                await FirebaseFirestore.instance
                                    .collection(UserProfileData.tmVersity!)
                                    .doc('AllBooks')
                                    .set({
                                  'FullNameArray': GetBookData.bookNameList
                                });

                                // GetBookData.bookNameList =
                                //     await GetBookData.getBookNameListFirebase();
                                // await getBookNameList();
                                Navigator.pop(context);
                              }
                            },
                            child: Center(
                              child: Text('Add to Database',
                                  style: GoogleFonts.aBeeZee(
                                      fontSize: 18, color: Colors.white)),
                            ),
                          )
                        ],
                      )),
                ],
              ),
            ),
          );
        });
  }

  getBookNameList() async {
    await GetBookData.getBookNameListFirebase();
    setState(() {});
  }

  @override
  void initState() {
    // controller = ScrollController();
    // controller.addListener(() {
    //   scrlLstnr();
    // });

    getBookNameList();

    super.initState();
  }

  @override
  void dispose() {
    // controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(bookNameList);
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
                      ignore = true;
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
                      color: Color(0xff9bafd9),
                      // gradient: ,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(18))),
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(
                              bottom: CommonThings.size.width * .03),
                          height: 7,
                          width: CommonThings.size.width * .20,
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                      Expanded(
                        child: IgnorePointer(
                          ignoring: ignore,
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
                                      'Add Book',
                                      style: GoogleFonts.abrilFatface(
                                        color: Color(0xff001a54),
                                        fontSize: 38,
                                        // fontWeight: FontWeight.w500,
                                        // fontStyle: FontStyle.italic
                                      ),
                                    ),
                                  ),

                                  DropdownSearch<dynamic>(
                                    // popupBackgroundColor: Colors.black,
                                    maxHeight: CommonThings.size.height * .6,
                                    emptyBuilder: (context, searchEntry) =>
                                        Material(
                                      child: Center(
                                        child: Text(
                                          "\"$searchEntry\" is not listed. Please enlist.",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ),
                                    popupShape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    popupTitle: Material(
                                      // borderRadius: BorderRadius.circular(160),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                'Listed Books',
                                                style: GoogleFonts.abrilFatface(
                                                  fontSize: 30,
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  addBookInList();
                                                },
                                                child: Text(
                                                  'Add a new Book',
                                                  style: GoogleFonts.aBeeZee(
                                                      fontSize: 18,
                                                      color: Colors.white),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    mode: Mode.BOTTOM_SHEET,
                                    validator: (value) {
                                      if (value == null || value == '') {
                                        return 'Must select your Book\'s name';
                                      }
                                      return null;
                                    },
                                    label: 'Book\'s Name',
                                    items: GetBookData.bookNameList,

                                    dropdownSearchDecoration: InputDecoration(
                                      filled: true,
                                      fillColor: Color(0xffffffff),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xff001a54),
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 2,
                                          color: Color(0xff6F00FF),
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    showSearchBox: true,
                                    searchBoxDecoration:
                                        kTextFieldDecoration.copyWith(
                                      labelText: 'Search',
                                      hintText: 'If not listed, please Add',
                                    ),

                                    onChanged: (value) {
                                      riseForm();
                                      // addBookInList();
                                      // if (value != "Add A New Book") {
                                      bookData.bookName = value;

                                      // } else {

                                      // }
                                    },
                                    selectedItem: bookData.bookName,
                                  ),
                                  // BookFormField(
                                  //   lebel: 'Book\'s Name',
                                  //   hintText: 'Please provide the right name',
                                  //   raiseForm: () {
                                  //     riseForm();
                                  //   },
                                  //   onChanged: (value) {
                                  //     bookData.bookName = value;
                                  //   },
                                  //   validate: (value) {
                                  //     if (value == null || value == '')
                                  //       return 'This field cannot be empty';
                                  //     return null;
                                  //   },
                                  // ),
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
                                            labelText: 'For',
                                            hintText: 'Rent or Sell',
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
                                            DropdownMenuItem(
                                              child: Text('For Share',
                                                  style:
                                                      TextStyle(fontSize: 18)),
                                              value: 'For Share',
                                            ),
                                            DropdownMenuItem(
                                              child: Text('For Sell',
                                                  style:
                                                      TextStyle(fontSize: 18)),
                                              value: 'For Sell',
                                            ),
                                            DropdownMenuItem(
                                              child: Text('For Rent ',
                                                  style:
                                                      TextStyle(fontSize: 18)),
                                              value: 'For Rent',
                                            ),
                                          ],
                                          onChanged: (dynamic value) {
                                            setState(() {
                                              bookData.bookFor = value;
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
                                            // FocusScope.of(context).nextFocus();
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
                                      // child: BookFormField(

                                      //   lebel: 'Price',
                                      //   hintText: 'Enter fair amount',
                                      //   raiseForm: () {
                                      //     riseForm();
                                      //   },
                                      //   onChanged: (value) {
                                      //     bookData.bookPrice = value;
                                      //   },
                                      //   validate: (value) {
                                      //     if (value == null || value == '')
                                      //       return 'This field cannot be empty. Input 0 taka';
                                      //     return null;
                                      //   },
                                      // ),

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
                                            hintText: 'Enter fair amount',
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
                                    '*Please read carefully.\n The following informations will be visible to all user.\n- Your name.\n- Your profile picture.\n- Your department, year and registration no.\n- Your email address.\n- Book\'s informations.',
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
                                          child: Text(
                                            'Verify',
                                            style: GoogleFonts.aBeeZee(
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                        ),
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
                              await UploadIMG().getBookPic();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: Duration(seconds: 1),
                                  content: Text('Image Uploading'),
                                ),
                              );

                              bookImgLink = await UploadIMG().uploadBookPic(
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
                // visible: true,
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
                          // bookNameList.add(bookData.bookName);

                          try {
                            // await FirebaseFirestore.instance
                            //     .collection(UserProfileData.tmVersity)
                            //     .doc('AllBooks')
                            //     .collection(bookData.bookName)
                            //     .doc(bookId)
                            //     .set(bookData.getBookMap());

                            await FirebaseFirestore.instance
                                .collection(UserProfileData.tmVersity!)
                                .doc('AllBooks')
                                .collection('AllBooks')
                                .doc()
                                .set(bookData.getBookMap());

                            // String bookPathFirestore = FirebaseFirestore.instance
                            //     .collection(UserProfileData.tmVersity)
                            //     .doc('AllBooks')
                            //     .collection('AllBooks')
                            //     .doc()
                            //     .path;
                            // print(bookPathFirestore);
                            // UserProfileData.myBookList.add(bookPathFirestore);

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
