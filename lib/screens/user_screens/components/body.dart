// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_mobile_app/api/account_api.dart';
import 'package:keyboard_mobile_app/model/account_respone.dart';

import '../../../configs/mediaquery.dart';
import '../../../controller/update_profile_controller.dart';
import '../../../widgets/custom_widgets/gender_chose.dart';
import 'dropdown.dart';

class BodyAccount extends StatelessWidget {
  final AccountResponse account;
  BodyAccount({
    Key? key,
    required this.account,
  }) : super(key: key);
  final profileController = Get.find<UpdateProfileController>();

  final controller = Get.find<AccountApi>();

  late String? imgUrl = '';

  // @override
  @override
  Widget build(BuildContext context) {
    profileController.fetchCurrent();
    return SingleChildScrollView(
      child: Container(
        height: mediaHeight(context, 1),
        width: mediaWidth(context, 1),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Center(
                    child: SizedBox(
                      height: mediaHeight(context, 5),
                      width: mediaWidth(context, 3),
                      child:
                          CachedNetworkImage(imageUrl: "${account.imageUrl}"),
                    ),
                  ),
                  Divider(
                    endIndent: mediaWidth(context, 5),
                    indent: mediaWidth(context, 5),
                    thickness: 2,
                    color: Colors.black38,
                  ),
                  dropDownInfo(
                      text: 'Tên',
                      name: '${controller.accountRespone.value!.fullName}'),
                  dropDownInfo(
                      text: 'Số điện thoại',
                      name: '${controller.accountRespone.value!.phoneNumber}'),
                  SizedBox(
                    height: mediaHeight(context, 23),
                  ),
                  DropdownDate(
                    text: "Ngày sinh",
                    name: DateFormat("dd/MM/yyyy").format(account.birthday!),
                    currentBirthDay: account.birthday,
                  ),
                  // BirthdayDatePickerWidget(
                  //   initialDate: account.birthday,
                  //   onChanged: (value) {
                  //     profileController.date = value;
                  //   },
                  // ),
                  GenderSelectionWidget(
                    gender: account.gender,
                    onChanged: (value) {
                      profileController.selectedGender = value;
                    },
                    size: 2,
                  ), // Add more ListTiles here for each setting
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
