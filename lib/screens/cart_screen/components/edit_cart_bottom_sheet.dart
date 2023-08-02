import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_mobile_app/model/cart_model.dart';
import 'package:keyboard_mobile_app/model/product_details_model.dart';
import 'package:keyboard_mobile_app/screens/product/components/quantity_selector.dart';

import '../../../controller/cart_controller.dart';
import '../../../widgets/custom_widgets/custom_button.dart';

class EditCartItemBottomSheet extends StatefulWidget {
  final CartModel cart;
  const EditCartItemBottomSheet({super.key, required this.cart});

  @override
  State<EditCartItemBottomSheet> createState() =>
      _EditCartItemBottomSheetState();
}

class _EditCartItemBottomSheetState extends State<EditCartItemBottomSheet> {
  final cartController = Get.find<CartController>();
  late String? selectedProductDetails;
  late int? currentQuantity;

  @override
  void initState() {
    super.initState();
    selectedProductDetails = widget.cart.productDetailId;
    currentQuantity = widget.cart.quantity;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.6,
      child: SingleChildScrollView(
        child: Column(children: [
          Stack(children: [
            SizedBox(
              height: 50,
              child: Center(
                child: Text(
                  'Tên sản phẩm',
                  style: GoogleFonts.nunito(fontSize: 18),
                ),
              ),
            ),
            Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  child: GestureDetector(
                      onTap: () {}, child: const Icon(CupertinoIcons.xmark)),
                ))
          ]),
          const Divider(
            thickness: 10,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              children: [
                Text(
                  'Size',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          // SizeRadioChosen(
          //   item: widget.cartItem.size,
          //   onSizeSelected: (value) {
          //     selectedSize = value;
          //   },
          // ),
          const Divider(
            thickness: 10,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              children: [
                Text(
                  'Số lượng',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 5),
            child: QuantitySelector(
              maxQuantity: 10, //Sửa lại chỗ này
              initialValue: widget.cart.quantity ?? 0,
              onValueChanged: (value) {
                currentQuantity = value;
              },
            ),
          ),
          const Divider(
            thickness: 10,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              children: [
                Text(
                  'Toppings',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          // CurrentToppingChoiceWidget(
          //   onToppingsSelected: (value) {
          //     selectedToppings = value;
          //   },
          //   currentToppings: widget.cartItem.toppings,
          // ),
          DefaultButton(
            press: () {
              // final updatedItem = widget.cartItem.copyWith(
              //   size: selectedSize,
              //   quantity: currentQuantity,
              //   toppings: selectedToppings,
              // );
              // cartController.updateCartItem(widget.cartItem, updatedItem);
            },
            text: "Lưu",
          )
        ]),
      ),
    );
  }
}
