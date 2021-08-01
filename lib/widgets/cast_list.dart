import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_bank_mobile/constants.dart';
import 'package:movie_bank_mobile/models/cast.dart';
import 'dart:math' as math;

class CastList extends StatelessWidget {
  const CastList({
    Key? key,
    required this.cast,
  }) : super(key: key);
  final List<Cast> cast;

  getBackgroundImage(imageUrl) {
    if (imageUrl == '') {
      return AssetImage('assets/images/avatar.jpg');
    } else {
      return NetworkImage("$TMDB_WEB_URL/w185/$imageUrl");
    }
  }

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
            'Cast',
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
          SizedBox(
            height: 60,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(
                math.min(cast.length, 10),
                (int i) {
                  return InkWell(
                    child: Container(
                      margin: EdgeInsets.only(
                        right: 10,
                      ),
                      child: Tooltip(
                        message: cast[i].name,
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: getBackgroundImage(
                            cast[i].avatar,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      // showCastDetails(casts[i]);
                    },
                    hoverColor: Colors.transparent,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
