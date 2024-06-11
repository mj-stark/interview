import 'dart:async';
import 'dart:math';

class StockService {
  final _random = Random();
  final StreamController<List<double>> _historicalPricesStreamController =
      StreamController<List<double>>.broadcast();
  final StreamController<double> _currentPriceStreamController =
      StreamController<double>.broadcast();
  final StreamController<List<Map<String, dynamic>>>
      _trendingStocksStreamController =
      StreamController<List<Map<String, dynamic>>>.broadcast();
  final StreamController<double> _balanceAmountStreamController =
      StreamController<double>.broadcast();
  final StreamController<double> _totalInvestedStreamController =
      StreamController<double>.broadcast();

  Timer? _timer;
  double _currentPrice = 0.0;
  double _balanceAmount = 0.0;
  double _totalInvested = 0.0;

  StockService() {
    // Start generating random data every 10 seconds
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _generateRandomData();
    });
  }

  // Generate random stock data and update streams
  void _generateRandomData() {
    _currentPrice = 100 + _random.nextDouble() * 50;
    _currentPriceStreamController.sink.add(_currentPrice);

    final historicalPrices =
        List.generate(30, (_) => 100 + _random.nextDouble() * 50);
    _historicalPricesStreamController.sink.add(historicalPrices);

    final trendingStocks = List.generate(
        5,
        (_) => {
              'name': _generateRandomStockName(),
              'price': (100 + _random.nextDouble() * 100).toStringAsFixed(2),
              'change': (_random.nextDouble() * 20 - 10).toStringAsFixed(2)
            });
    _trendingStocksStreamController.sink.add(trendingStocks);

    _balanceAmount += _random.nextDouble() * 1000 - 500;
    _balanceAmountStreamController.sink.add(_balanceAmount);

    _totalInvested += _random.nextDouble() * 10000 - 5000;
    _totalInvestedStreamController.sink.add(_totalInvested);
  }

  // Generate a random 3-letter stock name
  String _generateRandomStockName() {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    String name = '';
    for (int i = 0; i < 3; i++) {
      name += letters[_random.nextInt(letters.length)];
    }
    return name;
  }

  // Public method to manually trigger data generation
  void refreshData() {
    _generateRandomData();
  }

  // Stream to listen for current stock price updates
  Stream<double> get currentPriceStream => _currentPriceStreamController.stream;

  // Stream to listen for historical stock prices updates
  Stream<List<double>> get historicalPricesStream =>
      _historicalPricesStreamController.stream;

  // Stream to listen for trending stocks updates
  Stream<List<Map<String, dynamic>>> get trendingStocksStream =>
      _trendingStocksStreamController.stream;

  // Stream to listen for balance amount updates
  Stream<double> get balanceAmountStream =>
      _balanceAmountStreamController.stream;

  // Stream to listen for total invested amount updates
  Stream<double> get totalInvestedStream =>
      _totalInvestedStreamController.stream;

  // Dispose of controllers when no longer needed
  void dispose() {
    _timer?.cancel();
    _currentPriceStreamController.close();
    _historicalPricesStreamController.close();
    _trendingStocksStreamController.close();
    _balanceAmountStreamController.close();
    _totalInvestedStreamController.close();
  }
}
