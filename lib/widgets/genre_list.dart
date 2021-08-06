import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_bank_mobile/models/genre.dart';
import 'package:movie_bank_mobile/providers/provider.dart';
import 'package:provider/provider.dart';

class GenreList extends StatelessWidget {
  const GenreList({
    Key? key,
    required this.genreIds,
  }) : super(key: key);

  final dynamic genreIds;

  String getGenre(List<Genre> genres, int genreId) {
    String genre = genres.firstWhere((element) => element.id == genreId).name;
    return genre == 'Science Fiction' ? 'SciFi' : genre;
  }

  @override
  Widget build(BuildContext context) {
    final genreModel = Provider.of<GenreProvider>(context);

    if (genreIds == null ||
        genreIds.length == 0 ||
        genreModel.genres.length == 0)
      return Container();
    else
      return Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Wrap(
          children: [
            for (int genreId in genreIds)
              Padding(
                padding: EdgeInsets.only(
                  right: 10,
                  top: 5,
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
                      getGenre(genreModel.genres, genreId),
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
