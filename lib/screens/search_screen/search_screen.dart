import 'package:buy_n_sell/custom_widgets/my_appbar/my_appbar.dart';
import 'package:buy_n_sell/screens/search_screen/category_searches.dart';
import 'package:buy_n_sell/screens/search_screen/product_searches.dart';
import 'package:flutter/material.dart';

import '../../custom_widgets/my_colors/my_colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: MyAppBar(
        readOnly: false,
        autoFocus: true,
        controller: _searchController,
        onChanged: (value) {
          setState(() {});
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CategorySearches(searchQuery: _searchController.text),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      "All items",
                      style: TextStyle(
                        color: MyColors.blackColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Icon(Icons.tune_outlined, size: 21),
                ),
              ],
            ),
            ProductSearches(searchQuery: _searchController.text),
          ],
        ),
      ),
    );
  }
}
