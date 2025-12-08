import 'dart:convert';

import 'package:buy_n_sell/api_urls/api_urls.dart';
import 'package:buy_n_sell/custom_widgets/custom_fields/custom_textfields.dart';
import 'package:buy_n_sell/screens/login_signup_screen/forgot_password_screen.dart';
import 'package:buy_n_sell/screens/login_signup_screen/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../../custom_widgets/my_colors/my_colors.dart';
import '../../model_class/login_model.dart';
import '../../shared_pref/shared_pref.dart';
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

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

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
                height: screenHeight * 0.35,
                fit: BoxFit.contain,
              ),

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
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                loginUser();
                              } else {
                                print("Login failed!");
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

  void loginUser() async {
    var url = Uri.parse(ApiUrl.login);

    var response = await http.post(
      url,
      body: {
        "mail": emailController.text.toString(),
        "password": pswdController.text.toString(),
      },
    );

    final jsonData = jsonDecode(response.body);

    LoginModel loginModel = LoginModel.fromJson(jsonData);

    if (loginModel.status == "success") {
      print("Login success!!!! ${response.body}");

      print("User ID: ${loginModel.user?.id}");
      print("User Name: ${loginModel.user?.name}");

      var email = emailController.text.toString();
      await SharedPref.saveLoginStatus(true);
      await SharedPref.saveUserEmail(email);

      print("Saved User email: $email");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    } else {
      print("Login failed! ${loginModel.status} and ${loginModel.message}");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login Failed!")));
    }
  }

  Future<void> _handleLogin(String provider) async {
    switch (provider) {
      case "google":
        await _handleGoogleSignIn();

      case "facebook":
        await _handleFacebookSignIn();

      case "instagram":
        await _handleInstagramSignIn();
    }
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      GoogleSignInAccount? googleaccount = await _googleSignIn.signIn();
      if (googleaccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleaccount.authentication;

        final accessToken = googleSignInAuthentication.accessToken;
        final idToken = googleSignInAuthentication.idToken;

        print("$accessToken");
        print("$idToken");

        if (accessToken != null) {
          print("Name is :" + googleaccount.displayName.toString());
          print("Email is :" + googleaccount.email.toString());
          print("Photo is :" + googleaccount.photoUrl.toString());
        }
      }
    } catch (e) {
      print("MY ERROR : $e");
    }
  }

  Future<void> _handleFacebookSignIn() async {
    print("Facebook login clicked");
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Login through facebook is out of service, try another way!")));

  }

  Future<void> _handleInstagramSignIn() async {
    print("Instagram login clicked");
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Login through instagram is out of service, try another way!")));
  }
}
