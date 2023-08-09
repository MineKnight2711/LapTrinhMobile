import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_mobile_app/controller/update_profile_controller.dart';
import 'package:keyboard_mobile_app/utils/data_convert.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/custom_input.dart';
import '../../../api/account_api.dart';
import '../../../configs/mediaquery.dart';
import '../../../model/account_model.dart';
import '../../../transition_animation/screen_transition.dart';
import '../../../utils/show_animations.dart';
import '../../../widgets/custom_widgets/datetime_picker.dart';
import '../../../widgets/custom_widgets/message.dart';
import '../../homescreen/homescreen.dart';

// class DropdownDate extends StatefulWidget {
//   const DropdownDate({
//     Key? key,
//     required this.name,
//     required this.text,
//     this.currentBirthDay,
//   }) : super(key: key);

//   final String text, name;
//   final DateTime? currentBirthDay;
//   @override
//   State<DropdownDate> createState() => _DropdownDate();
// }

class DatePickerExpandTile extends StatelessWidget {
  final String title;
  final DateTime? currentBirthday;
  final UpdateProfileController updateProfileController;
  DatePickerExpandTile(
      {super.key,
      required this.title,
      required this.currentBirthday,
      required this.updateProfileController});
  final accountApi = Get.find<AccountApi>();
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Text(DateFormat("dd/MM/yyyy").format(currentBirthday!)),
          ],
        ),
        textColor: Colors.black,
        trailing: Obx(
          () => AnimatedRotation(
            turns: updateProfileController.isBirthDayDropDown.value ? 0.25 : 0,
            duration: const Duration(milliseconds: 200),
            child: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: updateProfileController.isBirthDayDropDown.value
                  ? Colors.black
                  : Colors.black,
            ),
          ),
        ),
        onExpansionChanged: (bool value) {
          updateProfileController.isBirthDayDropDown.value = value;
        },
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                height: mediaHeight(context, 17),
                width: mediaWidth(context, 1.5),
                child: BirthdayDatePickerWidget(
                  initialDate: currentBirthday,
                  onChanged: (value) {
                    updateProfileController.date = value;
                  },
                ),
              ),
              const Spacer(),
              Container(
                width: 1.5,
                height: 20,
                color: Colors.black,
              ),
              TextButton(
                onPressed: () async {
                  showOrderLoadingAnimation(
                      context, "assets/animations/loading_1.json", 180);
                  String result = await updateProfileController.updateAccount();
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
                child: const Text(
                  'Lưu',
                ),
              ),
            ],
          ),
        ],
      )
    ]);
  }
}

class InputExpandTile extends StatelessWidget {
  final String title;
  final String content;
  final Function(String?)? textFieldOnChanged;
  final TextEditingController textController;
  final TextInputType? inputType;
  final bool isExpanded;
  final bool isValid;
  final Function(bool)? onExpansionChanged;
  final Function()? onSavePressed;
  const InputExpandTile(
      {super.key,
      required this.title,
      required this.content,
      required this.textController,
      this.textFieldOnChanged,
      this.inputType,
      required this.isExpanded,
      this.onExpansionChanged,
      this.onSavePressed,
      required this.isValid});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Text(content),
          ],
        ),
        textColor: Colors.black,
        trailing: AnimatedRotation(
          turns: isExpanded ? 0.25 : 0,
          duration: const Duration(milliseconds: 200),
          child: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: isExpanded ? Colors.black : Colors.black,
          ),
        ),
        onExpansionChanged: onExpansionChanged,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                margin: const EdgeInsets.only(left: 10),
                height: mediaHeight(context, 7),
                width: mediaWidth(context, 1.35),
                child: Center(
                  child: ProfileInputTextField(
                    controller: textController,
                    onChanged: textFieldOnChanged,
                    textInputType: inputType,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                width: 1.5,
                height: 20,
                color: Colors.black,
              ),
              TextButton(
                onPressed: isValid ? onSavePressed : null,
                child: const Text(
                  'Lưu',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ],
      )
    ]);
  }
}
// showLoadingAnimation(
//                       context, "assets/animations/loading.json", 180, 2);
//                   AccountModel account =
//                       accountApi.accountRespone.value!.toAccountModel();
//                   if (updateProfileController.date != null) {
//                     account.birthday = updateProfileController.date;
//                     await accountApi.updateAccount(account);
//                     accountApi.fetchCurrent().whenComplete(() {
//                       replaceFadeInTransition(context, HomeScreen());
//                     });
//                   } else {
//                     await accountApi.updateAccount(account);
//                     accountApi.fetchCurrent().whenComplete(() {
//                       replaceFadeInTransition(context, HomeScreen());
//                     });
//                   }