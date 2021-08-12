import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_bank_mobile/utils/custom_text_styles.dart';

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
            style: CustomTextStyles.text35(context),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            synopsis,
            style: CustomTextStyles.text14light(context),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
