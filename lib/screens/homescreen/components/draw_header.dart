import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_mobile_app/configs/mediaquery.dart';
import 'package:keyboard_mobile_app/model/account_respone.dart';
import 'package:keyboard_mobile_app/utils/save_image.dart';
import 'package:keyboard_mobile_app/utils/show_animations.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/message.dart';
import 'package:logger/logger.dart';

import '../../../widgets/image_picker/select_image_constant/image_select.dart';

class MyDrawerHeader extends StatelessWidget {
  final AccountResponse account;
  final changeImageController = Get.put(ChangeImageController());
  MyDrawerHeader({
    Key? key,
    required this.account,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      // margin: EdgeInsets.only(bottom: 50),
      decoration: const BoxDecoration(
        color: Color(0xff06AB8D),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              // padding: EdgeInsets.only(bottom: 30),
              height: mediaHeight(context, 6.5),
              width: mediaWidth(context, 3.5),
              child: Obx(
                () => ImagePickerWidget(
                  onImageSelected: (selectedImage) async {
                    String url =
                        await changeImageController.saveImageToFirebaseStorage(
                            selectedImage, "${account.accountId}");
                    Logger().i("$url log url");
                    if (url.isNotEmpty) {
                      // ignore: use_build_context_synchronously
                      showLoadingAnimation(
                          context, "assets/animations/loading_1.json", 180, 3);
                      String result = await changeImageController
                          .changeImageUrl("${account.accountId}", url);
                      if (result == "Success") {
                        CustomSuccessMessage.showMessage(
                                "Cập nhật ảnh thành công!")
                            .then((value) {
                          changeImageController
                              .awaitCurrentAccount()
                              .whenComplete(() => Navigator.pop(context));
                        });
                      } else {
                        CustomErrorMessage.showMessage(result);
                      }
                    } else {
                      CustomErrorMessage.showMessage("Có lỗi xảy ra!");
                    }
                  },
                  currentImageUrl:
                      changeImageController.newImageUrl.value.isNotEmpty
                          ? changeImageController.newImageUrl.value
                          : account.imageUrl,
                ),
              ),
            ),
            SizedBox(height: mediaHeight(context, 150)),
            Text(
              "${account.fullName}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "${account.email}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
