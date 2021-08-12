import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_bank_mobile/utils/custom_text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class PaheSearch extends StatelessWidget {
  const PaheSearch({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  void _openPahe() async {
    String url = 'https://pahe.ph/?s=${_getSearchableString()}';
    if (await canLaunch(url)) await launch(url);
  }

  String _getSearchableString() {
    return title.replaceAll(RegExp('\\s'), '+');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _openPahe();
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: Color(0xffa1a2d2).withOpacity(0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              color: Color(0xffa1a2d2).withOpacity(0.8),
            ),
            Text(
              'Search on Pahe',
              style: CustomTextStyles.text16light(context),
            ),
          ],
        ),
      ),
    );
  }
}
