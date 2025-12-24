import 'package:buy_n_sell/custom_widgets/my_appbar/my_appbar.dart';
import 'package:buy_n_sell/providers/product_provider.dart';
import 'package:buy_n_sell/screens/search_screen/category_searches.dart';
import 'package:buy_n_sell/screens/search_screen/product_searches.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../custom_widgets/my_colors/my_colors.dart';
import '../../providers/category_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isSubmitted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
      Provider.of<ProductProvider>(context, listen: false).fetchProducts(forceRefresh: true);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        readOnly: false,
        autoFocus: true,
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            isSubmitted = false;
          });
        },
        onSubmitted: (value) {
          print("onsubmitted clicked");
          setState(() {
            isSubmitted = true;
          });
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
            ProductSearches(searchQuery: _searchController.text, isSubmitted: isSubmitted,),
          ],
        ),
      ),
    );
  }
}
