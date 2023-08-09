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
            child: BannerView(),
          ),
          SliverToBoxAdapter(
            child: tabBar,
          ),
        ];
      },
    ));
  }
}

class BannerView extends StatelessWidget {
  const BannerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: mediaHeight(context, 4.7),
      child: Swiper(
        itemCount: ListBanner.banner.length,
        autoplay: true,
        autoplayDelay: 5000,
        viewportFraction: 1,
        scale: 0.6,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          var item = ListBanner.banner[index];
          return Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 20.0,
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
      ),
    );
  }
}

class ListBanner {
  static List banner = [
    "assets/images/banner1.png",
    "assets/images/banner2.jpg",
    "assets/images/banner3.jpg",
    "assets/images/banner4.png",
    "assets/images/banner5.jpg",
    "assets/images/banner6.png",
    "assets/images/banner7.jpg",
    "assets/images/banner8.jpg",
    "assets/images/banner9.jpg",
    "assets/images/banner10.jpg",
  ];
}
