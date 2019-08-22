// import 'package:flutter/material.dart';

// import 'services/networking.dart';

//TODO Loesung von Angela
import 'package:http/http.dart' as http;
import 'dart:convert';

//String selectedCurrency = 'USD';
String cryptoCurrency = 'BTC';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

// class CoinData {
//   CoinData(this.selectedCurrency);

//   final String selectedCurrency;
//   int amountC = 100;

//   Future<dynamic> getExchangeRate() async {
//     NetworkHelper networkHelper = NetworkHelper(
//         'https://apiv2.bitcoinaverage.com/indices/global/ticker/BTCUSD');
//     var currencyData = await networkHelper.getData();
//     return currencyData;
//   }

//   getCoinData(currencyData) {
//     double value = currencyData['last'];
//     amountC = value.toInt();

//     print('The amount is $amountC');
//   }
// }

//TODO Loesung von Angela nachvollziehen warum es bei mir nicht geklappt hat!!!!!!!!!!!!!!!

const bitcoinAverageURL =
    'https://apiv2.bitcoinaverage.com/indices/global/ticker';

class CoinData {
  //CoinData(this.currency);

  //String currency;

  //3. Create the Asynchronous method getCoinData() that returns a Future (the price data).
  Future getCoinData(selectedCurrency) async {
    //4. Create a url combining the bitcoinAverageURl with the currencies we're interested, BTC to USD.
    String requestURL = '$bitcoinAverageURL/BTC$selectedCurrency';

    //5. Make a GET request to the URL and wait for the response.
    http.Response response = await http.get(requestURL);

    //6. Check that the request was successful.
    if (response.statusCode == 200) {
      //7. Use the 'dart:convert' package to decode the JSON data that comes back from BitcoinAverage.
      var decodedData = jsonDecode(response.body);
      print(decodedData);
      //8. Get the last price of bitcoin with the key 'last'.
      var lastPrice = decodedData['last'];
      //9. Output the lastPrice from the method.

      return lastPrice;
    } else {
      //10. Handle any errors that occur during the request.
      print(response.statusCode);
      //Optional: throw an error if our request fails.
      throw 'Problem with the get request';
    }
  }
}
