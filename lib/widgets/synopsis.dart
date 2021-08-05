import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Synopsis extends StatelessWidget {
  const Synopsis({
    Key? key,
    required this.synopsis,
  }) : super(key: key);

  final String synopsis;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Synopsis',
            style: GoogleFonts.barlowCondensed(
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(.85),
              letterSpacing: 2,
              fontSize: 35,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            synopsis,
            style: GoogleFonts.barlowCondensed(
              fontWeight: FontWeight.w500,
              color: Color(0xffa1a2d2),
              letterSpacing: 2,
              fontSize: 14,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
