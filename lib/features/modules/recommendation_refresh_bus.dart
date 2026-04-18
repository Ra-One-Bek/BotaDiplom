import 'package:flutter/foundation.dart';

class RecommendationRefreshBus extends ChangeNotifier {
  RecommendationRefreshBus._();

  static final RecommendationRefreshBus instance =
      RecommendationRefreshBus._();

  void bump() {
    notifyListeners();
  }
}