import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../login_signup_screen/login_screen.dart';
import '../network_error/network_error.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  double _scale = 0.5;
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _scale = 1.0;
        _opacity = 1.0;
      });
    });

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
        List<ConnectivityResult> result,
        ) {
      Timer(
        Duration(seconds: 2),
            () {
          if (result.contains(ConnectivityResult.mobile) || result.contains(ConnectivityResult.wifi)) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          } else if (result.contains(ConnectivityResult.none)) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => NetworkError()),
            );
          }
        },
      );
    });
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
}
