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
  String? _userName;

  // Getters
  bool get isLoggedIn => _isLoggedIn;

  bool get isLoading => _isLoading;

  String? get userName => _userName;

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
    String? name = await SharedPref.getUserName();
    String? email = await SharedPref.getUserEmail();

    _isLoggedIn = status;
    _userName = name;
    _userEmail = email;

    _isLoading = false;
    notifyListeners();
  }

  //manual login
  Future<void> loginUser(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      var response = await http.post(
        Uri.parse(ApiUrl.login),
        body: {
          "mail": email,
          "password": password,
          "auth_provider": "manual",
        },
      );

      final jsonData = jsonDecode(response.body);
      if (jsonData['status'] == 'success') {
        _handleLoginSuccess(jsonData['user']);
      } else {
        _errorMessage = jsonData['message'] ?? 'Login failed';
        _isLoggedIn = false;
      }
    } catch (e) {
      _errorMessage = "Something went wrong: $e";
      _isLoggedIn = false;
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
    _userName = null;
    _userEmail = null;

    _isLoading = false;
    notifyListeners();
  }

  // Handle successful login
  void _handleLoginSuccess(Map<String, dynamic> user) async {
    _isLoggedIn = true;
    _userEmail = user['mail'];
    _userName = user['name'];

    await SharedPref.saveLoginStatus(true);
    await SharedPref.saveUserEmail(_userEmail!);
    await SharedPref.saveUserName(_userName!);
  }

  // Social Login (Google / Facebook / Instagram)
  Future<void> loginSocial({
    required String email,
    required String authProvider, // "google", "facebook", "instagram"
    String? name,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      var response = await http.post(
        Uri.parse(ApiUrl.login),
        body: {
          "mail": email,
          "auth_provider": authProvider,
          if (name != null) "name": name,
        },
      );

      final jsonData = jsonDecode(response.body);
      if (jsonData['status'] == 'success') {
        _handleLoginSuccess(jsonData['user']);
      } else {
        _errorMessage = jsonData['message'] ?? 'Social login failed';
        _isLoggedIn = false;
      }
    } catch (e) {
      _errorMessage = "Something went wrong: $e";
      _isLoggedIn = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  // Google Sign-In
  Future<void> googleLogin() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _googleSignIn.signOut();
      GoogleSignInAccount? googleAccount = await _googleSignIn.signIn();
      if (googleAccount != null) {
        await loginSocial(
          email: googleAccount.email,
          name: googleAccount.displayName,
          authProvider: "google",
        );
      } else {
        _errorMessage = "Google login cancelled.";
        _isLoggedIn = false;
      }
    } catch (e) {
      _errorMessage = "Google login failed: $e";
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

    try {
      var url = Uri.parse(ApiUrl.signUp);

      var response = await http.post(
        url,
        body: {'name': name, 'mail': email, 'password': password},
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
    } catch (e) {
      _signupMessage = "Something went wrong. Try again.";

    }
    _isSigningUp = false;
    notifyListeners();
    return false;
  }
}
