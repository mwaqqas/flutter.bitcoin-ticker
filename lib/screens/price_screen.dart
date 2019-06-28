import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

import 'package:bitcoin_ticker/models/coin_data.dart';
import 'package:bitcoin_ticker/screens/loading_screen.dart';
import 'package:bitcoin_ticker/utilities/constants.dart';

class PriceScreen extends StatefulWidget {
  final Map<String, String> exchangeRates;
  final selectedCurrency;
  final selectedIndex;
  PriceScreen({
    this.exchangeRates,
    this.selectedCurrency,
    this.selectedIndex,
  });

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency;
  int selectedIndex;
  String btcRate;
  String ethRate;
  String ltcRate;
  CoinData coinData = CoinData();

  @override
  void initState() {
    super.initState();
    final initialData = widget.exchangeRates;
    setState(() {
      selectedCurrency = widget.selectedCurrency;
      btcRate = initialData['BTC'];
      ethRate = initialData['ETH'];
      ltcRate = initialData['LTC'];
    });
  }

  DropdownButton<String> getCurerncyDropdownAndroid() {
    List<DropdownMenuItem<String>> itemList = [];

    for (String currency in currenciesList) {
      Widget item = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      itemList.add(item);
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return LoadingScreen(
              selectedCurrency: selectedCurrency,
            );
          }));
        });
      },
      items: itemList,
    );
  }

  Widget getCurerncyDropdownIOS() {
    List<Widget> itemList = [];
    for (String currency in currenciesList) {
      Widget item = Text(currency);
      itemList.add(item);
    }

    Widget cupertinoPicker = CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (index) {
        selectedIndex = index;
        print(selectedIndex);
        selectedCurrency = currenciesList[index];
      },
      children: itemList,
    );

    return NotificationListener<ScrollEndNotification>(
      child: cupertinoPicker,
      onNotification: (notification) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return LoadingScreen(selectedCurrency: selectedCurrency);
            },
          ),
        );
      },
    );
  }

  getPlatformSpecificCurrencyDropdown() {
    if (Platform.isIOS) {
      return getCurerncyDropdownIOS();
    } else if (Platform.isAndroid) {
      return getCurerncyDropdownAndroid();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              CoinPriceDisplay(
                exchangeRate: btcRate,
                cryptoCurrency: 'BTC',
                selectedCurrency: selectedCurrency,
              ),
              CoinPriceDisplay(
                exchangeRate: ethRate,
                cryptoCurrency: 'ETH',
                selectedCurrency: selectedCurrency,
              ),
              CoinPriceDisplay(
                exchangeRate: ltcRate,
                cryptoCurrency: 'LTC',
                selectedCurrency: selectedCurrency,
              ),
            ],
          ),
          Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Select your currency: ',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Platform.isIOS
                      ? getCurerncyDropdownIOS()
                      : getCurerncyDropdownAndroid(),
                ],
              )),
        ],
      ),
    );
  }
}

class CoinPriceDisplay extends StatelessWidget {
  const CoinPriceDisplay({
    Key key,
    @required this.exchangeRate,
    @required this.selectedCurrency,
    @required this.cryptoCurrency,
  }) : super(key: key);

  final String exchangeRate;
  final String selectedCurrency;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $exchangeRate $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
