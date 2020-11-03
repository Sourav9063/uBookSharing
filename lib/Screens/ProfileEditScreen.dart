import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
// import 'package:dropdownfield/dropdownfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

import 'package:uBookSharing/BackEnd/Datas.dart';
import 'package:uBookSharing/BackEnd/FireBase.dart';
import 'package:uBookSharing/BackEnd/UploadIMG.dart';

import 'package:uBookSharing/Components/CompoundWidgets.dart';
import 'package:uBookSharing/Constants.dart';
import 'package:uBookSharing/Screens/MainScreenNew.dart';
// import 'package:uBookSharing/Screens/MainScreen.dart';
import 'package:vibration/vibration.dart';

class ProfileEditScreen extends StatefulWidget {
  ProfileEditScreen({Key key}) : super(key: key);

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  List<String> versity = [];
  final _formKey = GlobalKey<FormState>();
  final _versityName = GlobalKey<FormState>();
  bool imgAdded = false;
  bool validated = false;
  // bool versityNameValidation = false;
  getVersityList() async {
    await FirebaseFirestore.instance
        .collection('uNiversityList')
        .get()
        .then((value) => {
              value.docs.forEach((element) {
                var nv = element.data()['Name'];
                setState(() {
                  versity.add(nv.toString());
                });

                // Map<String, dynamic> mp;
                // mp = element.data();
                // versity.add(mp['Name']);
                // print(mp['Name']);
              })
            });
  }

