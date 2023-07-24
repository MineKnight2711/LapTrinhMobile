import 'package:flutter/material.dart';

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 80,
            width: 80,
            child: CircleAvatar(
              backgroundImage: avatarUrl != null
                  ? Image.network(avatarUrl!).image
                  : Image.asset(
                      'assets/images/profile.png',
                    ).image,
            ),
          ),
          const SizedBox(height: 8),
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
    );
  }
}
