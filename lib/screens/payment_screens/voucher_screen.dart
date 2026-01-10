import 'package:flutter/material.dart';
import '../../custom_widgets/my_colors/my_colors.dart';

class VoucherScreen extends StatelessWidget {
  const VoucherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Active Vouchers",
          style: TextStyle(
            color: MyColors.primaryLightColor,
            fontWeight: FontWeight.w600,
            fontSize: screenWidth * 0.055,
          ),
        ),
        backgroundColor: MyColors.whiteColor,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        children: [
          _voucherTile(
            context,
            title: "First Purchase",
            subtitle: "5% off your next order",
            validTill: "Valid until 5.16.20",
          ),
          SizedBox(height: screenHeight * 0.015),
          _voucherTile(
            context,
            title: "Gift From Customer Care",
            subtitle: "15% off your next purchase",
            validTill: "Valid until 6.20.20",
          ),
        ],
      ),
    );
  }

  Widget _voucherTile(
      BuildContext context, {
        required String title,
        required String subtitle,
        required String validTill,
      }) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        border: Border.all(color: MyColors.primaryColor),
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                    TextStyle(fontWeight: FontWeight.w600)),
                SizedBox(height: screenWidth * 0.01),
                Text(subtitle,
                    style: TextStyle(color: MyColors.greyColor)),
                SizedBox(height: screenWidth * 0.015),
                Text(validTill,
                    style: TextStyle(fontSize: screenWidth * 0.03)),
              ],
            ),
          ),
          ElevatedButton(onPressed: () {}, child: Text("Apply")),
        ],
      ),
    );
  }
}
