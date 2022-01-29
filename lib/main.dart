import 'package:flutter/material.dart';
import './ui/Weather.dart';


void main() {
  runApp(
      new MaterialApp(
      title: 'WEATHER APP',
        home: Weather(),
        debugShowCheckedModeBanner: false,
    ));
}