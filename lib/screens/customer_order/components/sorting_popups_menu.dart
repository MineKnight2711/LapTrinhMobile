import 'package:flutter/material.dart';
import 'package:keyboard_mobile_app/controller/order_controller.dart';

class SortingPopupMenu extends StatelessWidget {
  final OrderController orderController;
  const SortingPopupMenu({super.key, required this.orderController});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text('Xếp theo'),
        PopupMenuButton(
          icon: Image.asset(
            'assets/icons/menu_icon.png',
            color: Colors.black,
            scale: 4,
          ),
          itemBuilder: (context) => <PopupMenuEntry>[
            PopupMenuItem(
              child: PopupMenuButton<SortByPrice>(
                child: const Text('Xếp theo giá'),
                onSelected: (sortByPrice) {
                  orderController.sortByOrderStatusController.value = null;
                  orderController.sortByPriceController.value = sortByPrice;
                  orderController.sortListOrder();
                },
                itemBuilder: (context) => const <PopupMenuEntry<SortByPrice>>[
                  PopupMenuItem<SortByPrice>(
                    value: SortByPrice.lowToHigh,
                    child: Row(
                      children: [
                        Text('Giá: Thấp đến cao'),
                        Icon(Icons.arrow_drop_up_sharp),
                      ],
                    ),
                  ),
                  PopupMenuItem<SortByPrice>(
                    value: SortByPrice.highToLow,
                    child: Row(
                      children: [
                        Text('Giá: Cao đến thấp'),
                        Icon(Icons.arrow_drop_down_sharp),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              child: PopupMenuButton<SortByOrderStatus>(
                child: const Text('Xếp theo tình trạng đơn'),
                onSelected: (sortByOrderStatus) {
                  orderController.sortByPriceController.value = null;
                  orderController.sortByOrderStatusController.value =
                      sortByOrderStatus;
                  orderController.sortListOrder();
                },
                itemBuilder: (context) =>
                    const <PopupMenuEntry<SortByOrderStatus>>[
                  PopupMenuItem<SortByOrderStatus>(
                    value: SortByOrderStatus.order_status_unconfirmed,
                    child: Text(
                      'Chưa xác nhận',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  PopupMenuItem<SortByOrderStatus>(
                    value: SortByOrderStatus.order_status_ondeliver,
                    child: Text(
                      'Đang giao',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  PopupMenuItem<SortByOrderStatus>(
                    value: SortByOrderStatus.order_status_delivered,
                    child: Text(
                      'Đã giao',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                  PopupMenuItem<SortByOrderStatus>(
                    value: SortByOrderStatus.order_status_canceled,
                    child: Text(
                      'Đã huỷ',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              child: const Text('Tất cả đơn hàng'),
              onTap: () {
                orderController.listQueryOrder.value =
                    List.from(orderController.storedListQueryOrder);
              },
            ),
          ],
        ),
      ],
    );
  }
}
