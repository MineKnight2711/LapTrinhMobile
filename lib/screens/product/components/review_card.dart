import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../configs/mediaquery.dart';
import '../../../controller/review_controller.dart';
import '../../../model/account_respone.dart';
import '../../../model/review_model.dart';
import '../../../widgets/custom_widgets/rating_bars.dart';

class ReviewCard extends StatelessWidget {
  final ReviewModel review;
  ReviewCard({super.key, required this.review});
  final reviewController = Get.find<ReviewController>();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: mediaHeight(context, 6),
        width: mediaWidth(context, 1),
        child: FutureBuilder<AccountResponse?>(
          future: reviewController.getAcconutById("${review.accountId}"),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  SizedBox(
                    height: mediaHeight(context, 9),
                    width: mediaWidth(context, 1),
                    child: ListTile(
                      leading: SizedBox(
                        height: mediaHeight(context, 9),
                        width: mediaWidth(context, 6),
                        child: CachedNetworkImage(
                          imageUrl: snapshot.data!.imageUrl.toString(),
                        ),
                      ),
                      title: Text("${snapshot.data?.fullName}"),
                      subtitle: Row(
                        children: [
                          ShowRatingBar(
                            rating: review.star ?? 0.0,
                            size: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 3, left: 5),
                            child: Text(
                              review.star.toString(),
                              style: GoogleFonts.nunito(fontSize: 16),
                            ),
                          )
                        ],
                      ),
                      trailing:
                          reviewController.checkAccount("${review.accountId}")
                              ? TextButton(
                                  child: const Text("Xoá"),
                                  onPressed: () {},
                                )
                              : const SizedBox.shrink(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        "${review.comment}",
                      ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ));
  }
}
