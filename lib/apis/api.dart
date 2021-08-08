import 'dart:convert';
import 'dart:io';

import 'package:movie_bank_mobile/constants.dart';
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

    return movies;
  } else {
    throw Exception('Failed to load movies');
  }
}
