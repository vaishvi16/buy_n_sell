import 'package:buy_n_sell/providers/auth_provider.dart';
import 'package:buy_n_sell/providers/cart_provider.dart';
import 'package:buy_n_sell/providers/category_product_provider.dart';
import 'package:buy_n_sell/providers/category_provider.dart';
import 'package:buy_n_sell/providers/dashboard_provider.dart';
import 'package:buy_n_sell/providers/product_provider.dart';
import 'package:buy_n_sell/providers/wishlist_provider.dart';
import 'package:buy_n_sell/screens/dashboard_screen/dashboard_screen.dart';
import 'package:buy_n_sell/screens/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(
          create: (_) {
            final productProvider = ProductProvider();
            productProvider.fetchProducts();
            return productProvider;
          },
        ),
        ChangeNotifierProvider(create: (_) => CategoryProductProvider()),
        ChangeNotifierProvider(
          create: (_) {
            final provider = WishlistProvider();
            provider
                .loadWishlist(); // to load data from db and show the saved current state when app starts
            return provider;
          },
        ),
        ChangeNotifierProvider(create: (_) {
          final cartProvider = CartProvider();
          cartProvider.loadCart();
        return cartProvider;
        }),

      ],
      child: MaterialApp(
        home: DashboardScreen(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}
