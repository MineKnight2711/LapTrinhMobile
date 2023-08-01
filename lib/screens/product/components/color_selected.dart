import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_mobile_app/configs/mediaquery.dart';
import 'package:keyboard_mobile_app/controller/product_controller.dart';
import 'package:keyboard_mobile_app/model/product_details_model.dart';

class ColorChoiceWidget extends StatefulWidget {
  final Function(ProductDetailModel?) onSizeSelected;

  const ColorChoiceWidget({Key? key, required this.onSizeSelected})
      : super(key: key);

  @override
  ColorChoiceWidgetState createState() => ColorChoiceWidgetState();
}

class ColorChoiceWidgetState extends State<ColorChoiceWidget> {
  String? _selectedColor = '';
  final productController = Get.find<ProductController>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 8.0,
        ),
        Obx(() {
          if (productController.listProductDetails.value != null) {
            //Số lượng item trên 1 hàng
            const int crossAxisCount = 4;
            //Số lượng item trong listProductDetails
            final int numberOfItems =
                productController.listProductDetails.value!.length;
            // khoảng cách dọc giữa các item
            const double crossAxisSpacing = 1;
            // khoảng cách ngang giữa các item
            const double mainAxisSpacing = 15;
            // Tỉ lệ khung hình của item
            const double itemAspectRatio = 1 / 1.5;
            //Tính toán chiều rộng của item bên trong sizedbox
            final double itemWidth = (MediaQuery.of(context).size.width -
                    (crossAxisSpacing * (crossAxisCount - 1))) /
                crossAxisCount;
            //Tính toán số lượng hàng được build ra
            final int rowCount = (numberOfItems / crossAxisCount).ceil();
            //Tính toán chiều cao cuối cùng của SizedBox
            final double calculatedHeight =
                rowCount * itemWidth * itemAspectRatio +
                    (mainAxisSpacing * (rowCount - 1));
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: calculatedHeight,
              child: StaggeredGridView.countBuilder(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: mainAxisSpacing,
                crossAxisSpacing: crossAxisSpacing,
                staggeredTileBuilder: (index) =>
                    const StaggeredTile.count(1, itemAspectRatio),
                itemCount: numberOfItems,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final item =
                      productController.listProductDetails.value![index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = item.color;
                      });
                      widget.onSizeSelected(item);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: _selectedColor == item.color
                            ? Colors.transparent
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(2.0),
                        border: Border.all(
                            color: const Color.fromARGB(255, 255, 98, 0)),
                      ),
                      child: Stack(
                        children: [
                          Center(
                              child: Text(
                            "${item.color}",
                            style: GoogleFonts.nunito(
                                fontSize: mediaAspectRatio(context, 1 / 27),
                                color: _selectedColor == item.color
                                    ? const Color.fromARGB(255, 255, 98, 0)
                                    : Colors.black),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          )),
                          if (_selectedColor == item.color)
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Icon(
                                Icons
                                    .check, // Replace with the icon you want to use for the tick.
                                color: Colors.green,
                                size: mediaAspectRatio(context, 1 / 40),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        })
      ],
    );
  }
}
