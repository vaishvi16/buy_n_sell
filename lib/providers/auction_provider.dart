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
  Future<Map<String, dynamic>?> getBidWinner(String productId) async {
    try {
      final res = await http.get(
        Uri.parse("${ApiUrl.getBidWinner}?product_id=$productId"),
      );

      print("Winner API Response: ${res.body}");

      if (res.statusCode != 200) return null;

      final data = json.decode(res.body);

      if (data == null || data.isEmpty) return null;

      return data;
    } catch (e) {
      print("Winner API Error: $e");
      return null;
    }
  }


  Future<Map<String, dynamic>> placeBid(String productId, String userId, String bidAmount) async {
    try {
      final res = await http.post(
        Uri.parse(ApiUrl.insertBid),
        body: {
          "product_id": productId,
          "user_id": userId,
          "bid_amount": bidAmount,
        },
      );

      print(" RAW Response: ${res.body}");

      // PERFECT FIX: Handle PLAIN TEXT "Bid placed"
      if (res.statusCode == 200) {
        final responseText = res.body.trim();

        // Check if it's plain text success message
        if (responseText == "Bid placed" ||
            responseText.toLowerCase().contains("success") ||
            responseText.toLowerCase().contains("placed")) {
          return {"success": true, "message": "Bid placed successfully!"};
        }

        // Only try JSON if it's NOT plain text
        if (!responseText.startsWith("{") && !responseText.startsWith("[")) {
          return {"success": true, "message": responseText.isNotEmpty ? responseText : "Bid placed!"};
        }

        // Parse JSON as fallback
        final data = json.decode(responseText);
        return {
          "success": data["status"] == "success" || data["success"] == true,
          "message": data["message"] ?? "Bid placed successfully!"
        };
      }

      return {"success": false, "message": "Server error (${res.statusCode})"};
    } catch (e) {
      print("Full Error: $e");
      return {"success": false, "message": "Network error"};
    }
  }

}