  upLoadData() async {
    // print(UserLogInData.uid);
    UserProfileData.tmVersity =
        UserProfileData.versityName.replaceAll(' ', '').trim().toUpperCase();
    UserProfileData.uid = FirebaseAuth.instance.currentUser.uid;

    try {
      await FirebaseFirestore.instance
          .collection(AllKeys.userCollectionKey)
          .doc(FirebaseAuth.instance.currentUser.email)
          .set(UserProfileData.getMap());

      Navigator.pushReplacement(
          context,
          PageTransition(
              settings: RouteSettings(name: "Foo"),
              curve: Curves.fastOutSlowIn,
              child: MainScreenNew(),
              type: PageTransitionType.rightToLeftWithFade));
      //  UserProfileData.name,  UserProfileData.versityName,
      // 'profilePicLink', 'admitted', 'dept', 'phoneNum', 'email'

      // Map afda =  UserProfileData.getMap( UserProfileData.name,  UserProfileData.versityName,
      //     'profilePicLink', 'admitted', 'dept', 'phoneNum', 'email');
      // print(afda[AllKeys.nameKey]);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertsCompound(
            msg: 'Something Wrong',
            color: Colors.red.shade200,
            des: "Couldn't upload data",
            buttonTxt: 'OK',
            function: () {
              // spinner = false;
              Navigator.pop(context);
            },
          );
        },
      );
      // print(e.code);
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
      // print(rn);
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

  bool bl = false;
  checkVersity() async {
    await FirebaseFirestore.instance
        .collection('uNiversityList')
        .where(AllKeys.tmVersityKey, isEqualTo: tmAddversity)
        .get()
        .then((value) => {
              if (value.docs.isNotEmpty) {bl = true} else {bl = false}
            });
  }

  String addversity;
  String tmAddversity;
  addVersity() {
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
                        children: [
                          Text(
                            'Add Your University',
                            style: GoogleFonts.abrilFatface(
                              color: Colors.red.shade700,
                              fontSize: 28,
                              // fontWeight: FontWeight.w500,
                              // fontStyle: FontStyle.italic
                            ),
                          ),
                          Form(
                            key: _versityName,
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: TextFormField(
                                textCapitalization: TextCapitalization.words,
                                validator: (value) {
                                  if (value == null)
                                    return 'Enter University Name';
                                  if (bl) return 'University already listed';
                                  if (value.length < 5)
                                    return 'Enter full Name';
                                  return null;
                                },
                                onChanged: (value) {
                                  addversity = value;
                                },
                                decoration: kTextFieldDecoration.copyWith(
                                  labelText: 'University',
                                  hintText: 'Enter full name',
                                ),
                              ),
                            ),
                          ),
                          Text(
                            '*This app is based on community.So, use the full name of your University which is known by all. Use your University website.\nWe will check and your ID will be banned if we find any duplicate or hoax name...',
                            style: TextStyle(color: Colors.red),
                          ),
                          RaisedButton(
                            onPressed: () async {
                              tmAddversity =
                                  addversity.toUpperCase().replaceAll(' ', '');
                              // print(tmAddversity);
                              await checkVersity();
                              bool vali = _versityName.currentState.validate();

                              if (vali) {
                                await FirebaseFirestore.instance
                                    .collection('uNiversityList')
                                    .doc()
                                    .set({
                                  'Name': addversity,
                                  'TUname': tmAddversity,
                                  'AddedBy':
                                      FirebaseAuth.instance.currentUser.email
                                });
                                // Navigator.pushReplacement(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => UserProfile()));

                                await getVersityList();
                                Navigator.pop(context);
                              }
                            },
                            child: Text('Add',
                                style: GoogleFonts.aBeeZee(
                                    fontSize: 18, color: Colors.white)),
                          )
                        ],
                      )),
                ],
              ),
            ),
          );
        });
  }

  isProfileComplete() async {
    String val =
        await GetUserData.getUserData(FirebaseAuth.instance.currentUser.email);
    if (val == 'done') {
      Navigator.pushReplacement(
          context,
          PageTransition(
              settings: RouteSettings(name: "Foo"),
              curve: Curves.fastOutSlowIn,
              child: MainScreenNew(),
              type: PageTransitionType.fade));
    }
  }

  @override
  void initState() {
    super.initState();
    // isProfileComplete();

    setState(() {
      getVersityList();
      versity.add('Add your University');
      UserProfileData.profilePicLink =
          FirebaseAuth.instance.currentUser.photoURL;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        return AnimatedContainer(
            duration: Duration(milliseconds: 1000),
            curve: Curves.fastOutSlowIn,
            height: CommonThings.size.height,
            width: CommonThings.size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xfffb8b24),
                  Color(0xff3c096c),
                  Color(0xff14213D),
                  Colors.black,

                  // Color(0xffa9418b),
                  // Color(0xffFCA311),

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
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Lottie.asset(
                                'assets/lottie/bookWritting.json',
                              ),
                              Text(
                                'Profile',
                                style: GoogleFonts.abrilFatface(
                                  color: Color(0xffffe066),
                                  fontSize: 28,
                                  // fontWeight: FontWeight.w500,
                                  // fontStyle: FontStyle.italic
                                ),
                              ),
                              SizedBox(
                                height: CommonThings.size.width * .20,
                              )
                            ],
                          ),
                        ),
                        IconAccount(
                          radious: CommonThings.size.width * .40,
                          imglink: UserProfileData.profilePicLink,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.add_photo_alternate,
                            size: 40,
                            color: Color(0xffFB8B24),
                          ),
                          onPressed: () async {
                            // if (FirebaseAuth.instance.currentUser.photoURL ==
                            //     null) {
                            try {
                              await UploadIMG().getUserPic();
                              final link = await UploadIMG().uploadUserPic(
                                  FirebaseAuth.instance.currentUser.email,
                                  UsableData.id);

                              await FirebaseAuth.instance.currentUser
                                  .updateProfile(photoURL: link);
                              // FirebaseAuth.instance.currentUser.updateProfile(displayName: );
                              setState(() {
                                UserProfileData.profilePicLink = link;
                                imgAdded = true;
                              });
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.teal.shade800,
                                  content: Text('Image Uploaded Successfully'),
                                ),
                              );
                            } catch (e) {
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  content:
                                      Text('Couldn\'t upload profile picture'),
                                ),
                              );
                            }
                            // }
                            // else {
                            //   setState(() {
                            //      UserProfileData.profilePicLink =
                            //         FirebaseAuth.instance.currentUser.photoURL;
                            //   });
                            // }
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProfileEditScreen()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Material(
                                borderRadius: BorderRadius.circular(100),
                                color: Theme.of(context).accentColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) {
                                        return ProfileEditScreen();
                                      }));
                                    },
                                    icon: Icon(
                                      Icons.replay,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Expanded(
                            child: RaisedButton(
                              color: Colors.purple.shade900,
                              onPressed: () {
                                addVersity();
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: Text(
                                  'Add Your University',
                                  style: GoogleFonts.aBeeZee(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // height: 1000,
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      decoration: BoxDecoration(
                        // color: Colors.black54,
                        border: Border.all(
                          color: Colors.white70,
                          width: 5,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      // color: Colors.white30,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: DropdownSearch<String>(
                                  popupTitle: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Listed University',
                                          style: GoogleFonts.abrilFatface(
                                            fontSize: 30,
                                          ),
                                        ),
                                        RaisedButton(
                                          onPressed: () {
                                            addVersity();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8),
                                            child: Text(
                                              'Add Your University',
                                              style: GoogleFonts.aBeeZee(
                                                  fontSize: 14,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                                  mode: Mode.BOTTOM_SHEET,
                                  popupShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  validator: (value) {
                                    if (value == null || value == '') {
                                      return 'Must Give your University name';
                                    }
                                    return null;
                                  },
                                  label: 'University',
                                  items: versity,
                                  dropdownSearchDecoration:
                                      kTextFieldDecoration,
                                  showSearchBox: true,
                                  searchBoxDecoration:
                                      kTextFieldDecoration.copyWith(
                                    labelText: 'Search',
                                    hintText: 'If not listed, please add',
                                  ),
                                  onChanged: (value) {
                                    gredianAlign();
                                    if (value != 'Add your University') {
                                      UserProfileData.versityName = value;
                                      // versityNameValidation = true;
                                      // print(UserProfileData.versityName);
                                    } else {
                                      addVersity();
                                    }
                                  },
                                  selectedItem: UserProfileData.versityName,
                                ),
                              ),

                              // Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   //   // child: TextFormField(
                              //   //   //   style: TextStyle(fontSize: 18),
                              //   //   //   onChanged: (value) {
                              //   //   //      UserProfileData.versityName = value;
                              //   //   //   },
                              //   //   //   onTap: () => gredianAlign(),
                              //   //   //   decoration: kTextFieldDecoration.copyWith(
                              //   //   //       prefixIcon: Icon(Icons.account_balance),
                              //   //   //       labelText: 'University',
                              //   //   //       hintText:
                              //   //   //           'Abbreviation of your University name'),
                              //   //   // ),
                              //   child: Container(
                              //     decoration: BoxDecoration(
                              //         color: Colors.white,
                              //         borderRadius: BorderRadius.circular(18),
                              //         border: Border.all(
                              //             color: Colors.purple, width: 4)),
                              //     child: DropDownField(
                              //       textStyle: TextStyle(fontSize: 18),
                              //       itemsVisibleInDropdown: 4,
                              //       // icon: Icon(Icons.account_balance),
                              //       value: UserProfileData.versityName,
                              //       required: true,

                              //       labelText: 'University',
                              //       hintText: 'If not listed, please Add',
                              //       items: versity,

                              //       onValueChanged: (value) {
                              //         gredianAlign();
                              //         if (value != 'Add your University') {
                              //           UserProfileData.versityName = value;
                              //           versityNameValidation = true;
                              //         } else {
                              //           addVersity();
                              //         }
                              //       },
                              //     ),
                              //   ),
                              // ),

                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: TextFormField(
                                  textCapitalization: TextCapitalization.words,
                                  style: TextStyle(fontSize: 18),
                                  validator: (value) {
                                    if (value == null || value == '')
                                      return 'This field cannot be empty!';
                                    return null;
                                  },
                                  onChanged: (value) {
                                    UserProfileData.name = value;
                                    FirebaseAuth.instance.currentUser
                                        .updateProfile(displayName: value);
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
                                        validator: (value) {
                                          if (value == null || value == '') {
                                            return 'This field cannot be empty!';
                                          }
                                          if (value.length != 4)
                                            return 'Must be a Year';
                                          if (int.parse(value) < 2000 ||
                                              int.parse(value) > 2051)
                                            return 'Must be a valid year';

                                          return null;
                                        },
                                        style: TextStyle(fontSize: 18),
                                        keyboardType: TextInputType.datetime,
                                        onChanged: (value) {
                                          UserProfileData.admitted = value;
                                        },
                                        onTap: () => gredianAlign(),
                                        decoration:
                                            kTextFieldDecoration.copyWith(
                                                prefixIcon:
                                                    Icon(Icons.calendar_today),
                                                labelText: 'Year',
                                                hintText: 'Admission year'),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value == null || value == '')
                                            return 'This field cannot be empty!';
                                          return null;
                                        },
                                        style: TextStyle(fontSize: 18),
                                        onChanged: (value) {
                                          UserProfileData.dept = value;
                                        },
                                        onTap: () => gredianAlign(),
                                        decoration:
                                            kTextFieldDecoration.copyWith(
                                                prefixIcon: Icon(Icons
                                                    .supervised_user_circle),
                                                labelText: 'Department',
                                                hintText: 'Abbreviation'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value == '')
                                      return 'This field cannot be empty!';
                                    return null;
                                  },
                                  style: TextStyle(fontSize: 18),
                                  onChanged: (value) {
                                    UserProfileData.registrationNo = value;
                                  },
                                  onTap: () => gredianAlign(),
                                  decoration: kTextFieldDecoration.copyWith(
                                      prefixIcon: Icon(Icons.account_circle),
                                      labelText: 'Registration',
                                      hintText: 'Enter your registration No'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value == '')
                                      return 'This field cannot be empty!';
                                    if (value.length != 11)
                                      return 'Must be 11 digits';
                                    return null;
                                  },
                                  style: TextStyle(fontSize: 18),
                                  keyboardType: TextInputType.phone,
                                  onChanged: (value) {
                                    UserProfileData.phoneNum = value;
                                  },
                                  onTap: () => gredianAlign(),
                                  decoration: kTextFieldDecoration.copyWith(
                                      prefixIcon: Icon(Icons.phone),
                                      labelText: 'Phone',
                                      hintText: 'It\'s secured'),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value == '')
                                      return 'This field cannot be empty!';
                                    return null;
                                  },
                                  style: TextStyle(fontSize: 18),
                                  minLines: 1,
                                  maxLines: 3,
                                  onChanged: (value) {
                                    UserProfileData.address = value;
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
                                    const EdgeInsets.only(left: 8.0, bottom: 0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    '*Your phone number and address are secured.\n No one will know unless you share it.',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: RaisedButton(
                                        onPressed: () {
                                          FocusScope.of(context).unfocus();
                                          UserProfileData.email = FirebaseAuth
                                              .instance.currentUser.email;
                                          gredianAlign();
                                          setState(() {
                                            validated = _formKey.currentState
                                                .validate();
                                          });
                                          if (validated &&
                                              UserProfileData.profilePicLink ==
                                                  null) {
                                            Scaffold.of(context).showSnackBar(
                                              SnackBar(
                                                backgroundColor:
                                                    Colors.teal.shade800,
                                                content: Text(
                                                    'Please upload an image'),
                                              ),
                                            );
                                          }
                                          validated
                                              ? Vibration.vibrate(duration: 50)
                                              : Vibration.vibrate(
                                                  duration: 200);
                                          // print( UserProfileData.versityName);
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
                                      flex: validated &&
                                              UserProfileData.profilePicLink !=
                                                  null
                                          ? 2
                                          : 1,
                                      child: RaisedButton(
                                        color: Colors.green,
                                        onPressed: validated &&
                                                UserProfileData
                                                        .profilePicLink !=
                                                    null
                                            ? () {
                                                gredianAlign();
                                                upLoadData();
                                              }
                                            : null,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          child: Text(
                                            'Upload',
                                            style: GoogleFonts.aBeeZee(
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              // RaisedButton(onPressed: () {
                              //   Navigator.pushReplacement(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) => MainPage()));
                              // })
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
      }),
    );
  }
}
