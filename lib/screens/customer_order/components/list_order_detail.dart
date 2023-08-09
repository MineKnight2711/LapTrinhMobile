import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_mobile_app/configs/mediaquery.dart';
import 'package:keyboard_mobile_app/model/query_order_model.dart';

import '../../../utils/data_convert.dart';

class OrderDetailView extends StatelessWidget {
  final QueryOrderDetail detail;
  const OrderDetailView({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: mediaHeight(context, 15),
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black38))),
        child: Row(
          children: [
            Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(4.0)),
              height: mediaHeight(context, 20),
              width: mediaWidth(context, 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: CachedNetworkImage(
                  imageUrl: detail.productDetail.product.displayUrl,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Expanded(
                child: Text(
              "${detail.productDetail.product.productName} x ${detail.quantity}",
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(fontSize: 13),
            )),
            Text(
              DataConvert()
                  .formatCurrency(detail.productDetail.price * detail.quantity),
              textAlign: TextAlign.right,
              style: GoogleFonts.nunito(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
