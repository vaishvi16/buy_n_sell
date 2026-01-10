import 'package:buy_n_sell/custom_widgets/my_colors/my_colors.dart';
import 'package:flutter/material.dart';

class CheckoutItemCard extends StatelessWidget {
  final String title;
  final String price;
  final String imageUrl;

  const CheckoutItemCard({
    super.key,
    required this.title,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Card(
      elevation: 0,
      margin: EdgeInsets.only(bottom: screenWidth * 0.03),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
      ),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.03),
        child: Row(
          children: [
            CircleAvatar(
              radius: screenWidth * 0.07,
              backgroundImage: NetworkImage(imageUrl),
            ),
            SizedBox(width: screenWidth * 0.03),
            Expanded(child: Text(title)),
            Text(
              price,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: MyColors.primaryLightColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
