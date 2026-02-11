import 'package:flutter/material.dart';

import '../../custom_widgets/my_colors/my_colors.dart';

class WinnerDialog extends StatelessWidget {
  final String winnerName;
  final String winningAmount;
  final bool isWinner;

  const WinnerDialog({
    super.key,
    required this.winnerName,
    required this.winningAmount,
    required this.isWinner,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      backgroundColor: MyColors.transparentColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.05),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.all(screenWidth * 0.06),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(screenWidth * 0.05),
              gradient: LinearGradient(
                colors: [MyColors.orangeColor, MyColors.whiteColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/animations/well_done.gif",
                  height: screenWidth * 0.25,
                ),

                SizedBox(height: screenWidth * 0.04),

                Text(
                  "🎉 Auction Winner!",
                  style: TextStyle(
                    fontSize: screenWidth * 0.055,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: screenWidth * 0.05),

                // Winner Name
                Text(
                  winnerName,
                  style: TextStyle(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                    color: MyColors.primaryColor,
                  ),
                ),

                SizedBox(height: screenWidth * 0.03),

                // Winning Amount
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: screenWidth * 0.025,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  ),
                  child: Center(
                    child: Text(
                      "Winning Bid: \$$winningAmount",
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        color: MyColors.greenColor,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: screenWidth * 0.06),

                // Pay Now Button
                if (isWinner)
                  SizedBox(
                    width: double.infinity,
                    height: screenWidth * 0.13,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.03,
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Pay Now ",
                        style: TextStyle(
                          color: MyColors.whiteLightColor,
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          //cross icon
          Positioned(
            top: -14,
            right: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: MyColors.whiteColor,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: MyColors.blackDarkColor, blurRadius: 4)],
                ),
                child: Icon(Icons.close, size: 18, color: MyColors.blackDarkColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
