import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_mobile_app/configs/mediaquery.dart';
import 'package:keyboard_mobile_app/controller/address_controller.dart';
import 'package:keyboard_mobile_app/screens/address/add_address_screen.dart';
import 'package:keyboard_mobile_app/screens/address/components/address_item.dart';
import 'package:keyboard_mobile_app/screens/address/update_adress_screen.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/custom_appbar.dart';
import '../../transition_animation/screen_transition.dart';

class AddressListScreen extends StatelessWidget {
  final addressController = Get.find<AddressController>();
  AddressListScreen({super.key});
  Future<void> onRefresh() async {
    addressController.getListAddress();
  }

  @override
  Widget build(BuildContext context) {
    addressController.getListAddress();
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Địa chỉ của tôi',
        onPressed: () {
          addressController.listAddress.value = null;
          Navigator.pop(context);
        },
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: Obx(() {
          if (addressController.listAddress.value != null) {
            addressController.listAddress.value!;
            return SizedBox(
              width: mediaWidth(context, 1),
              child: SingleChildScrollView(
                child: Obx(
                  () => Column(
                    children: addressController.listAddress.value!
                        .where((element) => element.defaultAddress == true)
                        .map((address) => InkWell(
                              onTap: () {
                                addressController.fetchCurrentAddress(address);
                                slideInTransition(
                                    context,
                                    UpdateAddressScreen(
                                      address: address,
                                    ));
                              },
                              child: AddressItem(
                                address: address,
                              ),
                            ))
                        .toList()
                      ..addAll(
                        addressController.listAddress.value!
                            .where((address) =>
                                address.defaultAddress ==
                                false) // Filter addresses with defaultAddress == false
                            .map((address) => InkWell(
                                  onTap: () {
                                    addressController
                                        .fetchCurrentAddress(address);
                                    slideInTransition(
                                        context,
                                        UpdateAddressScreen(
                                          address: address,
                                        ));
                                  },
                                  child: AddressItem(
                                    address: address,
                                  ),
                                ))
                            .toList(),
                      ),
                  ),
                ),
              ),
            );
          }

          return const Center(
            child: Text("Bạn chưa có địa chỉ ?"),
          );
        }),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
        child: FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          label: Text(
            'Thêm',
            style: GoogleFonts.nunito(fontSize: 16),
          ),
          onPressed: () {
            slideUpTransition(context, NewAddressScreen());
          },
        ),
      ),
    );
  }
}
