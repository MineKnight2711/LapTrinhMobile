class ReviewModel {
  String? reviewId;
  String? accountId;
  String? productId;
  DateTime? dateReview;
  double? star;
  String? comment;

  ReviewModel({
    this.reviewId,
    this.accountId,
    this.productId,
    this.dateReview,
    this.star,
    this.comment,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      reviewId: json['reviewId'],
      accountId: json['accountId'],
      productId: json['productId'],
      dateReview: DateTime.parse(json['dateReview']),
      star: json['star'].toDouble(),
      comment: json['comment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'dateReview': dateReview?.toIso8601String(),
      'star': star.toString(),
      'comment': comment,
    };
  }
}
