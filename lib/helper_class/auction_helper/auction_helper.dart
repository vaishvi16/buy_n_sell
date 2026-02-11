import 'dart:async';
import 'package:flutter/material.dart';
import '../../providers/auction_provider.dart';
import '../../shared_pref/shared_pref.dart';

class AuctionHelper extends ChangeNotifier {
  final AuctionProvider provider;
  final String productId;
  bool winnerDialogShown = false;
  void Function(String winnerName, String amount, bool isWinner)? onWinnerDetected;

  Timer? _timer;

  int remainingSeconds = 0;
  String highestBid = "1";
  bool auctionEnded = false;
  bool initialized = false;
  bool isLast10Seconds = false; // Last 10 sec tracking

  AuctionHelper({
    required this.provider,
    required this.productId,
  });

  Future<void> initAuction() async {
    if (initialized) return;
    initialized = true;

    final data = await provider.getAuctionTime(productId);

    if (data["status"] == "no_auction_found") {
      await _loadFinalHighestBid(); // This works for ended auctions
      auctionEnded = true;
      remainingSeconds = 0;
      notifyListeners();
      return;
    }

    remainingSeconds = data["remaining_seconds"] ?? 0;

    if (remainingSeconds <= 0) {
      await _finalizeAuction();
      return;
    }

    await _loadHighestBid();
    _checkLast10Seconds(); // Check initial state
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      remainingSeconds--;

      _checkLast10Seconds(); // Check every second

      if (remainingSeconds <= 0) {
        timer.cancel();
        remainingSeconds = 0;
        await _finalizeAuction();
        return;
      }

      await _loadHighestBid();
      notifyListeners();
    });
  }

  void _checkLast10Seconds() {
    // Last 10 seconds highlight effect
    isLast10Seconds = remainingSeconds > 0 && remainingSeconds <= 10;
  }

  Future<void> _loadHighestBid() async {
    final bidData = await provider.getCurrentHighestBid(productId);
    if (bidData != null && bidData["bid_amount"] != null) {
      highestBid = bidData["bid_amount"].toString();
    }
  }

  Future<void> _loadFinalHighestBid() async {
    // For ENDED auctions - load highest bid from auction table
    final bidData = await provider.getCurrentHighestBid(productId);
    if (bidData != null && bidData["bid_amount"] != null) {
      highestBid = bidData["bid_amount"].toString();
    } else {
      // Fallback: Try to get winner bid if available
      final winnerData = await provider.getBidWinner(productId);
      if (winnerData != null && winnerData["winning_bid"] != null) {
        highestBid = winnerData["winning_bid"].toString();
      }
    }
  }

  Future<void> _finalizeAuction() async {
    final winnerData = await provider.getBidWinner(productId);

    await _loadFinalHighestBid();

    auctionEnded = true;
    remainingSeconds = 0;
    isLast10Seconds = false;

    notifyListeners();

    if (winnerDialogShown) return;
    if (winnerData == null) return;
    if (winnerData["status"] != "sold") return;

    winnerDialogShown = true;

    final loggedInUserId = await SharedPref.getUserId();

    bool isWinner = false;

    if (loggedInUserId != null &&
        loggedInUserId.toString() ==
            winnerData["winner_user_id"].toString()) {
      isWinner = true;
    }

    if (onWinnerDetected != null) {
      onWinnerDetected!(
        winnerData["winner_name"] ?? "Winner",
        winnerData["winning_bid"] ?? highestBid,
        isWinner,
      );
    }
  }

  Future<Map<String, dynamic>> placeBid(String bidAmount) async {
    // Check login
    final userId = await SharedPref.getUserId();
    if (userId == null) {
      return {"success": false, "message": "Please login first"};
    }

    // Validate : bid amount > current amount
    final currentBid = int.tryParse(highestBid ?? "1") ?? 1;
    final newBid = int.tryParse(bidAmount) ?? 0;
    if (newBid <= currentBid) {
      return {"success": false, "message": "Bid must be higher than \$$currentBid"};
    }

    final result = await provider.placeBid(productId, userId, bidAmount);

    if (result["success"]) {
      await Future.delayed(Duration(milliseconds: 500));
      await _loadHighestBid(); // Refresh bid
      notifyListeners();
    }
    return result;
  }


  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
