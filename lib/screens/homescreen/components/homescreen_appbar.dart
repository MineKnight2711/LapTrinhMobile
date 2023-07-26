import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_mobile_app/configs/constant.dart';
import 'package:keyboard_mobile_app/screens/homescreen/components/user_drawer.dart';
import 'package:keyboard_mobile_app/screens/homescreen/homescreen.dart';
import 'package:keyboard_mobile_app/screens/login_signup/login_screen.dart';
import 'package:keyboard_mobile_app/transition_animation/screen_transition.dart';

import '../../../api/account_api.dart';

// ignore: must_be_immutable
class CustomHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final accountApi = Get.find<AccountApi>();
  // final cartController = Get.find<CartController>();
  CustomHomeAppBar({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: GestureDetector(
        child: const Icon(
          Icons.home_outlined,
          size: 30,
        ),
        onTap: () {
          slideInTransition(context, HomeScreen());
        },
      ),
      backgroundColor: mainAppThemeColor,
      title: Text(
        "Home",
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      actions: [
        SizedBox(
          width: 45,
          child: Obx(() {
            final userInfo = accountApi.accountRespone.value;
            if (userInfo == null) {
              return Container(
                width: 45,
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: Image.asset(
                      'assets/images/profile.png',
                      scale: 1,
                    ).image,
                    fit: BoxFit.fill,
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    slideInTransition(context, LoginScreen());
                  },
                ),
              );
            } else {
              String? imageUrl = accountApi.accountRespone.value?.imageUrl;
              return Container(
                width: 45,
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: imageBackgroundColor,
                  image: DecorationImage(
                    image: imageUrl != null
                        ? Image.network(
                            imageUrl,
                          ).image
                        : Image.asset(
                            'assets/images/profile.png',
                          ).image,
                    fit: BoxFit.fill,
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    scaffoldKey.currentState?.openEndDrawer();
                  },
                ),
              );
            }
          }),
        ),
        const SizedBox(
          width: 23.0,
        ),
      ],
    );
  }

  late String? avt;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Widget buildDrawer(BuildContext context) {
    accountApi.fetchCurrent();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Obx(() {
            if (accountApi.accountRespone.value != null) {
              final accounts = accountApi.accountRespone.value!;
              return UserDrawer(
                accounts: accounts,
              );
            }
            return const NoUserDrawer();
          }),
        ],
      ),
    );
  }
}
