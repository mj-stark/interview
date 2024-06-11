import 'package:flutter/material.dart';
import 'package:stock_dashboard/home_page.dart';
import 'package:stock_dashboard/stock_details_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/stock-details': (context) => StockDetailsPage(symbol: ModalRoute.of(context)!.settings.arguments as String),
      },
    );
  }
}
