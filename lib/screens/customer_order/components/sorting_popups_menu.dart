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
                    child: Text('Giá: Thấp đến cao'),
                  ),
                  PopupMenuItem<SortByPrice>(
                    value: SortByPrice.highToLow,
                    child: Text('Giá: Cao đến thấp'),
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
                    child: Text('Chưa xác nhận'),
                  ),
                  PopupMenuItem<SortByOrderStatus>(
                    value: SortByOrderStatus.order_status_delivered,
                    child: Text('Đã giao'),
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
