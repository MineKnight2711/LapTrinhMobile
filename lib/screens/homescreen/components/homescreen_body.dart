import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_mobile_app/configs/mediaquery.dart';

class HomescreenBody extends StatelessWidget {
  const HomescreenBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///// HIEN THI DANH MUC TU WIDGET CATEGORY O DAY ////
        Column(
          children: [
            // MenuCategoryList(),
          ],
        ),
        const SizedBox(
          height: 19.0,
        ),
        //WIDGET HIEN THI BANNER VOUCHER O DAY//
        const Column(
          children: [
            BannerList(),
          ],
        ),
        const SizedBox(
          height: 26.22,
        ),
        Container(
          height: 20.0,
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              Text(
                "Hàng nóng hổi...",
                style: GoogleFonts.roboto(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                "Xem Tất Cả",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff1CB069),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 13.87,
        ),
        //List sản phẩm recommeneded
      ],
    );
  }
}

class BannerList extends StatelessWidget {
  const BannerList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: mediaHeight(context, 6),
      child: Swiper(
        itemCount: ListDataTemp.banner.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          var item = ListDataTemp.banner[index];
          return Container(
            height: 120.0,
            width: 250,
            margin: const EdgeInsets.symmetric(
              horizontal: 28.0,
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "$item",
                ),
                fit: BoxFit.cover,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(
                  16.0,
                ),
              ),
            ),
          );
        },
        pagination: SwiperPagination(), // Add pagination dots.
        // control: SwiperControl(), // Add next and previous arrow controls.
      ),
    );
  }
}

class ListDataTemp {
  static List banner = [
    "assets/images/banner1.png",
    "assets/images/banner2.jpg",
    "assets/images/banner3.jpg",
  ];
}
