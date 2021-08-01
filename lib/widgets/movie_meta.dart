import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MovieMeta extends StatelessWidget {
  const MovieMeta({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$title: ',
          style: GoogleFonts.barlowCondensed(
            fontWeight: FontWeight.w500,
            color: Color(0xffa1a2d2),
            letterSpacing: 2,
            fontSize: 16,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.barlowCondensed(
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.9),
            letterSpacing: 2,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
