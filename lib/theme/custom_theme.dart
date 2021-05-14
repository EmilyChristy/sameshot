import 'package:flutter/material.dart';

import 'colors.dart';

class CustomTheme with ChangeNotifier {
  static bool _isDarkTheme = false;
  ThemeMode get currentTheme => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }

  static ThemeData get lightTheme {
    return ThemeData(
        primaryColor: Colors.indigo[800],
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Montserrat', //3
        textTheme: TextTheme(
            headline1: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
            bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind')),
        buttonTheme: ButtonThemeData(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0)),
            buttonColor: Colors.orange[700],
            textTheme: ButtonTextTheme.primary));
  }

  static ThemeData get darkTheme {
    return ThemeData(
        primaryColor: CustomColors.darkGrey,
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'Montserrat',
        textTheme: TextTheme(
            headline1: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
            bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind')),
        //textTheme: ThemeData.dark().textTheme,
        buttonTheme: ButtonThemeData(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0)),
            buttonColor: Colors.orange[700],
            textTheme: ButtonTextTheme.primary));
  }
}
