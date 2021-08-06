import 'package:flutter/material.dart';
import 'package:movie_bank_mobile/apis/api.dart';
import 'package:movie_bank_mobile/models/genre.dart';

class GenreProvider with ChangeNotifier {
  List<Genre> genres = [];
  bool loading = false;

  getGenreData() async {
    loading = true;
    genres = await fetchGenres();
    loading = false;

    notifyListeners();
  }
}
