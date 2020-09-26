import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonThings {
  static Size size;
}

class UserLogInData {
  static String email;
  static String uid;
  static updateUID() async {
    UserLogInData.uid = await UserDataSavedEmailPassword.getuidSharedPref();
  }
}

class AllKeys {
  static const String nameKey = 'NameKey';
  static const String versityNameKey = 'VersityNameKey';
  static const String profilePicLinkKey = 'ProfileLinkKey';
  static const String deptKey = 'DeptKey';
  static const String phnNumKey = 'PhoneKey';
  static const String emailKey = 'EmailKey';
  static const String admittedKey = 'AdmittedKey';
  static const String addressKey = 'AddressKey';
}

class UserProfileData {
  String name;
  String versityName;
  String profilePicLink;
  String admitted;
  String dept;
  String phoneNum;
  String email;
  String address;
  

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
  Map<String, dynamic> getMap()
  // String name,
  // String versityName,
  // String profilePicLink,
  // String admitted,
  // String dept,
  // String phoneNum,
  // String email)
  {
    Map userMapData = Map<String, dynamic>();

    userMapData[AllKeys.nameKey] = this.name;
    userMapData[AllKeys.phnNumKey] = this.phoneNum;
    userMapData[AllKeys.versityNameKey] = this.versityName;
    userMapData[AllKeys.admittedKey] = this.admitted;
    userMapData[AllKeys.deptKey] = this.dept;
    userMapData[AllKeys.profilePicLinkKey] = this.profilePicLink;
    userMapData[AllKeys.emailKey] = email;
    userMapData[AllKeys.addressKey] = address;
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

  static Future<bool> saveuidSharedPref(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(uidKey, uid);
  }

  static Future<String> getuidSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(uidKey);
  }

  static Future<bool> clearuidSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.remove(uidKey);
  }

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
