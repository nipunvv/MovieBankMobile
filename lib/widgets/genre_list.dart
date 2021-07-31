import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GenreList extends StatelessWidget {
  const GenreList({
    Key? key,
    required this.genreIds,
  }) : super(key: key);

  final dynamic genreIds;

  getGenres() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    if (genreIds == null || genreIds.length == 0)
      return Container();
    else
      return Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          children: [
            for (int id in genreIds)
              Padding(
                padding: EdgeInsets.only(
                  right: 10,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    3,
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xffff4069),
                          Color(0xffff4551),
                          Color(0xfffe4a40),
                        ],
                      ),
                    ),
                    child: Text(
                      'CRIME',
                      style: GoogleFonts.barlowCondensed(
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(.85),
                        letterSpacing: 2,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
  }
}
