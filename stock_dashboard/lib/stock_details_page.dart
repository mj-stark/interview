import 'package:flutter/material.dart';
import 'package:stock_data/stock_data.dart'; // Import the custom package

class StockDetailsPage extends StatelessWidget {
  final String symbol;

  StockDetailsPage({required this.symbol});

  @override
  Widget build(BuildContext context) {
    StockService stockService = StockService(); // Create an instance of the StockService

    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Details - $symbol'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<double>(
  future: stockService.getCurrentPrice(symbol),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    } else if (snapshot.hasError) {
      return Text('Error fetching data');
    } else {
      double currentPrice = snapshot.data ?? 0.0; // Handle null value
      return Text('Current Price: \$${currentPrice.toStringAsFixed(2)}');
    }
  },
),


            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/stock-details', arguments: symbol);
              },
              child: Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }
}
