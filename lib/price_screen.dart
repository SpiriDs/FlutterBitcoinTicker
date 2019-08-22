import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  // CoinData coinData = CoinData();
  // int amount;
  // String selectedCurrency = 'USD';
  // dynamic tada = coinData.getExchangeRate();

  String selectedCurrency = 'AUD';

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropDownItems.add(newItem);
      //print(dropDownItems);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropDownItems,
      onChanged: (value) {
        //!getData(); not here, the mistake is that the function is called before the currency changes. so you get the selected Currency but the value of the previouse one. It have to be in the setSate Methode after the value is changed
        setState(
          () {
            selectedCurrency = value;
            getData(); //! Important is, that the function call is in the setState-function, so it will actualize after                 the selectedCurrency changes

//print(value);
          },
        );
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      var newItem = Text(currency);
      pickerItems.add(newItem);
      //print(pickerItems);
      //print(currency);
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(currenciesList[selectedIndex]);
        setState(() {
          selectedCurrency = currenciesList[
              selectedIndex]; //! Wichtig beim Cupertino PIcker ist, dass man um an den Wert zu bekommen auf die urspruengliche Liste mit dem selectedIndex auf der jeweiligen Position zurueckgreift!

          getData(); //!getData() muss in der setSate() aufgerufen werden, da davor die Waehrung geandert wird!! Der Fehler war bei mir, dass ich e
        });
      },
      children: pickerItems,
    );
  }

  //Im Turorial wird diese Funktion geloescht und durch einen Terneren Operator ersetzt.
  // Platform.isIOS ? iOSPicker() : androidDropdown
  //Mir gefaellt die Funktionsvariante besser
  Widget getPicker() {
    if (Platform.isIOS) {
      return iOSPicker();
    } else if (Platform.isAndroid) {
      return androidDropdown();
    }
  }

  //TODO Loesung von Angela untersuchen warum es bei mir nicht funktioniert hat!!!!!!!!!
  //12. Create a variable to hold the value and use in our Text Widget. Give the variable a starting value of '?' before the data comes back from the async methods.
  String bitcoinValueInUSD = '?';

  //11. Create an async method here await the coin data from coin_data.dart
  void getData() async {
    try {
      double data = await CoinData().getCoinData(selectedCurrency);
      //13. We can't await in a setState(). So you have to separate it out into two steps.
      setState(() {
        bitcoinValueInUSD = data.toStringAsFixed(0);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    //14. Call getData() when the screen loads up. We can't call CoinData().getCoinData() directly here because we can't make initState() async.
    getData();
  }

// @override
// void initState(){
//   super.initState();

// }
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
          Padding(
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
                  //'1 BTC = ? $selectedCurrency',
                  //TODO Loesung ANgela
                  //15. Update the Text Widget with the data in bitcoinValueInUSD.
                  '1 BTC = $bitcoinValueInUSD $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            //child: Platform.isIOS ? iOSPicker() : androidDropdown(),    ==> Version ohne getPicker Funktion
            child: iOSPicker(),
          ),
        ],
      ),
    );
  }
}
