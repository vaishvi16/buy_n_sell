import 'package:buy_n_sell/custom_widgets/my_appbar/primary_appbar.dart';
import 'package:flutter/material.dart';
import '../../custom_widgets/my_colors/my_colors.dart';
import 'order_tracking_screen.dart';

class ToReceiveScreen extends StatelessWidget {
  const ToReceiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: primaryAppBar(title: "To Receive", subtitle: " Order History"),
      body: ListView.builder(
        padding: EdgeInsets.all(screenWidth * 0.03),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.only(bottom: screenHeight * 0.020),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(screenWidth * 0.03),
            ),
            color: MyColors.whiteColor,
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.03),
              child: Row(
                children: [
                  Container(
                    height: screenWidth * 0.15,
                    width: screenWidth * 0.15,
                    decoration: BoxDecoration(
                      color: MyColors.greyColor,
                      borderRadius:
                      BorderRadius.circular(screenWidth * 0.02),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Order #92287157",
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        Text(
                          "Packed",
                          style: TextStyle(
                            color: MyColors.greyColor,
                            fontSize: screenWidth * 0.035,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.primaryLightColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.045,
                        vertical: screenHeight * 0.012,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(screenWidth * 0.025),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrderTrackingScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Track",
                      style: TextStyle(
                        color: MyColors.greyLightColor,
                        fontSize: screenWidth * 0.035,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
