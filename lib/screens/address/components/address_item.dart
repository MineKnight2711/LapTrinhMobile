import 'package:flutter/material.dart';
import 'package:keyboard_mobile_app/configs/mediaquery.dart';
import 'package:keyboard_mobile_app/model/address_model.dart';
import 'package:keyboard_mobile_app/utils/data_convert.dart';

class AddressItem extends StatelessWidget {
  final AddressModel address;
  const AddressItem({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      height: size.height / 6.2,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('${address.receiverName} '),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: 1,
                height: 20,
                color: Colors.black.withOpacity(0.3),
              ),
              // VerticalDivider(
              //   width: 4,
              //   thickness: 2,
              //   color: Colors.black.withOpacity(0.2),
              // ),
              Text("${address.receiverPhone}"),
              const Spacer(),
            ],
          ),
          SizedBox(
            height: mediaHeight(context, 90),
          ),
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
            height: mediaHeight(context, 90),
          ),
          Visibility(
            visible: address.defaultAddress!,
            child: Row(
              children: [
                Container(
                  width: mediaWidth(context, 5), // Expand to full width
                  height: mediaHeight(context, 32), // Adjust height as needed
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
          const Expanded(
            child: SizedBox.shrink(),
          ),
          const Divider(
            color: Colors.black,
            height: 0,
            thickness: 0.5,
          ),
        ],
      ),
    );
  }
}
