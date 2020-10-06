import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonThings {
  static Size size;
}

// class UserLogInData {
//   static String email;
//   static String uid;
//   static updateUID() async {
//     UserLogInData.uid = await UserDataSavedEmailPassword.getuidSharedPref();
//   }
// }

class AllKeys {
  static const String userCollectionKey = 'UserCollectionAll';
  static const String nameKey = 'NameKey';
  static const String versityNameKey = 'VersityNameKey';
  static const String tmVersityKey = 'TUname';
  static const String profilePicLinkKey = 'ProfileLinkKey';
  static const String deptKey = 'DeptKey';
  static const String phnNumKey = 'PhoneKey';
  static const String emailKey = 'EmailKey';
  static const String admittedKey = 'AdmittedKey';
  static const String addressKey = 'AddressKey';
  static const String registrationNoKey = 'RegistrarionNoKey';
  static const String uidKey = 'UidKey';
  static const String upLoadedBookNoKey = 'UploadedNoKey';

//book keys
  static const String bookNameKey = 'BookNameKey';
  static const String bookWriterNameKey = 'WriterNameKey';
  static const String bookEditionKey = 'EditionKey';
  static const String bookForKey = 'ForKey';
  static const String bookImgKey = 'ImgKey';
  static const String bookDesKey = 'DescriptionKey';
  static const String bookPriceKey = 'PriceKey';

  static const String bookUploaderNameKey = 'UploaderNameKey';
  static const String bookUploaderEmailKey = 'UploaderEmailKey';
  static const String bookUploaderBatchKey = 'UploaderBatchKey';
  static const String bookUploaderDeptKey = 'UploaderDeptKey';
  static const String bookUploaderImgKey = 'UploaderDeptImgKey';
}

class BookData {
  static String bookName;
  static String bookWriter;
  static String bookEdition;
  static String bookFor;
  static String bookDes;
  static String bookImgLink;
  static String bookPrice;

  static Map<String, dynamic> getBookMap() {
    Map bookMapData = Map<String, dynamic>();

    bookMapData[AllKeys.bookNameKey] = bookName;
    bookMapData[AllKeys.bookWriterNameKey] = bookWriter;
    bookMapData[AllKeys.bookEditionKey] = bookEdition;
    bookMapData[AllKeys.bookForKey] = bookFor;
    bookMapData[AllKeys.bookDesKey] = bookDes;
    bookMapData[AllKeys.bookImgKey] = bookImgLink;
    bookMapData[AllKeys.bookPriceKey] = bookPrice;
    bookMapData[AllKeys.bookUploaderNameKey] = UserProfileData.name;
    bookMapData[AllKeys.bookUploaderDeptKey] = UserProfileData.dept;
    bookMapData[AllKeys.bookUploaderBatchKey] = UserProfileData.admitted;
    bookMapData[AllKeys.bookUploaderEmailKey] = UserProfileData.email;
    bookMapData[AllKeys.bookUploaderImgKey] = UserProfileData.profilePicLink;

    print(bookMapData);
    return bookMapData;
  }
}

class UserProfileData {
  static String name;
  static String versityName;
  static String tmVersity;
  static String profilePicLink;
  static String admitted;
  static String dept;
  static String phoneNum;
  static String email;
  static String address;
  static String registrationNo;
  static String uploadedBookNo;
  static String uid;

  static Map<String, dynamic> getMap() {
    Map userMapData = Map<String, dynamic>();

    userMapData[AllKeys.nameKey] = name;
    userMapData[AllKeys.phnNumKey] = phoneNum;
    userMapData[AllKeys.versityNameKey] = versityName;
    userMapData[AllKeys.tmVersityKey] = tmVersity;
    userMapData[AllKeys.admittedKey] = admitted;
    userMapData[AllKeys.deptKey] = dept;
    userMapData[AllKeys.profilePicLinkKey] = profilePicLink;
    userMapData[AllKeys.emailKey] = email;
    userMapData[AllKeys.addressKey] = address;
    userMapData[AllKeys.registrationNoKey] = registrationNo;
    userMapData[AllKeys.uidKey] = uid;
    if (uploadedBookNo == null)
      userMapData[AllKeys.upLoadedBookNoKey] = '0';
    else
      userMapData[AllKeys.upLoadedBookNoKey] = uploadedBookNo;

    print(userMapData);
    return userMapData;
  }
}

class UserDataSavedEmailPassword {
  static final String emailKey = 'UserEmail';
  static final String passwordKey = 'UserPassword';
  static final String isLoggedInKey = 'IsloggedIn';
  static final String uidKey = 'uidKey';

  // String getEmail() {
  //   return _email;
  // }

  // String getPassword() {
  //   return _password;
  // }

  static Future<bool> saveEmailSharedPref(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(emailKey, email);
  }

  static Future<String> getEmailSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(emailKey);
  }

  // static Future<bool> saveuidSharedPref(String uid) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   return prefs.setString(uidKey, uid);
  // }

  // static Future<String> getuidSharedPref() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   return prefs.getString(uidKey);
  // }

  // static Future<bool> clearuidSharedPref() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   return prefs.remove(uidKey);
  // }

  static Future<bool> savePasswordSharedPref(String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(passwordKey, password);
  }

  static Future<String> getPasswordSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(passwordKey);
  }

  static Future<bool> saveIsLoggedInSharedPref(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setBool(isLoggedInKey, isLoggedIn);
  }

  static Future<bool> getIsLoggedInSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLoggedInKey);
  }
}
