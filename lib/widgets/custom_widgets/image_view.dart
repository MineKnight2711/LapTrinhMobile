import 'package:flutter/material.dart';
import 'package:keyboard_mobile_app/configs/mediaquery.dart';

class CustomImageView extends StatelessWidget {
  final String imageAssetUrl;
  final double imageSize;
  const CustomImageView(
      {super.key, required this.imageAssetUrl, required this.imageSize});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          imageAssetUrl,
          width: mediaWidth(context, imageSize / 2),
          height: mediaHeight(context, imageSize),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
