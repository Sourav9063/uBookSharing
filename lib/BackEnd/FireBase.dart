import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uBookSharing/BackEnd/Datas.dart';

class GetUserData {
  static Future<String> getUserData(email) async {
    try {
      await FirebaseFirestore.instance
          .collection(AllKeys.userCollectionKey)
          .doc(email)
          .get()
          .then((value) => {
                UserProfileData.name = value[AllKeys.nameKey],
                UserProfileData.versityName = value[AllKeys.versityNameKey],
                UserProfileData.tmVersity = value[AllKeys.tmVersityKey],
                UserProfileData.phoneNum = value[AllKeys.phnNumKey],
                UserProfileData.address = value[AllKeys.addressKey],
                UserProfileData.admitted = value[AllKeys.admittedKey],
                UserProfileData.dept = value[AllKeys.deptKey],
                UserProfileData.email = value[AllKeys.emailKey],
                UserProfileData.profilePicLink =
                    value[AllKeys.profilePicLinkKey],
                UserProfileData.registrationNo =
                    value[AllKeys.registrationNoKey],
                UserProfileData.uploadedBookNo =
                    value[AllKeys.upLoadedBookNoKey],
                // UserProfileData.myBookList = value[AllKeys.myBookListKey]
              });
      if (UserProfileData.name == null) return 'empty';
      return 'done';
    } catch (e) {
      return 'Error';
    }
    // return 'Something went wrong';
  }

  // static Future<String> setUploadedBookNo() async {
  //   int num = int.parse(UserProfileData.uploadedBookNo);
  //   num++;
  //   UserProfileData.uploadedBookNo = num.toString();
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection(AllKeys.userCollectionKey)
  //         .doc(UserProfileData.email)
  //         .update({AllKeys.upLoadedBookNoKey: UserProfileData.uploadedBookNo});

  //     await FirebaseFirestore.instance
  //         .collection(AllKeys.userCollectionKey)
  //         .doc(UserProfileData.email)
  //         .update({AllKeys.myBookListKey: UserProfileData.myBookList});
  //     return 'done';
  //   } catch (e) {
  //     return e.message;
  //   }
  // }
}

class GetBookData {
  static Future<List<BookData>> getRecent10Books() async {
    List<BookData> recentDataList = [];

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection(UserProfileData.tmVersity!)
        .doc('AllBooks')
        .collection('AllBooks')
        .orderBy(AllKeys.bookTimeUploadKey, descending: true)
        .limit(10)
        .get();

    recentDataList = getBookDataObjFromQuerySnapshot(querySnapshot);

    return recentDataList;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>>? getRecentBookStream(
      int n, String req) {
    if (UserProfileData.tmVersity != null)
      return FirebaseFirestore.instance
          .collection(UserProfileData.tmVersity!)
          .doc('AllBooks')
          .collection(req)
          .orderBy(AllKeys.bookTimeUploadKey, descending: true)
          .limit(n)
          .snapshots();

    return null;
  }

  static List<BookData> getBookDataObjFromQuerySnapshot(
      QuerySnapshot<Map<String, dynamic>> value) {
    List<BookData> recentDataList = [];
    value.docs.forEach((element) {
      BookData bookData = BookData();
      bookData = getBookDataFromDocumentSnapshot(element);

      recentDataList.add(bookData);
    });

    return recentDataList;
  }

  static BookData getBookDataFromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> element) {
    BookData bookData = BookData();

    // print(element.data()[AllKeys.bookNameKey]);
    bookData.bookName = element.data()![AllKeys.bookNameKey];
    bookData.bookWriter = element.data()![AllKeys.bookWriterNameKey];
    bookData.bookFor = element.data()![AllKeys.bookForKey];
    bookData.bookDes = element.data()![AllKeys.bookDesKey];
    bookData.bookImgLink = element.data()![AllKeys.bookImgKey];
    bookData.bookPrice = element.data()![AllKeys.bookPriceKey];
    bookData.bookEdition = element.data()![AllKeys.bookEditionKey];
    bookData.bookTime = element.data()![AllKeys.bookTimeKey];

    bookData.bookTimeUpload = element.data()![AllKeys.bookTimeUploadKey];
    bookData.bookTimeUploadString =
        element.data()![AllKeys.bookTimeUploadStringKey];

    bookData.bookUploaderName = element.data()![AllKeys.bookUploaderNameKey];
    bookData.bookUploaderEmail = element.data()![AllKeys.bookUploaderEmailKey];
    bookData.bookUploaderBatch = element.data()![AllKeys.bookUploaderBatchKey];
    bookData.bookUploaderDept = element.data()![AllKeys.bookUploaderDeptKey];
    bookData.bookUploaderImg = element.data()![AllKeys.bookUploaderImgKey];
    bookData.docId = element.reference.id;
    return bookData;
  }

