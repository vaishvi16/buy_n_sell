import 'package:buy_n_sell/custom_widgets/my_appbar/primary_appbar.dart';
import 'package:flutter/material.dart';
import '../../custom_widgets/custom_fields/tracking_status.dart';
import '../../custom_widgets/my_colors/my_colors.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderStatus;

  const OrderTrackingScreen({super.key, required this.orderStatus});

  bool isPackedActive() {
    return orderStatus == "packed" ||
        orderStatus == "shipped" ||
        orderStatus == "delivered";
  }

  bool isShippedActive() {
    return orderStatus == "shipped" || orderStatus == "delivered";
  }

  bool isOutForDeliveryActive() {
    return orderStatus == "out_for_delivery" || orderStatus == "delivered";
  }

  bool isDeliveredActive() {
    return orderStatus == "delivered";
  }

  String getStatusMessage() {
    if (orderStatus == "pending") {
      return "Order not packed yet";
    } else if (orderStatus == "cancelled") {
      return "Order cancelled";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final statusMessage = getStatusMessage();

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

            // SHOW MESSAGE FOR PENDING / CANCELLED
            if (statusMessage.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                child: Text(
                  statusMessage,
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    color: MyColors.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

            // TRACKING STEPS
            TrackingStatus(title: "Packed", active: isPackedActive()),
            TrackingStatus(title: "Shipped", active: isShippedActive()),
            TrackingStatus(
                title: "Out for delivery",
                active: isOutForDeliveryActive()),
            TrackingStatus(title: "Delivered", active: isDeliveredActive()),
          ],
        ),
      ),
    );
  }
}
