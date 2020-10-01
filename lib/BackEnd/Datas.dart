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
  static const String registrationNo = 'RegistrarionNoKey';
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

  // Map<String, dynamic> userMapData;

  // UserProfileData(
  //     {this.name,
  //     this.versityName,
  //     this.admitted,
  //     this.dept,
  //     this.email,
  //     this.phoneNum,
  //     this.profilePicLink});

  //   userMapData[AllKeys.nameKey] = name;

  //   return userMapData;
  // }
  static Map<String, dynamic> getMap()
  // String name,
  // String versityName,
  // String profilePicLink,
  // String admitted,
  // String dept,
  // String phoneNum,
  // String email)
  {
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
    userMapData[AllKeys.registrationNo] = registrationNo;
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
