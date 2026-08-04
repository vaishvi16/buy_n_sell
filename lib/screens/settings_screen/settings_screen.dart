import 'package:buy_n_sell/screens/bottom_navigation_screen/profile_screen.dart';
import 'package:buy_n_sell/screens/login_signup_screen/forgot_password_screen.dart';
import 'package:buy_n_sell/screens/order_screens/order_history_screen.dart';
import 'package:buy_n_sell/screens/payment_screens/contact_info.dart';
import 'package:buy_n_sell/screens/payment_screens/shipping_address.dart';
import 'package:buy_n_sell/screens/payment_screens/voucher_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../custom_widgets/custom_fields/profile_header.dart';
import '../../custom_widgets/custom_fields/settings_tile.dart';
import '../../custom_widgets/my_colors/my_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/theme_provider.dart';
import '../../shared_pref/shared_pref.dart';
import '../login_signup_screen/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery
        .of(context)
        .size
        .height;
    final width = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          AppLocalizations.of(context)!.settings,
          style: TextStyle(
            color: MyColors.primaryLightColor,
            fontWeight: FontWeight.w600,
            fontSize: width * 0.065,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(),

            SizedBox(height: height * 0.015),

            // Language + Dark Mode Row
            Container(
              color: MyColors.whiteColor,
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.04,
                vertical: height * 0.015,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer<LanguageProvider>(
                    builder: (context, languageProvider, child) {
                      return DropdownButton<String>(
                        value: languageProvider.locale.languageCode,
                        underline: const SizedBox(),
                        icon: const Icon(Icons.keyboard_arrow_down),
                        onChanged: (value) {
                          if (value != null) {
                            languageProvider.changeLanguage(value);
                          }
                        },
                        items: [
                          DropdownMenuItem(
                            value: "en",
                            child: Text(AppLocalizations
                                .of(context)
                                ?.english ?? "English"),
                          ),
                          DropdownMenuItem(
                            value: "hi",
                            child: Text(AppLocalizations
                                .of(context)
                                ?.hindi ?? "Hindi"),
                          ),
                          DropdownMenuItem(
                            value: "gu",
                            child: Text(AppLocalizations
                                .of(context)
                                ?.gujarati ?? "Gujarati"),
                          ),
                        ],
                      );
                    },
                  ),
                  Row(
                    children: [
                      Text(
                        "Dark Mode",
                        style: TextStyle(fontSize: width * 0.035),
                      ),
                      Consumer<ThemeProvider>(
                        builder: (context, themeProvider, child) {
                          return Switch(
                            value: themeProvider.isDarkMode,
                            activeColor: MyColors.primaryColor,
                            onChanged: (value) {
                              themeProvider.toggleTheme(value);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: height * 0.015),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              child: Column(
                children: [
                  SettingsTile(
                    icon: Icons.edit,
                    title: "Edit Profile",
                    onTap: () async {
                      final authProvider = Provider.of<AuthProvider>(
                        context,
                        listen: false,
                      );

                      final phone = await SharedPref.getPhoneNumber();

                      if (!context.mounted) return;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ContactInfoScreen(
                            email: authProvider.userEmail,
                            phone: phone,
                          ),
                        ),
                      );
                    },
                  ),
                  SettingsTile(
                    icon: Icons.shopping_bag_outlined,
                    title: "Order History",
                    screen: OrderHistoryScreen(),
                  ),
                  SettingsTile(
                    icon: Icons.location_on_outlined,
                    title: "Shipping Details",
                    screen: ShippingAddressScreen(),
                  ),
                  SettingsTile(
                    icon: Icons.card_giftcard,
                    title: "All Coupons",
                    screen: VoucherScreen(),
                  ),
                  SettingsTile(
                    icon: Icons.lock_outline,
                    title: "Change Password",
                    screen: ForgotPasswordScreen(),
                  ),
                  SettingsTile(
                    icon: Icons.logout,
                    title: "Log Out",
                    //  screen: ProfileScreen(),
                    onTap: () => _showLogoutSheet(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutSheet(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06,
            vertical: screenHeight * 0.025,
          ),
          decoration: BoxDecoration(
            color: Theme
                .of(context)
                .cardColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle
              Container(
                width: screenWidth * 0.15,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              SizedBox(height: screenHeight * 0.025),

              CircleAvatar(
                radius: screenWidth * 0.09,
                backgroundColor: Colors.red.withOpacity(0.1),
                child: Icon(
                  Icons.logout_rounded,
                  color: Colors.red,
                  size: screenWidth * 0.09,
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              Text(
                "Logout",
                style: TextStyle(
                  fontSize: screenWidth * 0.055,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: screenHeight * 0.01),

              Text(
                "Are you sure you want to logout from your account?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: screenWidth * 0.038,
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.018,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                  ),

                  SizedBox(width: screenWidth * 0.04),

                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.018,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () async {
                        final authProvider = Provider.of<AuthProvider>(
                          context,
                          listen: false,
                        );
                        final dashboardProvider = Provider.of<
                            DashboardProvider>(
                          context,
                          listen: false,
                        );

                        await authProvider.logout();
                        dashboardProvider.resetIndex();

                        if (!context.mounted) return;

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LoginScreen(),
                          ),
                              (route) => false,
                        );
                      },
                      child: const Text("Logout"),
                    ),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.015),
            ],
          ),
        );
      },
    );
  }
}
