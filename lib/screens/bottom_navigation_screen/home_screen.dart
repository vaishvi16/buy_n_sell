import 'package:buy_n_sell/custom_widgets/my_appbar/my_appbar.dart';
import 'package:buy_n_sell/custom_widgets/my_colors/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/category_provider.dart';
import '../category_section/category_section.dart';
import '../search_screen/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: MyAppBar(readOnly: true,controller: _searchController,navigate: SearchScreen(), autoFocus: false,),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.0),
            child: Card(
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: MyColors.greyColor),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                child: Image.network(
                  "https://thumbs.dreamstime.com/b/winter-sale-concept-horizontal-banner-vector-illustration-abstract-creative-discount-layout-special-offer-graphic-design-poster-104935868.jpg",
                  width: screenWidth,
                  // height: screenHeight * 0.25,
                ),
              ),
            ),
          ),
          Expanded(child: CategorySection()),
        ],
      ),
    );
  }
}
