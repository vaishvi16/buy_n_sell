import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../screens/sell_product_screens/sell_product_screen.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  bool readOnly;
  bool autoFocus;
  TextEditingController controller;
  final Widget? navigate;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Function(String imagePath)? onImageSelected;

  MyAppBar({
    required this.readOnly,
    required this.autoFocus,
    this.actions,
    required this.controller,
    this.navigate,
    this.onChanged,
    this.onSubmitted,
    this.onImageSelected
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
                  onSubmitted: onSubmitted,
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
                    suffixIcon: IconButton(
                      icon: Icon(Icons.camera_alt),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                        await picker.pickImage(source: ImageSource.camera);

                        if (image != null) {
                          _showImageOptions(context, image.path);
                        }
                      },
                    ),
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

  void _showImageOptions(BuildContext context, String imagePath) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding:  EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // Title
               Text(
                "Choose Option",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

               SizedBox(height: 20),

              // OPTIONS ROW
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  // SEARCH OPTION
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        if (navigate != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => navigate!,
                              settings: RouteSettings(arguments: imagePath),
                            ),
                          );
                        }
                      },
                      child: Container(
                        margin:  EdgeInsets.only(right: 10),
                        padding:  EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children:  [
                            Icon(Icons.search, size: 32, color: Colors.blue),
                            SizedBox(height: 8),
                            Text(
                              "Search",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // SELL OPTION
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);

                        if (onImageSelected != null) {
                          onImageSelected!(imagePath);
                        } else if (navigate != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => navigate!,
                              settings: RouteSettings(arguments: imagePath),
                            ),
                          );
                        }
                      },

                      child: Container(
                        margin:  EdgeInsets.only(left: 10),
                        padding:  EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children:  [
                            Icon(Icons.sell, size: 32, color: Colors.green),
                            SizedBox(height: 8),
                            Text(
                              "Sell",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
