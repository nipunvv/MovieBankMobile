import 'dart:convert';
import 'dart:io';

import 'package:movie_bank_mobile/constants.dart';
import 'package:movie_bank_mobile/models/actor.dart';
import 'package:movie_bank_mobile/models/cast.dart';
import 'package:movie_bank_mobile/models/credit.dart';
import 'package:movie_bank_mobile/models/genre.dart';
import 'package:http/http.dart' as http;
import 'package:movie_bank_mobile/models/movie.dart';

Future<List<Genre>> fetchGenres() async {
  String url = "${TMDB_API_URL}genre/movie/list";
  final response = await http.get(
    Uri.parse(url),
    headers: {HttpHeaders.authorizationHeader: "Bearer $TMDB_API_KEY"},
  );

  if (response.statusCode == 200) {
    List<Genre> genres = [];
    for (Map<String, dynamic> genre in jsonDecode(response.body)['genres']) {
      genres.add(Genre.fromJson(genre));
    }

    return genres;
  } else {
    throw Exception('Failed to load genres');
  }
}

Future<Credit> fetchCastDetails(String creditId) async {
  String url = "${TMDB_API_URL}credit/$creditId";
  final response = await http.get(
    Uri.parse(url),
    headers: {HttpHeaders.authorizationHeader: "Bearer $TMDB_API_KEY"},
  );

  if (response.statusCode == 200) {
    Credit credit = Credit.fromJson(jsonDecode(response.body));
    return credit;
  } else {
    throw Exception('Failed to load cast details');
  }
}

Future<List<Movie>> fetchMoviesOfPerson(int personId) async {
  String url = "${TMDB_API_URL}person/$personId/movie_credits";
  final response = await http.get(
    Uri.parse(url),
    headers: {HttpHeaders.authorizationHeader: "Bearer $TMDB_API_KEY"},
  );

  if (response.statusCode == 200) {
    List<Movie> movies = [];
    for (Map<String, dynamic> movie in jsonDecode(response.body)['cast']) {
      movies.add(Movie.fromJson(movie));
    }

    for (Map<String, dynamic> movie in jsonDecode(response.body)['crew']) {
      movies.add(Movie.fromJson(movie));
    }

    return movies;
  } else {
    throw Exception('Failed to load movies');
  }
}

Future<List<Movie>> findMovies(String keyword) async {
  String url = "${TMDB_API_URL}search/movie?query=$keyword";
  final response = await http.get(
    Uri.parse(url),
    headers: {HttpHeaders.authorizationHeader: "Bearer $TMDB_API_KEY"},
  );

  if (response.statusCode == 200) {
    List<Movie> movies = [];
    Movie m;
    for (Map<String, dynamic> movie in jsonDecode(response.body)['results']) {
      m = Movie.fromJson(movie);
      if (m.releaseDate != '' && m.posterPath != '') movies.add(m);
    }

    return movies;
  } else {
    throw Exception('Failed to load Movies');
  }
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

Future<Actor> fetchActorDetails(int actorId) async {
  String url = "${TMDB_API_URL}person/$actorId";
  final response = await http.get(
    Uri.parse(url),
    headers: {HttpHeaders.authorizationHeader: "Bearer $TMDB_API_KEY"},
  );

  if (response.statusCode == 200) {
    Actor actor = Actor.fromJson(jsonDecode(response.body));
    return actor;
  } else {
    throw Exception('Failed to load actor details');
  }
}

Future<List<Movie>> fetchMoviesOfActor(int actorId) async {
  String url = "${TMDB_API_URL}person/$actorId/movie_credits";
  final response = await http.get(
    Uri.parse(url),
    headers: {HttpHeaders.authorizationHeader: "Bearer $TMDB_API_KEY"},
  );

  if (response.statusCode == 200) {
    List<Movie> movies = [];
    for (Map<String, dynamic> movie in jsonDecode(response.body)['cast']) {
      movies.add(Movie.fromJson(movie));
    }

    return movies;
  } else {
    throw Exception('Failed to load movies');
  }
}

Future<List<Movie>> fetchMovies(String type) async {
  String url =
      "${TMDB_API_URL}movie/${type == 'popular' ? 'popular' : 'now_playing'}?language=en-US&page=1";
  final response = await http.get(
    Uri.parse(url),
    headers: {HttpHeaders.authorizationHeader: "Bearer $TMDB_API_KEY"},
  );

  if (response.statusCode == 200) {
    List<Movie> movies = [];
    Movie m;
    for (Map<String, dynamic> movie in jsonDecode(response.body)['results']) {
      movie['category'] = type;
      m = Movie.fromJson(movie);
      if (m.releaseDate != '') movies.add(m);
    }

    return movies;
  } else {
    throw Exception('Failed to load Movies');
  }
}