  static List<dynamic>? bookNameList;
  static Future<bool?> getBookNameListFirebase() async {
    try {
      await FirebaseFirestore.instance
          .collection(UserProfileData.tmVersity!)
          .doc('AllBooks')
          .get()
          .then((value) {
        bookNameList = value['FullNameArray'];
      });
      bookNameList!.sort();
      return true;
    } catch (e) {
      bookNameList!.add('No data');

      return null;
    }
    // print(bookNameList);
  }

  // static Future<BookData> bookDataFromRef(String ref) async {
  //   var dataRromRef = await FirebaseFirestore.instance.doc(ref).get();

  //   return getBookDataFromDocumentSnapshot(dataRromRef);
  // }

  static Future<QuerySnapshot<Map<String, dynamic>>> bookDataSearch(
      String field, String? search) async {
    return await FirebaseFirestore.instance
        .collection(UserProfileData.tmVersity!)
        .doc('AllBooks')
        .collection('AllBooks')
        .where(field, isEqualTo: search)
        .get();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> bookDataSearchStream(
      String field, String search) {
    return FirebaseFirestore.instance
        .collection(UserProfileData.tmVersity!)
        .doc('AllBooks')
        .collection('AllBooks')
        .where(field, isEqualTo: search)
        .snapshots();
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> bookDataGrSearch(
      String field, String search) async {
    return await FirebaseFirestore.instance
        .collection(UserProfileData.tmVersity!)
        .doc('AllBooks')
        .collection('AllBooks')
        .where(field, isGreaterThanOrEqualTo: search)
        .get();
  }

  static bookDataDelete(String? docId, String folder) async {
    try {
      // print(docId);
      // print('\n');
      await FirebaseFirestore.instance
          .collection(UserProfileData.tmVersity!)
          .doc('AllBooks')
          .collection(folder)
          .doc(docId)
          .delete();
      // .where(field, isLessThanOrEqualTo: search)
    } catch (e) {
      print('Error deleting');
    }
  }
}

class StorageSettings {
  static deleteImage(String url) async {
    try {
      Reference photoRef = FirebaseStorage.instance.refFromURL(url);
      await photoRef.delete();
    } catch (e) {
      print(e);
      print('Error photo deleting');
    }
  }

  // static void deleteFireBaseStorageItem(String fileUrl) {
  //   String filePath = fileUrl.replaceAll(
  //       new RegExp(
  //           r'https://firebasestorage.googleapis.com/v0/b/dial-in-2345.appspot.com/o/'),
  //       '');

  //   filePath = filePath.replaceAll(new RegExp(r'%2F'), '/');

  //   filePath = filePath.replaceAll(new RegExp(r'(\?alt).*'), '');

  //   StorageReference storageReferance = FirebaseStorage.instance.ref();

  //   storageReferance
  //       .child(filePath)
  //       .delete()
  //       .then((_) => print('Successfully deleted $filePath storage item'));
  // }
}

class Interactions {
  static DocumentReference firestoreRef = FirebaseFirestore.instance
      .collection(UserProfileData.tmVersity!)
      .doc('Interactions');

  static writeMsg(String email, Map<String, dynamic> map) async {
    await firestoreRef.collection(email).add(map);
  }

  static deleteDocWithId(String email, String? id) async {
    await firestoreRef.collection(email).doc(id).delete();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMsgStream(
      String email) {
    return firestoreRef
        .collection(email)
        .orderBy('SentKey', descending: true)
        .limit(15)
        .get()
        .asStream();
  }

  static testWrite(String email, Map<String, dynamic> map) async {
    await FirebaseFirestore.instance.collection('Interactions').doc().set(map);
  }
}

class ChatsFirebase {
  CollectionReference firestoreColRef = FirebaseFirestore.instance
      .collection(UserProfileData.tmVersity!)
      .doc('Interactions')
      .collection(UserProfileData.email!);

  fromMe(String docID, Map<String, dynamic> map) async {
    await firestoreColRef.doc(docID).collection(docID).add(map);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getStream(String docID) {
    return firestoreColRef
        .doc(docID)
        .collection(docID)
        .orderBy('time', descending: true)
        .limitToLast(20)
        .snapshots();
  }
}
