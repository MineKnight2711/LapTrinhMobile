import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:keyboard_mobile_app/api/account_api.dart';

import '../model/account_respone.dart';

class ChangeImageController extends GetxController {
  final newImageUrl = ''.obs;
  final accountApi = Get.find<AccountApi>();

  //Chờ thông tin người dùng hiện tại
  Future<AccountResponse?> awaitCurrentAccount() async {
    return await accountApi.fetchCurrent().then((currentAccount) {
      if (currentAccount != null) {
        newImageUrl.value = currentAccount.imageUrl ?? '';
        return currentAccount;
      }
      return null;
    });
  }

  Future<String> changeImageUrl(String accountId, String newImageUrl) async {
    final respone = await accountApi.changeImageUrl(accountId, newImageUrl);
    if (respone.message!.contains("success")) {
      return "Success";
    }
    return respone.message!;
  }

  Future<String> saveImageToFirebaseStorage(
      File? imageFile, String userInfo) async {
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
}
