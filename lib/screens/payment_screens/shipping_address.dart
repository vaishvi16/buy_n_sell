import 'package:flutter/material.dart';
import '../../custom_widgets/custom_fields/checkout_textfield.dart';
import '../../custom_widgets/my_colors/my_colors.dart';

class ShippingAddressScreen extends StatelessWidget {
  const ShippingAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Shipping Address",
          style: TextStyle(
            color: MyColors.primaryLightColor,
            fontWeight: FontWeight.w600,
            fontSize: screenWidth * 0.055,
          ),
        ),
        backgroundColor: MyColors.whiteLightColor,
        elevation: 0,
        foregroundColor: MyColors.blackColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          children: [
            CheckoutTextField(label: "Country", hint: "India"),
            CheckoutTextField(label: "Address", hint: "Street address"),
            CheckoutTextField(label: "Town / City", hint: "Bengaluru"),
            CheckoutTextField(label: "Postcode", hint: "7000"),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: MyColors.primaryColor,
            padding:
            EdgeInsets.symmetric(vertical: screenHeight * 0.018),
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(screenWidth * 0.03),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "Save Changes",
            style: TextStyle(color: MyColors.whiteColor),
          ),
        ),
      ),
    );
  }
}
