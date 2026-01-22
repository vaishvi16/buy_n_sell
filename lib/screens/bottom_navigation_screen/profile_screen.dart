import 'package:buy_n_sell/custom_widgets/custom_fields/custom_wishlist_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../custom_widgets/custom_fields/order_tabs.dart';
import '../../custom_widgets/my_colors/my_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../login_signup_screen/login_screen.dart';
import '../order_screens/recieve_screen.dart';
import '../order_screens/review_selection_screen.dart';
import '../search_screen/category_searches.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: MyColors.whiteLightColor,
      body: Consumer2<ProductProvider, WishlistProvider>(
        builder: (context, productProvider, wishlistProvider, _) {
          final wishlistProducts = productProvider.allProducts
              .where((p) => wishlistProvider.isInWishlist(p.id ?? ""))
              .toList();

          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: screenWidth * 0.055,
                              backgroundImage: NetworkImage(
                                "https://i.pravatar.cc/150?img=47",
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.025),
                            Text(
                              "Hello, Amanda!",
                              style: TextStyle(
                                fontSize: screenWidth * 0.06,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      IconButton(
                        icon: Icon(Icons.notes_outlined, size: screenWidth * 0.065),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ToReceiveScreen(),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.settings, size: screenWidth * 0.065),
                        onPressed: () {
                          _showLogoutSheet(context);
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.025),

                  // ANNOUNCEMENT
                  Container(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    decoration: BoxDecoration(
                      color: MyColors.whiteColor,
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Announcement\nLorem ipsum dolor sit amet.",
                            style: TextStyle(
                              color: MyColors.blackColor,
                              fontSize: screenWidth * 0.038,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: MyColors.blackColor,
                          size: screenWidth * 0.06,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.035),

                  // MY ORDERS
                  _sectionHeading(
                    title: "My Orders",
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  ),

                  Row(
                    children: [
                      OrderTab(title: "To Pay", onTap: () {}),
                      OrderTab(
                        title: "To Receive",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ToReceiveScreen(),
                            ),
                          );
                        },
                      ),
                      OrderTab(
                        title: "To Review",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ReviewSelectionScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.035),

                  //TOP PRODUCTS
                  _sectionHeading(
                    title: "Top Products",
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  ),
                  CategorySearches(),

                  SizedBox(height: screenHeight * 0.035),

                  // RECENTLY VIEWED
                  _sectionHeading(
                    title: "Recently viewed",
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  ),

                  if (wishlistProducts.isEmpty)
                    Text(
                      "No recently viewed items",
                      style: TextStyle(fontSize: screenWidth * 0.038),
                    )
                  else
                    ...wishlistProducts.map(
                      (product) => Padding(
                        padding: EdgeInsets.only(bottom: screenHeight * 0.015),
                        child: CustomWishlistCard(
                          product: product,
                          screenWidth: screenWidth,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showLogoutSheet(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ListTile(
          leading: Icon(
            Icons.logout,
            color: Colors.red,
            size: screenWidth * 0.06,
          ),
          title: Text("Logout", style: TextStyle(fontSize: screenWidth * 0.04)),
          onTap: () async {
            final authProvider = Provider.of<AuthProvider>(
              context,
              listen: false,
            );
            final dashboardProvider = Provider.of<DashboardProvider>(
              context,
              listen: false,
            );

            await authProvider.logout();
            dashboardProvider.resetIndex();

            if (!context.mounted) return;

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          },
        );
      },
    );
  }

  Widget _sectionHeading({
    required String title,
    required double screenWidth,
    required double screenHeight,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: screenHeight * 0.015),
      ],
    );
  }
}
