import 'package:flutter/material.dart';

import '../screens/bottom_navigation_screen/add_to_cart_screen.dart';
import '../screens/bottom_navigation_screen/home_screen.dart';
import '../screens/bottom_navigation_screen/profile_screen.dart';
import '../screens/bottom_navigation_screen/wishlist_screen.dart';

class DashboardProvider extends ChangeNotifier {

  int _selectedIndex = 0;    // private variable
  int get selectedIndex => _selectedIndex;   // get the value of private variable

  final List<Widget> _screens = <Widget>[
    HomeScreen(),
    WishlistScreen(),
    AddToCartScreen(),
    ProfileScreen(),
  ]; // private variable

  Widget get currentScreen => _screens[_selectedIndex]; // get the value of private variable index wise

  void onItemTapped(int index) {
    _selectedIndex = index;
    print(_selectedIndex);
    notifyListeners(); // will notify the screen
  }

}
