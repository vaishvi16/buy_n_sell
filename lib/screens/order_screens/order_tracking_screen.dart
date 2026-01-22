import 'package:buy_n_sell/custom_widgets/my_appbar/primary_appbar.dart';
import 'package:flutter/material.dart';
import '../../custom_widgets/custom_fields/tracking_status.dart';
import '../../custom_widgets/my_colors/my_colors.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar:
      primaryAppBar(title: "Track Your Order", subtitle: "Order status"),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tracking Number",
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: screenHeight * 0.015),
            const TrackingStatus(title: "Packed", active: true),
            const TrackingStatus(title: "Shipped", active: true),
            const TrackingStatus(title: "Out for delivery", active: false),
            const TrackingStatus(title: "Delivered", active: false),
          ],
        ),
      ),
    );
  }
}
