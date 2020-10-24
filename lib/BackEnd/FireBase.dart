import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uBookSharing/BackEnd/Datas.dart';

class GetUserData {
  static Future<String> getUserData(email) async {
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
                UserProfileData.email = value.data()[AllKeys.emailKey],
                UserProfileData.profilePicLink =
                    value.data()[AllKeys.profilePicLinkKey],
                UserProfileData.registrationNo =
                    value.data()[AllKeys.registrationNoKey],
                UserProfileData.uploadedBookNo =
                    value.data()[AllKeys.upLoadedBookNoKey],
              });
      if (UserProfileData.name == null) return 'empty';
      return 'done';
    } catch (e) {
      return e.message;
    }
    // return 'Something went wrong';
  }

  static setUploadedBookNo() async {
    int num = int.parse(UserProfileData.uploadedBookNo);
    num++;
    UserProfileData.uploadedBookNo = num.toString();
    await FirebaseFirestore.instance
        .collection(AllKeys.userCollectionKey)
        .doc(UserProfileData.email)
        .update({AllKeys.upLoadedBookNoKey: UserProfileData.uploadedBookNo});
  }
}

class GetBookData {
  static Future<List<BookData>> getRecent10Books() async {
    List<BookData> recentDataList = [];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(UserProfileData.tmVersity)
        .doc('AllBooks')
        .collection('AllBooks')
        .orderBy(AllKeys.bookTimeUploadKey, descending: true)
        .limit(10)
        .get();

    recentDataList = getBookDataObjFromQuerySnapshot(querySnapshot);

    return recentDataList;
  }

  static Stream<QuerySnapshot> getRecentBookStream(int n, String req) {
    if (UserProfileData.tmVersity != null)
      return FirebaseFirestore.instance
          .collection(UserProfileData.tmVersity)
          .doc(req)
          .collection(req)
          .orderBy(AllKeys.bookTimeUploadKey, descending: true)
          .limit(n)
          .snapshots();

    return null;
  }

  static List<BookData> getBookDataObjFromQuerySnapshot(QuerySnapshot value) {
    List<BookData> recentDataList = [];
    value.docs.forEach((element) {
      BookData bookData = BookData();

      // print(element.data()[AllKeys.bookNameKey]);
      bookData.bookName = element.data()[AllKeys.bookNameKey];
      bookData.bookWriter = element.data()[AllKeys.bookWriterNameKey];
      bookData.bookFor = element.data()[AllKeys.bookForKey];
      bookData.bookDes = element.data()[AllKeys.bookDesKey];
      bookData.bookImgLink = element.data()[AllKeys.bookImgKey];
      bookData.bookPrice = element.data()[AllKeys.bookPriceKey];
      bookData.bookEdition = element.data()[AllKeys.bookEditionKey];
      bookData.bookTime = element.data()[AllKeys.bookTimeKey];
      bookData.bookTimeUpload = element.data()[AllKeys.bookTimeUploadKey];

      bookData.bookUploaderName = element.data()[AllKeys.bookUploaderNameKey];
      bookData.bookUploaderEmail = element.data()[AllKeys.bookUploaderEmailKey];
      bookData.bookUploaderBatch = element.data()[AllKeys.bookUploaderBatchKey];
      bookData.bookUploaderDept = element.data()[AllKeys.bookUploaderDeptKey];
      bookData.bookUploaderImg = element.data()[AllKeys.bookUploaderImgKey];
      recentDataList.add(bookData);
    });

    return recentDataList;
  }
}
