import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_mobile_app/api/account_api.dart';
import 'package:keyboard_mobile_app/configs/mediaquery.dart';
import 'package:keyboard_mobile_app/model/account_model.dart';
import 'package:keyboard_mobile_app/screens/homescreen/homescreen.dart';
import 'package:keyboard_mobile_app/transition_animation/screen_transition.dart';
import 'package:keyboard_mobile_app/utils/show_animations.dart';

import '../../../widgets/custom_widgets/datetime_picker.dart';

class dropDownInfo extends StatefulWidget {
  const dropDownInfo({
    Key? key,
    required this.name,
    required this.text,
  }) : super(key: key);

  final String text, name;

  @override
  State<dropDownInfo> createState() => _dropDownInfo();
}

class _dropDownInfo extends State<dropDownInfo> {
  bool _isExpanded = false;
  final String _textValue = '';
  late final TextEditingController _textEditingController =
      TextEditingController();
  final accountApi = Get.find<AccountApi>();

  @override
  void initState() {
    super.initState();
    _textEditingController.text = widget.name;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.text),
            Text(widget.name),
          ],
        ),
        textColor: Colors.black,
        trailing: AnimatedRotation(
          turns: _isExpanded ? 0.25 : 0,
          duration: const Duration(milliseconds: 200),
          child: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: _isExpanded ? Colors.black : Colors.black,
          ),
        ),
        onExpansionChanged: (bool value) {
          setState(() {
            _isExpanded = value;
          });
        },
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                      hintText: "Input your ${widget.name}",
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20)),
                ),
              ),
              Container(
                width: 1.5,
                height: 20,
                color: Colors.black,
              ),
              TextButton(
                onPressed: () async {
                  try {
                    showLoadingAnimation(
                        context, "assets/animations/loading.json", 180, 2);
                    AccountModel account =
                        accountApi.accountRespone.value!.toAccountModel();
                    if (widget.text == 'Tên') {
                      account.fullName = _textEditingController.text;
                      await accountApi.updateAccount(account);
                      accountApi.fetchCurrent().whenComplete(() {
                        replaceFadeInTransition(context, HomeScreen());
                      });
                    } else if (widget.text == 'Số điện thoại') {
                      account.phone = _textEditingController.text;
                      await accountApi.updateAccount(account);
                      accountApi.fetchCurrent().whenComplete(() {
                        replaceFadeInTransition(context, HomeScreen());
                      });
                    } else {
                      account.fullName = _textEditingController.text;
                      await accountApi.updateAccount(account);
                      accountApi.fetchCurrent().whenComplete(() {
                        replaceFadeInTransition(context, HomeScreen());
                      });
                    }
                    // AccountModel user = AccountModel(
                    //     accountId: account.accountId,
                    //     fullName: account.fullName,
                    //     birthday: account.birthday,
                    //     phone: account.phone,
                    //     email: account.email,
                    //     gender: account.gender,
                    //     imageUrl: account.imageUrl);
                    // Get.back();
                  } catch (e) {
                    throw Exception(e);
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

class DropdownDate extends StatefulWidget {
  const DropdownDate({
    Key? key,
    required this.name,
    required this.text,
    this.currentBirthDay,
  }) : super(key: key);

  final String text, name;
  final DateTime? currentBirthDay;
  @override
  State<DropdownDate> createState() => _DropdownDate();
}

class _DropdownDate extends State<DropdownDate> {
  bool _isExpanded = false;
  DateTime? chosenDate;
  late final TextEditingController _textEditingController =
      TextEditingController();
  final accountApi = Get.find<AccountApi>();

  @override
  void initState() {
    super.initState();
    _textEditingController.text = widget.name;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.text),
            Text(widget.name),
          ],
        ),
        textColor: Colors.black,
        trailing: AnimatedRotation(
          turns: _isExpanded ? 0.25 : 0,
          duration: const Duration(milliseconds: 200),
          child: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: _isExpanded ? Colors.black : Colors.black,
          ),
        ),
        onExpansionChanged: (bool value) {
          setState(() {
            _isExpanded = value;
          });
        },
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                height: mediaHeight(context, 17),
                width: mediaWidth(context, 1.5),
                child: BirthdayDatePickerWidget(
                  initialDate: widget.currentBirthDay,
                  onChanged: (value) {
                    chosenDate = value;
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
                  try {
                    showLoadingAnimation(
                        context, "assets/animations/loading.json", 180, 2);
                    AccountModel account =
                        accountApi.accountRespone.value!.toAccountModel();
                    if (chosenDate != null) {
                      account.birthday = chosenDate;
                      await accountApi.updateAccount(account);
                      accountApi.fetchCurrent().whenComplete(() {
                        replaceFadeInTransition(context, HomeScreen());
                      });
                    } else {
                      await accountApi.updateAccount(account);
                      accountApi.fetchCurrent().whenComplete(() {
                        replaceFadeInTransition(context, HomeScreen());
                      });
                    }

                    // AccountModel user = AccountModel(
                    //     accountId: account.accountId,
                    //     fullName: account.fullName,
                    //     birthday: account.birthday,
                    //     phone: account.phone,
                    //     email: account.email,
                    //     gender: account.gender,
                    //     imageUrl: account.imageUrl);
                    // Get.back();
                  } catch (e) {
                    throw Exception(e);
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
