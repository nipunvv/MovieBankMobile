import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_bank_mobile/constants.dart';
import 'package:movie_bank_mobile/models/cast.dart';
import 'package:movie_bank_mobile/models/movie.dart';
import 'package:movie_bank_mobile/widgets/cast_list.dart';
import 'package:movie_bank_mobile/widgets/genre_list.dart';
import 'package:movie_bank_mobile/widgets/movie_header.dart';
import 'package:http/http.dart' as http;
import 'package:movie_bank_mobile/widgets/movie_list.dart';
import 'package:movie_bank_mobile/widgets/movie_meta.dart';
import 'package:movie_bank_mobile/widgets/pahe_search.dart';
import 'package:movie_bank_mobile/widgets/synopsis.dart';

class MovieDetail extends StatefulWidget {
  final Movie movie;
  const MovieDetail({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  late Future<List<Cast>> cast;
  late Future<Movie> movie;
  late Future<List<Movie>> similarMovies;

  @override
  void initState() {
    super.initState();
    cast = fetchCast(widget.movie.id);
    movie = fetchMovieDetails(widget.movie.id);
    similarMovies = fetchSimilarMovies(widget.movie.id);
  }

  String getYearFromReleaseDate(String releaseDate) {
    if (releaseDate == '') return '';
    return releaseDate.substring(0, 4);
  }

  String getMovieDuration(int runtime) {
    int minutes = runtime % 60;
    int hour = runtime ~/ 60;
    String duration = '';
    if (hour > 0) {
      duration = '$hour hr';
      if (minutes > 0) {
        duration += ' $minutes mins';
      }
    }
    return duration;
  }

  Future<List<Cast>> fetchCast(movieId) async {
    String url = "${TMDB_API_URL}movie/$movieId/credits";
    final response = await http.get(
      Uri.parse(url),
      headers: {HttpHeaders.authorizationHeader: "Bearer $TMDB_API_KEY"},
    );

    if (response.statusCode == 200) {
      List<Cast> casts = [];
      for (Map<String, dynamic> cast in jsonDecode(response.body)['cast']) {
        Cast c = Cast.fromJson(cast);
        casts.add(c);
      }

      for (Map<String, dynamic> cast in jsonDecode(response.body)['crew']) {
        if (cast['department'] == 'Directing' && cast['job'] == 'Director') {
          Cast c = Cast.fromJson(cast);
          casts.add(c);
        }
      }

      return casts;
    } else {
      throw Exception('Failed to load cast');
    }
  }

  Future<Movie> fetchMovieDetails(movieId) async {
    String url = "${TMDB_API_URL}movie/$movieId";
    final response = await http.get(
      Uri.parse(url),
      headers: {HttpHeaders.authorizationHeader: "Bearer $TMDB_API_KEY"},
    );

    if (response.statusCode == 200) {
      Movie movie = Movie.fromJson(jsonDecode(response.body));
      return movie;
    } else {
      throw Exception('Failed to load cast');
    }
  }

  Future<List<Movie>> fetchSimilarMovies(movieId) async {
    String url = "${TMDB_API_URL}movie/$movieId/similar";
    final response = await http.get(
      Uri.parse(url),
      headers: {HttpHeaders.authorizationHeader: "Bearer $TMDB_API_KEY"},
    );

    if (response.statusCode == 200) {
      List<Movie> movies = [];
      for (Map<String, dynamic> movie in jsonDecode(response.body)['results']) {
        movies.add(Movie.fromJson(movie));
      }

      return movies;
    } else {
      throw Exception('Failed to load similar movies');
    }
  }

  String getDirectorName(List<Cast> cast) {
    Cast director = cast.firstWhere((element) => element.job == 'Director');
    return director.name;
  }

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
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
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
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.width * 0.525,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MovieMeta(
                                title: 'Release Date',
                                value: widget.movie.releaseDate,
                              ),
                              MovieMeta(
                                title: 'Vote Count',
                                value: widget.movie.voteCount.toString(),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Duration: ',
                                    style: GoogleFonts.barlowCondensed(
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xffa1a2d2),
                                      letterSpacing: 2,
                                      fontSize: 16,
                                    ),
                                  ),
                                  FutureBuilder<Movie>(
                                    future: movie,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        Movie? movie = snapshot.data;
                                        return Text(
                                          getMovieDuration(movie!.runtime),
                                          style: GoogleFonts.barlowCondensed(
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Colors.white.withOpacity(0.9),
                                            letterSpacing: 2,
                                            fontSize: 14,
                                          ),
                                        );
                                      }
                                      return Text('');
                                    },
                                  ),
                                ],
                              ),
                              Row(
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
                                    future: cast,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        List<Cast>? cast = snapshot.data ?? [];
                                        return Text(
                                          getDirectorName(cast),
                                          style: GoogleFonts.barlowCondensed(
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Colors.white.withOpacity(0.9),
                                            letterSpacing: 2,
                                            fontSize: 14,
                                          ),
                                        );
                                      }
                                      return Text('');
                                    },
                                  ),
                                ],
                              ),
                              PaheSearch(title: widget.movie.title),
                              SizedBox(
                                height: 2,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Synopsis(synopsis: widget.movie.overview),
                  FutureBuilder<List<Cast>>(
                    future: cast,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Cast> cast = snapshot.data ?? [];
                        return CastList(
                          cast: cast,
                        );
                      }
                      return Text('');
                    },
                  ),
                  FutureBuilder<List<Movie>>(
                    future: similarMovies,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Movie> movies = snapshot.data ?? [];
                        return MovieList(movies: movies);
                      }
                      return Text('');
                    },
                  ),
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
                    height: 3,
                  ),
                  GenreList(genreIds: widget.movie.genreIds),
                  SizedBox(
                    height: 10,
                  ),
                  MovieHeader(
                    releaseYear:
                        getYearFromReleaseDate(widget.movie.releaseDate),
                    rating: widget.movie.voteAvg.toString(),
                    language: widget.movie.language,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
