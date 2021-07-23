import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class UploadIMG {
  // static PickedFile? pickedImage;
 static XFile? xFile;
  static late File imageUser;
  static late File imageBook;

  final _picker = ImagePicker();

  getUserPic() async {
    // pickedImage = await _picker.getImage(
    //     source: ImageSource.gallery,
    //     imageQuality: 50,
    //     maxHeight: 720,
    //     maxWidth: 720);
       xFile =await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 720,
        maxWidth: 720);
        
    imageUser = File(xFile!.path);

    // String dir = (await getApplicationDocumentsDirectory()).path;
    // String newPath = path.join(dir, 'case01wd03id01.jpg');
    // imageUser = await File(pickedImage.path).copy(newPath);
  }

  getBookPic() async {
    xFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxHeight: 1200,
        maxWidth: 1200);
    imageBook = File(xFile!.path);
  }

  uploadUserPic(String email, String id) async {
    // String id = UsableData.getMillisecondsId();
    Reference userPic =
        FirebaseStorage.instance.ref().child('User').child(email).child(id);

    await userPic.putFile(imageUser);
    return await userPic.getDownloadURL();
  }

  uploadBookPic(String email, String id) async {
    Reference bookPic = FirebaseStorage.instance
        .ref()
        .child('Books')
        .child('Upload')
        .child(email)
        // .child(id)
        .child(id);
    await bookPic.putFile(imageBook);
    // print('upload Complete book');
    return await bookPic.getDownloadURL();
  }

  uploadRequstPic(String email, String id) async {
    Reference bookPic = FirebaseStorage.instance
        .ref()
        .child('Books')
        .child('Request')
        .child(email)
        // .child(id)
        .child(id);
    await bookPic.putFile(imageUser);
    // print('upload Complete book');
    return await bookPic.getDownloadURL();
  }
}
