import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../api_urls/api_urls.dart';
import '../model_class/login_model.dart';
import '../model_class/signup_model.dart';
import '../shared_pref/shared_pref.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _userEmail;
  String? _errorMessage;
  bool _isSigningUp = false;
  String? _signupMessage;

  // Getters
  bool get isLoggedIn => _isLoggedIn;

  bool get isLoading => _isLoading;

  String? get userEmail => _userEmail;

  String? get errorMessage => _errorMessage;

  bool get isSigningUp => _isSigningUp;

  String? get signupMessage => _signupMessage;

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  // Check login status from SharedPreferences
  Future<void> checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();

    bool status = await SharedPref.getLoginStatus();
    String? email = await SharedPref.getUserEmail();

    _isLoggedIn = status;
    _userEmail = email;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loginUser(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      var url = Uri.parse(ApiUrl.login);

      var response = await http.post(
        url,
        body: {"mail": email, "password": password},
      );

      final jsonData = jsonDecode(response.body);
      LoginModel loginModel = LoginModel.fromJson(jsonData);

      if (loginModel.status == "success") {
        print("Login success!!!! ${response.body}");

        print("User ID: ${loginModel.user?.id}");
        print("User Name: ${loginModel.user?.name}");

        _isLoggedIn = true;
        _userEmail = email;

        //save user id
        final userId = loginModel.user?.id?.toString();
        if (userId != null) {
          await SharedPref.saveUserId(userId);
        }

        //save login status and email
        await SharedPref.saveLoginStatus(true);
        await SharedPref.saveUserEmail(email);
      } else {
        _isLoggedIn = false;
        _errorMessage = loginModel.message ?? "Login failed!";
      }
    } catch (e) {
      _isLoggedIn = false;
      _errorMessage = "Something went wrong. Try again! $e";
    }
    _isLoading = false;
    notifyListeners();
  }

  // Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await SharedPref.logout();
    _isLoggedIn = false;
    _userEmail = null;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _handleLogin(String provider) async {
    switch (provider) {
      case "google":
        await googleLogin();

      case "facebook":
        await facebookLogin();

      case "instagram":
        await instagramLogin();
    }
  }

  // Google Sign-In
  Future<void> googleLogin() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      GoogleSignInAccount? googleAccount = await _googleSignIn.signIn();
      if (googleAccount != null) {
        _isLoggedIn = true;
        _userEmail = googleAccount.email;
        await SharedPref.saveLoginStatus(true);
        await SharedPref.saveUserEmail(_userEmail!);
      }
    } catch (e) {
      _errorMessage = "Google login failed!";
      _isLoggedIn = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> facebookLogin() async {
    print("Facebook login clicked");
  }

  Future<void> instagramLogin() async {
    print("Instagram login clicked");
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> signUpUser(String name, String email, String password) async {
    _isSigningUp = true;
    _signupMessage = null;
    notifyListeners();

    try{
      var url = Uri.parse(ApiUrl.signUp);

      var response = await http.post(
        url,
        body: {
          'name': name,
          'mail': email,
          'password': password,
        },
      );

      var jsonData = jsonDecode(response.body);

      SignupModel smodel = SignupModel.fromJson(jsonData);

      if (smodel.status == 'success') {
        print("uSer sign up success!");
        _signupMessage = "Signup successful. Please login.";
        _isSigningUp = false;
        notifyListeners();
        return true;
      } else {
        print("USer sign up failed! ${smodel.status} and ${smodel.message}");
        _signupMessage = "Signup failed";

      }
    }catch(e){
      _signupMessage = "Something went wrong. Try again.";

    }
    _isSigningUp = false;
    notifyListeners();
    return false;
  }
}
