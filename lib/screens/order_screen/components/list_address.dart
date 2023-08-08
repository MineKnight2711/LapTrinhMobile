import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_mobile_app/configs/mediaquery.dart';
import 'package:keyboard_mobile_app/controller/address_controller.dart';
import 'package:keyboard_mobile_app/model/address_model.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/custom_appbar.dart';

import '../../../utils/data_convert.dart';

class AccountListAddress extends StatelessWidget {
  final addressController = Get.find<AddressController>();

  AccountListAddress({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Chọn địa chỉ",
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Obx(() {
        if (addressController.listAddress.value != null) {
          return ListView.builder(
            itemCount: addressController.listAddress.value!.length,
            itemBuilder: (context, index) {
              final address = addressController.listAddress.value![index];
              return AddressItem(
                address: address,
                onPressed: () {
                  addressController.chosenAddress.value = address;
                  Navigator.pop(context);
                },
              );
            },
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }
}

class AddressItem extends StatelessWidget {
  final AddressModel address;
  final Function()? onPressed;
  const AddressItem({super.key, required this.address, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      elevation: 3,
      shadowColor: Colors.amber,
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
        height: address.defaultAddress == true
            ? mediaHeight(context, 6.5)
            : mediaHeight(context, 8),
        child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('${address.receiverName} '),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: 1,
                  height: 20,
                  color: Colors.black.withOpacity(0.3),
                ),
                Text("${address.receiverPhone}"),
                const Spacer(),
              ],
            ),
            subtitle: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        DataConvert().simplifyAddress("${address.address}"),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: mediaHeight(context, 10 * 10),
                ),
                Visibility(
                  visible: address.defaultAddress!,
                  child: Row(
                    children: [
                      Container(
                        width: mediaWidth(context, 5), // Expand to full width
                        height:
                            mediaHeight(context, 32), // Adjust height as needed
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.deepOrange)),
                        child: const Center(
                          child: Text(
                            'Mặc định',
                            style: TextStyle(color: Colors.deepOrange),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            onTap: onPressed),
      ),
    );
  }
}
