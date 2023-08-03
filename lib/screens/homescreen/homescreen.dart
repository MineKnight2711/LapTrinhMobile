import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_mobile_app/configs/constant.dart';
import 'package:keyboard_mobile_app/controller/cart_controller.dart';
import 'package:keyboard_mobile_app/controller/category_controller.dart';
import 'package:keyboard_mobile_app/controller/product_controller.dart';
import 'package:keyboard_mobile_app/screens/cart_screen/cart_screen.dart';
import 'package:keyboard_mobile_app/screens/homescreen/components/homescreen_body.dart';
import 'package:keyboard_mobile_app/transition_animation/screen_transition.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/custom_appbar.dart';

import 'components/homescreen_appbar.dart';

class HomeScreenController extends GetxController {
  var selectedindex = 0.obs;
  void onItemTapped(BuildContext context, int index) {
    selectedindex.value = index;
    if (selectedindex.value == 1) {
      Get.put(CartController());
      slideInTransition(context, CartScreen());
    } else {
      slideInTransitionReplacement(context, HomeScreen());
    }
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final homeController = Get.find<HomeScreenController>();
  final categoryController = Get.find<CategoryController>();
  final productController = Get.find<ProductController>();
  Future<void> _refesh() async {
    await categoryController.getAllCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      ////////////////MENU NAVIGATION BAR BEN TRAI O DAY//////////////
      appBar: CustomAppBar(
        onPressed: () {},
        showLeading: false,
        actions: [
          CustomHomeAppBar(scaffoldKey: scaffoldKey),
        ],
        title: "CMK",
        backGroundColor: Colors.transparent,
      ),
      endDrawer:
          CustomHomeAppBar(scaffoldKey: scaffoldKey).buildDrawer(context),
      body: RefreshIndicator(
        onRefresh: _refesh,
        color: Colors.blue,
        child: const HomescreenBody(),
      ),
      bottomNavigationBar: Obx(
        () => MyBottomNavigationBar(
          onItemTapped: (index) => homeController.onItemTapped(context, index),
          selectedIndex: homeController.selectedindex.value,
        ),
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
