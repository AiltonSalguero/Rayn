import 'package:flutter/material.dart';

class Util {
  static var colores = [
    Color(0xFFEF7A65),
    Color(0xFFFF90B3),
    Color(0xFFFFC2E2),
    Color(0xFFB892FF)
  ];

  static String _numberToString(int number) {
    if (number < 10) {
      return "0" + number.toString();
    } else {
      return number.toString();
    }
  }

  static String segundosToReloj(int tiempo) {
    int horas = tiempo ~/ 3600;
    int minutos = (tiempo % 3600) ~/ 60;
    int segundos = (tiempo % 3600) % 60;
    String reloj;
    reloj = Util._numberToString(horas) +
        "h " +
        Util._numberToString(minutos) +
        "m " +
        Util._numberToString(segundos) +
        "s";
    return reloj;
  }
}
