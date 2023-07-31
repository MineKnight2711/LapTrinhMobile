import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_mobile_app/controller/account_controller.dart';
import 'package:keyboard_mobile_app/controller/login_controller.dart';
import 'package:keyboard_mobile_app/controller/update_profile_controller.dart';
import 'package:keyboard_mobile_app/model/account_respone.dart';
import 'package:keyboard_mobile_app/transition_animation/screen_transition.dart';
import '../../../controller/change_password_controller.dart';
import '../../user_screens/change_password_screen.dart';
import '../../user_screens/update_info_screen.dart';
import 'draw_header.dart';

class UserDrawer extends StatelessWidget {
  final AccountResponse accounts;

  final loginController = Get.find<LoginController>();
  UserDrawer({
    Key? key,
    required this.accounts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        accounts.imageUrl != null
            ? MyDrawerHeader(
                fullName: '${accounts.fullName}',
                email: '${accounts.email}',
                avatarUrl: '${accounts.imageUrl}',
              )
            : MyDrawerHeader(
                fullName: '${accounts.fullName}',
                email: '${accounts.email}',
                avatarUrl: null,
              ),
        ListTile(
          title: const Text('Cập nhật thông tin'),
          onTap: () {
            Navigator.pop(context);
            Get.put(UpdateProfileController(accounts));
            slideInTransition(
              context,
              ChangeInfo(account: accounts),
            );
          },
        ),
        ListTile(
          title: const Text('Địa chỉ đã lưu'),
          onTap: () {
            Navigator.pop(context);
            Get.put(UpdateProfileController(accounts));
            slideInTransition(
              context,
              ChangeInfo(account: accounts),
            );
          },
        ),
        ListTile(
          title: const Text('Đổi mật khẩu'),
          onTap: () {
            Navigator.pop(context);
            Get.put(ChangePasswordController());
            slideInTransition(
                context,
                ChangePasswordScreen(
                  email: '${accounts.email}',
                ));
          },
        ),
        ListTile(
          title: const Text('Xác thực vân tay'),
          trailing: Obx(() => Switch(
                value: loginController.enableFingerprint.value,
                onChanged: (newValue) {
                  loginController.enableFingerprint.value = newValue;
                  loginController.setFingerPrintState(newValue);
                },
              )),
        ),
        ListTile(
          title: const Text('Đơn hàng'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text('Đăng xuất'),
          onTap: () {
            AccountController().logOut();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class NoUserDrawer extends StatelessWidget {
  const NoUserDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text('Đăng nhập'),
          onTap: () {
            // Get.put(ChangePasswordController());
            // slideinTransition(context, ChangePasswordScreen());
          },
        ),
        ListTile(
          title: const Text('Thoát'),
          onTap: () {
            // controller.logout();
            // Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
