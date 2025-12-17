import 'package:buy_n_sell/custom_widgets/my_colors/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/dashboard_provider.dart';
import '../bottom_navigation_screen/add_to_cart_screen.dart';
import '../bottom_navigation_screen/home_screen.dart';
import '../bottom_navigation_screen/profile_screen.dart';
import '../bottom_navigation_screen/wishlist_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = context.watch<DashboardProvider>();

    return Scaffold(
      extendBody: true,
      backgroundColor: MyColors.primaryColor,
      body: dashboardProvider.currentScreen,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: MyColors.primaryColor,
              blurRadius: 12,
              offset: Offset(2, 2),
              spreadRadius: 1,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: "",
                backgroundColor: MyColors.primaryColor,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border_outlined),
                label: "",
                backgroundColor: MyColors.primaryColor,
                //title: Text('Download'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag_outlined),
                label: "",
                backgroundColor: MyColors.primaryColor,
                //title: Text('Home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "",
                backgroundColor: MyColors.primaryColor,
                //title: Text('Download'),
              ),
            ],
            currentIndex: dashboardProvider.selectedIndex,
            backgroundColor: Colors.transparent,
            selectedItemColor: MyColors.blackDarkColor,
            unselectedItemColor: MyColors.whiteLightColor,
            onTap: dashboardProvider.onItemTapped,
            showSelectedLabels: false,
            showUnselectedLabels: false,
          ),
        ),
      ),
    );
  }
}
