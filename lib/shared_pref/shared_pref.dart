
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static const String _isLoggedInKey = "isLoggedIn";
  static const String _userEmailKey = "userEmail";
  static const String _shippingAddressKey = "shippingAddress";
  static const String _phoneNumberKey = "phoneNumber";


  // Save login status
  static Future<void> saveLoginStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, status);
  }

  // Get login status
  static Future<bool> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Save user email
  static Future<void> saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userEmailKey, email);
  }

  // Get user email
  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  // Logout (clear all data)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Save shipping address
  static Future<void> saveShippingAddress(String address) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_shippingAddressKey, address);
  }

// Get shipping address
  static Future<String?> getShippingAddress() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_shippingAddressKey);
  }

  // Save phone number
  static Future<void> savePhoneNumber(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_phoneNumberKey, phone);
  }

// Get phone number
  static Future<String?> getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_phoneNumberKey);
  }
}