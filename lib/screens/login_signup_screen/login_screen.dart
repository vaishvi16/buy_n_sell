
import 'package:buy_n_sell/custom_widgets/custom_fields/custom_textfields.dart';
import 'package:buy_n_sell/screens/login_signup_screen/forgot_password_screen.dart';
import 'package:buy_n_sell/screens/login_signup_screen/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../custom_widgets/my_colors/my_colors.dart';
import '../../providers/auth_provider.dart';
import '../dashboard_screen/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController pswdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool showPassword = false;

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
                height: screenHeight * 0.35,
                fit: BoxFit.contain,
              ),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                                  size: 22,
                                ),
                                onPressed: () {
                                  setState(() {
                                    showPassword = !showPassword;
                                  });
                                },
                              ),
                              maxLine: 1,
                            ),
                            SizedBox(height: screenHeight * 0.03),

                            // LOGIN BUTTON
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
                                  final authProvider = Provider.of<AuthProvider>(context, listen: false);
                                  await authProvider.loginUser(emailController.text, pswdController.text);

                                  if (authProvider.isLoggedIn) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (_) => DashboardScreen()),
                                    );
                                  } else if (authProvider.errorMessage != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(authProvider.errorMessage!)),
                                    );
                                    authProvider.clearError();
                                  }
                                }
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: MyColors.primaryColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.015),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: MyColors.blackColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.030),

                            Row(
                              children: [
                                Expanded(child: Divider(thickness: 2)),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SignupScreen(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'New User? Sign Up',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelMedium,
                                    ),
                                  ),
                                ),
                                Expanded(child: Divider(thickness: 2)),
                              ],
                            ),

                            SizedBox(height: screenHeight * 0.02),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                socialIcon(
                                  "assets/icons/instagram.png",
                                  "instagram",
                                ),
                                SizedBox(width: 15),
                                socialIcon(
                                  "assets/icons/facebook.png",
                                  "facebook",
                                ),
                                SizedBox(width: 15),
                                socialIcon("assets/icons/google.png", "google"),
                              ],
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

  Widget socialIcon(String path, String provider) {
    return GestureDetector(
      onTap: () {
      //  _handleLogin(provider);
      },
      child: CircleAvatar(
        radius: 21,
        backgroundColor: Colors.white,
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.all(Radius.circular(21)),
          child: Image.asset(path, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
