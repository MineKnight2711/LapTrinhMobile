import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_mobile_app/configs/mediaquery.dart';
import 'package:keyboard_mobile_app/controller/category_controller.dart';
import 'package:keyboard_mobile_app/screens/homescreen/components/product_list.dart';

import '../../../model/category_model.dart';

class HomescreenBody extends StatefulWidget {
  const HomescreenBody({Key? key}) : super(key: key);

  @override
  State<HomescreenBody> createState() => _HomescreenBodyState();
}

class _HomescreenBodyState extends State<HomescreenBody>
    with TickerProviderStateMixin<HomescreenBody> {
  late TabController _tabController;
  final categoryController = Get.find<CategoryController>();

  @override
  void initState() {
    super.initState();
    _initTabController();
    categoryController.listCategory.stream.listen(_onCategoriesChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _initTabController() {
    _tabController = TabController(
      length: categoryController.listCategory.value?.length ?? 0,
      vsync: this,
    );
  }

  void _onCategoriesChanged(List<CategoryModel>? categories) {
    int newLength = categories?.length ?? 0;
    if (newLength != _tabController.length) {
      setState(() {
        _initTabController();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget tabBar = Obx(() {
      if (categoryController.listCategory.value == null) {
        return const LinearProgressIndicator();
      }
      return TabBar(
        tabs: categoryController.listCategory.value!
            .map((category) => Tab(text: category.categoryName ?? ''))
            .toList(),
        labelStyle: const TextStyle(fontSize: 16.0),
        unselectedLabelStyle: const TextStyle(fontSize: 14.0),
        labelColor: Colors.black87,
        unselectedLabelColor: const Color.fromRGBO(0, 0, 0, 0.5),
        isScrollable: true,
        controller: _tabController,
      );
    });

    return SafeArea(
        child: NestedScrollView(
      physics: const NeverScrollableScrollPhysics(),
      body: Obx(() {
        if (categoryController.listCategory.value != null &&
            categoryController.listCategory.value!.isNotEmpty) {
          final listCategory = categoryController.listCategory.value!;
          return TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: listCategory.map((category) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16.0),
                  Flexible(
                      child: ProductList(
                    categoryModel: category,
                  )),
                ],
              );
            }).toList(),
          );
        } else {
          categoryController.getAllCategory();
          return const Center(child: Text("Loading..."));
        }
      }),
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          const SliverToBoxAdapter(
            child: BannerList(),
          ),
          SliverToBoxAdapter(
            child: tabBar,
          ),
        ];
      },
    ));
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
        pagination: SwiperCustomPagination(
          builder: (context, config) {
            return CustomSwiperPagination(
                itemCount: ListDataTemp.banner.length,
                activeIndex: config.activeIndex);
          },
        ), // Add pagination dots.
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
    "assets/images/banner3.jpg",
    "assets/images/banner3.jpg",
    "assets/images/banner3.jpg",
    "assets/images/banner3.jpg",
    "assets/images/banner3.jpg",
    "assets/images/banner3.jpg",
    "assets/images/banner3.jpg",
    "assets/images/banner3.jpg",
  ];
}

class CustomSwiperPagination extends StatelessWidget {
  final int itemCount;
  final int activeIndex;

  const CustomSwiperPagination(
      {super.key, required this.itemCount, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.all(16.0),
        height: 2, // Adjust the height of the line here
        width: itemCount * 20.0, // Adjust the width based on itemCount
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return Container(
              width: 12,
              margin: const EdgeInsets.symmetric(horizontal: 2.0),
              color: activeIndex == index
                  ? Colors.blue
                  : Colors.grey, // Adjust active and inactive colors here
            );
          },
        ),
      ),
    );
  }
}
