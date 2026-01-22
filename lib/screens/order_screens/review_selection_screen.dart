import 'package:buy_n_sell/custom_widgets/my_appbar/primary_appbar.dart';
import 'package:flutter/material.dart';
import '../../custom_widgets/my_colors/my_colors.dart';

class ReviewSelectionScreen extends StatelessWidget {
  const ReviewSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: primaryAppBar(
        title: "Review Products",
        subtitle: "Select Item to Review",
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(screenWidth * 0.04),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: screenHeight * 0.015),
            padding: EdgeInsets.all(screenWidth * 0.03),
            decoration: BoxDecoration(
              color: MyColors.whiteColor,
              borderRadius: BorderRadius.circular(screenWidth * 0.03),
            ),
            child: Row(
              children: [
                Container(
                  height: screenWidth * 0.15,
                  width: screenWidth * 0.15,
                  color: MyColors.greyColor,
                ),
                SizedBox(width: screenWidth * 0.03),
                Expanded(
                  child: Text(
                    "Product Name",
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(screenWidth * 0.025),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.045,
                      vertical: screenHeight * 0.012,
                    ),
                  ),
                  child: Text(
                    "Review",
                    style: TextStyle(
                      fontSize: screenWidth * 0.038,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
