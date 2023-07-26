import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_mobile_app/configs/constant.dart';
import 'package:keyboard_mobile_app/screens/homescreen/components/homescreen_body.dart';

import 'components/homescreen_appbar.dart';

class HomeScreenController extends GetxController {
  var selectedindex = 0.obs;
  void onItemTapped(int index) {
    selectedindex.value = index;
    // if (selectedindex.value == 1) {
    //   if (u.user == null) {
    //     slideinTransition(context, LoginScreen());
    //     pleaseLoginPopup(context);
    //   } else {
    //     slideinTransition(context, CardScreenView());
    //   }
    // } else if (selectedindex.value == 0) {
    //   slideinTransitionNoBack(context, AppHomeScreen());
    // }
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final homeController = Get.find<HomeScreenController>();
  Future<void> _refesh() async {
    // await categoryController.getAllCategory();
    // await dishController.getAllDish();
    // await sizeController.getAllSize();
    // await toppingController.getAllTopping();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      ////////////////MENU NAVIGATION BAR BEN TRAI O DAY//////////////
      appBar: CustomHomeAppBar(scaffoldKey: scaffoldKey),
      endDrawer:
          CustomHomeAppBar(scaffoldKey: scaffoldKey).buildDrawer(context),
      body: RefreshIndicator(
        onRefresh: _refesh,
        color: Colors.blue,
        child: ListView(
          children: const [
            Column(
              children: [
                SizedBox(height: 10),
                HomescreenBody(),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        onItemTapped: (index) => homeController.onItemTapped,
        selectedIndex: homeController.selectedindex.value,
      ),
    );
  }
}

class MyBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const MyBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8.0,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        child: BottomNavigationBar(
          backgroundColor: mainBottomNavColor,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Giỏ hàng',
            ),
          ],
          currentIndex: selectedIndex,
          onTap: onItemTapped,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
        ),
      ),
    );
  }
}
