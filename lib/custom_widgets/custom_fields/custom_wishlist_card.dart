import 'package:flutter/material.dart';

import '../../model_class/product_model.dart';
import '../my_colors/my_colors.dart';

class CustomWishlistCard extends StatelessWidget {
  final ProductModel product;
  final double screenWidth;

  CustomWishlistCard({required this.product, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.03),
      decoration: BoxDecoration(
        color: MyColors.whiteColor,
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(screenWidth * 0.025),
            child: Image.network(
              product.image ?? "",
              height: screenWidth * 0.22,
              width: screenWidth * 0.18,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: screenWidth * 0.22,
                width: screenWidth * 0.18,
                color: MyColors.greyColor,
                child: Icon(Icons.image_not_supported),
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: screenWidth * 0.015),
                Text(
                  "Rs. ${product.price}",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
