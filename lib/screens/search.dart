import 'package:flutter/material.dart';
import 'package:movie_bank_mobile/utils/page_utils.dart';

const CURRENT_PAGE = 1;

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff303043),
      bottomNavigationBar: getBottomNavigationBar(CURRENT_PAGE, context),
      body: Container(),
    );
  }
}
