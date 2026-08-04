import 'package:buy_n_sell/custom_widgets/my_colors/my_colors.dart';
import 'package:buy_n_sell/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserAvatar extends StatelessWidget {
  final double radius;

  const UserAvatar({
    super.key,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final name = authProvider.userName ?? "User";

        final firstLetter =
        name.isNotEmpty ? name[0].toUpperCase() : "U";

        return CircleAvatar(
          radius: radius,
          backgroundColor: MyColors.primaryColor,
          child: Text(
            firstLetter,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: radius * 0.8,
            ),
          ),
        );
      },
    );
  }
}