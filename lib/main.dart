import 'package:flutter/material.dart';
import 'package:movie_bank_mobile/providers/provider.dart';
import 'package:movie_bank_mobile/screens/Home.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

void main() {
  runApp(
    MultiProvider(
      providers: providers,
      child: MovieBank(),
    ),
  );
}

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<GenreProvider>(create: (_) => GenreProvider()),
];

class MovieBank extends StatelessWidget {
  final Map<int, Color> color = {
    50: Color.fromRGBO(31, 31, 47, .1),
    100: Color.fromRGBO(31, 31, 47, .2),
    200: Color.fromRGBO(31, 31, 47, .3),
    300: Color.fromRGBO(31, 31, 47, .4),
    400: Color.fromRGBO(31, 31, 47, .5),
    500: Color.fromRGBO(31, 31, 47, .6),
    600: Color.fromRGBO(31, 31, 47, .7),
    700: Color.fromRGBO(31, 31, 47, .8),
    800: Color.fromRGBO(31, 31, 47, .9),
    900: Color.fromRGBO(31, 31, 47, 1),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MovieBank',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xff1f1f2f, color),
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
