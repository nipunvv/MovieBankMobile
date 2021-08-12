import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_bank_mobile/utils/custom_text_styles.dart';

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
          style: CustomTextStyles.text16light(context),
        ),
        Text(
          value,
          style: CustomTextStyles.text14(context),
        ),
      ],
    );
  }
}
