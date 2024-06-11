import 'dart:async';
import 'dart:math';

class StockService {
  final _random = Random();

  Future<double> getCurrentPrice(String symbol) async {
    // Simulate a delay to mimic an asynchronous operation
    await Future.delayed(Duration(seconds: 1));

    // Generate random stock prices for demonstration
    return 100 + _random.nextDouble() * 50;
  }

  List<double> getHistoricalPrices(String symbol) {
    return List.generate(30, (_) => 100 + _random.nextDouble() * 50);
  }
}
