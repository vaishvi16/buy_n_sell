import 'package:buy_n_sell/l10n/app_localizations.dart';
import 'package:buy_n_sell/providers/auction_provider.dart';
import 'package:buy_n_sell/providers/auth_provider.dart';
import 'package:buy_n_sell/providers/cart_provider.dart';
import 'package:buy_n_sell/providers/category_product_provider.dart';
import 'package:buy_n_sell/providers/category_provider.dart';
import 'package:buy_n_sell/providers/checkout_provider.dart';
import 'package:buy_n_sell/providers/dashboard_provider.dart';
import 'package:buy_n_sell/providers/language_provider.dart';
import 'package:buy_n_sell/providers/order_history_provider.dart';
import 'package:buy_n_sell/providers/order_provider.dart';
import 'package:buy_n_sell/providers/product_provider.dart';
import 'package:buy_n_sell/providers/sell_product_provider.dart';
import 'package:buy_n_sell/providers/theme_provider.dart';
import 'package:buy_n_sell/providers/wishlist_provider.dart';
import 'package:buy_n_sell/screens/dashboard_screen/dashboard_screen.dart';
import 'package:buy_n_sell/screens/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => CheckoutProvider()),
        ChangeNotifierProvider(create: (_) => OrderHistoryProvider()),
        ChangeNotifierProvider(create: (_) => AuctionProvider()),
        ChangeNotifierProvider(
          create: (_) => SellProductProvider(),
        ),
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
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LanguageProvider(),
        ),

      ],
      child: Consumer2<ThemeProvider, LanguageProvider>(
        builder: (context, themeProvider, languageProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,

            themeMode: themeProvider.themeMode,

            theme: ThemeData(
              brightness: Brightness.light,
              useMaterial3: true,
            ),

            darkTheme: ThemeData(
              brightness: Brightness.dark,
              useMaterial3: true,
            ),

            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            supportedLocales: const [
              Locale('en'),
              Locale('hi'),
              Locale('gu'),
            ],

            locale: languageProvider.locale,

            home: SplashScreen(),
          );
        },
      ),
    ),
  );
}
