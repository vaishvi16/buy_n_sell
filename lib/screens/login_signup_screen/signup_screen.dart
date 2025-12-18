import 'package:buy_n_sell/screens/login_signup_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../custom_widgets/custom_fields/custom_textfields.dart';
import '../../custom_widgets/my_colors/my_colors.dart';
import '../../providers/auth_provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController nameController = TextEditingController();
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
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                height: screenHeight * 0.30,
                fit: BoxFit.contain,
              ),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom,),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.08,
                        vertical: screenWidth * 0.02
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomTextField(
                              controller: nameController,
                              labelText: "Name",
                              hintText: "Enter your name",
                              validator: (value) =>
                                  value!.isEmpty ? "Enter name" : null,
                              keyboardType: TextInputType.name,
                              maxLine: 1,
                            ),
                            SizedBox(height: screenHeight * 0.015),
                            CustomTextField(
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
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

                            // SIGN UP BUTTON
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
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  final authProvider = Provider.of<AuthProvider>(
                                    context,
                                    listen: false,
                                  );

                                  final success = await authProvider.signUpUser(
                                    nameController.text.toString(),
                                    emailController.text.toString(),
                                    pswdController.text.toString(),
                                  );

                                  if (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(authProvider.signupMessage!)),
                                    );

                                    Navigator.pop(context); // go back to login
                                  } else if (authProvider.signupMessage != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(authProvider.signupMessage!)),
                                    );
                                  }
                                }
                              },
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: MyColors.primaryColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.015),

                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Already have an account? ',
                                    style: TextStyle(color: MyColors.blackColor),
                                  ),
                                  Text(
                                    ' Login',
                                    style: TextStyle(
                                      color: MyColors.whiteLightColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
}
