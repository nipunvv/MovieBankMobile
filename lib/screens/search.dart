import 'package:flutter/material.dart';
import 'package:movie_bank_mobile/utils/page_utils.dart';

const CURRENT_PAGE = 1;

class Search extends StatelessWidget {
  final searchFieldController = TextEditingController();
  Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff303043),
      bottomNavigationBar: getBottomNavigationBar(CURRENT_PAGE, context),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            left: 15,
            right: 15,
            top: 20,
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: TextField(
              controller: searchFieldController,
              showCursor: true,
              textInputAction: TextInputAction.go,
              onSubmitted: (value) {
                // searchMovies(value);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 5.0,
                ),
              ),
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
