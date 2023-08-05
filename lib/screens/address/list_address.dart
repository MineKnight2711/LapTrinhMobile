import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_mobile_app/configs/mediaquery.dart';
import 'package:keyboard_mobile_app/controller/address_controller.dart';
import 'package:keyboard_mobile_app/model/account_respone.dart';
import 'package:keyboard_mobile_app/screens/address/components/address_item.dart';
import 'package:keyboard_mobile_app/utils/show_animations.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/custom_appbar.dart';
import 'package:lottie/lottie.dart';

class AddressListScreen extends StatelessWidget {
  final addressController = Get.find<AddressController>();
  AddressListScreen({super.key});
  Future<void> onRefresh() async {
    addressController.getListAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Địa chỉ của tôi'),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: Obx(() {
          if (addressController.listAddress.value != null) {
            final listAddress = addressController.listAddress.value!;
            if (listAddress.isNotEmpty) {
              return SizedBox(
                width: mediaWidth(context, 1),
                child: SingleChildScrollView(
                  child: Column(
                    children: listAddress
                        .map((address) => AddressItem(
                              address: address,
                            ))
                        .toList(),
                  ),
                ),
              );
            }
            return Lottie.asset("assets/animations/loading_1.json",
                width: mediaWidth(context, 1), height: mediaHeight(context, 1));
          }
          return Lottie.asset("assets/animations/loading_1.json",
              width: mediaWidth(context, 1), height: mediaHeight(context, 1));
        }),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: FloatingActionButton.extended(
          label: const Icon(Icons.add),
          onPressed: () {},
        ),
      ),
    );
  }
}
