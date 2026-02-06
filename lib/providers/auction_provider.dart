import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../api_urls/api_urls.dart';
import '../model_class/auction_model.dart';

class AuctionProvider with ChangeNotifier {
  List<AuctionProductModel> liveAuctions = [];
  List<AuctionProductModel> endedAuctions = [];
  List<AuctionProductModel> upcomingAuctions = [];
  bool isLoading = false;

  Future<void> fetchAuctions() async {
    isLoading = true;
    notifyListeners();

    final res = await http.get(Uri.parse(ApiUrl.viewProducts));
    final List data = json.decode(res.body);

    liveAuctions = data
        .where((e) => e['bid_status'] == 'active')
        .map((e) => AuctionProductModel.fromJson(e))
        .toList();

    upcomingAuctions = data
        .where((e) => e['bid_status'] == 'available')
        .map((e) => AuctionProductModel.fromJson(e))
        .toList();

    endedAuctions = data
        .where((e) => e['bid_status'] == 'sold')
        .map((e) => AuctionProductModel.fromJson(e))
        .toList();

    isLoading = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> getAuctionTime(String productId) async {
    final res = await http.get(
      Uri.parse("${ApiUrl.getAuctionTime}?product_id=$productId"),
    );

    final data = json.decode(res.body);
    return data;
  }


  // Get Current Highest Bid
  Future<Map<String, dynamic>?> getCurrentHighestBid(String productId) async {
    final res = await http.get(
      Uri.parse("${ApiUrl.getCurrentHighestBid}?product_id=$productId"),
    );

    // If no bid found, API might return empty object
    final data = json.decode(res.body);
    if (data == null || data.isEmpty) return null;

    return data;
  }

  // show product wise highest bid amount [works for ended product status also]
  Future<String> getHighestBidDisplay(String productId) async {
    try {
      final bidData = await getCurrentHighestBid(productId);
      if (bidData != null && bidData["bid_amount"] != null) {
        return bidData["bid_amount"].toString();
      }

      final winnerData = await getBidWinner(productId);
      if (winnerData != null && winnerData["winning_bid"] != null) {
        return winnerData["winning_bid"].toString();
      }

      return "1";
    } catch (e) {
      return "1";
    }
  }



  // Get Auction Winner (finalize auction)
  Future<Map<String, dynamic>> getBidWinner(String productId) async {
    final res = await http.get(
      Uri.parse("${ApiUrl.getBidWinner}?product_id=$productId"),
    );

    final data = json.decode(res.body);
    return data;
  }

}
