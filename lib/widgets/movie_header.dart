import 'package:flutter/material.dart';
import 'package:movie_bank_mobile/widgets/movie_header_item.dart';

class MovieHeader extends StatelessWidget {
  const MovieHeader({
    Key? key,
    required this.releaseYear,
    required this.rating,
    required this.language,
  }) : super(key: key);

  final String releaseYear;
  final String rating;
  final String language;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.12,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 15.0,
            offset: Offset(0.0, 5),
          ),
        ],
        color: Color(0xff323143),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          MovieHeaderItem(
            icon: Icons.calendar_today,
            text: releaseYear,
          ),
          MovieHeaderItem(
            icon: Icons.language,
            text: language,
          ),
          MovieHeaderItem(
            icon: Icons.star,
            text: rating,
          ),
        ],
      ),
    );
  }
}
