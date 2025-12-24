import 'package:flutter/material.dart';
import '../my_colors/my_colors.dart';

class primaryAppBar extends StatelessWidget
    implements PreferredSizeWidget {

  final String title;
  final String subtitle;

  const primaryAppBar({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 2,
      backgroundColor: MyColors.primaryColor,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 22,
        ),
        color: MyColors.blackColor,
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: MyColors.whiteColor,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: MyColors.whiteLightColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
