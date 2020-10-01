import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uBookSharing/BackEnd/Datas.dart';

class GetUserData {
  Future<String> getUserData(email) async {
    try {
      await FirebaseFirestore.instance
          .collection(AllKeys.userCollectionKey)
          .doc(email)
          .get()
          .then((value) => {
                UserProfileData.name = value.data()[AllKeys.nameKey],
                UserProfileData.versityName =
                    value.data()[AllKeys.versityNameKey],
                UserProfileData.tmVersity = value.data()[AllKeys.tmVersityKey],
                UserProfileData.phoneNum = value.data()[AllKeys.phnNumKey],
                UserProfileData.address = value.data()[AllKeys.addressKey],
                UserProfileData.admitted = value.data()[AllKeys.admittedKey],
                UserProfileData.dept = value.data()[AllKeys.deptKey],
              });
    } catch (e) {
      return e.message;
    }
    return 'Something went wrong';
  }
}
