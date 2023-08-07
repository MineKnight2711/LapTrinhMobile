import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_mobile_app/controller/address_controller.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/custom_appbar.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/message.dart';

import '../../configs/mediaquery.dart';
import '../../widgets/custom_widgets/custom_button.dart';
import '../../widgets/custom_widgets/custom_input.dart';

class NewAddressScreen extends StatelessWidget {
  final addressController = Get.find<AddressController>();
  NewAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: "Thêm địa chỉ",
          onPressed: () {
            addressController.onFinishingAddAddress();
            Navigator.pop(context);
          }),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(2),
                  alignment: Alignment.centerLeft,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Thông tin liên hệ"),
                  ),
                ),
                SizedBox(
                  height: mediaHeight(context, 120),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: CustomInputTextField(
                    onChanged: addressController.validateReceiverName,
                    controller: addressController.receiverNameController,
                    labelText: 'Họ tên người nhận',
                    hintText: 'Nhập họ tên',
                  ),
                ),
                SizedBox(
                  height: mediaHeight(context, 90),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: CustomInputTextField(
                    onChanged: addressController.validateReceiverPhone,
                    controller: addressController.receiverPhoneController,
                    textInputType: TextInputType.phone,
                    labelText: 'Số điện thoại người nhận',
                    hintText: 'Nhập số điện thoại',
                  ),
                ),
                SizedBox(
                  height: mediaHeight(context, 120),
                ),
                Container(
                  margin: const EdgeInsets.all(2),
                  alignment: Alignment.centerLeft,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Địa chỉ"),
                  ),
                ),
                SizedBox(
                  height: mediaHeight(context, 120),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: CustomInputTextField(
                    onChanged: addressController.validateHouseAndStreet,
                    controller: addressController.houseAndStreetController,
                    labelText: 'Số nhà, đường',
                  ),
                ),
                SizedBox(
                  height: mediaHeight(context, 90),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: CustomInputTextField(
                    onChanged: addressController.validateWard,
                    controller: addressController.wardController,
                    labelText: 'Phường/Xã',
                  ),
                ),
                SizedBox(
                  height: mediaHeight(context, 90),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: CustomInputTextField(
                    onChanged: addressController.validateDistrictAndCity,
                    controller: addressController.districtAndCityController,
                    labelText: 'Quận/Huyện,Thành phố/Tỉnh',
                  ),
                ),
                SizedBox(
                  height: mediaHeight(context, 90),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Text(
                        "Đặt làm địa chỉ mặc định",
                        style: GoogleFonts.nunito(fontSize: 16),
                      ),
                      const Spacer(),
                      Transform.scale(
                        scale: 1.2,
                        child: Obx(
                          () => Switch(
                            value: addressController.listAddress.value ==
                                        null ||
                                    addressController.listAddress.value!.isEmpty
                                ? true
                                : addressController.defaultAddress.value,
                            onChanged: addressController.listAddress.value ==
                                        null ||
                                    addressController.listAddress.value!.isEmpty
                                ? null
                                : (value) {
                                    addressController.defaultAddress.value =
                                        value;
                                  },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: mediaHeight(context, 90),
                ),
                Container(
                    margin: const EdgeInsets.all(16),
                    child: Obx(
                      () => DefaultButton(
                        enabled: addressController.isValidReceiverName.value &&
                            addressController.isValidReceiverPhone.value &&
                            addressController.isValidHouseAndStreet.value &&
                            addressController.isValidWard.value &&
                            addressController.isValidDistrictAndCity.value,
                        text: "Thêm địa chỉ",
                        press: () async {
                          final currentAccount =
                              await addressController.awaitCurrentAccount();
                          if (currentAccount != null) {
                            String result = await addressController
                                .addAddress("${currentAccount.accountId}");
                            if (result == "Success") {
                              CustomSuccessMessage.showMessage(
                                      "Thêm địa chỉ thành công")
                                  .then((value) {
                                addressController
                                    .getListAddress()
                                    .whenComplete(() {
                                  addressController.onFinishingAddAddress();
                                  addressController.getListAddress();
                                  Navigator.pop(context);
                                });
                              });
                            } else {
                              CustomErrorMessage.showMessage("Có lỗi xảy ra!");
                            }
                          } else {
                            CustomErrorMessage.showMessage(
                                "Phiên đăng nhập không hợp lệ!");
                          }
                        },
                      ),
                    ))
              ],
            ),
          ),
        ],
      )),
    );
  }
}
