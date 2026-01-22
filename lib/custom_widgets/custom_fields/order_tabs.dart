import 'package:flutter/material.dart';

import '../my_colors/my_colors.dart';

class OrderTab extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const OrderTab({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(right: screenWidth * 0.02),
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.012,
          ),
          decoration: BoxDecoration(
            color: MyColors.primaryLightColor,
            borderRadius: BorderRadius.circular(screenWidth * 0.03),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: MyColors.greyLightColor,
                fontSize: screenWidth * 0.038,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
