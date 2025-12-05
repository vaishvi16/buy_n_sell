import 'package:buy_n_sell/screens/login_signup_screen/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../api_urls/api_urls.dart';
import '../../custom_widgets/custom_fields/custom_textfields.dart';
import '../../custom_widgets/my_colors/my_colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final RegExp emailValidatorRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

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
              SizedBox(height: screenHeight * 0.03),
              Text("Forgot Password?", style: TextStyle(fontWeight: FontWeight.w500,color: MyColors.blackColor, fontSize: 24),),
              Text("No worries, we'll help you to reset it.", style: TextStyle(fontWeight: FontWeight.w400,color: MyColors.blackColor),),
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
                                forgotPassword(email);
                              } else {
                                print("Login failed!");
                              }
                            },
                            child: Text(
                              "Forgot Password",
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

  void forgotPassword(String email) async{
    var url = Uri.parse(ApiUrl.forgotPassword);

    var response = await http.post(url, body: {
      'mail' : email
    });

    if(response.statusCode == 200){
      print("Forgot Password request sent!! ${response.body}");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ResetPasswordScreen(email: email,),));
    }else{
      print("Forgot password request failed ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter valid email!")));
    }
  }
}
