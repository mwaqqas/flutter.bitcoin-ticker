import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:bitcoin_ticker/utilities/constants.dart';

class CoinData {
  Future<String> getCoinData({fiat, crypto}) async {
    String url =
        "https://apiv2.bitcoinaverage.com/indices/global/ticker/$crypto$fiat";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      String coinLastPrice = jsonResponse['last'].round().toString();
      return coinLastPrice;
    } else {
      print("Request failed with status: ${response.statusCode}.");
      return '${response.statusCode}';
    }
  }

  Future<Map<String, String>> getAllCoinData(String selectedCurrency) async {
    Map<String, String> coinDataMap = {};
    coinDataMap['selectedCurrency'] = selectedCurrency;

    for (String crypto in cryptoList) {
      var price = await getCoinData(crypto: crypto, fiat: selectedCurrency);
      coinDataMap[crypto] = price;
    }
    return coinDataMap;
  }
}
