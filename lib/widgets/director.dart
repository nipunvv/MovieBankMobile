import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_bank_mobile/apis/api.dart';
import 'package:movie_bank_mobile/models/cast.dart';
import 'package:movie_bank_mobile/models/credit.dart';
import 'package:movie_bank_mobile/utils/image_utils.dart';
import 'package:movie_bank_mobile/widgets/cast_brief.dart';

class Director extends StatelessWidget {
  const Director({
    Key? key,
    required this.director,
  }) : super(key: key);
  final Future<List<Cast>> director;

  String getDirectorName(List<Cast> cast) {
    Cast director = cast.firstWhere((element) => element.job == 'Director');
    return director.name;
  }

  showCastDetails(BuildContext context, Cast director) {
    Future<Credit> castDetails = fetchCastDetails(director.creditId);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: 100,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.4,
            ),
            child: FutureBuilder<Credit>(
              future: castDetails,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Credit? credit = snapshot.data;
                  return CastBrief(
                    director,
                    credit,
                    getBackgroundImage,
                    'director',
                  );
                } else {
                  return Center(
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Director: ',
          style: GoogleFonts.barlowCondensed(
            fontWeight: FontWeight.w500,
            color: Color(0xffa1a2d2),
            letterSpacing: 2,
            fontSize: 16,
          ),
        ),
        FutureBuilder<List<Cast>>(
          future: director,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Cast>? cast = snapshot.data ?? [];
              return InkWell(
                onTap: () {
                  showCastDetails(context,
                      cast.firstWhere((element) => element.job == 'Director'));
                },
                child: Text(
                  getDirectorName(cast),
                  style: GoogleFonts.barlowCondensed(
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.9),
                    letterSpacing: 2,
                    fontSize: 14,
                  ),
                ),
              );
            }
            return Text('');
          },
        ),
      ],
    );
  }
}
