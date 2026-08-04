import 'package:flutter/material.dart';

import '../my_colors/my_colors.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? screen;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.screen,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        } else if (screen != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen!),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: width * 0.025),
        decoration: BoxDecoration(
          color: MyColors.whiteColor,
          borderRadius: BorderRadius.circular(width * 0.03),
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.grey, size: width * 0.06),
          title: Text(
            title,
            style: TextStyle(
              fontSize: width * 0.035,
              color: MyColors.blackDarkColor,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: width * 0.04,
            color: MyColors.greyColor,
          ),
        ),
      ),
    );
  }
}
