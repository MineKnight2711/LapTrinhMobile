import 'package:flutter/material.dart';
import 'package:keyboard_mobile_app/screens/order_screen/components/list_address.dart';
import 'package:keyboard_mobile_app/transition_animation/screen_transition.dart';
import 'package:keyboard_mobile_app/utils/data_convert.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/message.dart';

import '../../../model/address_model.dart';

class AddressView extends StatelessWidget {
  final AddressModel address;

  const AddressView({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Expanded(
              child: Text("${address.receiverName} | ${address.receiverPhone}"),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
                flex: 2,
                child:
                    Text(DataConvert().simplifyAddress2("${address.address}"))),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                color: kDefaultIconLightColor,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: InkWell(
                onTap: () {
                  slideInTransition(context, AccountListAddress());
                },
                child: const Text(
                  'Thay đổi',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
