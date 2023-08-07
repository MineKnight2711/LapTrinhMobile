import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_mobile_app/controller/address_controller.dart';
import 'package:keyboard_mobile_app/model/address_model.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/custom_appbar.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/custom_button.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/custom_input.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/message.dart';

import '../../configs/mediaquery.dart';

class UpdateAddressScreen extends StatelessWidget {
  final AddressModel address;
  final addresController = Get.find<AddressController>();
  UpdateAddressScreen({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          onPressed: () {
            Navigator.pop(context);
          },
          title: "Cập nhật địa chỉ"),
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
                    onChanged: addresController.validateUpdateReceiverName,
                    controller: addresController.updateReceiverNameController,
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
                    onChanged: addresController.validateUpdateReceiverPhone,
                    controller: addresController.updateReceiverPhoneController,
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
                    onChanged: addresController.validateUpdateHouseAndStreet,
                    controller: addresController.updateHouseAndStreetController,
                    labelText: 'Số nhà, đường',
                  ),
                ),
                SizedBox(
                  height: mediaHeight(context, 90),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: CustomInputTextField(
                    onChanged: addresController.validateUpdateWard,
                    controller: addresController.updateWardController,
                    labelText: 'Phường/Xã',
                  ),
                ),
                SizedBox(
                  height: mediaHeight(context, 90),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: CustomInputTextField(
                    onChanged: addresController.validateUpdateDistrictAndCity,
                    controller:
                        addresController.updateDistrictAndCityController,
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
                            value: addresController.updateDefaultAddress.value,
                            onChanged: address.defaultAddress == false
                                ? (value) {
                                    addresController
                                        .updateDefaultAddress.value = value;
                                  }
                                : null,
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
                  margin: const EdgeInsets.all(8),
                  child: TextButton.icon(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      String result = await addresController
                          .deleteAddress("${address.addressId}");
                      if (result == "Success") {
                        CustomSuccessMessage.showMessage(
                                "Xoá địa chỉ thành công")
                            .then((value) {
                          addresController.getListAddress().whenComplete(() {
                            addresController.getListAddress();
                            Navigator.pop(context);
                          });
                        });
                      } else {
                        CustomSuccessMessage.showMessage(result);
                      }
                    },
                    label: const Text("Xoá địa chỉ"),
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                      overlayColor: MaterialStateProperty.all<Color>(
                          Colors.red.withOpacity(0.05)),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(16),
                  child: Obx(
                    () => DefaultButton(
                      enabled: addresController
                              .isValidUpdateReceiverName.value &&
                          addresController.isValidUpdateReceiverPhone.value &&
                          addresController.isValidUpdateHouseAndStreet.value &&
                          addresController.isValidUpdateWard.value &&
                          addresController.isValidUpdateDistrictAndCity.value,
                      press: () async {
                        String result =
                            await addresController.updateAddress(address);
                        if (result == "Success") {
                          CustomSuccessMessage.showMessage(
                                  "Cập nhật thành công!")
                              .then((value) {
                            addresController
                                .getListAddress()
                                .whenComplete(() => Navigator.pop(context));
                          });
                        } else {
                          CustomErrorMessage.showMessage(result);
                        }
                      },
                      text: "Lưu",
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}
