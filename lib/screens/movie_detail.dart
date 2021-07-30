import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_bank_mobile/constants.dart';
import 'package:movie_bank_mobile/models/movie.dart';
import 'package:movie_bank_mobile/widgets/genre_list.dart';

class MovieDetail extends StatefulWidget {
  final Movie movie;
  const MovieDetail({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  getGenres() {
    //
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
              top: MediaQuery.of(context).size.height * 0.5,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.movie.title,
                  style: GoogleFonts.barlowCondensed(
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(.85),
                    letterSpacing: 2,
                    fontSize: 35,
                  ),
                ),
                GenreList(genreIds: widget.movie.genreIds),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
