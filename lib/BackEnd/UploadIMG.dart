import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class UploadIMG {
  static PickedFile pickedImage;
  static File imageUser;
  static File imageBook;

  final _picker = ImagePicker();

  getUserPic() async {
    pickedImage =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 30);
    imageUser = File(pickedImage.path);
  }

  getBookPic() async {
    pickedImage =
        await _picker.getImage(source: ImageSource.camera, imageQuality: 30);
    imageBook = File(pickedImage.path);
  }

  uploadUserPic(String uid) async {
    StorageReference userPic =
        FirebaseStorage.instance.ref().child('User').child(uid).child(uid);
    await userPic.putFile(imageUser).onComplete;
    return await userPic.getDownloadURL();
  }

  uploadBookPic(String bookID, String email) async {
    StorageReference bookPic = FirebaseStorage.instance
        .ref()
        .child('Books')
        .child(email)
        .child(bookID);
    await bookPic.putFile(imageBook).onComplete;
    print('upload Complete book');
    return await bookPic.getDownloadURL();
  }
}
