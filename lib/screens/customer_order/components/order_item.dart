import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_mobile_app/controller/order_controller.dart';

import '../../../configs/mediaquery.dart';
import '../../../model/query_order_model.dart';
import '../../../utils/data_convert.dart';
import '../order_detail_bottom_sheet.dart';

class QueryOrderCard extends StatelessWidget {
  final QueryOrder queryOrder;
  final OrderController orderController;
  const QueryOrderCard(
      {super.key, required this.queryOrder, required this.orderController});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      height: mediaHeight(context, 7),
      child: Card(
        elevation: 4,
        shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: ListTile(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              backgroundColor: Colors.white,
              builder: (BuildContext context) {
                return OrderDetailBottomSheet(
                  order: queryOrder,
                );
              },
            );
          },
          title: SizedBox(
            height: mediaHeight(context, 17),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        "Mã đơn hàng: ${queryOrder.orderId.toUpperCase()}",
                        style: const TextStyle(fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: mediaHeight(context, 200),
                ),
                Row(
                  children: [
                    Flexible(
                      child: Obx(
                        () => Text(
                          "Tổng tiền ${DataConvert().formatCurrency(orderController.caculateTotal(queryOrder).value)}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          subtitle: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Ngày đặt: ${DataConvert().formattedOrderDate(queryOrder.orderDate)}",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: mediaHeight(context, 200),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Tình trạng: ${queryOrder.status}",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
