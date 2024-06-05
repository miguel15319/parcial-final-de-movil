import 'package:flutter/material.dart';
import 'package:parcialmovil/ConverMoneda.dart';


void main() {
  runApp(Pantallas());
}

class Pantallas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Cambio_Pant(),
    );
  }
}

class Cambio_Pant extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Pant_Magn(),
      ),
    );
  }
}

class Pant_Magn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConverMoneda(),
    );
  }
}
