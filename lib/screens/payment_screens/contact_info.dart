import 'package:flutter/material.dart';

import '../../custom_widgets/custom_fields/checkout_textfield.dart';
import '../../custom_widgets/my_colors/my_colors.dart';
import '../../shared_pref/shared_pref.dart';

class ContactInfoScreen extends StatefulWidget {
  final String? email;
  final String? phone;

  const ContactInfoScreen({super.key, this.email, this.phone});

  @override
  State<ContactInfoScreen> createState() => _ContactInfoScreenState();
}

class _ContactInfoScreenState extends State<ContactInfoScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email ?? '';
    _phoneController.text = widget.phone ?? '';
  }

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
            CheckoutTextField(
              label: "Phone Number",
              hint: "phone number",
              controller: _phoneController,
              textInputType: TextInputType.number,
            ),
            CheckoutTextField(
              label: "Email",
              hint: "email",
              controller: _emailController,
              textInputType: TextInputType.emailAddress,
            ),
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
          onPressed: () async {
            if (_phoneController.text.isNotEmpty) {
              await SharedPref.savePhoneNumber(_phoneController.text);
            }

            Navigator.pop(context, true);
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
