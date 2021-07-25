import 'package:flutter/material.dart';
import 'package:movie_bank_mobile/screens/Home.dart';

void main() {
  runApp(MovieBank());
}

class MovieBank extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MovieBank',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
