import 'package:buy_n_sell/custom_widgets/custom_fields/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../my_colors/my_colors.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Container(
      color: MyColors.whiteColor,
      padding: EdgeInsets.all(width * 0.04),
      child: Row(
        children: [
          UserAvatar(
            radius: width * 0.07,
          ),
          SizedBox(width: width * 0.03),
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    authProvider.userName ?? "User",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: width * 0.04,
                    ),
                  ),
                  SizedBox(height: height * 0.005),
                  Text(
                    authProvider.userEmail ?? "",
                    style: TextStyle(
                      color: MyColors.greyColor,
                      fontSize: width * 0.032,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
