import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:uBookSharing/BackEnd/Datas.dart';
import 'package:uBookSharing/BackEnd/UploadIMG.dart';
import 'package:uBookSharing/Components/CompoundWidgets.dart';
import 'package:uBookSharing/Constants.dart';

class UserProfile extends StatefulWidget {
  UserProfile({Key key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  UserProfileData currentData = UserProfileData();

  List<String> versity = [];
  // List<String> country = [
  //   "America",
  //   "Brazil",
  //   "Canada",
  //   "India",
  //   "Mongalia",
  //   "USA",
  //   "China",
  //   "Russia",
  //   "Germany"
  // ];

  getVersityList() async {
    await FirebaseFirestore.instance
        .collection('uNiversityList')
        .get()
        .then((value) => {
              value.docs.forEach((element) {
                versity.add(element.data()['Name']);
                // Map<String, dynamic> mp;
                // mp = element.data();
                // versity.add(mp['Name']);
                // print(mp['Name']);
              })
            });
  }

  upLoadData() async {
    // print(UserLogInData.uid);
    currentData.versityName = currentData.versityName.toUpperCase().trim();
    try {
      await FirebaseFirestore.instance
          .collection(currentData.versityName)
          .doc('USER')
          .collection('UserCollections')
          .doc(UserLogInData.uid)
          .set(currentData.getMap());

      // currentData.name, currentData.versityName,
      // 'profilePicLink', 'admitted', 'dept', 'phoneNum', 'email'

      // Map afda = currentData.getMap(currentData.name, currentData.versityName,
      //     'profilePicLink', 'admitted', 'dept', 'phoneNum', 'email');
      // print(afda[AllKeys.nameKey]);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertsCompound(
            msg: 'Something Wrong',
            color: Colors.red.shade200,
            des: e.message,
            buttonTxt: 'OK',
            function: () {
              // spinner = false;
              Navigator.pop(context);
            },
          );
        },
      );
      print(e.code);
    }
  }

  int rand = 1;
  Alignment alb = Alignment.bottomLeft;
  Alignment ale = Alignment.topRight;
  void gredianAlign() {
    // rand = Random().nextInt(5) + 1;
    int rn = Random().nextInt(5) + 1;
    while (rand == rn) {
      rn = Random().nextInt(5) + 1;
      print(rn);
    }
    rand = rn;
    setState(() {
      if (rand == 1) {
        alb = Alignment.bottomLeft;
        ale = Alignment.topRight;
      }

      if (rand == 2) {
        ale = Alignment.bottomLeft;
        alb = Alignment.topRight;
      }

      if (rand == 3) {
        alb = Alignment.bottomRight;
        ale = Alignment.topLeft;
      }
      if (rand == 4) {
        ale = Alignment.bottomRight;
        alb = Alignment.topLeft;
      }
      if (rand == 5) {
        ale = Alignment.centerLeft;
      }
      if (rand == 6) {
        alb = Alignment.centerRight;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getVersityList();
      versity.add('Add your University');
      currentData.profilePicLink = FirebaseAuth.instance.currentUser.photoURL;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
          duration: Duration(milliseconds: 1000),
          curve: Curves.fastOutSlowIn,
          height: CommonThings.size.height,
          width: CommonThings.size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                // Color(0xff000000),
                // // Color(0xff373b5f),
                // Color(0xff14213D),
                // Color(0xff6F00FF),

                // Colors.pink.shade100,

                // Colors.pink,
                Color(0xfffb8b24),

                // Color(0xff3C1414),

                // Color(0xffe0aaff),
                // Colors.red,
                // Color(0xff7b2cbf),

                Color(0xff3c096c),
                Color(0xff14213D),
                Colors.black,

                // Color(0xffa9418b),
                // Color(0xffFCA311),

                // Colors.white
                // Color(0xffc0392b),
            
              ],
              begin: alb,
              end: ale,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 30,
                      ),
                      IconAccount(
                        radious: CommonThings.size.width * .40,
                        imglink: currentData.profilePicLink,
                      ),
                      GestureDetector(
                        child: Icon(
                          Icons.add_photo_alternate,
                          size: 40,
                          color: Color(0xffFB8B24),
                        ),
                        onTap: () async {
                          // if (FirebaseAuth.instance.currentUser.photoURL ==
                          //     null) {
                          await UploadIMG().getUserPic();
                          final link = await UploadIMG()
                              .uploadUserPic(UserLogInData.uid);

                          FirebaseAuth.instance.currentUser
                              .updateProfile(photoURL: link);
                          // FirebaseAuth.instance.currentUser.updateProfile(displayName: );
                          setState(() {
                            currentData.profilePicLink = link;
                          });
                          // }
                          // else {
                          //   setState(() {
                          //     currentData.profilePicLink =
                          //         FirebaseAuth.instance.currentUser.photoURL;
                          //   });
                          // }
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    // height: 1000,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      border: Border.all(
                        color: Colors.white70,
                        width: 5,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    // color: Colors.white30,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Form(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  // child: TextFormField(
                                  //   style: TextStyle(fontSize: 18),
                                  //   onChanged: (value) {
                                  //     currentData.versityName = value;
                                  //   },
                                  //   onTap: () => gredianAlign(),
                                  //   decoration: kTextFieldDecoration.copyWith(
                                  //       prefixIcon: Icon(Icons.account_balance),
                                  //       labelText: 'University',
                                  //       hintText:
                                  //           'Abbreviation of your University name'),
                                  // ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(18),
                                        border: Border.all(
                                            color: Colors.purple, width: 4)),
                                    child: DropDownField(
                                      textStyle: TextStyle(fontSize: 18),
                                      itemsVisibleInDropdown: 4,
                                      // icon: Icon(Icons.account_balance),
                                      value: currentData.versityName,
                                      required: true,
                                      labelText: 'University',
                                      items: versity,
                                      onValueChanged: (value) {
                                        gredianAlign();
                                        if (value != 'Add your University')
                                          currentData.versityName = value;
                                        else {
                                          Navigator.pop(context);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    style: TextStyle(fontSize: 18),
                                    onChanged: (value) {
                                      currentData.name = value;
                                    },
                                    onTap: () => gredianAlign(),
                                    decoration: kTextFieldDecoration.copyWith(
                                        prefixIcon: Icon(Icons.account_circle),
                                        labelText: 'Name',
                                        hintText: 'Use your real name'),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: TextFormField(
                                          style: TextStyle(fontSize: 18),
                                          keyboardType: TextInputType.datetime,
                                          onChanged: (value) {
                                            currentData.admitted = value;
                                          },
                                          onTap: () => gredianAlign(),
                                          decoration:
                                              kTextFieldDecoration.copyWith(
                                                  prefixIcon: Icon(
                                                      Icons.calendar_today),
                                                  labelText: 'Batch',
                                                  hintText: 'Year'),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: TextFormField(
                                          style: TextStyle(fontSize: 18),
                                          onChanged: (value) {
                                            currentData.dept = value;
                                          },
                                          onTap: () => gredianAlign(),
                                          decoration: kTextFieldDecoration
                                              .copyWith(
                                                  prefixIcon: Icon(Icons
                                                      .supervised_user_circle),
                                                  labelText: 'Department',
                                                  hintText:
                                                      'Use the abbreviation'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    style: TextStyle(fontSize: 18),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      currentData.phoneNum = value;
                                    },
                                    onTap: () => gredianAlign(),
                                    decoration: kTextFieldDecoration.copyWith(
                                        prefixIcon: Icon(Icons.phone),
                                        labelText: 'Phone',
                                        hintText:
                                            'No one will know unless you share it'),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    style: TextStyle(fontSize: 18),
                                    minLines: 1,
                                    maxLines: 3,
                                    onChanged: (value) {
                                      currentData.address = value;
                                    },
                                    onTap: () => gredianAlign(),
                                    decoration: kTextFieldDecoration.copyWith(
                                        prefixIcon: Icon(Icons.home),
                                        labelText: 'Address',
                                        hintText: 'Use your current location'),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: RaisedButton(
                                          onPressed: () {
                                            gredianAlign();
                                            print(currentData.versityName);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16),
                                            child: Text(
                                              'Verify Data',
                                              style: GoogleFonts.aBeeZee(
                                                  fontSize: 18,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Expanded(
                                        child: RaisedButton(
                                          color: Colors.green,
                                          onPressed: () {
                                            gredianAlign();
                                            upLoadData();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16),
                                            child: Text(
                                              'Upload',
                                              style: GoogleFonts.aBeeZee(
                                                  fontSize: 18,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
