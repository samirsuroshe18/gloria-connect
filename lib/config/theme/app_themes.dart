import 'package:flutter/material.dart';

ThemeData theme(){
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    appBarTheme: appBarTheme(),
    useMaterial3: true,
  );
}

AppBarTheme appBarTheme(){
  return const AppBarTheme(
      color: Colors.white,
      iconTheme: IconThemeData(
          color: Colors.white
      )
  );
}