import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uBookSharing/BackEnd/Datas.dart';

class UploadIMG {
  static PickedFile pickedImage;
  static File imageUser;
  static File imageBook;

  final _picker = ImagePicker();

  getUserPic() async {
    pickedImage =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 15);
    imageUser = File(pickedImage.path);

    // String dir = (await getApplicationDocumentsDirectory()).path;
    // String newPath = path.join(dir, 'case01wd03id01.jpg');
    // imageUser = await File(pickedImage.path).copy(newPath);
  }

  getBookPic() async {
    pickedImage =
        await _picker.getImage(source: ImageSource.camera, imageQuality: 15);
    imageBook = File(pickedImage.path);
  }

  uploadUserPic(String email) async {
    // String id = UsableData.getMillisecondsId();
    StorageReference userPic = FirebaseStorage.instance
        .ref()
        .child('User')
        .child(email)
        .child(UsableData.getMillisecondsId());

    await userPic.putFile(imageUser).onComplete;
    return await userPic.getDownloadURL();
  }

  uploadBookPic(String email) async {
    String id = UsableData.getMillisecondsId();
    StorageReference bookPic = FirebaseStorage.instance
        .ref()
        .child('Books')
        .child('Upload')
        .child(email)
        // .child(id)
        .child(id);
    await bookPic.putFile(imageBook).onComplete;
    // print('upload Complete book');
    return await bookPic.getDownloadURL();
  }

  uploadRequstPic(String email) async {
    String id = UsableData.getMillisecondsId();
    StorageReference bookPic = FirebaseStorage.instance
        .ref()
        .child('Books')
        .child('Request')
        .child(email)
        // .child(id)
        .child(id);
    await bookPic.putFile(imageUser).onComplete;
    // print('upload Complete book');
    return await bookPic.getDownloadURL();
  }
}
