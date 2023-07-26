import 'package:flutter/material.dart';
import 'package:keyboard_mobile_app/configs/mediaquery.dart';

class MyDrawerHeader extends StatelessWidget {
  final String fullName;
  final String email;
  final String? avatarUrl;

  const MyDrawerHeader({
    Key? key,
    required this.fullName,
    required this.email,
    this.avatarUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: const BoxDecoration(
        color: Color(0xff06AB8D),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: mediaHeight(context, 14),
              width: mediaWidth(context, 6),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: avatarUrl != null
                      ? Image.network(avatarUrl!).image
                      : Image.asset(
                          'assets/images/profile.png',
                        ).image,
                ),
              ),
            ),
            SizedBox(height: mediaHeight(context, 40)),
            Text(
              fullName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              email,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
