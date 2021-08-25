import 'package:flutter/material.dart';
import 'package:movie_bank_mobile/utils/page_utils.dart';

const CURRENT_PAGE = 2;

class Favorites extends StatelessWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff303043),
      bottomNavigationBar: getBottomNavigationBar(CURRENT_PAGE, context),
      body: Container(),
    );
  }
}
