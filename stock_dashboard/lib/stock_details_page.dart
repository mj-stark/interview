import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Chart package
import 'package:stock_data/stock_data.dart'; // Custom package for stock data

class StockDetailsPage extends StatefulWidget {
  final String symbol;

  StockDetailsPage({required this.symbol});

  @override
  _StockDetailsPageState createState() => _StockDetailsPageState();
}

class _StockDetailsPageState extends State<StockDetailsPage> {
  late StockService _stockService;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _stockService = StockService();
  }

  @override
  void dispose() {
    _stockService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Details: ${widget.symbol.toUpperCase()}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder<double>(
              stream: _stockService.currentPriceStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  _errorMessage =
                      'Error fetching current price: ${snapshot.error}';
                  return Text(_errorMessage!);
                } else if (snapshot.hasData) {
                  return Text(
                    'Current Price: \$${snapshot.data!.toStringAsFixed(2)}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                } else {
                  return Text('No data available.');
                }
              },
            ),
            SizedBox(height: 30),
            StreamBuilder<List<double>>(
              stream: _stockService.historicalPricesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  _errorMessage =
                      'Error fetching historical data: ${snapshot.error}';
                  return Text(_errorMessage!);
                } else if (snapshot.hasData) {
                  List<FlSpot> spots = snapshot.data!.asMap().entries.map(
                    (entry) {
                      int index = entry.key;
                      double value = entry.value;
                      return FlSpot(index.toDouble(), value);
                    },
                  ).toList();

                  return Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: LineChart(
                        LineChartData(
                          lineBarsData: [
                            LineChartBarData(
                              spots: spots,
                              isCurved: true,
                              barWidth: 1,
                              belowBarData: BarAreaData(show: true),
                            ),
                          ],
                          titlesData: FlTitlesData(
                            rightTitles: AxisTitles(drawBelowEverything: false),
                            topTitles: AxisTitles(
                              drawBelowEverything: false,
                            ),
                          ),
                          borderData: FlBorderData(show: true),
                          gridData: FlGridData(show: true),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Text('No data available.');
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _stockService
            .refreshData(), // Use the public method to refresh data
        child: Icon(Icons.refresh),
      ),
    );
  }
}
