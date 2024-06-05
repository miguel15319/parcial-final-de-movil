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

  String selectedInputCurrency = 'COP';
  String selectedOutputCurrency = 'USD';
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
  final response = await http.get(
    Uri.parse('https://v6.exchangerate-api.com/v6/7dea1ba3578a535722f06eb4/latest/$selectedInputCurrency'),
    headers: {
      'consumer': 'Brayan Barajas y Miguel Roa',
    }
  );
        

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
        title: Text('Currency Converter'),
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            CurrencyDropdown(
              label: 'From',
              selectedCurrency: selectedInputCurrency,
              onChanged: (String? newValue) {
                setState(() {
                  selectedInputCurrency = newValue!;
                  fetchConversionRate();
                });
              },
              currencies: currencies,
            ),
            SizedBox(height: 10),
             CurrencyInputField(
              controller: inputController,
              label: 'Amount',
            ),
            SizedBox(height: 20),
            CurrencyDropdown(
              label: 'To',
              selectedCurrency: selectedOutputCurrency,
              onChanged: (String? newValue) {
                setState(() {
                  selectedOutputCurrency = newValue!;
                  fetchConversionRate();
                });
              },
              currencies: currencies,
            ),
            SizedBox(height: 20),
           
            CurrencyInputField(
              controller: outputController,
              label: 'Result',
              readOnly: true,
            ),
          ],
        ),
      ),
    );
  }
}

class CurrencyDropdown extends StatelessWidget {
  final String label;
  final String selectedCurrency;
  final Function(String?) onChanged;
  final Map<String, String> currencies;

  const CurrencyDropdown({
    Key? key,
    required this.label,
    required this.selectedCurrency,
    required this.onChanged,
    required this.currencies,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.blueGrey, fontSize: 16)),
        DropdownButton<String>(
          value: selectedCurrency,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down_circle),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.blueGrey),
          underline: Container(
            height: 2,
            color: Colors.blueAccent,
          ),
          onChanged: onChanged,
          items: currencies.entries.map<DropdownMenuItem<String>>((entry) {
            return DropdownMenuItem<String>(
              value: entry.key,
              child: Text(entry.value),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class CurrencyInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool readOnly;

  const CurrencyInputField({
    Key? key,
    required this.controller,
    required this.label,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        suffixIcon: readOnly ? null : Icon(Icons.edit),
      ),
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 18),
    );
  }
}
