import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'stock_details_page.dart'; // Import StockDetailsPage
import 'package:stock_data/stock_data.dart'; // Import the StockService class

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allTrendingStocks = [];
  List<Map<String, dynamic>> _filteredTrendingStocks = [];
  int _selectedIndex = 0;
  String _selectedTimeFrame = 'Days';
  late StockService _stockService;

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

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _changeTimeFrame(String timeFrame) {
    setState(() {
      _selectedTimeFrame = timeFrame;
    });
  }

  void _navigateToStockDetails(BuildContext context, String symbol) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StockDetailsPage(symbol: symbol),
      ),
    );
  }

  void _filterStocks(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredTrendingStocks = _allTrendingStocks;
      });
      return;
    }

    final filteredStocks = _allTrendingStocks.where((stock) {
      final stockName = stock['name'].toString().toLowerCase();
      final searchQuery = query.toLowerCase();
      return stockName.contains(searchQuery);
    }).toList();

    setState(() {
      _filteredTrendingStocks = filteredStocks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NavigationRail(
            backgroundColor: Colors.purple,
            selectedIconTheme: const IconThemeData(color: Colors.white),
            unselectedIconTheme: const IconThemeData(color: Colors.white54),
            selectedLabelTextStyle: const TextStyle(color: Colors.white),
            unselectedLabelTextStyle: const TextStyle(color: Colors.white54),
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onDestinationSelected,
            labelType: NavigationRailLabelType.all,
            destinations: [
              const NavigationRailDestination(
                icon: Icon(Icons.category_outlined),
                selectedIcon:
                    Icon(Icons.category_outlined, color: Colors.purple),
                label: Text('Dash Board'),
              ),
              const NavigationRailDestination(
                icon: Icon(Icons.pageview_sharp),
                selectedIcon: Icon(Icons.pageview_sharp, color: Colors.purple),
                label: Text('Portfolio'),
              ),
              const NavigationRailDestination(
                icon: Icon(Icons.settings),
                selectedIcon: Icon(Icons.settings, color: Colors.purple),
                label: Text('Settings'),
              ),
            ],
          ),
          VerticalDivider(
            thickness: 1,
            width: 1,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.search),
                                  SizedBox(width: 8.0),
                                  Expanded(
                                    child: TextField(
                                      controller: _searchController,
                                      decoration: InputDecoration(
                                        hintText: 'Search...',
                                        border: InputBorder.none,
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.clear),
                                          onPressed: () {
                                            _searchController
                                                .clear(); // Clear the search input
                                            _filterStocks(
                                                ''); // Reset the search filter
                                          },
                                        ),
                                      ),
                                      onChanged: (query) {
                                        _filterStocks(
                                            query); // Filter the stocks as the user types
                                      },
                                      onSubmitted: (query) {
                                        _filterStocks(
                                            query); // Filter the stocks when the search is submitted
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 16.0),
                          Icon(Icons.notifications),
                          SizedBox(width: 16.0),
                          CircleAvatar(
                            radius: 20.0,
                            backgroundImage:
                                NetworkImage('https://via.placeholder.com/100'),
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            'Manoj', // Replace with user's name
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 0,
                      child: Card(
                        elevation: 5,
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Balance',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              StreamBuilder<double>(
                                stream: _stockService.balanceAmountStream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      '\$${snapshot.data!.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                },
                              ),
                              SizedBox(height: 16.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Gains',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 18,
                                        ),
                                      ),
                                      StreamBuilder<double>(
                                        stream:
                                            _stockService.totalInvestedStream,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Text(
                                              '\$${snapshot.data!.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          } else {
                                            return CircularProgressIndicator();
                                          }
                                        },
                                      ),
                                      SizedBox(height: 16.0),
                                      Text(
                                        'Loss',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 18,
                                        ),
                                      ),
                                      StreamBuilder<double>(
                                        stream:
                                            _stockService.totalInvestedStream,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Text(
                                              '\$${snapshot.data!.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          } else {
                                            return CircularProgressIndicator();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.0),
                              Text(
                                'Total Equity',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              StreamBuilder<double>(
                                stream: _stockService.totalInvestedStream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      '\$${snapshot.data!.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    StreamBuilder<List<double>>(
                      stream: _stockService.historicalPricesStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: GestureDetector(
                                  onTap: () => _navigateToStockDetails(
                                      context, 'AAPL'), // Example symbol
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.lightBlue,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    height: 350,
                                    padding: EdgeInsets.all(20.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ElevatedButton(
                                                onPressed: () =>
                                                    _changeTimeFrame('Days'),
                                                child: Text(
                                                  'Days',
                                                  style: TextStyle(
                                                    color: _selectedTimeFrame ==
                                                            'Days'
                                                        ? Colors.black
                                                        : Colors.purple,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ElevatedButton(
                                                onPressed: () =>
                                                    _changeTimeFrame('Weeks'),
                                                child: Text(
                                                  'Weeks',
                                                  style: TextStyle(
                                                    color: _selectedTimeFrame ==
                                                            'Weeks'
                                                        ? Colors.black
                                                        : Colors.purple,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ElevatedButton(
                                                onPressed: () =>
                                                    _changeTimeFrame('Months'),
                                                child: Text(
                                                  'Months',
                                                  style: TextStyle(
                                                    color: _selectedTimeFrame ==
                                                            'Months'
                                                        ? Colors.black
                                                        : Colors.purple,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ElevatedButton(
                                                onPressed: () =>
                                                    _changeTimeFrame('Years'),
                                                child: Text(
                                                  'Years',
                                                  style: TextStyle(
                                                    color: _selectedTimeFrame ==
                                                            'Years'
                                                        ? Colors.black
                                                        : Colors.purple,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                          child: LineChart(
                                            LineChartData(
                                              lineBarsData: [
                                                LineChartBarData(
                                                  spots: List.generate(
                                                      snapshot.data!.length,
                                                      (index) => FlSpot(
                                                          index.toDouble(),
                                                          snapshot
                                                              .data![index])),
                                                  isCurved: false,
                                                  barWidth: 2,
                                                  isStrokeCapRound: false,
                                                  belowBarData:
                                                      BarAreaData(show: true),
                                                ),
                                              ],
                                              titlesData: FlTitlesData(
                                                rightTitles: AxisTitles(
                                                    drawBelowEverything: false),
                                                topTitles: AxisTitles(
                                                  drawBelowEverything: false,
                                                ),
                                              ),
                                              gridData: FlGridData(show: true),
                                              borderData:
                                                  FlBorderData(show: false),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 16.0),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 16.0),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Trending Stocks',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8.0),
                                        StreamBuilder<
                                            List<Map<String, dynamic>>>(
                                          stream: _stockService
                                              .trendingStocksStream,
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return ListView.builder(
                                                shrinkWrap: true,
                                                itemCount:
                                                    snapshot.data!.length,
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                      onTap: () =>
                                                          // Extract the stock name from the map and pass it to the navigation function
                                                          _navigateToStockDetails(
                                                            context,
                                                            snapshot.data![
                                                                        index]
                                                                    ['name']
                                                                as String, // Pass the name field from the map
                                                          ),
                                                      child: Card(
                                                        elevation: 5,
                                                        child: ListTile(
                                                          title: Text(
                                                              'Stock Name ${String.fromCharCodes(List.generate(3, (index) => Random().nextInt(26) + 65))}'), // Generates a random 3-letter stock name
                                                          subtitle: Text(
                                                              'Price: \$${(index + 1) * 100}'),
                                                          trailing: Text(
                                                            index % 2 == 0
                                                                ? '+\$${index * 50}'
                                                                : '-\$${index * 50}',
                                                            style: TextStyle(
                                                              color: index %
                                                                          2 ==
                                                                      0
                                                                  ? Colors.green
                                                                  : Colors.red,
                                                            ),
                                                          ),
                                                        ),
                                                      ));
                                                },
                                              );
                                            } else {
                                              return CircularProgressIndicator();
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
