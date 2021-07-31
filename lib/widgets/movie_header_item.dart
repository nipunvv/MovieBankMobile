import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MovieHeaderItem extends StatelessWidget {
  const MovieHeaderItem({Key? key, required this.icon, required this.text})
      : super(key: key);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Colors.white,
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          text,
          style: GoogleFonts.barlowCondensed(
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(.85),
            letterSpacing: 2,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}
