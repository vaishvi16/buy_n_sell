import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  bool readOnly;
  bool autoFocus;
  TextEditingController controller;
  final Widget? navigate;
  final ValueChanged<String>? onChanged;

  MyAppBar({
    required this.readOnly,
    required this.autoFocus,
    this.actions,
    required this.controller,
    this.navigate,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight + 20),
      child: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              "assets/logos/5_miles.png",
              width: screenWidth * 0.25,
              fit: BoxFit.contain,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: screenWidth * 0.02,
                  top: screenHeight * 0.01,
                ),
                child: TextField(
                  readOnly: readOnly,
                  autofocus: autoFocus,
                  maxLines: 1,
                  onChanged: onChanged,
                  controller: controller,
                  onTap: () {
                    if (readOnly && navigate != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => navigate!),
                      );
                    }
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    labelText: 'Search...',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: Icon(Icons.camera_alt),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
