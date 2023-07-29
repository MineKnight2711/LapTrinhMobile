import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

Future<String> saveImage(File? imageFile, String userInfo) async {
  if (imageFile != null) {
    final fileName = 'user_$userInfo.jpg';
    final Reference storageReference =
        FirebaseStorage.instance.ref().child('userimage/$fileName');
    final UploadTask uploadTask = storageReference.putFile(imageFile);
    final TaskSnapshot downloadUrl = (await uploadTask);
    final String url = await downloadUrl.ref.getDownloadURL();
    return url;
  }
  return '';
}
