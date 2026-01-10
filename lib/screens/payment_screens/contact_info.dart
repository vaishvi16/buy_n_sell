import 'package:flutter/material.dart';

import '../../custom_widgets/custom_fields/checkout_textfield.dart';
import '../../custom_widgets/my_colors/my_colors.dart';

class ContactInfoScreen extends StatelessWidget {
  const ContactInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Contact Information",
          style: TextStyle(
            color: MyColors.primaryLightColor,
            fontWeight: FontWeight.w600,
            fontSize: screenWidth * 0.055,
          ),
        ),
        backgroundColor: MyColors.whiteColor,
        elevation: 0,
        foregroundColor: MyColors.blackColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          children: [
            CheckoutTextField(label: "Phone Number", hint: "+84932000000"),
            CheckoutTextField(label: "Email", hint: "amandamorgan@example.com"),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: MyColors.primaryColor,
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.018),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(screenWidth * 0.03),
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
