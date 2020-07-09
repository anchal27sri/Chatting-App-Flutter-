import 'package:flutter/material.dart';

class ColorMap {
  Map<String, Map<String, Color>> choiceColorMap = {
    'Blue': {
      'light': Colors.blue[200],
      'normal': Colors.blue,
      'dark': Colors.blue[900]
    },
    'Green': {
      'light': Colors.green[200],
      'normal': Colors.green,
      'dark': Colors.green[900]
    },
    'Red': {
      'light': Colors.red[200],
      'normal': Colors.red,
      'dark': Colors.red[900]
    },
    'Dark': {
      'light': Colors.grey[300],
      'normal': Colors.grey,
      'dark': Colors.grey[900]
    },
    'Yellow': {
      'light': Colors.yellow[200],
      'normal': Colors.yellow,
      'dark': Colors.yellow[900]
    },
  };
}
