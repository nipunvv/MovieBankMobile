import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_bank_mobile/utils/custom_text_styles.dart';

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
          style: CustomTextStyles.text20(context),
        ),
      ],
    );
  }
}
