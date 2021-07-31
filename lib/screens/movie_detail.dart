import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_bank_mobile/constants.dart';
import 'package:movie_bank_mobile/models/movie.dart';
import 'package:movie_bank_mobile/widgets/genre_list.dart';
import 'package:movie_bank_mobile/widgets/movie_header.dart';

class MovieDetail extends StatefulWidget {
  final Movie movie;
  const MovieDetail({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Hero(
                tag: 'movie_image_${widget.movie.category}_${widget.movie.id}',
                child: CachedNetworkImage(
                  imageUrl: "$TMDB_WEB_URL/w342${widget.movie.posterPath}",
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.3),
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                color: Colors.white,
                gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [
                    Colors.grey.withOpacity(0.0),
                    Color(0xff303043),
                  ],
                  stops: [0.0, 1.0],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.7,
              ),
              color: Color(0xff1a1a24),
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: 30,
                    ),
                    padding: EdgeInsets.all(
                      10,
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: CachedNetworkImage(
                            imageUrl:
                                "$TMDB_WEB_URL/w342${widget.movie.posterPath}",
                            width: MediaQuery.of(context).size.width * 0.35,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      widget.movie.title,
                      style: GoogleFonts.barlowCondensed(
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(.85),
                        letterSpacing: 2,
                        fontSize: 35,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  GenreList(genreIds: widget.movie.genreIds),
                  SizedBox(
                    height: 10,
                  ),
                  MovieHeader(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
