import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConverMoneda extends StatefulWidget {
  @override
  _ConverMonedaState createState() => _ConverMonedaState();
}

class _ConverMonedaState extends State<ConverMoneda> {
  TextEditingController inputController = TextEditingController();
  TextEditingController outputController = TextEditingController();

  String selectedInputCurrency = 'USD';
  String selectedOutputCurrency = 'COP';
  double conversionRate = 1.0;

  final Map<String, String> currencies = {
    'USD': 'United States Dollar',
    'EUR': 'Euro',
    'GBP': 'British Pound',
    'JPY': 'Japanese Yen',
    'AUD': 'Australian Dollar',
    'CAD': 'Canadian Dollar',
    'CHF': 'Swiss Franc',
    'CNY': 'Chinese Yuan',
    'SEK': 'Swedish Krona',
    'NZD': 'New Zealand Dollar',
    'COP': 'Colombian Peso'
  };

  @override
  void initState() {
    super.initState();
    inputController.addListener(convert);
    fetchConversionRate();
  }

  Future<void> fetchConversionRate() async {
    final response = await http.get(Uri.parse(
        'https://v6.exchangerate-api.com/v6/7dea1ba3578a535722f06eb4/latest/$selectedInputCurrency'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        conversionRate = data['conversion_rates'][selectedOutputCurrency];
      });
      convert();
    } else {
      throw Exception('Failed to load exchange rate');
    }
  }

  void convert() {
    double inputValue = double.tryParse(inputController.text) ?? 0;
    double outputValue = inputValue * conversionRate;
    outputController.text = outputValue.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversor de Moneda'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton<String>(
                  value: selectedInputCurrency,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedInputCurrency = newValue!;
                      fetchConversionRate();
                    });
                  },
                  items: currencies.entries.map<DropdownMenuItem<String>>((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),
                ),
                DropdownButton<String>(
                  value: selectedOutputCurrency,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedOutputCurrency = newValue!;
                      fetchConversionRate();
                    });
                  },
                  items: currencies.entries.map<DropdownMenuItem<String>>((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: inputController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Cantidad',
                border: OutlineInputBorder(),
              ),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
              onChanged: (value) => convert(),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: outputController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Resultado',
                border: OutlineInputBorder(),
              ),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
              readOnly: true,
            ),
          ],
        ),
      ),
    );
  }
}
