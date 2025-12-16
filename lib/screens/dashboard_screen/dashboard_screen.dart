import 'package:buy_n_sell/custom_widgets/my_colors/my_colors.dart';
import 'package:flutter/material.dart';

import '../bottom_navigation_screen/add_to_cart_screen.dart';
import '../bottom_navigation_screen/home_screen.dart';
import '../bottom_navigation_screen/profile_screen.dart';
import '../bottom_navigation_screen/wishlist_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print(_selectedIndex);
    });
  }

  static final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    WishlistScreen(),
    AddToCartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: MyColors.primaryColor,
      body: _widgetOptions.elementAt(_selectedIndex),
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
            currentIndex: _selectedIndex,
            backgroundColor: Colors.transparent,
            selectedItemColor: MyColors.blackDarkColor,
            unselectedItemColor: MyColors.whiteLightColor,
            onTap: _onItemTapped,
            showSelectedLabels: false,
            showUnselectedLabels: false,
          ),
        ),
      ),
    );
  }
}
