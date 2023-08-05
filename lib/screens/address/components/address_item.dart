import 'package:flutter/material.dart';
import 'package:keyboard_mobile_app/configs/mediaquery.dart';
import 'package:keyboard_mobile_app/model/address_model.dart';

class AddressItem extends StatelessWidget {
  final AddressModel address;
  const AddressItem({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      width: double.infinity,
      height: size.height / 4.9,
      child: Column(
        children: [
          Row(
            children: [
              Text('${address.receiverName} | ${address.receiverPhone}'),
            ],
          ),
          SizedBox(
            height: mediaHeight(context, 90),
          ),
          Row(
            children: [
              Flexible(child: Text('${address.address}')),
            ],
          ),
          SizedBox(
            height: mediaHeight(context, 90),
          ),
          Row(
            children: [
              Text('Set cứng'),
            ],
          ),
          SizedBox(
            height: mediaHeight(context, 90),
          ),
          Row(
            children: [
              address.defaultAddress == true
                  ? Container(
                      width: mediaWidth(context, 6.5), // Expand to full width
                      height:
                          mediaHeight(context, 32), // Adjust height as needed
                      color: Colors
                          .blue, // Replace with your desired color or decoration
                      child: Center(
                        child: Text('Default'),
                      ),
                    )
                  : Container(
                      width: mediaWidth(context, 4), // Expand to full width
                      height:
                          mediaHeight(context, 32), // Adjust height as needed
                      color: Colors
                          .blue, // Replace with your desired color or decoration
                      child: Center(
                        child: Text('Not default'),
                      ),
                    ),
            ],
          ),
          SizedBox(
            height: mediaHeight(context, 90),
          ),
        ],
      ),
    );
  }
}
