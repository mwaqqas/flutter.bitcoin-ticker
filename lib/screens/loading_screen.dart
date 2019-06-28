import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:bitcoin_ticker/models/coin_data.dart';
import 'package:bitcoin_ticker/screens/price_screen.dart';

class LoadingScreen extends StatefulWidget {
  final selectedCurrency;
  LoadingScreen({this.selectedCurrency});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  CoinData coinData = CoinData();
  String selectedCurrency;

  @override
  void initState() {
    super.initState();
    if (widget.selectedCurrency == null) {
      selectedCurrency = 'BHD';
    } else {
      selectedCurrency = widget.selectedCurrency;
    }

    getAllCoinData(selectedCurrency);
  }

  void getAllCoinData(selectedCurrency) async {
    Map<String, String> allExchangeRates =
        await coinData.getAllCoinData(selectedCurrency);

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return PriceScreen(
        exchangeRates: allExchangeRates,
        selectedCurrency: selectedCurrency,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.lightBlue,
          size: 100.0,
        ),
      ),
    );
  }
}
