import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../login_signup_screen/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold( body: Center(
      child: IconButton(
        icon: const Icon(
          Icons.logout,
          size: 40,
          color: Colors.red,
        ),
        onPressed: () async {
          final authProvider =
          Provider.of<AuthProvider>(context, listen: false);
          final dashboardProvider =
          Provider.of<DashboardProvider>(context, listen: false);

          await authProvider.logout();
          dashboardProvider.resetIndex();

          if (!context.mounted) return;

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
          );
        },
      ),
    ),);
  }
}
