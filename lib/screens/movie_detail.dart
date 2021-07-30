import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_bank_mobile/constants.dart';
import 'package:movie_bank_mobile/models/movie.dart';

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
      body: Container(
        child: Align(
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
      ),
    );
  }
}
