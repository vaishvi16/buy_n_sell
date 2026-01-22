import 'package:flutter/material.dart';

import '../my_colors/my_colors.dart';

class TrackingStatus extends StatelessWidget {
  final String title;
  final bool active;

  const TrackingStatus({required this.title, required this.active});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.check_circle,
        color: active ? MyColors.primaryColor : MyColors.greyColor,
      ),
      title: Text(title),
    );
  }
}