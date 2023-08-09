// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_mobile_app/controller/update_profile_controller.dart';
import 'package:keyboard_mobile_app/model/account_respone.dart';
import 'package:keyboard_mobile_app/screens/user_screens/components/drop_down.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/custom_appbar.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/custom_button.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/message.dart';
import '../../api/account_api.dart';
import '../../configs/mediaquery.dart';
import '../../transition_animation/screen_transition.dart';
import '../../utils/show_animations.dart';
import '../homescreen/homescreen.dart';

class ChangeInfo extends StatelessWidget {
  final AccountResponse account;
  ChangeInfo({super.key, required this.account});
  final profileController = Get.find<UpdateProfileController>();
  final accountApi = Get.find<AccountApi>();
  @override
  Widget build(BuildContext context) {
    profileController.fetchCurrent();
    return Scaffold(
      appBar: CustomAppBar(
        onPressed: () {
          profileController.onClose();
          Navigator.pop(context);
        },
        title: 'Cập nhật thông tin',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: mediaHeight(context, 40),
            ),
            AccountAvatar(imageUrl: account.imageUrl),
            SizedBox(
              height: mediaHeight(context, 40),
            ),
            Divider(
              endIndent: mediaWidth(context, 5),
              indent: mediaWidth(context, 5),
              thickness: 2,
              color: Colors.black38,
            ),
            SizedBox(
              height: mediaHeight(context, 50),
            ),
            DatePickerExpandTile(
              title: "Ngày sinh",
              currentBirthday: account.birthday,
              updateProfileController: profileController,
            ),
            SizedBox(
              height: mediaHeight(context, 20 * 10),
            ),
            Obx(
              () => InputExpandTile(
                title: 'Họ và tên',
                content: account.fullName.toString(),
                textController: profileController.fullNameController,
                isExpanded: profileController.isFullNameDropdown.value,
                isValid: profileController.isValidFullname.value,
                textFieldOnChanged: profileController.validateFullname,
                onExpansionChanged: (isExpanded) {
                  profileController.isFullNameDropdown.value = isExpanded;
                },
                onSavePressed: () async {
                  showOrderLoadingAnimation(
                      context, "assets/animations/loading_1.json", 180);
                  String result = await profileController.updateAccount();
                  if (result == "Success") {
                    CustomSuccessMessage.showMessage("Cập nhật thành công!")
                        .whenComplete(() {
                      Navigator.pop(context);
                      accountApi.fetchCurrent().whenComplete(() {
                        replaceFadeInTransition(context, HomeScreen());
                      });
                    });
                  } else {
                    CustomErrorMessage.showMessage("Có lỗi xảy ra!")
                        .whenComplete(() => Navigator.pop(context));
                  }
                },
              ),
            ),
            Obx(
              () => InputExpandTile(
                title: 'Số điện thoại',
                content: account.phoneNumber.toString(),
                textController: profileController.phoneNumberController,
                isExpanded: profileController.isPhoneNumberDropDown.value,
                isValid: profileController.isValidPhonenumber.value,
                textFieldOnChanged: profileController.validatePhonenumber,
                onExpansionChanged: (isExpanded) {
                  profileController.isPhoneNumberDropDown.value = isExpanded;
                },
                onSavePressed: () async {
                  showOrderLoadingAnimation(
                      context, "assets/animations/loading_1.json", 180);
                  String result = await profileController.updateAccount();
                  if (result == "Success") {
                    CustomSuccessMessage.showMessage("Cập nhật thành công!")
                        .whenComplete(() {
                      Navigator.pop(context);
                      accountApi.fetchCurrent().whenComplete(() {
                        replaceFadeInTransition(context, HomeScreen());
                      });
                    });
                  } else {
                    CustomErrorMessage.showMessage("Có lỗi xảy ra!")
                        .whenComplete(() => Navigator.pop(context));
                  }
                },
              ),
            ),
            SizedBox(
              height: mediaHeight(context, 40),
            ),
            SizedBox(
              height: mediaHeight(context, 40),
            ),
          ],
        ),
      ),
    );
  }
}

class AccountAvatar extends StatelessWidget {
  final String? imageUrl;
  const AccountAvatar({
    super.key,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 80,
      backgroundImage: CachedNetworkImageProvider(imageUrl ?? ''),
    );
  }
}
