import 'package:buy_n_sell/api_urls/api_urls.dart';
import 'package:buy_n_sell/screens/login_signup_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../custom_widgets/custom_fields/custom_textfields.dart';
import '../../custom_widgets/my_colors/my_colors.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
   ResetPasswordScreen({required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController pswdController = TextEditingController();
  TextEditingController cPswdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool showPassword = false;
  bool showCPassword = false;

  final RegExp emailValidatorRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );
  final RegExp passwordValidatorRegExp = RegExp(
    r"^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*\W).{6,16}$",
  );

  @override
  void initState() {
    super.initState();
    emailController.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              MyColors.whiteColor,
              MyColors.whiteColor,
              MyColors.primaryLightColor,
              MyColors.primaryColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Image.asset(
                "assets/logos/5_miles.png",
                height: screenHeight * 0.25,
                fit: BoxFit.contain,
              ),
              Text(
                "Set New Password!",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: MyColors.blackColor,
                    fontSize: 24
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0),
                child: Text(
                  textAlign: TextAlign.center,
                  "Must be at least 6 letters, include uppercase, lowercase and special character.",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: MyColors.blackColor,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.08,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextField(
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            readOnly: true,
                            labelText: "Email",
                            hintText: "Enter email",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!emailValidatorRegExp.hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          CustomTextField(
                            controller: pswdController,
                            labelText: "Password",
                            hintText: "Enter password",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (!passwordValidatorRegExp.hasMatch(value)) {
                                return 'Password must be atleast 6 characters, include uppercase, lowercase, number, and special character.';
                              }
                              return null;
                            },

                            keyboardType: TextInputType.text,
                            obsureText: !showPassword,
                            sufFixIcon: IconButton(
                              icon: Icon(
                                showPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: MyColors.blackColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                            ),
                            maxLine: 1,
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          CustomTextField(
                            controller: cPswdController,
                            labelText: "Confirm Password",
                            hintText: "Enter confirm password",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter confirm password';
                              }
                              var pswdValue = pswdController.text.toString();
                              var cPswdValue = cPswdController.text.toString();

                              if (pswdValue != cPswdValue) {
                                return 'Password and Confirm Password must match! ';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                            obsureText: !showCPassword,
                            sufFixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  showCPassword = !showCPassword;
                                });
                              },
                              icon: Icon(
                                showCPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                            maxLine: 1,
                          ),
                          SizedBox(height: screenHeight * 0.045),

                          // RESET BUTTON
                          ElevatedButton(
                            style: ButtonStyle(
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.all(
                                    Radius.circular(8),
                                  ),
                                ),
                              ),
                              minimumSize: WidgetStatePropertyAll(
                                Size(screenWidth * 0.6, 45),
                              ),
                              backgroundColor: WidgetStatePropertyAll(
                                MyColors.whiteLightColor,
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                var email = emailController.text.toString();
                                var pass = pswdController.text.toString();
                                resetPassword(email, pass);
                              } else {
                                print("reset password failed!");
                              }
                            },
                            child: Text(
                              "Reset Password",
                              style: TextStyle(
                                color: MyColors.primaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void resetPassword(String email, String pass) async {
    var url = Uri.parse(ApiUrl.resetPassword);

    var response = await http.post(
      url,
      body: {'mail': email, 'password': pass},
    );

    if (response.statusCode == 200) {
      print("Password updated successfully!");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Password Updated Successfully")));
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    } else {
      print("Password failed to update!");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Password Update failed!")));
    }
  }
}
