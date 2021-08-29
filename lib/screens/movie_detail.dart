import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_bank_mobile/apis/api.dart';
import 'package:movie_bank_mobile/constants.dart';
import 'package:movie_bank_mobile/models/cast.dart';
import 'package:movie_bank_mobile/models/movie.dart';
import 'package:movie_bank_mobile/utils/custom_text_styles.dart';
import 'package:movie_bank_mobile/widgets/cast_list.dart';
import 'package:movie_bank_mobile/widgets/director.dart';
import 'package:movie_bank_mobile/widgets/genre_list.dart';
import 'package:movie_bank_mobile/widgets/movie_header.dart';
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
  late Movie currentMovie;
  late Future<List<Cast>> cast;
  late Future<Movie> movie;
  late Future<List<Movie>> similarMovies;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    currentMovie = widget.movie;
    cast = fetchCast(currentMovie.id);
    movie = fetchMovieDetails(currentMovie.id);
    similarMovies = fetchSimilarMovies(currentMovie.id);
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

  changeMovie(Movie newMovie) {
    this.setState(() {
      currentMovie = newMovie;
      cast = fetchCast(newMovie.id);
      movie = fetchMovieDetails(newMovie.id);
      similarMovies = fetchSimilarMovies(newMovie.id);
    });
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Hero(
                tag: 'movie_image_${currentMovie.category}_${currentMovie.id}',
                child: CachedNetworkImage(
                  imageUrl: "$TMDB_WEB_URL/w342${currentMovie.posterPath}",
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
                                "$TMDB_WEB_URL/w342${currentMovie.posterPath}",
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
                                value: currentMovie.releaseDate,
                              ),
                              MovieMeta(
                                title: 'Vote Count',
                                value: currentMovie.voteCount.toString(),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Duration: ',
                                    style:
                                        CustomTextStyles.text16light(context),
                                  ),
                                  FutureBuilder<Movie>(
                                    future: movie,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        Movie? movie = snapshot.data;
                                        return Text(
                                          getMovieDuration(movie!.runtime),
                                          style:
                                              CustomTextStyles.text14(context),
                                        );
                                      }
                                      return Text('');
                                    },
                                  ),
                                ],
                              ),
                              Director(director: cast),
                              PaheSearch(title: currentMovie.title),
                              SizedBox(
                                height: 2,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Synopsis(synopsis: currentMovie.overview),
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
                        return MovieList(
                          movies: movies,
                          changeMovie: changeMovie,
                        );
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
                      currentMovie.title,
                      style: CustomTextStyles.text35(context),
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  GenreList(genreIds: currentMovie.genreIds),
                  SizedBox(
                    height: 10,
                  ),
                  MovieHeader(
                    releaseYear:
                        getYearFromReleaseDate(currentMovie.releaseDate),
                    rating: currentMovie.voteAvg.toString(),
                    language: currentMovie.language,
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
