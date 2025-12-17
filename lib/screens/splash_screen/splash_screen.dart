import 'dart:async';

import 'package:buy_n_sell/screens/dashboard_screen/dashboard_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../shared_pref/shared_pref.dart';
import '../connectivity_error_screen/connectivity_error_screen.dart';
import '../login_signup_screen/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  double _scale = 0.5;
  double _opacity = 0.0;
  bool _navigated = false;
  String? email;

  @override
  void initState() {
    super.initState();

    // Animate splash logo
    Future.delayed(Duration.zero, () {
      setState(() {
        _scale = 1.0;
        _opacity = 1.0;
      });
    });

    // Check connectivity after 2 seconds
    Future.delayed(const Duration(seconds: 2), _checkConnectivity);

    }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          duration: Duration(seconds: 1),
          opacity: _opacity,
          child: AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.easeInOut,
            width: 400 * _scale,
            height: 600 * _scale,
            child: Image.asset("assets/logos/5_miles.png", fit: BoxFit.fill),
          ),
        ),
      ),
    );
  }

  void _checkConnectivity() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> result,
    ) async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      if (_navigated) return; // prevent double navigation

          if (result.contains(ConnectivityResult.mobile) ||
              result.contains(ConnectivityResult.wifi)) {
            // Check login status through provider
            await authProvider.checkLoginStatus();

            if (authProvider.isLoggedIn) {
              _navigateTo( DashboardScreen());
            } else {
              _navigateTo( LoginScreen());
            }
          } else {
            // No internet
            _navigateTo( ConnectivityErrorScreen());
          }
        });
  }

  void _navigateTo(Widget screen) {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }}
